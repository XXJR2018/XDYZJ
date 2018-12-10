//
//  TradingStautsVC.h
//  XXJR
//
//  Created by xxjr02 on 2017/10/12.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TradingStautsVC : CommonViewController

@property (nonatomic, assign) int  iStatus; // 1 - 交易成功，  2 - 交易中，  3 - 交易失败
@property (nonatomic, strong) NSString  *strError; // 失败的原因
@property (nonatomic, strong) NSString  *tradeId; // 本次交易的id
@property (nonatomic,strong) NSString  *strAddMoney;  // 交易成功时，所送的奖励




//"0000" to "交易成功",
//"BF00100" to "系统异常，请联系宝付",
//"BF00112" to "系统繁忙，请稍后再试",
//"BF00113" to "交易结果未知，请稍后查询",
//"BF00144" to "该交易有风险,订单处理中",
//"BF00115" to "交易处理中，请稍后查询",
//"BF00202" to "交易超时，请稍后查询")
@property (nonatomic, strong) NSString  *strStatus; // 状态码
@property (nonatomic, strong) NSString  *strTardingDes; // 交易中的原因

@end
