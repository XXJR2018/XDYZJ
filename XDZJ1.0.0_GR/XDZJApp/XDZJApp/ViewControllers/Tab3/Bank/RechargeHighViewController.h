//
//  RechargeHighViewController.h
//  XXJR
//
//  Created by xxjr02 on 2017/3/27.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RechargeHighViewController : CommonViewController

@property (nonatomic, assign) int  iEveryAomunt;     // 每单金额
@property (nonatomic, assign) int  iCharging;        // 每笔扣费
@property (nonatomic, strong) NSString  *strAcountAmount;    // 账户余额

@end
