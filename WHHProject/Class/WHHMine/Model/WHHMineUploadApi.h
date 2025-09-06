//
//  WHHMineUploadApi.h
//  WHHProject
//
//  Created by wenhuan on 2025/9/6.
//

#import <Foundation/Foundation.h>
#import "WHHRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface WHHMineUploadApi : WHHRequest
-(instancetype)initWHHUploadWithType:(int)type sourceData:(NSData *)imageData content:(NSString *)feedBackContent;
@end

NS_ASSUME_NONNULL_END
