//  Copyright (c) 2021 650 Industries, Inc. All rights reserved.

@import XCTest;

#import <EXUpdates/EXUpdatesStructuredHeaders.h>

@interface EXUpdatesStructuredHeadersTests : XCTestCase

@end

@implementation EXUpdatesStructuredHeadersTests

- (void)setUp
{
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testDictionaries
{
  NSString *dictionaryTestsJson = @"[{\"name\": \"basic dictionary\",\"raw\": [\"en=\\\"Applepie\\\", da=:w4ZibGV0w6ZydGUK:\"],\"header_type\": \"dictionary\",\"expected\": {\"en\": [\"Applepie\", {}], \"da\": [{\"__type\": \"binary\", \"value\": \"YODGE3DFOTB2M4TUMUFA====\"},{}]}},{\"name\": \"empty dictionary\",\"raw\": [\"\"],\"header_type\": \"dictionary\",\"expected\": {},\"canonical\": []},{\"name\": \"single item dictionary\",\"raw\": [\"a=1\"],\"header_type\": \"dictionary\",\"expected\": {\"a\": [1, {}]}},{\"name\": \"list item dictionary\",\"raw\": [\"a=(1 2)\"],\"header_type\": \"dictionary\",\"expected\": {\"a\": [[[1, {}], [2, {}]], {}]}},{\"name\": \"single list item dictionary\",\"raw\": [\"a=(1)\"],\"header_type\": \"dictionary\",\"expected\": {\"a\": [[[1, {}]], {}]}},{\"name\": \"empty list item dictionary\",\"raw\": [\"a=()\"],\"header_type\": \"dictionary\",\"expected\": {\"a\": [[], {}]}},{\"name\": \"no whitespace dictionary\",\"raw\": [\"a=1,b=2\"],\"header_type\": \"dictionary\",\"expected\": {\"a\": [1, {}], \"b\": [2, {}]},\"canonical\": [\"a=1, b=2\"]},{\"name\": \"extra whitespace dictionary\",\"raw\": [\"a=1 ,b=2\"],\"header_type\": \"dictionary\",\"expected\": {\"a\": [1, {}], \"b\": [2, {}]},\"canonical\": [\"a=1, b=2\"]},{\"name\": \"tab separated dictionary\",\"raw\": [\"a=1\\t,\\tb=2\"],\"header_type\": \"dictionary\",\"expected\": {\"a\": [1, {}], \"b\": [2, {}]},\"canonical\": [\"a=1, b=2\"]},{\"name\": \"leading whitespace dictionary\",\"raw\": [\" a=1 ,b=2\"],\"header_type\": \"dictionary\",\"expected\": {\"a\": [1, {}], \"b\": [2, {}]},\"canonical\": [\"a=1, b=2\"]},{\"name\": \"whitespace before = dictionary\",\"raw\": [\"a =1, b=2\"],\"header_type\": \"dictionary\",\"must_fail\": true},{\"name\": \"whitespace after = dictionary\",\"raw\": [\"a=1, b= 2\"],\"header_type\": \"dictionary\",\"must_fail\": true},{\"name\": \"two lines dictionary\",\"raw\": [\"a=1\", \"b=2\"],\"header_type\": \"dictionary\",\"expected\": {\"a\": [1, {}], \"b\": [2, {}]},\"canonical\": [\"a=1, b=2\"]},{\"name\": \"missing value dictionary\",\"raw\": [\"a=1, b, c=3\"],\"header_type\": \"dictionary\",\"expected\": {\"a\": [1,{}], \"b\": [true, {}], \"c\": [3, {}]}},{\"name\": \"all missing value dictionary\",\"raw\": [\"a, b, c\"],\"header_type\": \"dictionary\",\"expected\": {\"a\": [true,{}], \"b\": [true, {}], \"c\": [true, {}]}},{\"name\": \"start missing value dictionary\",\"raw\": [\"a, b=2\"],\"header_type\": \"dictionary\",\"expected\": {\"a\": [true,{}], \"b\": [2, {}]}},{\"name\": \"end missing value dictionary\",\"raw\": [\"a=1, b\"],\"header_type\": \"dictionary\",\"expected\": {\"a\": [1,{}], \"b\": [true, {}]}},{\"name\": \"missing value with params dictionary\",\"raw\": [\"a=1, b;foo=9, c=3\"],\"header_type\": \"dictionary\",\"expected\": {\"a\": [1,{}], \"b\": [true, {\"foo\": 9}], \"c\": [3, {}]}},{\"name\": \"explicit true value with params dictionary\",\"raw\": [\"a=1, b=?1;foo=9, c=3\"],\"header_type\": \"dictionary\",\"expected\": {\"a\": [1,{}], \"b\": [true, {\"foo\": 9}], \"c\": [3, {}]},\"canonical\": [\"a=1, b;foo=9, c=3\"]},{\"name\": \"trailing comma dictionary\",\"raw\": [\"a=1, b=2,\"],\"header_type\": \"dictionary\",\"must_fail\": true},{\"name\": \"empty item dictionary\",\"raw\": [\"a=1,,b=2,\"],\"header_type\": \"dictionary\",\"must_fail\": true},{\"name\": \"duplicate key dictionary\",\"raw\": [\"a=1,b=2,a=3\"],\"header_type\": \"dictionary\",\"expected\": {\"a\": [3, {}], \"b\": [2, {}]},\"canonical\": [\"a=3, b=2\"]},{\"name\": \"numeric key dictionary\",\"raw\": [\"a=1,1b=2,a=1\"],\"header_type\": \"dictionary\",\"must_fail\": true},{\"name\": \"uppercase key dictionary\",\"raw\": [\"a=1,B=2,a=1\"],\"header_type\": \"dictionary\",\"must_fail\": true},{\"name\": \"bad key dictionary\",\"raw\": [\"a=1,b!=2,a=1\"],\"header_type\": \"dictionary\",\"must_fail\": true}]";
  [self runTestArray:dictionaryTestsJson];
}

- (void)testNumbers
{
  NSString *numberTestsJson = @"[{\"name\": \"basic integer\",\"raw\": [\"42\"],\"header_type\": \"item\",\"expected\": [42, {}]},{\"name\": \"zero integer\",\"raw\": [\"0\"],\"header_type\": \"item\",\"expected\": [0, {}]},{\"name\": \"leading 0 zero\",\"raw\": [\"00\"],\"header_type\": \"item\",\"expected\": [0, {}],\"canonical\": [\"0\"]},{\"name\": \"negative zero\",\"raw\": [\"-0\"],\"header_type\": \"item\",\"expected\": [0, {}],\"canonical\": [\"0\"]},{\"name\": \"double negative zero\",\"raw\": [\"--0\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"negative integer\",\"raw\": [\"-42\"],\"header_type\": \"item\",\"expected\": [-42, {}]},{\"name\": \"leading 0 integer\",\"raw\": [\"042\"],\"header_type\": \"item\",\"expected\": [42, {}],\"canonical\": [\"42\"]},{\"name\": \"leading 0 negative integer\",\"raw\": [\"-042\"],\"header_type\": \"item\",\"expected\": [-42, {}],\"canonical\": [\"-42\"]},{\"name\": \"leading 0 zero\",\"raw\": [\"00\"],\"header_type\": \"item\",\"expected\": [0, {}],\"canonical\": [\"0\"]},{\"name\": \"comma\",\"raw\": [\"2,3\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"negative non-DIGIT first character\",\"raw\": [\"-a23\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"sign out of place\",\"raw\": [\"4-2\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"whitespace after sign\",\"raw\": [\"- 42\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"long integer\",\"raw\": [\"123456789012345\"],\"header_type\": \"item\",\"expected\": [123456789012345, {}]},{\"name\": \"long negative integer\",\"raw\": [\"-123456789012345\"],\"header_type\": \"item\",\"expected\": [-123456789012345, {}]},{\"name\": \"too long integer\",\"raw\": [\"1234567890123456\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"negative too long integer\",\"raw\": [\"-1234567890123456\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"simple decimal\",\"raw\": [\"1.23\"],\"header_type\": \"item\",\"expected\": [1.23, {}]},{\"name\": \"negative decimal\",\"raw\": [\"-1.23\"],\"header_type\": \"item\",\"expected\": [-1.23, {}]},{\"name\": \"decimal, whitespace after decimal\",\"raw\": [\"1. 23\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"decimal, whitespace before decimal\",\"raw\": [\"1 .23\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"negative decimal, whitespace after sign\",\"raw\": [\"- 1.23\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"tricky precision decimal\",\"raw\": [\"123456789012.1\"],\"header_type\": \"item\",\"expected\": [123456789012.1, {}]},{\"name\": \"double decimal decimal\",\"raw\": [\"1.5.4\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"adjacent double decimal decimal\",\"raw\": [\"1..4\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"decimal with three fractional digits\",\"raw\": [\"1.123\"],\"header_type\": \"item\",\"expected\": [1.123, {}]},{\"name\": \"negative decimal with three fractional digits\",\"raw\": [\"-1.123\"],\"header_type\": \"item\",\"expected\": [-1.123, {}]},{\"name\": \"decimal with four fractional digits\",\"raw\": [\"1.1234\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"negative decimal with four fractional digits\",\"raw\": [\"-1.1234\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"decimal with thirteen integer digits\",\"raw\": [\"1234567890123.0\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"negative decimal with thirteen integer digits\",\"raw\": [\"-1234567890123.0\"],\"header_type\": \"item\",\"must_fail\": true}]";
  [self runTestArray:numberTestsJson];
}

- (void)testStrings
{
  NSString *stringTestsJson = @"[{\"name\": \"basic string\",\"raw\": [\"\\\"foo bar\\\"\"],\"header_type\": \"item\",\"expected\": [\"foo bar\", {}]},{\"name\": \"empty string\",\"raw\": [\"\\\"\\\"\"],\"header_type\": \"item\",\"expected\": [\"\", {}]},{\"name\": \"long string\",\"raw\": [\"\\\"foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo \\\"\"],\"header_type\": \"item\",\"expected\": [\"foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo \", {}]},{\"name\": \"whitespace string\",\"raw\": [\"\\\" \\\"\"],\"header_type\": \"item\",\"expected\": [\" \", {}]},{\"name\": \"non-ascii string\",\"raw\": [\"\\\"füü\\\"\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"tab in string\",\"raw\": [\"\\\"\\\\t\\\"\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"newline in string\",\"raw\": [\"\\\" \\\\n \\\"\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"single quoted string\",\"raw\": [\"'foo'\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"unbalanced string\",\"raw\": [\"\\\"foo\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"string quoting\",\"raw\": [\"\\\"foo \\\\\\\"bar\\\\\\\" \\\\\\\\ baz\\\"\"],\"header_type\": \"item\",\"expected\": [\"foo \\\"bar\\\" \\\\ baz\", {}]},{\"name\": \"bad string quoting\",\"raw\": [\"\\\"foo \\\\,\\\"\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"ending string quote\",\"raw\": [\"\\\"foo \\\\\\\"\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"abruptly ending string quote\",\"raw\": [\"\\\"foo \\\\\"],\"header_type\": \"item\",\"must_fail\": true}]";
  [self runTestArray:stringTestsJson];
}

- (void)testBinaries
{
  NSString *binaryTestsJson = @"[{\"name\": \"basic binary\",\"raw\": [\":aGVsbG8=:\"],\"header_type\": \"item\",\"expected\": [{\"__type\": \"binary\", \"value\": \"NBSWY3DP\"},{}]},{\"name\": \"empty binary\",\"raw\": [\"::\"],\"header_type\": \"item\",\"expected\": [{\"__type\": \"binary\", \"value\": \"\"},{}]},{\"name\": \"bad paddding\",\"raw\": [\":aGVsbG8:\"],\"header_type\": \"item\",\"expected\": [{\"__type\": \"binary\", \"value\": \"NBSWY3DP\"},{}],\"can_fail\": true,\"canonical\": [\":aGVsbG8=:\"]},{\"name\": \"bad end delimiter\",\"raw\": [\":aGVsbG8=\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"extra whitespace\",\"raw\": [\":aGVsb G8=:\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"extra chars\",\"raw\": [\":aGVsbG!8=:\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"suffix chars\",\"raw\": [\":aGVsbG8=!:\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"non-zero pad bits\",\"raw\": [\":iZ==:\"],\"header_type\": \"item\",\"expected\": [{\"__type\": \"binary\", \"value\": \"RE======\"},{}],\"can_fail\": true,\"canonical\": [\":iQ==:\"]},{\"name\": \"non-ASCII binary\",\"raw\": [\":/+Ah:\"],\"header_type\": \"item\",\"expected\": [{\"__type\": \"binary\", \"value\": \"77QCC===\"},{}]},{\"name\": \"base64url binary\",\"raw\": [\":_-Ah:\"],\"header_type\": \"item\",\"must_fail\": true}]";
  [self runTestArray:binaryTestsJson];
}

- (void)testBooleans
{
  NSString *booleanTestsJson = @"[{\"name\": \"basic true boolean\",\"raw\": [\"?1\"],\"header_type\": \"item\",\"expected\": [true, {}]},{\"name\": \"basic false boolean\",\"raw\": [\"?0\"],\"header_type\": \"item\",\"expected\": [false, {}]},{\"name\": \"unknown boolean\",\"raw\": [\"?Q\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"whitespace boolean\",\"raw\": [\"? 1\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"negative zero boolean\",\"raw\": [\"?-0\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"T boolean\",\"raw\": [\"?T\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"F boolean\",\"raw\": [\"?F\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"t boolean\",\"raw\": [\"?t\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"f boolean\",\"raw\": [\"?f\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"spelled-out True boolean\",\"raw\": [\"?True\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"spelled-out False boolean\",\"raw\": [\"?False\"],\"header_type\": \"item\",\"must_fail\": true}]";
  [self runTestArray:booleanTestsJson];
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
    EXUpdatesStructuredHeaders *parser = [[EXUpdatesStructuredHeaders alloc] initWithRawInput:rawInput fieldType:[self fieldTypeWithString:test[@"header_type"]]];
    if ([(NSNumber *)test[@"must_fail"] boolValue]) {
      NSError *error;
      XCTAssertNil([parser parseStructuredFieldsWithError:&error]);
      XCTAssertNotNil(error);
    } else {
      NSError *error;
      id actual = [parser parseStructuredFieldsWithError:&error];
      XCTAssertNil(error);

      id expected = test[@"expected"];
      if ([(NSNumber *)test[@"can_fail"] boolValue]) {
        XCTAssert(!actual || [actual isEqual:expected]);
      } else {
        XCTAssertEqualObjects(actual, expected);
      }
    }
  }
}

- (EXUpdatesStructuredHeadersFieldType)fieldTypeWithString:(NSString *)string
{
  if ([@"dictionary" isEqualToString:string]) {
    return EXUpdatesStructuredHeadersFieldTypeDictionary;
  } else if ([@"list" isEqualToString:string]) {
    return EXUpdatesStructuredHeadersFieldTypeList;
  } else if ([@"item" isEqualToString:string]) {
    return EXUpdatesStructuredHeadersFieldTypeItem;
  } else {
    XCTAssert(NO, @"unexpected header_type");
  }
}

@end

@implementation NSData (EXUpdatesStructuredHeadersTests)

- (BOOL)isEqual:(id)object
{
  if ([object isKindOfClass:[NSDictionary class]] && [@"binary" isEqualToString:object[@"__type"]]) {
    NSData *dataToCompare = [[self class] dataFromBase32String:object[@"value"]];
    return [self isEqualToData:dataToCompare];
  }

  // plain isEqual implementation
  if (self == object) {
    return YES;
  }
  if (![object isKindOfClass:[NSData class]]) {
    return NO;
  }
  return [self isEqualToData:object];
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

