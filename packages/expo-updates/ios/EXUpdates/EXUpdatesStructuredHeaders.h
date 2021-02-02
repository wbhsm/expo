//  Copyright © 2021 650 Industries. All rights reserved.

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, EXUpdatesStructuredHeadersFieldType) {
  EXUpdatesStructuredHeadersFieldTypeDictionary,
  EXUpdatesStructuredHeadersFieldTypeList,
  EXUpdatesStructuredHeadersFieldTypeItem
};

@interface EXUpdatesStructuredHeaders : NSObject

- (instancetype)initWithRawInput:(NSString *)raw fieldType:(EXUpdatesStructuredHeadersFieldType)fieldType;
- (nullable id)parseStructuredFieldsWithError:(NSError ** _Nullable)error;

@end

NS_ASSUME_NONNULL_END
