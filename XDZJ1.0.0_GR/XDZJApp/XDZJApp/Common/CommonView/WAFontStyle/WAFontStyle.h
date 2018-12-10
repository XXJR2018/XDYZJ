//
//  WAFontStyle.h
//  UIPickerViewDemo
//
//  Created by gamin on 15/4/29.
//  Copyright (c) 2015年 gamin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WAFontStyle : UIViewController <UIPickerViewDelegate,UIPickerViewDataSource>



@property (strong, nonatomic) NSMutableArray *nsNumXX;//下限金额
@property (strong, nonatomic) NSMutableArray *nsDwXX;//下限单位
@property (strong, nonatomic) NSMutableArray *nsDao;//到 
@property (strong, nonatomic) NSMutableArray *nsNumSX;//上限金额
@property (strong, nonatomic) NSMutableArray *nsDwSX;//上限单位

@property (nonatomic) float   wChioceSize;//选择字体大小


@end
