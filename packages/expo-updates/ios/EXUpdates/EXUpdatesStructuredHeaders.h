//  Copyright © 2021 650 Industries. All rights reserved.

NS_ASSUME_NONNULL_BEGIN

@interface EXUpdatesStructuredHeaders : NSObject

- (instancetype)initWithRawInput:(NSString *)raw;


- (nullable NSData *)parseItemForTest;

@end

NS_ASSUME_NONNULL_END
