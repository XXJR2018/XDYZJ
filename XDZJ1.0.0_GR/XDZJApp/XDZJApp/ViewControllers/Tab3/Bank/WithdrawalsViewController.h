//
//  WithdrawalsViewController.h
//  XXJR
//
//  Created by xxjr02 on 2017/3/27.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WithdrawalsViewController : CommonViewController

@property (nonatomic, assign) int  iCharging;        // 每笔扣费
@property (nonatomic, strong) NSString  *strAcountAmount;    // 账户余额
@property (nonatomic, strong) NSString  *strHidePhone;    // 隐藏电话号码
@property (nonatomic, strong) NSString  *strPhone;    // 电话号码
@property (nonatomic, strong)  NSString *strHideCard;    // 隐藏卡号

@end
