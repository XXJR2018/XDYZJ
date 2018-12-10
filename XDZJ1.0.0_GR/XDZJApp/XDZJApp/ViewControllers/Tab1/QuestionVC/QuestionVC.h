//
//  QuestionVC.h
//  XXJR
//
//  Created by xxjr02 on 2018/7/12.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface QuestionVC : CommonViewController

@property (strong, nonatomic) NSURL *homeUrl;
@property (strong, nonatomic) NSString *titleStr;

// 弹出页面形式 push or present
@property (nonatomic,assign) BOOL isPresent;

@property (strong, nonatomic) WKWebView *wkWebView;

@end
