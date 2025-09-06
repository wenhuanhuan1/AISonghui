//
//  WHHSystemModel.h
//  WHHProject
//
//  Created by wenhuan on 2025/9/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WHHSystemModel : NSObject
@property(nonatomic,copy) NSString *systemTime;
@property(nonatomic,strong) WHHSystemModel *config;
@property(nonatomic,copy) NSString *sts;
@property(nonatomic,copy) NSString *recordNumber;
@property(nonatomic,copy) NSString *registerAgreementUrl;
@property(nonatomic,copy) NSString *privacyAgreementUrl;
@property(nonatomic,copy) NSString *fraudPreventionUrl;
@property(nonatomic,copy) NSString *contactUsMail;
@property(nonatomic,copy) NSString *vipAgreementUrl;

@end

NS_ASSUME_NONNULL_END
