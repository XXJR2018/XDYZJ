//
//  SecondVC.h
//  XXStatshipApp
//
//  Created by xxjr02 on 2018/6/8.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefreshViewController.h"

@interface SecondVC :MJRefreshViewController

@property (nonatomic, assign) int  iFindStyle;  // 1 - 查询所有订单，  2 - 查询新订单， 3 - 查询筛选条件

@property(nonatomic,strong) UIView *tabBar;

-(void)addButtonView;

@end
