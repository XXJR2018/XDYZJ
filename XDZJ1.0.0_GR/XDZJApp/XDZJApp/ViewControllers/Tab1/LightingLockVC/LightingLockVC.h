//
//  LightingLockVC.h
//  XDZJApp
//
//  Created by xxjr02 on 2018/8/9.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LightingLockVC : CommonViewController

@property (nonatomic,strong) NSDictionary *dataDic; // 抢单的本身信息

@property (nonatomic,strong) NSArray * arrCustTickets;  // 打折券的数组

@property (nonatomic,assign) float usableAmount;    // 可用余额

@property (nonatomic,assign)   BOOL  canUseTicket;  // 能否用打折券

@property (nonatomic,assign) int score;   // 积分 （审核时用到积分抢单）

@property (nonatomic,assign) int robNum;

@end
