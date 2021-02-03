//  Copyright (c) 2021 650 Industries, Inc. All rights reserved.

@import XCTest;

#import <objc/runtime.h>
#import <EXStructuredHeaders/EXStructuredHeadersParser.h>

@interface EXStructuredHeadersParserTests : XCTestCase

@end

@implementation EXStructuredHeadersParserTests

- (void)setUp
{
  [super setUp];

  // Replace NSDictionary's isEqual: method at runtime with one that knows about
  // the idiomatic format of the `expected` field in the test JSON objects.
  // This prevents us from having to iterate through every possible item and
  // pre-process the expected objects.
  // Same for NSArray
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    [self swizzleMethodForClass:[NSDictionary class]
                       original:@selector(isEqual:)
                    replacement:@selector(isEqualToTestResult:)];
    [self swizzleMethodForClass:[NSArray class]
                       original:@selector(isEqual:)
                    replacement:@selector(isEqualToTestResult:)];
  });
}

- (void)tearDown
{
  static dispatch_once_t undoToken;
  dispatch_once(&undoToken, ^{
    [self swizzleMethodForClass:[NSDictionary class]
                       original:@selector(isEqualToTestResult:)
                    replacement:@selector(isEqual:)];
    [self swizzleMethodForClass:[NSArray class]
                       original:@selector(isEqualToTestResult:)
                    replacement:@selector(isEqual:)];
  });
  [super tearDown];
}

// https://nshipster.com/method-swizzling/
- (void)swizzleMethodForClass:(Class)class original:(SEL)originalSelector replacement:(SEL)swizzledSelector
{
  Method originalMethod = class_getInstanceMethod(class, originalSelector);
  Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
  
  BOOL didAddMethod =
  class_addMethod(class,
                  originalSelector,
                  method_getImplementation(swizzledMethod),
                  method_getTypeEncoding(swizzledMethod));
  
  if (didAddMethod) {
    class_replaceMethod(class,
                        swizzledSelector,
                        method_getImplementation(originalMethod),
                        method_getTypeEncoding(originalMethod));
  } else {
    method_exchangeImplementations(originalMethod, swizzledMethod);
  }
}

