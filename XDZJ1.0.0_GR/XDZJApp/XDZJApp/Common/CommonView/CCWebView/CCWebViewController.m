//
//  CCWebViewController.m
//  WebViewDemo
//
//  Created by dangxy on 16/9/6.
//  Copyright © 2016年 xproinfo.com. All rights reserved.
//

#define MainColor     UIColorFromRGB(0xfc6923)  //主色

#import <WebKit/WebKit.h>
#import "CCWebViewController.h"
#import "MessageBoxView.h"



#define IOS8x ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
#define WebViewNav_TintColor ([UIColor orangeColor])

@interface CCWebViewController ()<UIWebViewDelegate,UIActionSheetDelegate,WKNavigationDelegate,MessageBoxViewDelegate,WKScriptMessageHandler>
@property (assign, nonatomic) NSUInteger loadCount;
@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) WKWebView *wkWebView;
@property (nonatomic ,strong)WKUserContentController * userCC;  // 为了和h5交互，所加入 (JavaScript)

@property (assign, nonatomic) BOOL isClickPay;

@end

@implementation CCWebViewController

/** 传入控制器、url、标题 */
+ (void)showWithContro:(UIViewController *)contro withUrlStr:(NSString *)urlStr withTitle:(NSString *)title {
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    CCWebViewController *webContro = [CCWebViewController new];
    webContro.homeUrl = [NSURL URLWithString:urlStr];
    webContro.titleStr = title;
    [contro.navigationController pushViewController:webContro animated:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isClickPay = NO;
    CustomNavigationBarView *nav = [self layoutWhiteNaviBarViewWithTitle:self.titleStr];
    [self configUI];
    
    
    float fRightBtnTopY =  NavHeight - 40;
    if (IS_IPHONE_X_MORE)
     {
        fRightBtnTopY = NavHeight - 42;
     }
    
//    if (_isChouJian  &&
//        ![PDAPI isTestUser])
//     {
//        UIButton *rightNavBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 70.f,fRightBtnTopY,70.f, 35.0f)];
//        [rightNavBtn setTitle:@"获奖记录" forState:UIControlStateNormal];
//        [rightNavBtn setTitleColor:[ResourceManager navgationTitleColor] forState:UIControlStateNormal];
//        [rightNavBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
//        [rightNavBtn addTarget:self action:@selector(actionCHJL) forControlEvents:UIControlEventTouchUpInside];
//        rightNavBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//        [nav addSubview:rightNavBtn];
//     }

    
   
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enterForeground)
                                                 name:DDGEnterForeground
                                               object:nil];
    
    


        

}

-(void) actionCHJL
{
    //抽奖
//    CJRecordVC *vc = [[CJRecordVC alloc] init];
//    [self.navigationController pushViewController:vc animated:NO];
}

-(void) enterForeground
{
    if (_isWeiXinPay &&
        _isClickPay)
     {
        _isClickPay = NO;
        //[self paySatuts];
     }
    
}

