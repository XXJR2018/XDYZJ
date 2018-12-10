//
//  AgreementViewController.m
//  DDGProject
//
//  Created by admin on 15/1/26.
//  Copyright (c) 2015年 Cary. All rights reserved.
//

#import "AgreementViewController.h"

@interface AgreementViewController ()

@end

@implementation AgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self layoutNaviBarViewWithTitle: @"小小金融用户注册协议"];
    [self setUpWebview];
}

- (void)popBack
{
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)setUpWebview
{
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight)];
    NSString *url = [NSString stringWithFormat:@"%@registerProtocol",[PDAPI WXSysRouteAPI]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    webView.backgroundColor = [UIColor whiteColor];
    [webView setScalesPageToFit:YES];
    [webView loadRequest:request];
    [self.view addSubview:webView];

}
@end
