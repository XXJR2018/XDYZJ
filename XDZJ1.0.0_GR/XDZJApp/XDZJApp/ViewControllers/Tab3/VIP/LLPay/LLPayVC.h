//
//  LLPayVC.h
//  XXJR
//
//  Created by xxjr02 on 2017/10/19.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLPaySdk.h"

@interface LLPayVC : CommonViewController<LLPaySdkDelegate>


@property(nonatomic,copy)NSString *usableAmount;  // 当前用户余额

@property(nonatomic,copy)NSString *moneyNum;  // 当前充值金额

@property(nonatomic,copy)NSString *rechargeType; // 充值类型    llrz- 连连认证支付    llkj - 连连快捷支付

@property(nonatomic,assign) long   couponId;     // 充值券的ID

@property(nonatomic,copy) NSString *strAddMoney;  // 支付成功时的奖励

@end