- (void)configUI {
    
    // 进度条
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, NavHeight, self.view.frame.size.width, 1)];
    progressView.tintColor = MainColor;
    progressView.trackTintColor = [UIColor whiteColor];
    [self.view addSubview:progressView];
    self.progressView = progressView;
    
    // 网页
    if (IOS8x) {
        
        WKWebViewConfiguration * config = [[WKWebViewConfiguration alloc]init];
        
        WKWebView *wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, NavHeight, self.view.frame.size.width, self.view.frame.size.height - NavHeight)  configuration:config];
        //        wkWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        if (_isMessage)
         {
            wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, NavHeight, self.view.frame.size.width, self.view.frame.size.height - NavHeight-40) configuration:config];
            
            UIButton *btOK = [[UIButton alloc] initWithFrame:CGRectMake(10*ScaleSize, self.view.frame.size.height - 40, SCREEN_WIDTH-20*ScaleSize, 40)];
            btOK.backgroundColor = [UIColor orangeColor];
            btOK.cornerRadius = 40/2;
            [btOK setTitle:@"创建短信模板" forState:UIControlStateNormal];
            [btOK setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
            btOK.titleLabel.font = [UIFont systemFontOfSize: 17.0];
            [btOK addTarget:self action:@selector(actionOK) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:btOK];
         }
        
        if (_isWeiXinPay)
         {
            wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, NavHeight, self.view.frame.size.width, self.view.frame.size.height - NavHeight-40) configuration:config];
            
            UIButton *btOK = [[UIButton alloc] initWithFrame:CGRectMake(10*ScaleSize, self.view.frame.size.height - 40, SCREEN_WIDTH-20*ScaleSize, 40)];
            btOK.backgroundColor = [ResourceManager mainColor];
            btOK.cornerRadius = 40/2;
            [btOK setTitle:@"开始支付" forState:UIControlStateNormal];
            [btOK setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
            btOK.titleLabel.font = [UIFont systemFontOfSize: 17.0];
            [btOK addTarget:self action:@selector(actionWeiPay) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:btOK];
         }
        
        
        self.userCC = config.userContentController;
        //此处相当于监听了JS中callFunction这个方法
        [self.userCC addScriptMessageHandler:self name:@"callFunction"];
        
        wkWebView.backgroundColor = [UIColor whiteColor];
        wkWebView.navigationDelegate = self;
        [self.view insertSubview:wkWebView belowSubview:progressView];
        
        [wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        NSURLRequest *request = [NSURLRequest requestWithURL:_homeUrl];
        [wkWebView loadRequest:request];
        self.wkWebView = wkWebView;
    }else {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, NavHeight, self.view.frame.size.width, self.view.frame.size.height - NavHeight)];
        //        webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        if (_isMessage)
         {
            webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, NavHeight, self.view.frame.size.width, self.view.frame.size.height - NavHeight-40)];
            
            UIButton *btOK = [[UIButton alloc] initWithFrame:CGRectMake(10*ScaleSize, self.view.frame.size.height -40, SCREEN_WIDTH-20*ScaleSize, 40)];
            btOK.backgroundColor = [UIColor orangeColor];
            btOK.cornerRadius = 40/2;
            [btOK setTitle:@"创建短信模板" forState:UIControlStateNormal];
            [btOK setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
            btOK.titleLabel.font = [UIFont systemFontOfSize: 17.0];
            [btOK addTarget:self action:@selector(actionOK) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:btOK];
         }
        
        if (_isWeiXinPay)
         {
            webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, NavHeight, self.view.frame.size.width, self.view.frame.size.height - NavHeight-40)];
            
            UIButton *btOK = [[UIButton alloc] initWithFrame:CGRectMake(10*ScaleSize, self.view.frame.size.height -40, SCREEN_WIDTH-20*ScaleSize, 40)];
            btOK.backgroundColor = [UIColor orangeColor];
            btOK.cornerRadius = 40/2;
            [btOK setTitle:@"开始支付" forState:UIControlStateNormal];
            [btOK setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
            btOK.titleLabel.font = [UIFont systemFontOfSize: 17.0];
            [btOK addTarget:self action:@selector(actionWeiPay) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:btOK];
         }
        
        webView.scalesPageToFit = YES;
        webView.backgroundColor = [UIColor whiteColor];
        webView.delegate = self;
        [self.view insertSubview:webView belowSubview:progressView];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:_homeUrl];
        [webView loadRequest:request];
        self.webView = webView;
        
        // request.URL.absoluteString === tel:13798213609
    }
}

-(void) actionOK
{
    if (_messageBlock)
     {
        [self.navigationController popViewControllerAnimated:YES];
        _messageBlock();
     }
}

-(void) actionWeiPay
{
    [self shareAction:_payUrl];
}

