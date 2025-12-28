//
//  WHHIntegralModel.h
//  WHHProject
//
//  Created by wenhuan on 2025/12/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WHHIntegralModel : NSObject

@property(nonatomic,assign) BOOL income;
@property(nonatomic,copy) NSString *num;
@property(nonatomic,copy) NSString *leftNum;
@property(nonatomic,assign) NSInteger type;
@property(nonatomic,copy) NSString *remark;
@property(nonatomic,assign) double createTime;
@property(nonatomic,copy) NSString *lastGetMaxId;

@property(nonatomic,assign) BOOL canMaking;

@property(nonatomic,strong) NSArray<WHHIntegralModel *> *list;
@property(nonatomic,copy) NSString *worksId;
@property(nonatomic,assign) NSInteger status;

@end

NS_ASSUME_NONNULL_END
