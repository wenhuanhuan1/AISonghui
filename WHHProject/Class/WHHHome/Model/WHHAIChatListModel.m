//
//  WHHAIChatListModel.m
//  WHHProject
//
//  Created by wenhuan on 2025/11/7.
//

#import "WHHAIChatListModel.h"

@implementation WHHAIChatListModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"conversationId":@"id"};
}

@end
