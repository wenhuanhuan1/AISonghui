//
//  WHHVIPCenterModel.h
//  WHHProject
//
//  Created by wenhuan on 2025/8/3.
//

#import "WHHBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WHHVIPCenterModel : WHHBaseModel
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,assign) BOOL isSelect;

@end

NS_ASSUME_NONNULL_END
