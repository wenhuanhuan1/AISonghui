//
//  WHHAIDestinyLineItemModel.h
//  WHHProject
//
//  Created by wenhuan on 2025/10/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WHHAIDestinyLineItemModel : NSObject
@property(nonatomic,assign) BOOL income;
@property(nonatomic,copy) NSString *num;

@property(nonatomic,copy) NSString *leftNum;
@property(nonatomic,copy) NSString *type;
@property(nonatomic,copy) NSString *remark;
@property(nonatomic,assign) double createTime;
@property(nonatomic,copy) NSString *lastGetMaxId;

@end

NS_ASSUME_NONNULL_END
