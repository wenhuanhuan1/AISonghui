//
//  WebPManager.m
//  WHHProject
//
//  Created by wenhuan on 2025/9/24.
//

#import "WebPManager.h"
@implementation WebPManager
+ (void)loadNetWebUrl:(NSString *)url displayImageView:(YYAnimatedImageView *)imageView{
    
    NSURL *imageUrl = [[NSURL alloc] initWithString:url];
        
    [imageView yy_setImageWithURL:imageUrl
                                   options:YYWebImageOptionShowNetworkActivity | YYWebImageOptionProgressive | YYWebImageOptionIgnoreImageDecoding];
}
@end
