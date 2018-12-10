//
//  QDDetailVC.h
//  XXJR
//
//  Created by xxjr02 on 2017/5/19.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QDDetailVC_Majia : CommonViewController

@property (nonatomic,strong) NSDictionary *dataDicionary;// 详情数据存储字典

@property (nonatomic,strong) NSString *applyID;// 抢单ID

@property (nonatomic,copy) NSString *borrowId;


@property (nonatomic,assign) BOOL isNotQD; // 不能抢单的标志位  ture时，不能抢单

@property (nonatomic,assign) BOOL freeHour;

@property (nonatomic,assign) BOOL haveFreeRob;

@property (nonatomic,assign) int score;

@property (nonatomic,assign) int robNum;

@property (nonatomic,assign) float usableAmount;    // 可用余额

@property (nonatomic,copy) NSDictionary *lightDic;    // 数据

@property (nonatomic,assign)   BOOL  canUseTicket;  // 能否用打折券

@property (nonatomic,copy)    NSArray * arrCustTickets;  // 打折券的数组

/*
 * 处理成功回调
 */
@property (nonatomic,copy) Block_Void handleBlock;

@end
