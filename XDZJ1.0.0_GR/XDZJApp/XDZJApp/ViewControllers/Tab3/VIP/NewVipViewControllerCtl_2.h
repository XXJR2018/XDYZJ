//
//  NewVipViewControllerCtl_2.h
//  XXJR
//
//  Created by xxjr02 on 2017/12/15.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewVipViewControllerCtl_2 : CommonViewController
@property(nonatomic,copy)NSString *usableAmount;
@property(nonatomic,assign)NSInteger vipGrade;
@property(nonatomic,copy)NSString *vipEndDate;
@property(nonatomic,copy)NSArray *vipDataArr;

@property(nonatomic,assign) int  iMoney;  // 优惠券的最低使用金额@end
@end
