//
//  WHHRequest.h
//  WHHProject
//
//  Created by wenhuan on 2025/9/1.
//

#import <UIKit/UIKit.h>
#import "YTKNetwork.h"
#import "WHHBaseModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^whhRequestHandle)(WHHBaseModel *model);

@interface WHHRequest : YTKRequest

- (void)whhStartRequestConsequenceHandle:(whhRequestHandle)handle;
@end

NS_ASSUME_NONNULL_END
