//
//  FCUploadSourceApi.m
//  WHHProject
//
//  Created by wenhuan on 2025/9/3.
//

#import "FCUploadSourceApi.h"
#import "WHHProject-Swift.h"
@interface FCUploadSourceApi()
@property(nonatomic,strong) NSData *data;
@property(nonatomic,assign) NSInteger type;

@end

@implementation FCUploadSourceApi

-(instancetype)initWHHUploadWithType:(int)type sourceData:(NSData *)imageData{
    
    if (self = [super init]){
        
        self.data = imageData;
        self.type = type;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/file/upload";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}


//body
- (id)requestArgument {

    return @{
        @"api-v":[WHHNetConf apiv],
        @"type":@(self.type),
        @"userId":[WHHUserInfoManager shared].userId
    };
}

//设置上传图片 所需要的 HTTP HEADER
- (AFConstructingBlock)constructingBodyBlock {
    NSData *data = self.data;

    if (self.type != 5) {
        return ^(id<AFMultipartFormData> formData) {
                   NSString *name = @"file";
                   NSString *fileName = @"upload.jpeg";
                   NSString *type = @"image/jpeg";
                   [formData appendPartWithFileData:data name:name fileName:fileName mimeType:type];
        };
    }else{
        return ^(id<AFMultipartFormData> formData) {
                   NSString *name = @"file";
                   NSString *fileName = @"uploadVoice.m4a";
                   NSString *type = @"audio/mp4";
                   [formData appendPartWithFileData:data name:name fileName:fileName mimeType:type];
        };
    }
   
}

@end
