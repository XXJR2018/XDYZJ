//
//  LightingSucces.h
//  XXJR
//
//  Created by xxjr02 on 2018/2/7.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LightingSucces : CommonViewController

@property (nonatomic,assign) float  fOrderMoney; // 订单的原始价格
@property (nonatomic,assign) float  ffRealMoney; // 订单的实际购买价格
@property (nonatomic,assign) float  fYHMoney; // 订单的优惠金额
@property (nonatomic,assign) int  iAddSocre; // 赠送积分
@property (nonatomic,strong) NSString * businessId;  // 抢单ID

@end
