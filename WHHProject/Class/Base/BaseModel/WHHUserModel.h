//
//  WHHUserModel.h
//  WHHProject
//
//  Created by wenhuan on 2025/6/10.
//

#import "WHHBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WHHUserModel : WHHBaseModel
@property(nonatomic,copy) NSString *token;
@property(nonatomic,copy) NSString *userId;
@property(nonatomic,copy) NSString *refreshToken;
@property(nonatomic,copy) NSString *expiresIn;
@property(nonatomic,copy) NSString *refreshExpiresIn;
@property(nonatomic,assign) NSInteger vip;
@property(nonatomic,assign) NSInteger newUser;
@property(nonatomic,assign) NSInteger improveUserInfo;

@end

NS_ASSUME_NONNULL_END
