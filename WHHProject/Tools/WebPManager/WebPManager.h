//
//  WebPManager.h
//  WHHProject
//
//  Created by wenhuan on 2025/9/24.
//

#import <Foundation/Foundation.h>
#import "YYWebImage.h"

NS_ASSUME_NONNULL_BEGIN

@interface WebPManager : NSObject
+ (void)loadNetWebUrl:(NSString *)url displayImageView:(YYAnimatedImageView *)imageView;
@end

NS_ASSUME_NONNULL_END
