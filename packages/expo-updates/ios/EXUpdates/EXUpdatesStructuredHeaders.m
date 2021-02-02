//  Copyright © 2021 650 Industries. All rights reserved.

#import <EXUpdates/EXUpdatesStructuredHeaders.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, EXUpdatesStructuredHeadersNumberType) {
  EXUpdatesStructuredHeadersNumberTypeInteger = 0,
  EXUpdatesStructuredHeadersNumberTypeDecimal = 1
};

@interface EXUpdatesStructuredHeaders ()

@property (nonatomic, strong) NSString *raw;
@property (nonatomic, assign) NSUInteger position;

@end

@implementation EXUpdatesStructuredHeaders

- (instancetype)initWithRawInput:(NSString *)raw
{
  if (self = [super init]) {
    _raw = raw;
    _position = 0;
  }
  return self;
}

- (nullable NSData *)parseItemForTest
{
  NSData *parsed = [self _parseABooleanWithError:nil];
  [self removeLeadingSP];
  return ![self hasRemaining] ? parsed : nil;
}

- (nullable id)_parseABareItem:(NSError ** _Nullable)error
{
  // 4.2.3.1
  unichar firstChar = [self peek];
  if ([self isDigit:firstChar] || firstChar == '-') {
    return [self _parseAnIntegerOrDecimalWithError:error];
  } else if (firstChar == '"') {
    return [self _parseAStringWithError:error];
  } else if ([self isAlpha:firstChar] || firstChar == '*') {
    return [self _parseATokenWithError:error];
  } else if (firstChar == ':') {
    return [self _parseAByteSequenceWithError:error];
  } else if (firstChar == '?') {
    return [self _parseABooleanWithError:error];
  } else {
    if (error) *error = [self errorWithMessage:@"Unrecognized item type"];
    return nil;
  }
}

- (nullable NSString *)_parseAKey:(NSError ** _Nullable)error
{
  // 4.2.3.3
  unichar firstChar = [self peek];
  if (![self isLowercaseAlpha:firstChar] && firstChar != '*') {
    if (error) *error = [self errorWithMessage:@"Key must begin with a lowercase letter or '*'"];
    return nil;
  }

  NSMutableString *outputString = [NSMutableString stringWithCapacity:[self remainingLength]];
  while ([self hasRemaining]) {
    unichar nextChar = [self peek];
    if (![self isLowercaseAlpha:nextChar] && ![self isDigit:nextChar] && ![self compareChar:nextChar withSet:@"_-.*"]) {
      return [outputString copy];
    } else {
      [outputString appendFormat:@"%c", nextChar];
      [self advance];
    }
  }

  return [outputString copy];
}

- (nullable NSNumber *)_parseAnIntegerOrDecimalWithError:(NSError ** _Nullable)error
{
  // 4.2.4
  EXUpdatesStructuredHeadersNumberType type = EXUpdatesStructuredHeadersNumberTypeInteger;
  NSInteger sign = 1;
  NSMutableString *inputNumber = [NSMutableString stringWithCapacity:20];

  if ([self compareNextChar:'-']) {
    [self advance];
    sign = -1;
  }

  if (![self hasRemaining]) {
    if (error) *error = [self errorWithMessage:@"Integer or decimal cannot be empty"];
    return nil;
  }

  if (![self isDigit:[self peek]]) {
    if (error) *error = [self errorWithMessage:@"Integer or decimal must begin with a digit"];
    return nil;
  }

  while ([self hasRemaining]) {
    unichar nextChar = [self consume];
    if ([self isDigit:nextChar]) {
      [inputNumber appendFormat:@"%c", nextChar];
    } else if (type == EXUpdatesStructuredHeadersNumberTypeInteger && nextChar == '.') {
      if (inputNumber.length > 12) {
        if (error) *error = [self errorWithMessage:@"Decimal cannot have more than 12 digits before the decimal point"];
        return nil;
      }
      [inputNumber appendFormat:@"%c", nextChar];
      type = EXUpdatesStructuredHeadersNumberTypeDecimal;
    } else {
      [self backout];
      break;
    }

    if (type == EXUpdatesStructuredHeadersNumberTypeInteger && inputNumber.length > 15) {
      if (error) *error = [self errorWithMessage:@"Integer cannot have more than 15 digits"];
      return nil;
    } else if (type == EXUpdatesStructuredHeadersNumberTypeDecimal && inputNumber.length > 16) {
      if (error) *error = [self errorWithMessage:@"Decimal cannot have more than 16 characters"];
      return nil;
    }
  }

  if (type == EXUpdatesStructuredHeadersNumberTypeInteger) {
    return @(inputNumber.longLongValue * sign);
  } else {
    if ([inputNumber hasSuffix:@"."]) {
      if (error) *error = [self errorWithMessage:@"Decimal cannot end with the character '.'"];
      return nil;
    }
    if ([inputNumber rangeOfString:@"."].location + 3 < inputNumber.length - 1) {
      if (error) *error = [self errorWithMessage:@"Decimal cannot have more than 3 digits after the decimal point"];
      return nil;
    }
    return @(inputNumber.doubleValue * sign);
  }
}

