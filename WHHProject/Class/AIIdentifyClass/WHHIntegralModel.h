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

@property(nonatomic,copy) NSString *userid;

@property(nonatomic,copy) NSString *worksId;

@property(nonatomic,assign) BOOL canMaking;

@property(nonatomic,strong) NSArray<WHHIntegralModel *> *list;
@property(nonatomic,assign) NSInteger status;
@property(nonatomic,copy) NSString *coverUrl;
@property(nonatomic,strong) NSArray<NSString * > *worksUrls;
@property(nonatomic,assign) NSInteger source;
@property(nonatomic,copy) NSString *prompt;
@property(nonatomic,copy) NSString *speech;
@property(nonatomic,strong) WHHIntegralModel *stat;
@property(nonatomic,assign) NSInteger likeCnt;
@property(nonatomic,assign) BOOL likeStatus;
@property(nonatomic,strong) WHHIntegralModel *creator;
@property(nonatomic,assign) NSInteger gender;
@property(nonatomic,copy) NSString *nickname;
@property(nonatomic,copy) NSString *logo;
@property(nonatomic,copy) NSString *background;
@property(nonatomic,copy) NSString *birthday;
@property(nonatomic,copy) NSString *onlineTime;

@end

NS_ASSUME_NONNULL_END
