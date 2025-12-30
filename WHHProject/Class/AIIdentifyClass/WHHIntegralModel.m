//
//  WHHIntegralModel.m
//  WHHProject
//
//  Created by wenhuan on 2025/12/27.
//

#import "WHHIntegralModel.h"
#import <MJExtension/MJExtension.h>
@implementation WHHIntegralModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"lastGetMaxId":@"id",@"userid":@"id"};
    
}

+(NSDictionary *)mj_objectClassInArray{
    
    return @{@"list":[WHHIntegralModel class]};
}

@end
