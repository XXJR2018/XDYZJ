//
//  VIPViewControllerCtl_2.h
//  XXJR
//
//  Created by xxjr03 on 16/10/27.
//  Copyright © 2016年 Cary. All rights reserved.
//

#import "CommonViewController.h"

@interface VIPViewControllerCtl_2 : CommonViewController
@property(nonatomic,copy)NSString *usableAmount;
@property(nonatomic,assign)NSInteger vipGrade;
@property(nonatomic,copy)NSString *vipEndDate;
@property(nonatomic,copy)NSArray *vipDataArr;

@property(nonatomic,assign) int  iMoney;  // 优惠券的最低使用金额
@end
