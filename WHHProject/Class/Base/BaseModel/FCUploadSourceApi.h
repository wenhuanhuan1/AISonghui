//
//  FCUploadSourceApi.h
//  WHHProject
//
//  Created by wenhuan on 2025/9/3.
//

#import "WHHRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface FCUploadSourceApi : WHHRequest


-(instancetype)initWHHUploadWithType:(int)type sourceData:(NSData *)imageData;
@end

NS_ASSUME_NONNULL_END
