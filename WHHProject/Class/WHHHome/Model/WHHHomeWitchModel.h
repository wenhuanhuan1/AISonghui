//
//  WHHHomeWitchModel.h
//  WHHProject
//
//  Created by wenhuan on 2025/9/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WHHHomeWitchModel : NSObject
@property(nonatomic,copy) NSString *meetingWords;
@property(nonatomic,copy) NSString *luckyColorValue;
@property(nonatomic,copy) NSString *goodAt;
@property(nonatomic,copy) NSString *goodAtIcon;

@property(nonatomic,copy) NSString *predictionName;
@property(nonatomic,copy) NSString *freeSubscribe;
@property(nonatomic,copy) NSString *icon;
@property(nonatomic,copy) NSString *luckyColor;
@property(nonatomic,copy) NSString *appearanceImage;
@property(nonatomic,copy) NSString *chatImage;
@property(nonatomic,copy) NSString *quotes;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,strong) NSArray<NSString *> *welfares;
@property(nonatomic,assign) NSInteger wichId;
@property(nonatomic,assign) BOOL subscribed;
@property(nonatomic,strong) WHHHomeWitchModel *stat;
@property(nonatomic,copy) NSString *fortuneTimes;
@property(nonatomic,copy) NSString *subscribeTimes;

/// 是否已经注销
@property(nonatomic,assign) BOOL destroyed;
/// 注销剩余时间
@property(nonatomic,assign) NSInteger leftDestroyTimeSeconds;

@property(nonatomic,assign) NSInteger exists;

@end

NS_ASSUME_NONNULL_END
