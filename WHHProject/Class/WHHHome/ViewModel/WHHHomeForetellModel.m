//
//  WHHHomeForetellModel.m
//  WHHProject
//
//  Created by wenhuan on 2025/9/6.
//

#import "WHHHomeForetellModel.h"
#import "MJExtension.h"

@implementation WHHHomeForetellItemModel


@end

@implementation WHHHomeForetellModel

+(NSDictionary *)mj_objectClassInArray{
    
    return @{@"items":[WHHHomeForetellItemModel class]};
    
}
@end
