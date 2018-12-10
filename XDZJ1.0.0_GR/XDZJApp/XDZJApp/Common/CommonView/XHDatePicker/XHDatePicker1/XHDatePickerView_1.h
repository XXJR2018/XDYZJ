//
//  XHDatePickerView.h
//  XHDatePicker
//
//  Created by 江欣华 on 16/8/16.
//  Copyright © 2016年 江欣华. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    DateStyleShowYearMonthDayHourMinute  = 0,
    DateStyleShowMonthDayHourMinute,
    DateStyleShowYearMonthDay,
    DateStyleShowMonthDay,
    DateStyleShowHourMinute
    
}XHDateStyle;

typedef enum{
    DateTypeStartDate,
    DateTypeEndDate
    
}XHDateType;

@interface XHDatePickerView_1 : UIView

@property (nonatomic,assign)XHDateStyle datePickerStyle;
@property (nonatomic,assign)XHDateType dateType;
@property (nonatomic,strong)UIColor *themeColor;

@property (nonatomic, retain) NSDate *maxLimitDate;//限制最大时间（没有设置默认2049）
@property (nonatomic, retain) NSDate *minLimitDate;//限制最小时间（没有设置默认1970）

@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *endDate;

@property (weak, nonatomic) IBOutlet UILabel *beginTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

-(instancetype)initWithCompleteBlock:(void(^)(NSDate *,NSDate *))completeBlock;


-(void)show;

//滚动到指定的时间位置
- (void)getNowDate:(NSDate *)date animated:(BOOL)animated;


@end
