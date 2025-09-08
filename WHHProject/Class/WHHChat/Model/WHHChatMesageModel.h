//
//  WHHChatMesageModel.h
//  WHHProject
//
//  Created by wenhuan on 2025/9/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



typedef NS_ENUM(NSInteger, WHHChatMesageDirection) {
    /// 消息发送方
    WHHChatMesageDirectionSend,
    /// 消息接受方
    WHHChatMesageDirectionReceive,
};


@interface WHHChatMesageModel : NSObject

/// 用户头像
@property(nonatomic,copy) NSString *icon;
/// 聊天内容
@property(nonatomic,copy) NSString *chatContent;
/// 消息方向
@property(nonatomic,assign) WHHChatMesageDirection messageDirection;

@end

NS_ASSUME_NONNULL_END
