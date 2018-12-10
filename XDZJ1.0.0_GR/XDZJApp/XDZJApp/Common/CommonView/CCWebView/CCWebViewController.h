//
//  CCWebViewController.h
//  WebViewDemo
//
//  Created by dangxy on 16/9/6.
//  Copyright © 2016年 xproinfo.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"
@interface CCWebViewController : CommonViewController

@property (strong, nonatomic) NSURL *homeUrl;
@property (strong, nonatomic) NSString *titleStr;

// 弹出页面形式 push or present
@property (nonatomic,assign) BOOL isPresent;


// 短信获客的特色页面
@property (nonatomic,assign) BOOL isMessage;

// 微信支付的特色页面
@property (nonatomic,assign) BOOL isWeiXinPay;
@property (strong, nonatomic) NSString *payUrl;

// 抽奖记录页面
@property (nonatomic,assign) BOOL isChouJian;

// 兑换途径页面
@property (nonatomic,assign) BOOL isDHTJ;

@property (nonatomic,copy) Block_Void  messageBlock;

/** 传入控制器、url、标题 */
+ (void)showWithContro:(UIViewController *)contro withUrlStr:(NSString *)urlStr withTitle:(NSString *)title;



@end

