//
//  AppDelegate.h
//  XXStatshipApp
//
//  Created by xxjr02 on 2018/5/28.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXJRTabBarViewController.h"
#import "DDGShareManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,WeiboSDKDelegate>

@property (strong, nonatomic) UIWindow *window;

/*!
 @brief     根控制器
 */
@property (nonatomic, strong) XXJRTabBarViewController *tabBarRootViewController;
@property (nonatomic, strong) UIViewController *rootViewController;

/*!
 @brief     获取启动时第一个载入的viewController, 可能是引导页, 可能是标签导航页
 */
- (void)getStartUpViewController;

@end

