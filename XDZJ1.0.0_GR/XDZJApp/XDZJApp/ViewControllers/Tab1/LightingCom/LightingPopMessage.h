//
//  LightingPopMessage.h
//  XXJR
//
//  Created by xxjr02 on 2018/2/7.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import <UIKit/UIKit.h>


// 抢单
@interface LightingPopMessage : UIView

@property (nonatomic,strong) Block_Void okBlock;

@property (nonatomic,strong) Block_Void cancelBlock;

@property (nonatomic,strong) UIViewController  *parentVC;

@property (nonatomic,strong) NSDictionary *dicData; // 抢单的本身信息

@property (nonatomic,strong) NSArray *arrDZQ ; // 打折券的数组（未过滤）

// --- 个性化参数 begin
@property (nonatomic,assign) int  iRobWay; //当为7时为特价抢单

@property (nonatomic,assign) BOOL  isTGKH ; // 是否是推广客户订单

@property (nonatomic,assign) BOOL  isYZKH; // 是否是优质客户订单

@property (nonatomic,strong) NSString *receiveId; // 推广客户订单时，使用的推广记录id
// --- 个性化参数 begin

@property (nonatomic,assign) float  fUsableAmount ; //用户可用余额

@property (nonatomic,assign) BOOL  canUseTicket ; //能否用打折券（老用户的充值金额是否用完）

@property (nonatomic,assign) int flag;  //   0 客户无券  1 该单有可使用的券(显示第一张)  2该单有可使用的券，但还有赠送金额不能用(暂不能使用)   3客户有券，但该单不可用(暂不能使用)  4， 推广客户时，抢单券暂不可用
//  初始化
-(instancetype)initWithDic:(NSDictionary*) dicValue  arraryDZQ:(NSArray*) arrValue
              usebleAmount:(float) fValue  canUse:(BOOL) bValue ;

// 会员特价  初始化
-(instancetype)initWithDic:(NSDictionary*) dicValue  robWay:(int) iValue  arraryDZQ:(NSArray*) arrValue
              usebleAmount:(float) fValue  canUse:(BOOL) bValue ;

// 推广客户所用 初始化函数
-(instancetype)initTGKHWithDic:(NSDictionary*) dicValue  arraryDZQ:(NSArray*) arrValue
              usebleAmount:(float) fValue ;

- (void)show;

@end
