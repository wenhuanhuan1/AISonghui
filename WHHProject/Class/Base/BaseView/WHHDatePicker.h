//
//  WHHDatePicker.h
//  WHHProject
//
//  Created by wenhuan on 2025/7/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WHHDatePicker : NSObject
-(instancetype)initSelectValue:(void(^)(NSDate *selectDate, NSString *selectValue))resultBlock;
- (void)show;
@end

NS_ASSUME_NONNULL_END
