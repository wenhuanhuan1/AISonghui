//
//  WHHAIChatListModel.h
//  WHHProject
//
//  Created by wenhuan on 2025/11/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WHHAIChatListModel : NSObject

@property(nonatomic,copy) NSString *conversationId;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *createTime;
@property(nonatomic,copy) NSString *content;
@property(nonatomic,copy) NSString *messageType;

@end

NS_ASSUME_NONNULL_END
