//
//  WHHBaseRequest.m
//  WHHProject
//
//  Created by wenhuan on 2025/6/10.
//

#import "WHHBaseRequest.h"
#import "MJExtension.h"

#import "WHHProject-Swift.h"



#ifdef DEBUG
#define whhLog(FORMAT, ...) fprintf(stderr, "%s:%d\t%s\n", [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ## __VA_ARGS__] UTF8String]);
#else
#define whhLog(...)
#endif


@implementation WHHBaseRequest


- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

- (YTKResponseSerializerType)responseSerializerType {
    return YTKResponseSerializerTypeJSON;
}

///// 设置header
//- (NSDictionary *)requestHeaderFieldValueDictionary {
//    NSString *verStr = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    NSString *uuid = [YCDeviceManager shared].getDeviceId;
//
//    NSString *currentTimestampString = [NSString stringWithFormat:@"%ld", [self wzGetNowCurrentTimestamp]];
//
//    NSString *osString = [UIDevice currentDevice].systemVersion;
//
//    NSString *phoneNameString = [UIDevice currentDevice].systemName;
//
//
//    NSString *osName = [NSString stringWithFormat:@"%@ %@", phoneNameString, osString];
//
//    NSString *queryString;
//
//    if ([self requestMethod] == YTKRequestMethodPOST) {
//        NSError *error;
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self requestArgument] options:0 error:&error];
//        queryString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    } else if ([self requestMethod] == YTKRequestMethodGET) {
//        queryString =  [self wzSortRequestParameterDic:[self requestArgument]];
//    }
//
//    NSString *oStr;
//
////    if ([self requestMethod] == YTKRequestMethodPOST) {
////        oStr = [NSString stringWithFormat:@"%@%@%@%@", [self requestUrl], timeMeetMD5HashWithString(queryString), currentTimestampString, [TimeMeetNetConfiguration timeMeetSaltKey]];
////    } else if ([self requestMethod] == YTKRequestMethodGET) {
////        oStr = [NSString stringWithFormat:@"%@%@%@%@", [self requestUrl], queryString, currentTimestampString, [TimeMeetNetConfiguration timeMeetSaltKey]];
////    }
//
//    NSString *token = [YCAIUserManager shared].token;
//
//    NSMutableDictionary *headerDict = [NSMutableDictionary dictionary];
//
//    [headerDict setValue:verStr forKey:@"v"];
//    [headerDict setValue:currentTimestampString forKey:@"t"];
//    [headerDict setValue:uuid forKey:@"d"];
//    [headerDict setValue:@"ios" forKey:@"o"];
////    [headerDict setValue:timeMeetMD5HashWithString(oStr) forKey:@"s"];
//    [headerDict setValue:token forKey:@"Authorization"];
//    [headerDict setValue:osName forKey:@"os"];
////    [headerDict setValue:TimeMeetDeviceTools.deviceName forKey:@"model"];
//
//    YCLog(@"请求的header结果%@", headerDict);
//
//    return headerDict.copy;
//}

//- (long)wzGetNowCurrentTimestamp {
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
//
//    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
//    [formatter setTimeZone:timeZone];
//    NSDate *datenow = [NSDate date];
//
//    long timeSp = [[NSNumber numberWithDouble:[datenow timeIntervalSince1970] * 1000] longValue];
//    return timeSp;
//}
//
//- (NSString *)wzSortRequestParameterDic:(NSDictionary *)dic {
//    NSArray *keyArray = [dic allKeys];
//
//    NSArray *sortArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult (id _Nonnull obj1, id _Nonnull obj2) {
//        return [obj1 compare:obj2
//                     options:NSNumericSearch];
//    }];
//    NSMutableArray *valueArray = [NSMutableArray array];
//
//    for (NSString *sortString in sortArray) {
//        [valueArray addObject:[dic objectForKey:sortString]];
//    }
//
//    NSMutableArray *signArray = [NSMutableArray array];
//
//    for (int i = 0; i < sortArray.count; i++) {
//        NSString *keyValeStr = [NSString stringWithFormat:@"%@=%@", sortArray[i], valueArray[i]];
//        [signArray addObject:keyValeStr];
//    }
//
//    NSString *sign = [signArray componentsJoinedByString:@"&"];
//
//    return sign;
//}

- (void)whhBeginNetworkingRequestSuccess:(WHHBaseRequestHandle)success failure:(WHHBaseRequestHandle)failure{
    
    
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
        if (success) {
            NSDictionary *dict = request.responseString.mj_JSONObject;
            WHHRequestModel *model = [WHHRequestModel mj_objectWithKeyValues:dict];
            
            whhLog(@"返回的原始结果%@", dict);
            whhLog(@"请求的参数%@", request.requestArgument);
            whhLog(@"Request url%@%@", [WHHEnvironmentConf baseUrl],request.requestUrl);
            
            success(model);
           
        }
    } failure:^(__kindof YTKBaseRequest *_Nonnull request) {

        NSDictionary *dict = request.responseString.mj_JSONObject;
        WHHRequestModel *model = [WHHRequestModel mj_objectWithKeyValues:dict];

        if (model == nil) {
            model = [[WHHRequestModel alloc] init];
            model.msg = @"请检查网络";
            model.code = -10000;
        }
      
        if (failure) {
            failure(model);
        }
    }];
    
}
@end
