//
//  WHHMineUploadApi.m
//  WHHProject
//
//  Created by wenhuan on 2025/9/6.
//

#import "WHHMineUploadApi.h"
#import "WHHProject-Swift.h"

@interface WHHMineUploadApi()
@property(nonatomic,strong) NSData *data;
@property(nonatomic,assign) NSInteger type;
@property(nonatomic,copy) NSString *tempFeedBackContent;

@end
@implementation WHHMineUploadApi
-(instancetype)initWHHUploadWithType:(int)type sourceData:(NSData *)imageData content:(NSString *)feedBackContent{
    
    if (self = [super init]){
        
        self.data = imageData;
        self.type = type;
        self.tempFeedBackContent = feedBackContent;
    }
    return self;
    
}
- (NSString *)requestUrl {
    return @"sys/feedback";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}


//body
- (id)requestArgument {

    return @{
        @"api-v":[WHHNetConf apiv],
        @"type":@(self.type),
        @"userId":[WHHUserInfoManager shared].userId,
        @"content":self.tempFeedBackContent
    };
}

//设置上传图片 所需要的 HTTP HEADER
- (AFConstructingBlock)constructingBodyBlock {
    NSData *data = self.data;

    return ^(id<AFMultipartFormData> formData) {
               NSString *name = @"files";
               NSString *fileName = @"upload.jpeg";
               NSString *type = @"image/jpeg";
               [formData appendPartWithFileData:data name:name fileName:fileName mimeType:type];
    };
}

@end
