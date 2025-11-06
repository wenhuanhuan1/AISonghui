//
//  WHHVIPCenterModel.h
//  WHHProject
//
//  Created by wenhuan on 2025/8/3.
//

#import "WHHBaseModel.h"
#import "MJRefresh.h"
NS_ASSUME_NONNULL_BEGIN

@interface WHHVIPCenterModel : NSObject
@property(nonatomic,copy) NSString *price;
@property(nonatomic,assign) BOOL isSelect;
@property(nonatomic,copy) NSString *code;
@property(nonatomic,copy) NSString *productId;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *shopId;

@property(nonatomic,copy) NSString *orderId;
@property(nonatomic,copy) NSString *uuid;
@property(nonatomic,copy) NSString *payAmount;

/// 0 门票 1：vip
@property(nonatomic,assign) NSInteger groups;
@property(nonatomic,copy) NSString *discountedPrice;
/// 1：周卡 2：月卡 3：年卡
@property(nonatomic,assign) NSInteger type;


@end

NS_ASSUME_NONNULL_END
