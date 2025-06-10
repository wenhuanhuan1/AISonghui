//
//  WHHRequestModel.h
//  WHHProject
//
//  Created by wenhuan on 2025/6/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WHHRequestModel : NSObject
@property(nonatomic,assign) NSInteger code;
@property(nonatomic,strong) id data;
@property(nonatomic,copy) NSString *msg;

@end

NS_ASSUME_NONNULL_END
