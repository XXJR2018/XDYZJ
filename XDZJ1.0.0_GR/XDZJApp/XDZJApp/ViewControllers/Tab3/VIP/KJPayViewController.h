//
//  KJPayViewController.h
//  XXJR
//
//  Created by xxjr03 on 2017/5/22.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import "CommonViewController.h"

@interface KJPayViewController : CommonViewController

@property(nonatomic,copy)NSString *usableAmount;  // 当前用户余额

@property(nonatomic,copy)NSString *moneyNum;  // 当前充值金额

@property(nonatomic,copy) NSString *strAddMoney;  // 支付成功时的奖励

@property(nonatomic,copy)NSString *rechargeType; // 充值类型    r- 余额充值    s - 优质单充值

@property(nonatomic,assign) long   couponId;     // 充值券的ID




@end