- (void)runTestArray:(NSString *)testsJson
{
  NSError *error;
  NSArray<NSDictionary *> *tests = [NSJSONSerialization JSONObjectWithData:[testsJson dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
  XCTAssertNil(error);

  for (NSDictionary *test in tests) {
    // When generating input_bytes, parsers MUST combine all field lines in the same section (header or trailer)
    // that case-insensitively match the field name into one comma-separated field-value, as per [RFC7230], Section 3.2.2;
    // this assures that the entire field value is processed correctly.
    NSString *rawInput = [(NSArray *)test[@"raw"] componentsJoinedByString:@","];
    EXStructuredHeadersParser *parser = [[EXStructuredHeadersParser alloc] initWithRawInput:rawInput fieldType:[self fieldTypeWithString:test[@"header_type"]]];
    if ([(NSNumber *)test[@"must_fail"] boolValue]) {
      NSError *error;
      XCTAssertNil([parser parseStructuredFieldsWithError:&error], @"Test failed: %@", test[@"name"]);
      XCTAssertNotNil(error, @"Test failed correctly, but there was no error object: %@", test[@"name"]);
    } else {
      NSError *error;
      id actual = [parser parseStructuredFieldsWithError:&error];
      XCTAssertNil(error, @"Test failed: %@", test[@"name"]);

      id expected = test[@"expected"];
      if ([(NSNumber *)test[@"can_fail"] boolValue]) {
        XCTAssert(!actual || [expected isEqual:actual], @"Test failed: %@", test[@"name"]);
      } else {
        XCTAssertEqualObjects(expected, actual, @"Test failed: %@", test[@"name"]);
      }
    }
  }
}

- (EXStructuredHeadersParserFieldType)fieldTypeWithString:(NSString *)string
{
  if ([@"dictionary" isEqualToString:string]) {
    return EXStructuredHeadersParserFieldTypeDictionary;
  } else if ([@"list" isEqualToString:string]) {
    return EXStructuredHeadersParserFieldTypeList;
  } else if ([@"item" isEqualToString:string]) {
    return EXStructuredHeadersParserFieldTypeItem;
  } else {
    XCTAssert(NO, @"unexpected header_type");
  }
}

@end

@interface NSArray (EXStructuredHeadersParserTests)

- (BOOL)isEqualToTestResult:(id)object;

@end

@implementation NSArray (EXStructuredHeadersParserTests)

- (BOOL)isEqualToTestResult:(id)object
{
  // dictionaries in the expected results are represented as arrays of tuplets [key, value]
  if ([object isKindOfClass:[NSDictionary class]]) {
    NSMutableArray *arrayToCompare = [NSMutableArray arrayWithCapacity:((NSDictionary *)object).count];
    [(NSDictionary *)object enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
      [arrayToCompare addObject:@[key, obj]];
    }];
    return [self isEqualToArray:arrayToCompare.copy];
  }

  // plain isEqual implementation
  if (self == object) {
    return YES;
  }
  if (![object isKindOfClass:[NSArray class]]) {
    return NO;
  }
  return [self isEqualToArray:object];
}

@end

@interface NSDictionary (EXStructuredHeadersParserTests)

- (BOOL)isEqualToTestResult:(id)object;

@end

@implementation NSDictionary (EXStructuredHeadersParserTests)

- (BOOL)isEqualToTestResult:(id)object
{
  if ([object isKindOfClass:[NSData class]] && [@"binary" isEqualToString:self[@"__type"]]) {
    NSData *dataToCompare = [[self class] dataFromBase32String:self[@"value"]];
    return [object isEqualToData:dataToCompare];
  }

  if ([object isKindOfClass:[NSString class]] && [@"token" isEqualToString:self[@"__type"]]) {
    return [object isEqualToString:self[@"value"]];
  }

  // plain isEqual implementation
  if (self == object) {
    return YES;
  }
  if (![object isKindOfClass:[NSDictionary class]]) {
    return NO;
  }
  return [self isEqualToDictionary:object];
}

// https://github.com/ekscrypto/Base32/blob/77e2871b17d71891a6e56e007221d84d77e566b9/Base32/MF_Base32Additions.m
+ (NSData *)dataFromBase32String:(NSString *)encoding
{
  NSData *data = nil;
  unsigned char *decodedBytes = NULL;
  @try {
#define __ 255
    static char decodingTable[256] = {
      __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0x00 - 0x0F
      __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0x10 - 0x1F
      __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0x20 - 0x2F
      __,__,26,27, 28,29,30,31, __,__,__,__, __, 0,__,__,  // 0x30 - 0x3F
      __, 0, 1, 2,  3, 4, 5, 6,  7, 8, 9,10, 11,12,13,14,  // 0x40 - 0x4F
      15,16,17,18, 19,20,21,22, 23,24,25,__, __,__,__,__,  // 0x50 - 0x5F
      __, 0, 1, 2,  3, 4, 5, 6,  7, 8, 9,10, 11,12,13,14,  // 0x60 - 0x6F
      15,16,17,18, 19,20,21,22, 23,24,25,__, __,__,__,__,  // 0x70 - 0x7F
      __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0x80 - 0x8F
      __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0x90 - 0x9F
      __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0xA0 - 0xAF
      __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0xB0 - 0xBF
      __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0xC0 - 0xCF
      __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0xD0 - 0xDF
      __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0xE0 - 0xEF
      __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0xF0 - 0xFF
    };
    static NSUInteger paddingAdjustment[8] = {0,1,1,1,2,3,3,4};
    encoding = [encoding stringByReplacingOccurrencesOfString:@"=" withString:@""];
    NSData *encodedData = [encoding dataUsingEncoding:NSASCIIStringEncoding];
    unsigned char *encodedBytes = (unsigned char *)[encodedData bytes];
    
    NSUInteger encodedLength = [encodedData length];
    if( encodedLength >= (NSUIntegerMax - 7) ) return nil; // NSUInteger overflow check
    NSUInteger encodedBlocks = (encodedLength + 7) >> 3;
    NSUInteger expectedDataLength = encodedBlocks * 5;
    
    decodedBytes = calloc(expectedDataLength, 1);
    if( decodedBytes != NULL ) {
      
      unsigned char encodedByte1, encodedByte2, encodedByte3, encodedByte4;
      unsigned char encodedByte5, encodedByte6, encodedByte7, encodedByte8;
      NSUInteger encodedBytesToProcess = encodedLength;
      NSUInteger encodedBaseIndex = 0;
      NSUInteger decodedBaseIndex = 0;
      unsigned char encodedBlock[8] = {0,0,0,0,0,0,0,0};
      NSUInteger encodedBlockIndex = 0;
      unsigned char c;
      while( encodedBytesToProcess-- >= 1 ) {
        c = encodedBytes[encodedBaseIndex++];
        if( c == '=' ) break; // padding...
        
        c = decodingTable[c];
        if( c == __ ) continue;
        
        encodedBlock[encodedBlockIndex++] = c;
        if( encodedBlockIndex == 8 ) {
          encodedByte1 = encodedBlock[0];
          encodedByte2 = encodedBlock[1];
          encodedByte3 = encodedBlock[2];
          encodedByte4 = encodedBlock[3];
          encodedByte5 = encodedBlock[4];
          encodedByte6 = encodedBlock[5];
          encodedByte7 = encodedBlock[6];
          encodedByte8 = encodedBlock[7];
          decodedBytes[decodedBaseIndex] = ((encodedByte1 << 3) & 0xF8) | ((encodedByte2 >> 2) & 0x07);
          decodedBytes[decodedBaseIndex+1] = ((encodedByte2 << 6) & 0xC0) | ((encodedByte3 << 1) & 0x3E) | ((encodedByte4 >> 4) & 0x01);
          decodedBytes[decodedBaseIndex+2] = ((encodedByte4 << 4) & 0xF0) | ((encodedByte5 >> 1) & 0x0F);
          decodedBytes[decodedBaseIndex+3] = ((encodedByte5 << 7) & 0x80) | ((encodedByte6 << 2) & 0x7C) | ((encodedByte7 >> 3) & 0x03);
          decodedBytes[decodedBaseIndex+4] = ((encodedByte7 << 5) & 0xE0) | (encodedByte8 & 0x1F);
          decodedBaseIndex += 5;
          encodedBlockIndex = 0;
        }
      }
      encodedByte7 = 0;
      encodedByte6 = 0;
      encodedByte5 = 0;
      encodedByte4 = 0;
      encodedByte3 = 0;
      encodedByte2 = 0;
      switch (encodedBlockIndex) {
        case 7:
          encodedByte7 = encodedBlock[6];
        case 6:
          encodedByte6 = encodedBlock[5];
        case 5:
          encodedByte5 = encodedBlock[4];
        case 4:
          encodedByte4 = encodedBlock[3];
        case 3:
          encodedByte3 = encodedBlock[2];
        case 2:
          encodedByte2 = encodedBlock[1];
        case 1:
          encodedByte1 = encodedBlock[0];
          decodedBytes[decodedBaseIndex] = ((encodedByte1 << 3) & 0xF8) | ((encodedByte2 >> 2) & 0x07);
          decodedBytes[decodedBaseIndex+1] = ((encodedByte2 << 6) & 0xC0) | ((encodedByte3 << 1) & 0x3E) | ((encodedByte4 >> 4) & 0x01);
          decodedBytes[decodedBaseIndex+2] = ((encodedByte4 << 4) & 0xF0) | ((encodedByte5 >> 1) & 0x0F);
          decodedBytes[decodedBaseIndex+3] = ((encodedByte5 << 7) & 0x80) | ((encodedByte6 << 2) & 0x7C) | ((encodedByte7 >> 3) & 0x03);
          decodedBytes[decodedBaseIndex+4] = ((encodedByte7 << 5) & 0xE0);
      }
      decodedBaseIndex += paddingAdjustment[encodedBlockIndex];
      data = [[NSData alloc] initWithBytes:decodedBytes length:decodedBaseIndex];
    }
  }
  @catch (NSException *exception) {
    data = nil;
    NSLog(@"WARNING: error occured while decoding base 32 string: %@", exception);
  }
  @finally {
    if( decodedBytes != NULL ) {
      free( decodedBytes );
    }
  }
  return data;
}

@end
