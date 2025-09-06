//
//  WHHHomeForetellModel.h
//  WHHProject
//
//  Created by wenhuan on 2025/9/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WHHHomeForetellItemModel : NSObject
@property(nonatomic,copy) NSString *score;
@property(nonatomic,copy) NSString *icon;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *content;
@property(nonatomic,copy) NSString *badLuck;
@property(nonatomic,copy) NSString *goodLuck;

@end

@interface WHHHomeForetellModel : NSObject
@property(nonatomic,copy) NSString *creating;
@property(nonatomic,copy) NSString *hasFortuneOld;
@property(nonatomic,strong) WHHHomeForetellModel *fortune;
@property(nonatomic,copy) NSString *luckyColorIntroduction;
@property(nonatomic,copy) NSString *avgScore;
@property(nonatomic,copy) NSString *luckyNumberIntroduction;
@property(nonatomic,copy) NSString *luckyGoods;
@property(nonatomic,copy) NSString *luckyColor;
@property(nonatomic,copy) NSString *luckyGoodsIntroduction;
@property(nonatomic,copy) NSString *luckyNumber;
@property(nonatomic,copy) NSString *suggestion;
@property(nonatomic,strong) NSArray<WHHHomeForetellItemModel*> *items;

@end

NS_ASSUME_NONNULL_END
