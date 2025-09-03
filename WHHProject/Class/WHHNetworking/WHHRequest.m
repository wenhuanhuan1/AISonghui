//
//  WHHRequest.m
//  WHHProject
//
//  Created by wenhuan on 2025/9/1.
//

#import "MJExtension.h"
#import "WHHRequest.h"

#import "WHHProject-Swift.h"

#ifdef DEBUG
#define WHHLog(FORMAT, ...) fprintf(stderr, "%s:%d\t%s\n", [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ## __VA_ARGS__] UTF8String]);
#else
#define WHHLog(...)
#endif
#import <CommonCrypto/CommonDigest.h>


static NSString *key = @"1B7q3Y2D*%-f1IW-";

@implementation WHHRequest


/// 计算字符串的32位小写MD5
static inline NSString *MD5Lower32(NSString *input) {
    if (input.length == 0) return @"";
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH]; // 16字节
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    // 转成32位小写十六进制
    NSMutableString *out = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [out appendFormat:@"%02x", digest[i]]; // %02x -> 小写并补零
    }
    return out;
}


- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeHTTP;
}

- (YTKResponseSerializerType)responseSerializerType {
    return YTKResponseSerializerTypeJSON;
}

-(NSString *)baseUrl {
    
    return WHHEnvironmentConf.baseUrl;
    
}
- (void)whhStartRequestConsequenceHandle:(whhRequestHandle)handle {
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
        NSDictionary *dict = request.responseString.mj_JSONObject;
        WHHBaseModel *model = [WHHBaseModel mj_objectWithKeyValues:dict];

        WHHLog(@"Result%@", dict);
        WHHLog(@"Request parameter%@", request.requestArgument);
        WHHLog(@"Result of request%@\nrequest的url = %@\n", dict, request.requestUrl);

        if (handle) {
            handle(model);
        }
    } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
        WHHLog(@"Request error=%@\n message = %@", [NSString stringWithFormat:@"%@%@", request.baseUrl, request.requestUrl], request.error);
        WHHLog(@"Request parameter%@", request.requestArgument);

        NSDictionary *dict = request.responseString.mj_JSONObject;
        WHHBaseModel *model = [WHHBaseModel mj_objectWithKeyValues:dict];

        if (model == nil) {
            model = [[WHHBaseModel alloc] init];
            model.msg = @"请检查网络";
            model.code = -10000;
        }

        if (handle) {
            handle(model);
        }
    }];
    
}


- (NSDictionary *)requestHeaderFieldValueDictionary {
    NSString *verStr = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    NSString *uuid = TimeMeetDeviceTools.getDevieUUID;

    NSString *currentTimestampString = [NSString stringWithFormat:@"%ld", [self whhGetCurrentTimestamp]];

    NSString *osString = [UIDevice currentDevice].systemVersion;

    NSString *phoneNameString = [UIDevice currentDevice].systemName;


    NSString *osName = [NSString stringWithFormat:@"%@ %@", phoneNameString, osString];

    NSString *queryString;

//    if ([self requestMethod] == YTKRequestMethodPOST) {
//        NSError *error;
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self requestArgument] options:0 error:&error];
//        queryString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//        
//    } else if ([self requestMethod] == YTKRequestMethodGET) {
//        queryString =  [self whhSortRequestParameterDic:[self requestArgument]];
//    }
//    
    
    queryString =  [self whhSortRequestParameterDic:[self requestArgument]];

    NSString *oStr;

//    if ([self requestMethod] == YTKRequestMethodPOST) {
//        oStr = [NSString stringWithFormat:@"%@%@%@%@", [self requestUrl], MD5Lower32(queryString), currentTimestampString,key];
//    } else if ([self requestMethod] == YTKRequestMethodGET) {
//        oStr = [NSString stringWithFormat:@"%@%@%@%@", [self requestUrl], queryString, currentTimestampString, key];
//    }
    
    
    NSString *token = [WHHUserInfoManager shared].token;
    
    NSString *kid = [WHHUserInfoManager shared].userId;
    
    NSString *signBefore = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",@"5556",kid,@"1",verStr,currentTimestampString,queryString,key,token];

    NSString *md5tring = MD5Lower32(signBefore);
        
    NSMutableDictionary *headerDict = [NSMutableDictionary dictionary];
    [headerDict setValue:@"5556" forKey:@"k"];
   
    [headerDict setValue:verStr forKey:@"v"];
    [headerDict setValue:currentTimestampString forKey:@"ts"];
    [headerDict setValue:@"1" forKey:@"t"];
    [headerDict setValue:token forKey:@"i"];

    [headerDict setValue:[WHHUserInfoManager shared].userId forKey:@"kid"];
    
    [headerDict setValue:md5tring forKey:@"s"];

    WHHLog(@"请求的header结果%@", headerDict);

    return headerDict.copy;
}

- (long)whhGetCurrentTimestamp {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];

    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];

    long timeSp = [[NSNumber numberWithDouble:[datenow timeIntervalSince1970]] longValue];
    return timeSp;
}

- (NSString *)whhSortRequestParameterDic:(NSDictionary *)dic {
    NSArray *keyArray = [dic allKeys];

    NSArray *sortArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult (id _Nonnull obj1, id _Nonnull obj2) {
        return [obj1 compare:obj2
                     options:NSNumericSearch];
    }];
    NSMutableArray *valueArray = [NSMutableArray array];

    for (NSString *sortString in sortArray) {
        [valueArray addObject:[dic objectForKey:sortString]];
    }

    NSMutableArray *signArray = [NSMutableArray array];

    for (int i = 0; i < sortArray.count; i++) {
        NSString *keyValeStr = [NSString stringWithFormat:@"%@=%@", sortArray[i], valueArray[i]];
        [signArray addObject:keyValeStr];
    }

    NSString *sign = [signArray componentsJoinedByString:@"&"];

    return sign;
}

@end
