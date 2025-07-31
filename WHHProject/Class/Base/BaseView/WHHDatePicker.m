//
//  WHHDatePicker.m
//  WHHProject
//
//  Created by wenhuan on 2025/7/29.
//

#import "BRDatePickerView.h"
#import "WHHDatePicker.h"
#define whhWeakSelf(weakSelf) __weak __typeof(&*self) weakSelf = self;

@interface WHHDatePicker ()
@property (nonatomic, strong) BRDatePickerView *datePickerView;

@end

@implementation WHHDatePicker
- (BRDatePickerView *)datePickerView {
    if (!_datePickerView) {
        _datePickerView = [[BRDatePickerView alloc]init];
        // 2.设置属性
        _datePickerView.selectDate = [NSDate date];
        _datePickerView.minDate = [NSDate br_setYear:1949 month:3 day:12];
        _datePickerView.maxDate = [NSDate date];
        _datePickerView.isAutoSelect = YES;

        _datePickerView.pickerMode = BRDatePickerModeYMD;
        _datePickerView.title = @"选择出生日期";
        _datePickerView.selectDate = [NSDate br_setYear:2006 month:1 day:1];
        _datePickerView.minDate = [NSDate br_setYear:1922 month:1 day:1];
        _datePickerView.maxDate = [NSDate date];

        BRPickerStyle *customStyle = [[BRPickerStyle alloc]init];
        customStyle.pickerColor = [UIColor whiteColor];
        customStyle.topCornerRadius = 8;
        customStyle.hiddenTitleLine = YES;
        customStyle.separatorColor = [UIColor clearColor];
        customStyle.titleBarColor = [UIColor whiteColor];
        customStyle.cancelTextColor = [UIColor blueColor];
        customStyle.doneTextColor = [UIColor blueColor];
        customStyle.pickerTextColor = [UIColor blackColor];
        customStyle.titleTextColor = [UIColor blackColor];
        customStyle.titleTextFont = [UIFont systemFontOfSize:16];
        _datePickerView.pickerStyle = customStyle;
        whhWeakSelf(weakSelf)
    }

    return _datePickerView;
}

- (instancetype)initSelectValue:(void (^)(NSDate *_Nonnull, NSString *_Nonnull))resultBlock {
    if (self = [super init]) {
        self.datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
            if (resultBlock) {
                resultBlock(selectDate, selectValue);
            }
        };
    }

    return self;
}

- (void)show {
    [self.datePickerView show];
}

@end