-(void) shareAction:(NSString *) payUrl
{    
    NSString *url = payUrl;
    UIImage *image = [UIImage imageNamed:@"AppIcon"];
    if (image && (image.size.width > 100  || image.size.height > 100)) {
        image = [image scaledToSize:CGSizeMake(100, 100*image.size.height/image.size.width)];
    }
    
    // 分享到微信朋友
    DDGShareManager * share = [DDGShareManager shareManager];
    

    
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]] )
     {
        [MBProgressHUD showErrorWithStatus:@"请先安装微信" toView:self.view];
        return;
     }

    _isClickPay = YES;
    [share weChatShare:@{@"title":@"信贷员之家充值", @"subTitle":@"打开分享的链接完成微信支付流程",@"image":UIImageJPEGRepresentation(image,1.0),@"url": url} shareScene:0 block:^(id result){
        NSDictionary *dic = (NSDictionary *)result;
        if ([[dic objectForKey:@"success"] boolValue]) {
            _isClickPay = YES;
            //[MBProgressHUD showErrorWithStatus:@"支付取消" toView:self.view];
        }else{
            _isClickPay = NO;
            [MBProgressHUD showErrorWithStatus:@"支付取消" toView:self.view];
        }
    }];;
}

-(void) paySatuts
{
    MessageBoxView * alert = [[MessageBoxView alloc] initWithTitle:@"提示"
                                                           Message:@"您的微信支付是否已经完成？"
                                                      CancelButton:@"支付成功"
                                                          OkButton:@"支付失败"];
    alert.parentVC = self;
    alert.delegate = self;
    
    [alert show];
    
}

#pragma mark ---- MessageBoxViewDelegate
-(void)didClickButtonAtIndex:(NSUInteger)index{
    switch (index) {
        case 1:
     {
        NSLog(@"Click OK");
        [self.navigationController popToRootViewControllerAnimated:YES];
        break;
     }
        case 2:
     {
        NSLog(@"Click Cancel");
        [self.navigationController popViewControllerAnimated:YES];
        break;
     }
        default:
            break;
    }
}

#pragma mark - 返回按钮事件
-(void)clickNavButton:(UIButton *)button{
    
    if (IOS8x) {
        if (self.isPresent) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else {
            if (self.wkWebView.canGoBack) {
                [self.wkWebView goBack];
            }else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }else {
        if (self.isPresent) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else {
            if (self.webView.canGoBack) {
                [self.webView goBack];
            }else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}

#pragma mark - wkWebView代理
// 如果不添加这个，那么wkwebview跳转不了AppStore
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    if ([webView.URL.absoluteString hasPrefix:@"https://itunes.apple.com"]) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
    }else if ([navigationAction.request.URL.absoluteString hasPrefix:@"tel:"]) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
    }else {
        
    }
    
    NSString *strUrl = webView.URL.absoluteString;
    
    if(_isDHTJ)
     {
        //[MBProgressHUD showErrorWithStatus:strUrl toView:self.view];
     }

    
//    if (_isDHTJ  &&
//        ([strUrl containsString:@"coupon/yqhy"]||
//        [strUrl containsString:@"baidu.com"]))
//
//     {
//        SharePrize *vc = [[SharePrize alloc] init];
//        [self.navigationController pushViewController:vc animated:NO];
//        decisionHandler(WKNavigationActionPolicyAllow);
//        [self.wkWebView goBack];
//        return;
//     }
//  
//        
//    if (_isDHTJ  &&
//        ([strUrl containsString:@"coupon/jfdh"]||
//        [strUrl containsString:@"sogou.com"]))
//     {
//        ExchangeIntegralVC *vc = [[ExchangeIntegralVC alloc] init];
//        [self.navigationController pushViewController:vc animated:NO];
//        decisionHandler(WKNavigationActionPolicyCancel);
//        //[self.wkWebView goBack];
//        return;
//     }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.wkWebView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        
        if (newprogress == 1) {
            [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }else {
            [self.progressView setAlpha:1.0f];
            BOOL animated = self.wkWebView.estimatedProgress > self.progressView.progress;
            [self.progressView setProgress:self.wkWebView.estimatedProgress animated:animated];
        }
    }
}

// 监听JavaScript
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    // message.name   函数名
    // message.body   参数
    NSLog(@"message.name :%@  message.body :%@",message.name, message.body);

}



// 记得取消监听
- (void)dealloc {
    if (IOS8x) {
        [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    }
    
    if (self.userCC)
     {
        [self.userCC removeScriptMessageHandlerForName:@"callFunction"];
     }
}

#pragma mark - webView代理

- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.loadCount ++;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.loadCount --;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    self.loadCount --;
}

//开始加载
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    //开始加载的时候，让加载进度条显示
    self.progressView.hidden = NO;
}

@end
