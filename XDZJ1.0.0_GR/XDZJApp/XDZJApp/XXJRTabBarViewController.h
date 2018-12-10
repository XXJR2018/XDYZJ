//
//  DDGTabBarViewController.h
//  DDGProject
//
//  Created by Cary on 15/1/1.
//  Copyright (c) 2015年 Cary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FristVC.h"
#import "SecondVC.h"
#import "ThridVC.h"

#import "XXJRSelectButton.h"


@interface XXJRTabBarViewController : UITabBarController

/*!
 @brief     当前控制器
 */
@property (nonatomic, strong) UINavigationController *homeViewController;

/**
 *  按钮视图
 */
@property (strong, nonatomic)  UIView *buttonsView;


@property (strong, nonatomic)  XXJRSelectButton *tab1_Button;
@property (strong, nonatomic)  XXJRSelectButton *tab2_Button;
@property (strong, nonatomic)  XXJRSelectButton *tab3_Button;


/**
 *  点击按钮
 */
- (void)tabButtonPressed:(id)sender;



@end
