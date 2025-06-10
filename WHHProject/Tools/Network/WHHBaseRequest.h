//
//  WHHBaseRequest.h
//  WHHProject
//
//  Created by wenhuan on 2025/6/10.
//

#import <YTKNetwork/YTKNetwork.h>
#import "WHHRequestModel.h"
NS_ASSUME_NONNULL_BEGIN


typedef void(^WHHBaseRequestHandle)(WHHRequestModel *model);

@interface WHHBaseRequest : YTKBaseRequest

- (void)whhBeginNetworkingRequestSuccess:(WHHBaseRequestHandle)success failure:(WHHBaseRequestHandle)failure;
@end

NS_ASSUME_NONNULL_END
