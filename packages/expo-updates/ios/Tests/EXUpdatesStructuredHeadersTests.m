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

- (void)test
{
//  NSString *testsJson = @"[{\"name\": \"basic dictionary\",\"raw\": [\"en=\\\"Applepie\\\", da=:w4ZibGV0w6ZydGUK:\"],\"header_type\": \"dictionary\",\"expected\": {\"en\": [\"Applepie\", {}], \"da\": [{\"__type\": \"binary\", \"value\": \"YODGE3DFOTB2M4TUMUFA====\"},{}]}},{\"name\": \"empty dictionary\",\"raw\": [\"\"],\"header_type\": \"dictionary\",\"expected\": {},\"canonical\": []},{\"name\": \"single item dictionary\",\"raw\": [\"a=1\"],\"header_type\": \"dictionary\",\"expected\": {\"a\": [1, {}]}},{\"name\": \"list item dictionary\",\"raw\": [\"a=(1 2)\"],\"header_type\": \"dictionary\",\"expected\": {\"a\": [[[1, {}], [2, {}]], {}]}},{\"name\": \"single list item dictionary\",\"raw\": [\"a=(1)\"],\"header_type\": \"dictionary\",\"expected\": {\"a\": [[[1, {}]], {}]}},{\"name\": \"empty list item dictionary\",\"raw\": [\"a=()\"],\"header_type\": \"dictionary\",\"expected\": {\"a\": [[], {}]}},{\"name\": \"no whitespace dictionary\",\"raw\": [\"a=1,b=2\"],\"header_type\": \"dictionary\",\"expected\": {\"a\": [1, {}], \"b\": [2, {}]},\"canonical\": [\"a=1, b=2\"]},{\"name\": \"extra whitespace dictionary\",\"raw\": [\"a=1 ,b=2\"],\"header_type\": \"dictionary\",\"expected\": {\"a\": [1, {}], \"b\": [2, {}]},\"canonical\": [\"a=1, b=2\"]},{\"name\": \"tab separated dictionary\",\"raw\": [\"a=1\\t,\\tb=2\"],\"header_type\": \"dictionary\",\"expected\": {\"a\": [1, {}], \"b\": [2, {}]},\"canonical\": [\"a=1, b=2\"]},{\"name\": \"leading whitespace dictionary\",\"raw\": [\" a=1 ,b=2\"],\"header_type\": \"dictionary\",\"expected\": {\"a\": [1, {}], \"b\": [2, {}]},\"canonical\": [\"a=1, b=2\"]},{\"name\": \"whitespace before = dictionary\",\"raw\": [\"a =1, b=2\"],\"header_type\": \"dictionary\",\"must_fail\": true},{\"name\": \"whitespace after = dictionary\",\"raw\": [\"a=1, b= 2\"],\"header_type\": \"dictionary\",\"must_fail\": true},{\"name\": \"two lines dictionary\",\"raw\": [\"a=1\", \"b=2\"],\"header_type\": \"dictionary\",\"expected\": {\"a\": [1, {}], \"b\": [2, {}]},\"canonical\": [\"a=1, b=2\"]},{\"name\": \"missing value dictionary\",\"raw\": [\"a=1, b, c=3\"],\"header_type\": \"dictionary\",\"expected\": {\"a\": [1,{}], \"b\": [true, {}], \"c\": [3, {}]}},{\"name\": \"all missing value dictionary\",\"raw\": [\"a, b, c\"],\"header_type\": \"dictionary\",\"expected\": {\"a\": [true,{}], \"b\": [true, {}], \"c\": [true, {}]}},{\"name\": \"start missing value dictionary\",\"raw\": [\"a, b=2\"],\"header_type\": \"dictionary\",\"expected\": {\"a\": [true,{}], \"b\": [2, {}]}},{\"name\": \"end missing value dictionary\",\"raw\": [\"a=1, b\"],\"header_type\": \"dictionary\",\"expected\": {\"a\": [1,{}], \"b\": [true, {}]}},{\"name\": \"missing value with params dictionary\",\"raw\": [\"a=1, b;foo=9, c=3\"],\"header_type\": \"dictionary\",\"expected\": {\"a\": [1,{}], \"b\": [true, {\"foo\": 9}], \"c\": [3, {}]}},{\"name\": \"explicit true value with params dictionary\",\"raw\": [\"a=1, b=?1;foo=9, c=3\"],\"header_type\": \"dictionary\",\"expected\": {\"a\": [1,{}], \"b\": [true, {\"foo\": 9}], \"c\": [3, {}]},\"canonical\": [\"a=1, b;foo=9, c=3\"]},{\"name\": \"trailing comma dictionary\",\"raw\": [\"a=1, b=2,\"],\"header_type\": \"dictionary\",\"must_fail\": true},{\"name\": \"empty item dictionary\",\"raw\": [\"a=1,,b=2,\"],\"header_type\": \"dictionary\",\"must_fail\": true},{\"name\": \"duplicate key dictionary\",\"raw\": [\"a=1,b=2,a=3\"],\"header_type\": \"dictionary\",\"expected\": {\"a\": [3, {}], \"b\": [2, {}]},\"canonical\": [\"a=3, b=2\"]},{\"name\": \"numeric key dictionary\",\"raw\": [\"a=1,1b=2,a=1\"],\"header_type\": \"dictionary\",\"must_fail\": true},{\"name\": \"uppercase key dictionary\",\"raw\": [\"a=1,B=2,a=1\"],\"header_type\": \"dictionary\",\"must_fail\": true},{\"name\": \"bad key dictionary\",\"raw\": [\"a=1,b!=2,a=1\"],\"header_type\": \"dictionary\",\"must_fail\": true}]";
//  NSString *numberTestsJson = @"[{\"name\": \"basic integer\",\"raw\": [\"42\"],\"header_type\": \"item\",\"expected\": [42, {}]},{\"name\": \"zero integer\",\"raw\": [\"0\"],\"header_type\": \"item\",\"expected\": [0, {}]},{\"name\": \"leading 0 zero\",\"raw\": [\"00\"],\"header_type\": \"item\",\"expected\": [0, {}],\"canonical\": [\"0\"]},{\"name\": \"negative zero\",\"raw\": [\"-0\"],\"header_type\": \"item\",\"expected\": [0, {}],\"canonical\": [\"0\"]},{\"name\": \"double negative zero\",\"raw\": [\"--0\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"negative integer\",\"raw\": [\"-42\"],\"header_type\": \"item\",\"expected\": [-42, {}]},{\"name\": \"leading 0 integer\",\"raw\": [\"042\"],\"header_type\": \"item\",\"expected\": [42, {}],\"canonical\": [\"42\"]},{\"name\": \"leading 0 negative integer\",\"raw\": [\"-042\"],\"header_type\": \"item\",\"expected\": [-42, {}],\"canonical\": [\"-42\"]},{\"name\": \"leading 0 zero\",\"raw\": [\"00\"],\"header_type\": \"item\",\"expected\": [0, {}],\"canonical\": [\"0\"]},{\"name\": \"comma\",\"raw\": [\"2,3\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"negative non-DIGIT first character\",\"raw\": [\"-a23\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"sign out of place\",\"raw\": [\"4-2\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"whitespace after sign\",\"raw\": [\"- 42\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"long integer\",\"raw\": [\"123456789012345\"],\"header_type\": \"item\",\"expected\": [123456789012345, {}]},{\"name\": \"long negative integer\",\"raw\": [\"-123456789012345\"],\"header_type\": \"item\",\"expected\": [-123456789012345, {}]},{\"name\": \"too long integer\",\"raw\": [\"1234567890123456\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"negative too long integer\",\"raw\": [\"-1234567890123456\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"simple decimal\",\"raw\": [\"1.23\"],\"header_type\": \"item\",\"expected\": [1.23, {}]},{\"name\": \"negative decimal\",\"raw\": [\"-1.23\"],\"header_type\": \"item\",\"expected\": [-1.23, {}]},{\"name\": \"decimal, whitespace after decimal\",\"raw\": [\"1. 23\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"decimal, whitespace before decimal\",\"raw\": [\"1 .23\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"negative decimal, whitespace after sign\",\"raw\": [\"- 1.23\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"tricky precision decimal\",\"raw\": [\"123456789012.1\"],\"header_type\": \"item\",\"expected\": [123456789012.1, {}]},{\"name\": \"double decimal decimal\",\"raw\": [\"1.5.4\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"adjacent double decimal decimal\",\"raw\": [\"1..4\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"decimal with three fractional digits\",\"raw\": [\"1.123\"],\"header_type\": \"item\",\"expected\": [1.123, {}]},{\"name\": \"negative decimal with three fractional digits\",\"raw\": [\"-1.123\"],\"header_type\": \"item\",\"expected\": [-1.123, {}]},{\"name\": \"decimal with four fractional digits\",\"raw\": [\"1.1234\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"negative decimal with four fractional digits\",\"raw\": [\"-1.1234\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"decimal with thirteen integer digits\",\"raw\": [\"1234567890123.0\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"negative decimal with thirteen integer digits\",\"raw\": [\"-1234567890123.0\"],\"header_type\": \"item\",\"must_fail\": true}]";
//  NSString *stringTestsJson = @"[{\"name\": \"basic string\",\"raw\": [\"\\\"foo bar\\\"\"],\"header_type\": \"item\",\"expected\": [\"foo bar\", {}]},{\"name\": \"empty string\",\"raw\": [\"\\\"\\\"\"],\"header_type\": \"item\",\"expected\": [\"\", {}]},{\"name\": \"long string\",\"raw\": [\"\\\"foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo \\\"\"],\"header_type\": \"item\",\"expected\": [\"foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo foo \", {}]},{\"name\": \"whitespace string\",\"raw\": [\"\\\" \\\"\"],\"header_type\": \"item\",\"expected\": [\" \", {}]},{\"name\": \"non-ascii string\",\"raw\": [\"\\\"füü\\\"\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"tab in string\",\"raw\": [\"\\\"\\\\t\\\"\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"newline in string\",\"raw\": [\"\\\" \\\\n \\\"\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"single quoted string\",\"raw\": [\"'foo'\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"unbalanced string\",\"raw\": [\"\\\"foo\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"string quoting\",\"raw\": [\"\\\"foo \\\\\\\"bar\\\\\\\" \\\\\\\\ baz\\\"\"],\"header_type\": \"item\",\"expected\": [\"foo \\\"bar\\\" \\\\ baz\", {}]},{\"name\": \"bad string quoting\",\"raw\": [\"\\\"foo \\\\,\\\"\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"ending string quote\",\"raw\": [\"\\\"foo \\\\\\\"\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"abruptly ending string quote\",\"raw\": [\"\\\"foo \\\\\"],\"header_type\": \"item\",\"must_fail\": true}]";
//  NSString *binaryTestsJson = @"[{\"name\": \"basic binary\",\"raw\": [\":aGVsbG8=:\"],\"header_type\": \"item\",\"expected\": [{\"__type\": \"binary\", \"value\": \"NBSWY3DP\"},{}]},{\"name\": \"empty binary\",\"raw\": [\"::\"],\"header_type\": \"item\",\"expected\": [{\"__type\": \"binary\", \"value\": \"\"},{}]},{\"name\": \"bad paddding\",\"raw\": [\":aGVsbG8:\"],\"header_type\": \"item\",\"expected\": [{\"__type\": \"binary\", \"value\": \"NBSWY3DP\"},{}],\"can_fail\": true,\"canonical\": [\":aGVsbG8=:\"]},{\"name\": \"bad end delimiter\",\"raw\": [\":aGVsbG8=\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"extra whitespace\",\"raw\": [\":aGVsb G8=:\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"extra chars\",\"raw\": [\":aGVsbG!8=:\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"suffix chars\",\"raw\": [\":aGVsbG8=!:\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"non-zero pad bits\",\"raw\": [\":iZ==:\"],\"header_type\": \"item\",\"expected\": [{\"__type\": \"binary\", \"value\": \"RE======\"},{}],\"can_fail\": true,\"canonical\": [\":iQ==:\"]},{\"name\": \"non-ASCII binary\",\"raw\": [\":/+Ah:\"],\"header_type\": \"item\",\"expected\": [{\"__type\": \"binary\", \"value\": \"77QCC===\"},{}]},{\"name\": \"base64url binary\",\"raw\": [\":_-Ah:\"],\"header_type\": \"item\",\"must_fail\": true}]";
  NSString *booleanTestsJson = @"[{\"name\": \"basic true boolean\",\"raw\": [\"?1\"],\"header_type\": \"item\",\"expected\": [true, {}]},{\"name\": \"basic false boolean\",\"raw\": [\"?0\"],\"header_type\": \"item\",\"expected\": [false, {}]},{\"name\": \"unknown boolean\",\"raw\": [\"?Q\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"whitespace boolean\",\"raw\": [\"? 1\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"negative zero boolean\",\"raw\": [\"?-0\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"T boolean\",\"raw\": [\"?T\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"F boolean\",\"raw\": [\"?F\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"t boolean\",\"raw\": [\"?t\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"f boolean\",\"raw\": [\"?f\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"spelled-out True boolean\",\"raw\": [\"?True\"],\"header_type\": \"item\",\"must_fail\": true},{\"name\": \"spelled-out False boolean\",\"raw\": [\"?False\"],\"header_type\": \"item\",\"must_fail\": true}]";

  NSError *error;
  NSArray<NSDictionary *> *tests = [NSJSONSerialization JSONObjectWithData:[booleanTestsJson dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
  XCTAssertNil(error);
  
  for (NSDictionary *test in tests) {
    EXUpdatesStructuredHeaders *parser = [[EXUpdatesStructuredHeaders alloc] initWithRawInput:test[@"raw"][0]];
    if ([(NSNumber *)test[@"must_fail"] boolValue]) {
      XCTAssertNil([parser parseItemForTest]);
//      XCTAssertNil([EXUpdatesStructuredHeaders parseStructuredHeader:test[@"raw"][0] withFieldType:@"dictionary"]);
    } else {
      XCTAssertEqualObjects(test[@"expected"][0], [parser parseItemForTest]);

//      NSData *result = [parser parseItemForTest];
//      NSString *actual = [[self class] base32StringFromData:result];
//      NSString *expected = test[@"expected"][0][@"value"];
//      if ([(NSNumber *)test[@"can_fail"] boolValue]) {
//        XCTAssert(!result || [actual isEqual:expected]);
//      } else {
//        XCTAssertEqualObjects(expected, actual);
//      }

//      NSDictionary *raw = [EXUpdatesStructuredHeaders parseStructuredHeader:test[@"raw"][0] withFieldType:@"dictionary"];
//      NSMutableDictionary *processed = [NSMutableDictionary new];
//      [raw enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//        processed[key] = @[obj, @{}];
//      }];
//      XCTAssertEqualObjects(test[@"expected"], [processed copy]);
    }
  }
}

// https://github.com/ekscrypto/Base32/blob/77e2871b17d71891a6e56e007221d84d77e566b9/Base32/MF_Base32Additions.m
+ (NSString *)base32StringFromData:(NSData *)data
{
  NSString *encoding = nil;
  unsigned char *encodingBytes = NULL;
  @try {
    static char encodingTable[32] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567";
    static NSUInteger paddingTable[] = {0,6,4,3,1};
    
    //                     Table 3: The Base 32 Alphabet
    //
    // Value Encoding  Value Encoding  Value Encoding  Value Encoding
    //     0 A             9 J            18 S            27 3
    //     1 B            10 K            19 T            28 4
    //     2 C            11 L            20 U            29 5
    //     3 D            12 M            21 V            30 6
    //     4 E            13 N            22 W            31 7
    //     5 F            14 O            23 X
    //     6 G            15 P            24 Y         (pad) =
    //     7 H            16 Q            25 Z
    //     8 I            17 R            26 2
    
    NSUInteger dataLength = [data length];
    NSUInteger encodedBlocks = dataLength / 5;
    if( (encodedBlocks + 1) >= (NSUIntegerMax / 8) ) return nil; // NSUInteger overflow check
    NSUInteger padding = paddingTable[dataLength % 5];
    if( padding > 0 ) encodedBlocks++;
    NSUInteger encodedLength = encodedBlocks * 8;
    
    encodingBytes = calloc(encodedLength, 1);
    if( encodingBytes != NULL ) {
      NSUInteger rawBytesToProcess = dataLength;
      NSUInteger rawBaseIndex = 0;
      NSUInteger encodingBaseIndex = 0;
      unsigned char *rawBytes = (unsigned char *)[data bytes];
      unsigned char rawByte1, rawByte2, rawByte3, rawByte4, rawByte5;
      while( rawBytesToProcess >= 5 ) {
        rawByte1 = rawBytes[rawBaseIndex];
        rawByte2 = rawBytes[rawBaseIndex+1];
        rawByte3 = rawBytes[rawBaseIndex+2];
        rawByte4 = rawBytes[rawBaseIndex+3];
        rawByte5 = rawBytes[rawBaseIndex+4];
        encodingBytes[encodingBaseIndex] = encodingTable[((rawByte1 >> 3) & 0x1F)];
        encodingBytes[encodingBaseIndex+1] = encodingTable[((rawByte1 << 2) & 0x1C) | ((rawByte2 >> 6) & 0x03) ];
        encodingBytes[encodingBaseIndex+2] = encodingTable[((rawByte2 >> 1) & 0x1F)];
        encodingBytes[encodingBaseIndex+3] = encodingTable[((rawByte2 << 4) & 0x10) | ((rawByte3 >> 4) & 0x0F)];
        encodingBytes[encodingBaseIndex+4] = encodingTable[((rawByte3 << 1) & 0x1E) | ((rawByte4 >> 7) & 0x01)];
        encodingBytes[encodingBaseIndex+5] = encodingTable[((rawByte4 >> 2) & 0x1F)];
        encodingBytes[encodingBaseIndex+6] = encodingTable[((rawByte4 << 3) & 0x18) | ((rawByte5 >> 5) & 0x07)];
        encodingBytes[encodingBaseIndex+7] = encodingTable[rawByte5 & 0x1F];
        
        rawBaseIndex += 5;
        encodingBaseIndex += 8;
        rawBytesToProcess -= 5;
      }
      rawByte4 = 0;
      rawByte3 = 0;
      rawByte2 = 0;
      switch (dataLength-rawBaseIndex) {
        case 4:
          rawByte4 = rawBytes[rawBaseIndex+3];
        case 3:
          rawByte3 = rawBytes[rawBaseIndex+2];
        case 2:
          rawByte2 = rawBytes[rawBaseIndex+1];
        case 1:
          rawByte1 = rawBytes[rawBaseIndex];
          encodingBytes[encodingBaseIndex] = encodingTable[((rawByte1 >> 3) & 0x1F)];
          encodingBytes[encodingBaseIndex+1] = encodingTable[((rawByte1 << 2) & 0x1C) | ((rawByte2 >> 6) & 0x03) ];
          encodingBytes[encodingBaseIndex+2] = encodingTable[((rawByte2 >> 1) & 0x1F)];
          encodingBytes[encodingBaseIndex+3] = encodingTable[((rawByte2 << 4) & 0x10) | ((rawByte3 >> 4) & 0x0F)];
          encodingBytes[encodingBaseIndex+4] = encodingTable[((rawByte3 << 1) & 0x1E) | ((rawByte4 >> 7) & 0x01)];
          encodingBytes[encodingBaseIndex+5] = encodingTable[((rawByte4 >> 2) & 0x1F)];
          encodingBytes[encodingBaseIndex+6] = encodingTable[((rawByte4 << 3) & 0x18)];
          // we can skip rawByte5 since we have a partial block it would always be 0
          break;
      }
      // compute location from where to begin inserting padding, it may overwrite some bytes from the partial block encoding
      // if their value was 0 (cases 1-3).
      encodingBaseIndex = encodedLength - padding;
      while( padding-- > 0 ) {
        encodingBytes[encodingBaseIndex++] = '=';
      }
      encoding = [[NSString alloc] initWithBytes:encodingBytes length:encodedLength encoding:NSASCIIStringEncoding];
    }
  }
  @catch (NSException *exception) {
    encoding = nil;
    NSLog(@"WARNING: error occured while tring to encode base 32 data: %@", exception);
  }
  @finally {
    if( encodingBytes != NULL ) {
      free( encodingBytes );
    }
  }
  return encoding;
}

@end

