//
//  WHHBaseModel.h
//  WHHProject
//
//  Created by wenhuan on 2025/6/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WHHBaseModel : NSObject
@property(nonatomic,copy) NSString *msg;
@property(nonatomic,strong) id data;
@property(nonatomic,assign) NSInteger success;

@end

NS_ASSUME_NONNULL_END
