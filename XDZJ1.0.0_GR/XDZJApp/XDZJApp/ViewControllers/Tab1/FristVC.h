//
//  FristVC.h
//  XXStatshipApp
//
//  Created by xxjr02 on 2018/6/8.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefreshViewController.h"

@interface FristVC : MJRefreshViewController

@property(nonatomic,strong) UIView *tabBar;

-(void)addButtonView;

@end
