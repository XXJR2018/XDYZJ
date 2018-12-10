//
//  ADViewController.m
//  DDGAPP
//
//  Created by admin on 15/3/3.
//  Copyright (c) 2015年 Cary. All rights reserved.
//

#import "ADViewController.h"

@interface ADViewController ()<UIWebViewDelegate>

@end

@implementation ADViewController

#pragma mark === viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self appearedLoad];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.reloadTitle = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (_adTitle && _adTitle.length > 0) {
        [self layoutNaviBarViewWithTitle:_adTitle];
    }
    
    [self layoutWebView];
}

-(void)layoutWebView
{
    float originY = _adTitle && _adTitle.length > 0 ? NavHeight : 20.0;
    CGRect frame = CGRectMake(0, originY, self.view.bounds.size.width, self.view.bounds.size.height - originY);
    UIWebView * webView = [[UIWebView alloc]initWithFrame:frame];
    webView.backgroundColor = [ResourceManager viewBackgroundColor];
    webView.scalesPageToFit = YES;
    webView.delegate = self;
    
    if (self.param) {
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:[[NSURL URLWithString:self.url] absoluteString] parameters:self.param error:nil];
        [webView loadRequest:request];
    }else{
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.f];
        [webView loadRequest:request];
    }
    
    [self.view addSubview:webView];
}

#pragma mark ==== UIWebViewDelegate
-(void)webViewDidFinishLoad:(UIWebView *)webView{
//    [MBProgressHUD hideAllHUDsForView:webView animated:YES];
    
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[CustomNavigationBarView class]] && self.reloadTitle) {
            CustomNavigationBarView *barView = (CustomNavigationBarView *)view;
            self.adTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
            barView.titleLab.text = self.adTitle;
        }
    }
}

#pragma mark - webViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString * requestString = [[request URL] absoluteString];
    requestString = [requestString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //获取H5页面里面按钮的操作方法,根据这个进行判断返回是内部的还是push的上一级页面
    if ([requestString hasSuffix:@"goback"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [webView goBack];
    }
    return YES;
}

//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
//{
//    //判断是否是单击
//    if (navigationType == UIWebViewNavigationTypeLinkClicked)
//    {
//        NSURL *url = [request URL];
//        if([[UIApplication sharedApplication] canOpenURL:url])
//        {
//            ADViewController *ctl = [[ADViewController alloc]init];
//            ctl.url = [url absoluteString];
//            ctl.adTitle = self.adTitle;
//            [self.navigationController pushViewController:ctl animated:YES];
//        }
//        return NO;
//    }
//    return YES;
//}




@end