- (nullable NSString *)_parseAStringWithError:(NSError ** _Nullable)error
{
  // 4.2.5
  NSMutableString *outputString = [NSMutableString stringWithCapacity:[self remainingLength]];

  if (![self compareNextChar:'"']) {
    if (error) *error = [self errorWithMessage:@"String must begin with the character '\"'"];
    return nil;
  }

  [self advance];
  while ([self hasRemaining]) {
    unichar nextChar = [self consume];
    if (nextChar == '\\') {
      if (![self hasRemaining]) {
        if (error) *error = [self errorWithMessage:@"String cannot end with the character '\\'"];
        return nil;
      }
      unichar followingChar = [self consume];
      if (![self compareChar:followingChar withSet:@"\"\\"]) {
        if (error) *error = [self errorWithMessage:@"String cannot contain '\\' followed by an invalid character"];
        return nil;
      }
      [outputString appendFormat:@"%c", followingChar];
    } else if (nextChar == '"') {
      return [outputString copy];
    } else if (nextChar < 0x20 || nextChar >= 0x7F) {
      if (error) *error = [self errorWithMessage:@"Invalid character in string"];
      return nil;
    } else {
      [outputString appendFormat:@"%c", nextChar];
    }
  }

  if (error) *error = [self errorWithMessage:@"String must have a closing '\"'"];
  return nil;
}

- (nullable NSString *)_parseATokenWithError:(NSError ** _Nullable)error
{
  // 4.2.6
  unichar firstChar = [self peek];
  if (![self isAlpha:firstChar] && firstChar != '*') {
    if (error) *error = [self errorWithMessage:@"Token must begin with an alphabetic character or '*'"];
    return nil;
  }

  NSMutableString *outputString = [NSMutableString stringWithCapacity:[self remainingLength]];
  while ([self hasRemaining]) {
    // the only allowed characters are tchar, ':', and '/'
    // check to see if nextChar is outside this set
    unichar nextChar = [self peek];
    if (nextChar <= ' ' || nextChar >= 0x7F || [self compareChar:nextChar withSet:@"\"(),;<=>?@[\\]{}"]) {
      return [outputString copy];
    } else {
      [outputString appendFormat:@"%c", [self consume]];
    }
  }

  return [outputString copy];
}

- (nullable NSData *)_parseAByteSequenceWithError:(NSError ** _Nullable)error
{
  // 4.2.7
  if (![self compareNextChar:':']) {
    if (error) *error = [self errorWithMessage:@"Byte sequence must begin with ':'"];
    return nil;
  }

  [self advance];
  NSMutableString *inputByteSequence = [NSMutableString stringWithCapacity:[self remainingLength]];
  while ([self hasRemaining]) {
    unichar nextChar = [self consume];
    if (nextChar == ':') {
      return [[NSData alloc] initWithBase64EncodedString:inputByteSequence options:kNilOptions];
    } else if (![self isBase64:nextChar]) {
      if (error) *error = [self errorWithMessage:@"Byte sequence can only contain valid base64 characters"];
      return nil;
    } else {
      [inputByteSequence appendFormat:@"%c", nextChar];
    }
  }

  if (error) *error = [self errorWithMessage:@"Byte sequence must have a closing ':'"];
  return nil;
}

- (nullable NSNumber *)_parseABooleanWithError:(NSError ** _Nullable)error
{
  // 4.2.8
  if (![self compareNextChar:'?']) {
    if (error) *error = [self errorWithMessage:@"Boolean must begin with '?'"];
    return nil;
  }

  [self advance];
  unichar nextChar = [self peek];
  if (nextChar == '1') {
    [self advance];
    return @(YES);
  } else if (nextChar == '0') {
    [self advance];
    return @(NO);
  } else {
    if (error) *error = [self errorWithMessage:@"Invalid value for boolean"];
    return nil;
  }
}

# pragma mark - utility methods

- (BOOL)hasRemaining
{
  return _position < _raw.length;
}

- (NSUInteger)remainingLength
{
  return _raw.length - _position;
}

- (unichar)peek
{
  return [self hasRemaining] ? [_raw characterAtIndex:_position] : (unichar) -1;
}

- (void)advance
{
  _position++;
}

- (void)backout
{
  _position--;
}

- (unichar)consume
{
  unichar thisChar = [self peek];
  [self advance];
  return thisChar;
}

- (BOOL)compareNextChar:(unichar)match
{
  return [self hasRemaining] ? [self peek] == match : NO;
}

- (BOOL)compareNextCharWithSet:(NSString *)charset
{
  return [self hasRemaining] ? [self compareChar:[self peek] withSet:charset] : NO;
}

- (void)removeLeadingSP
{
  while ([self compareNextChar:' ']) {
    [self advance];
  }
}

- (BOOL)compareChar:(unichar)ch withSet:(NSString *)charset
{
  return [charset containsString:[NSString stringWithFormat:@"%c", ch]];
}

- (BOOL)isDigit:(unichar)ch
{
  return ch >= '0' && ch <= '9';
}

- (BOOL)isLowercaseAlpha:(unichar)ch
{
  return ch >= 'a' && ch <= 'z';
}

- (BOOL)isAlpha:(unichar)ch
{
  return (ch >= 'A' && ch <= 'Z') || (ch >= 'a' && ch <= 'z');
}

- (BOOL)isBase64:(unichar)ch
{
  return (ch >= '0' && ch <= '9') || (ch >= 'A' && ch <= 'Z') || (ch >= 'a' && ch <= 'z') || ch == '+' || ch == '/' || ch == '=';
}

- (NSError *)errorWithMessage:(NSString *)message
{
  // TODO: implement this
  return [NSError new];
}

@end

NS_ASSUME_NONNULL_END
