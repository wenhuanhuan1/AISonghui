//
//  FCMineModel.h
//  WHHProject
//
//  Created by wenhuan on 2025/9/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FCMineModel : NSObject

/// 1男2女
@property(nonatomic,assign) NSInteger gender;
@property(nonatomic,copy) NSString *birthday;
@property(nonatomic,copy) NSString *logo;
/// 状态 1：正常 2：封禁 3：永久封禁
@property(nonatomic,assign) NSInteger status;

/// vip：0 非vip 1 vip
@property(nonatomic,assign) NSInteger vip;

@property(nonatomic,copy) NSString *vipExpireTime;

@property(nonatomic,assign) NSInteger luckValueNum;

@property(nonatomic,copy) NSString *nickname;


// 支付相关
@property(nonatomic,assign) NSInteger hasPlay;

@property(nonatomic,copy) NSString *prompt;


@end



NS_ASSUME_NONNULL_END
