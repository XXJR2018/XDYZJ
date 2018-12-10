//
//  SelectDZQController.h
//  XXJR
//
//  Created by xxjr02 on 2018/2/7.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefreshViewController.h"

@interface SelectDZQController : MJRefreshViewController


@property (nonatomic,strong) Block_Id selectBlock;

@property (nonatomic,strong) NSArray *arrDZQ;

@property (nonatomic,strong) NSString *ticketId;  //优惠券的ID

@property (nonatomic,assign) int  iOrderMoney; // 订单的原始价格

@property (nonatomic,strong) NSDictionary *dicData; // 抢单的本身信息

// --- 个性化参数 begin
@property (nonatomic,assign) int  iRobWay; //当为7时为特价抢单

@property (nonatomic,assign) BOOL  isTGKH ; // 是否是推广客户订单

@property (nonatomic,strong) NSString *receiveId; // 推广客户订单时，使用的推广记录id
// --- 个性化参数 end


@end
