//
//  WHHChatMesageModel.h
//  WHHProject
//
//  Created by wenhuan on 2025/9/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN




@interface WHHChatMesageModel : NSObject

/// 用户头像
@property(nonatomic,copy) NSString *icon;

@property(nonatomic,copy) NSString *messageId;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *createTime;
@property(nonatomic,copy) NSString *content;
@property(nonatomic,copy) NSString *messageType;


@end

NS_ASSUME_NONNULL_END
