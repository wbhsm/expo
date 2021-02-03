//  Copyright © 2021 650 Industries. All rights reserved.

#import "NSArray+EXStructuredHeadersTests.h"

NS_ASSUME_NONNULL_BEGIN

@implementation NSArray (EXStructuredHeadersTests)

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

NS_ASSUME_NONNULL_END
