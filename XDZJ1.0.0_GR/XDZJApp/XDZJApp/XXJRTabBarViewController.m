//
//  DDGTabBarViewController.m
//  DDGProject
//
//  Created by Cary on 15/1/1.
//  Copyright (c) 2015年 Cary. All rights reserved.
//

#import "XXJRTabBarViewController.h"
#import "AppDelegate.h"

#import "DDGUserInfoEngine.h"
#import "AccountOperationController.h"
#import "LocationManager.h"
#import "ApproveViewController.h"
#import "WCAlertview.h"
#import "WCAlertview2.h"

#import "HousViewController.h"
#import "WageViewController.h"
#import "ScotViewController.h"


NSString  *APP_URL = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.xxjr.xxjr_manage";  // APPSTORE

@interface XXJRTabBarViewController ()<WCALertviewDelegate>
{
    FristVC *ctl1;
    HousViewController *ctl1_MJ;
    
    SecondVC *ctl2;
    WageViewController *ctl2_MJ;
    
    ThridVC *ctl3;
    ScotViewController *clt3_MJ;
    
    
    
    

    UINavigationController *nav1;
    UINavigationController *nav2;
    UINavigationController *nav3;
    
}

/*!
 @brief     进入后台时间
 */
@property (nonatomic, strong) NSDate *intoBackground;


@end

@implementation XXJRTabBarViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark === TabBarButtons
-(XXJRSelectButton *)tab1_Button{
    if (_tab1_Button == nil){
        _tab1_Button = [[XXJRSelectButton alloc] initWithFrame:CGRectMake(0.f, 0, SCREEN_WIDTH/3, TabbarHeight)];
        [_tab1_Button addTarget:self action:@selector(tabButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        _tab1_Button.tag = 100;
        
    }
    return _tab1_Button;
}

-(XXJRSelectButton *)tab2_Button{
    if (_tab2_Button == nil){
//        _tab2_Button = [[XXJRSelectButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3, -15, SCREEN_WIDTH/3, TabbarHeight + 15)];
        
        _tab2_Button = [[XXJRSelectButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3, TabbarHeight)];
        [_tab2_Button addTarget:self action:@selector(tabButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        _tab2_Button.tag = 101;
        _tab2_Button.backgroundColor = RandomColor;
    }
    return _tab2_Button;
}

-(XXJRSelectButton *)tab3_Button{
    if (_tab3_Button == nil){
        _tab3_Button = [[XXJRSelectButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3 * 2, 0, SCREEN_WIDTH/3, TabbarHeight)];
        [_tab3_Button addTarget:self action:@selector(tabButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        _tab3_Button.tag = 102;
    }
    return _tab3_Button;
}

-(UINavigationController *)homeViewController{
    return _homeViewController = (UINavigationController *)self.selectedViewController;
}


#pragma mark === init
-(id)init{
    self = [super init];
    
    if (self) {
        
        self.view.frame = [[UIScreen mainScreen] bounds];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSucess:) name:DDGAccountEngineDidLoginNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSucess:) name:DDGAccountEngineDidLogoutNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleDidEnterBackgroudNotificaiton:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleWillEnterForegroundNotificaiton:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        // userInfo需要更新通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfo) name:DDGNotificationAccountNeedRefresh object:nil];
        
        // 推送消息处理
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNotification:) name:DDGPushNotification object:nil];
        
        // 首页切换到别的页面的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchTab:) name:DDGSwitchTabNotification object:nil];
        
        // token过期通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenOutOfData:) name:DDGUserTokenOutOfDataNotification object:nil];
        
        // 名片信息完成通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishUserInfo) name:@"FinishInfoNotification" object:nil];
        
        // 屏蔽掉地图定位
        //[[LocationManager shareManager] getUserLocationSuccess:nil failedBlock:nil];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[self layoutViews];
    
    // 版本检测
    [self onCheckVersion];
    
    [self InfoURL];
}

-(void)layoutViews{
    _buttonsView = [[UIView alloc] initWithFrame:CGRectMake(0.f, SCREEN_HEIGHT - TabbarHeight, SCREEN_WIDTH, TabbarHeight)];
    _buttonsView.backgroundColor = [UIColor whiteColor];
    _buttonsView.tag = 1010;
    _buttonsView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    _buttonsView.layer.shadowOffset = CGSizeMake(0,2);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    _buttonsView.layer.shadowOpacity = 0.6;//阴影透明度，默认0
    _buttonsView.layer.shadowRadius = 3;//阴影半径，默认3
    
    // 布置tabBar
    self.tab1_Button.normalImage = [ResourceManager tabBar_button1_gray];
    self.tab1_Button.selectedImage = [ResourceManager tabBar_button1_selected];
    self.tab2_Button.normalImage = [ResourceManager tabBar_button2_gray];
    self.tab2_Button.selectedImage = [ResourceManager tabBar_button2_selected];
    self.tab3_Button.normalImage = [ResourceManager tabBar_button3_gray];
    self.tab3_Button.selectedImage = [ResourceManager tabBar_button3_selected];

    //self.tab1_Button.normalBGColor = [UIColor orangeColor];;
    
    self.tab1_Button.selectedTextColor = self.tab2_Button.selectedTextColor = self.tab3_Button.selectedTextColor = [ResourceManager blueColor];
    self.tab1_Button.normalTextColor = self.tab2_Button.normalTextColor = self.tab3_Button.normalTextColor = [ResourceManager lightBlackColor];
    
    self.tab1_Button.selectedState = YES;
    self.tab2_Button.selectedState = NO;
    self.tab3_Button.selectedState = NO;
    [_buttonsView addSubview:self.tab1_Button];
    [_buttonsView addSubview:self.tab2_Button];
    [_buttonsView addSubview:self.tab3_Button];
    
    [self.tabBar removeFromSuperview];
    
    
    
    [self initViewControllers];
    
    [self ShowControllers];
    
    [self tabButtonPressed:self.tab1_Button];
}



-(void)initViewControllers{
    
    if ([PDAPI isTestUser])
     {
        ctl1_MJ=[[HousViewController alloc] init];
        ctl1_MJ.tabBar = self.buttonsView;
        
        nav1=[[UINavigationController alloc] initWithRootViewController:ctl1_MJ];
        [nav1 setNavigationBarHidden:NO];
        [nav1.navigationBar setHidden:YES];
        
        ctl2_MJ =[[WageViewController alloc] init];
        ctl2_MJ.tabBar = self.buttonsView;
        nav2=[[UINavigationController alloc] initWithRootViewController:ctl2_MJ];
        [nav2 setNavigationBarHidden:NO];
        [nav2.navigationBar setHidden:YES];
        
        clt3_MJ =[[ScotViewController alloc] init];
        clt3_MJ.tabBar = self.buttonsView;
        nav3=[[UINavigationController alloc] initWithRootViewController:clt3_MJ];
        [nav3 setNavigationBarHidden:NO];
        [nav3.navigationBar setHidden:YES];
     }
    else
     {
        ctl1=[[FristVC alloc] init];
        ctl1.tabBar = self.buttonsView;
        
        nav1=[[UINavigationController alloc] initWithRootViewController:ctl1];
        [nav1 setNavigationBarHidden:NO];
        [nav1.navigationBar setHidden:YES];
        
        ctl2 =[[SecondVC alloc] init];
        ctl2.tabBar = self.buttonsView;
        nav2=[[UINavigationController alloc] initWithRootViewController:ctl2];
        [nav2 setNavigationBarHidden:NO];
        [nav2.navigationBar setHidden:YES];
        
        ctl3 =[[ThridVC alloc] init];
        ctl3.tabBar = self.buttonsView;
        nav3=[[UINavigationController alloc] initWithRootViewController:ctl3];
        [nav3 setNavigationBarHidden:NO];
        [nav3.navigationBar setHidden:YES];
    }
}

-(void)ShowControllers{
    self.viewControllers=@[nav1,nav2,nav3];
}

-(void)loginSucess:(NSNotification *)notification{
    if (nav1) {
        [nav1 popToRootViewControllerAnimated:NO];
    }
    if (nav2) {
        [nav2 popToRootViewControllerAnimated:NO];
    }
    if (nav3) {
        [nav3 popToRootViewControllerAnimated:NO];
    }
    
    [self setButtonsState:self.tab1_Button];
    
    [self InfoURL];
}

-(void)logoutSucess:(NSNotification *)notification{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate getStartUpViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 * TabBar按钮显示状态
 */
- (void)tabButtonPressed:(XXJRSelectButton *)button
{
    if (button.tag == 101)
     {
        if ([PDAPI isTestUser])
         {
            [self getCheckVersion];
         }
        
     }
    
    [self setButtonsState:button];
}

-(void)setButtonsState:(XXJRSelectButton *)button{
    
    [_tab1_Button setSelectedState:NO];
    [_tab2_Button setSelectedState:NO];
    [_tab3_Button setSelectedState:NO];
    if ([PDAPI isTestUser])
     {
        if (button.tag == 100) {
            _tab1_Button.selectedState = YES;
            [ctl1_MJ addButtonView];
        }
        else if (![XXJRUtils isNetworkReachable])
         {
            [MBProgressHUD showErrorWithStatus:@"网络还没有设置好，请先设置网络" toView:self.view];
            [_tab1_Button setSelectedState:YES];
            return;
         }
        else if (button.tag == 101) {
            _tab2_Button.selectedState = YES;
            [ctl2_MJ addButtonView];
        }else if (button.tag == 102) {
            _tab3_Button.selectedState = YES;
            [clt3_MJ addButtonView];
        }
     }
    else
     {
        if (button.tag == 100) {
            _tab1_Button.selectedState = YES;
            [ctl1 addButtonView];
        }else if (button.tag == 101) {
            _tab2_Button.selectedState = YES;
            [ctl2 addButtonView];
        }else if (button.tag == 102) {
            _tab3_Button.selectedState = YES;
            [ctl3 addButtonView];
        }
        
     }
    
    

    
    self.selectedIndex = button.tag - 100;
}

/**
 *	关闭UIAlertView、UIActionSheet模态框
 */
- (void)closeModalView
{
    for (UIWindow *window in [UIApplication sharedApplication].windows)
    {
        for (UIView *view in window.subviews)
        {
            [self dismissActionSheetAndAletrtViewInView:view];
        }
    }
}

/**
 *	逐层遍历view的子view里有没UIAlertView、UIActionSheet，有的话将其关闭
 *
 *	@param	view	要遍历的view
 */
- (void)dismissActionSheetAndAletrtViewInView:(UIView *)view
{
    if ([view isKindOfClass:[UIActionSheet class]])
    {
        UIActionSheet *actionSheet = (UIActionSheet *)view;
        [actionSheet dismissWithClickedButtonIndex:actionSheet.cancelButtonIndex animated:NO];
    }
    else if ([view isKindOfClass:[UIAlertView class]])
    {
        UIAlertView *alertView = (UIAlertView *)view;
        [alertView dismissWithClickedButtonIndex:alertView.cancelButtonIndex animated:NO];
    }
    else
    {
        for (UIView *subView in view.subviews)
        {
            [self dismissActionSheetAndAletrtViewInView:subView];
        }
    }
}


#pragma mark -
#pragma mark notification
-(void)switchTab:(NSNotification *)notification{
    NSLog(@"user info is %@",notification.object);
    
    int tab = [[(NSDictionary *)notification.object objectForKey:@"tab"] intValue];
    int index = [[(NSDictionary *)notification.object objectForKey:@"index"] intValue];
    if (1 == tab)
     {
        //（抢单市场页面）
        [self setButtonsState:_tab1_Button];
        return;
     }
    if (2 == tab)
     {
        //（我的客户页面）
        [self setButtonsState:_tab2_Button];
        return;
     }
    if (3 == tab)
     {
        //（个人中心页面）
        [self setButtonsState:_tab3_Button];
        
        if (10 ==index)
         {
            ApproveViewController *ctl = [[ApproveViewController alloc] init];
            ctl.isShowJump = YES;
            [nav3 pushViewController:ctl animated:NO];
         }
        
        return;
     }
    
    // 刷新整个tabar
    if (100 == tab)
     {
        [self layoutViews];
        return;
     }
    
}

-(void)tokenOutOfData:(NSNotification *)notification{
    // 注销推送
    //[APService setAlias:@"" callbackSelector:nil object:nil];
    
    [[DDGAccountManager sharedManager] deleteUserData];
    
    [self loginSucess:nil];
    
    [DDGUserInfoEngine engine].parentViewController = self;
    [[DDGUserInfoEngine engine] finishUserInfoWithFinish:nil];
    if ([[DDGAccountManager sharedManager] isLoggedIn]) {
        [MBProgressHUD showErrorWithStatus:@"登录超时，请重新登录" toView:[DDGUserInfoEngine engine].loginViewController.view];
    }
}

-(void)finishUserInfo{
    //[ctl1 loadData];
}

-(void)pushNotification:(NSNotification *)notification{
    NSLog(@"user info is %@",notification.userInfo);
}

- (void)handleDidEnterBackgroudNotificaiton:(NSNotification *)notification{
    //程序退到后台的时间
    self.intoBackground = [NSDate date];
}

- (void)handleWillEnterForegroundNotificaiton:(NSNotification *)notification{
    CFRunLoopRunInMode(kCFRunLoopDefaultMode,0.4, NO);
}

/*!
 @brief 网络变化的通知回调
 */
- (void)reachabilityChanged:(NSNotification *)notification
{
    NSLog(@"reachabilityChanged");
    if ([XXJRUtils isNetworkReachable]){
        
    }else{
        [MBProgressHUD showNoNetworkHUDToView:self.view];
    }
}

#pragma mark - 网络通讯
//获取用户信息
-(void)InfoURL
{
    if (![[DDGAccountManager sharedManager] isLoggedIn])
     {
        return;
     }
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[PDAPI getUserBaseInfoAPI]                                                                               parameters:nil HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      // 保存数据 /////////////////////////////////////////////////
                                                                                      NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:operation.jsonResult.rows[0]];
                                                                                      for (NSString *key in dic.allKeys) {   //避免NULL字段
                                                                                          if ([[dic objectForKey:key] isEqual:[NSNull null]]) {
                                                                                              [dic setValue:@"" forKey:key];
                                                                                          }
                                                                                      }
                                                                                      
                                                                                      
                                                                                      // 1. 账号相关 mobile、 密码、真实姓名、用户信息
                                                                                      [DDGAccountManager sharedManager].userInfo = dic;
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                  }];
    //    operation.timeoutInterval = 10;
    [operation start];
}


#pragma mark - 判断版本更新
-(void)onCheckVersion{


    if (![XXJRUtils isNetworkReachable]){
        NSLog(@"Network is Error");
        
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSString *strValue = [defaults objectForKey:@"isAppReview"]; // 1 代表审核中， 0 代表 审核通过
        
        if (!strValue)
         {
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@"1" forKey:@"isAppReview"];
            
         }
        
        [self layoutViews];
        
        return;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    //params[@"appID"] = @"tgwIOS";
    params[@"appID"] = MY_APP_ID;
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[PDAPI getCheckVersionAPI]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      NSDictionary *dic = operation.jsonResult.attr;
                                                                                      
                                                                                      [self parseDic:dic];
                                                                                      
                                                                                      [self upMessage:dic];
                                                                                      
                                                                                      [self layoutViews];
                                                                           
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      NSLog(@"checkVersion failure");
                                                                                      
                                                                                      NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                                                                                      NSString *strValue = [defaults objectForKey:@"isAppReview"]; // 1 代表审核中， 0 代表 审核通过
                                                                                      
                                                                                      if (!strValue)
                                                                                       {
                                                                                          NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                                                                                          [defaults setObject:@"1" forKey:@"isAppReview"];
                                                                                          
                                                                                       }
                                                                                      
                                                                                      [self layoutViews];
                                                                                      
                                                                                  }];
    [operation start];
}

// 判断是否审核中
-(void) parseDic:(NSDictionary*) dic
{
    if (!dic)
     {
        return;
     }
    NSLog(@"dic : %@", dic);
    
    // isTestByIos   1 表示审核中，   0  表示审核通过
    int     iisTestByIos  = [dic[@"isTestByIos"] boolValue];
    
    NSString *version = dic[@"upVersion"];
    version = [version stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    currentVersion = [currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    // 网络版本号 和 isTestByIos ，都匹配，才是审核中 (审核时，后台返回的版本号，要比自己的版本号小)
    if ([currentVersion floatValue] > [version floatValue] &&
        iisTestByIos == 1)
     {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"1" forKey:@"isAppReview"];
        //[self layoutViews];
     }
    else
     {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"0" forKey:@"isAppReview"];
        //[self layoutViews];
     }
    
}

-(void) upMessage:(NSDictionary*) dic
{
    if (!dic)
     {
        return;
     }
    NSLog(@"dic : %@", dic);

    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    currentVersion = [currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    
    APP_URL = dic[@"upUrl"];
    NSString *version =dic[@"upVersion"];
    NSString *strV = dic[@"upVersion"];
    version = [version stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    NSString *strForceUpgradeVersion = dic[@"forceUpgradeVersion"];
    strForceUpgradeVersion = [strForceUpgradeVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    NSString *strMessage = @"新版本已更新，前往下载";
    NSString *strMessageTemp = dic[@"upDesc"];
    strMessageTemp =  [strMessageTemp stringByReplacingOccurrencesOfString:@"/n" withString:@"\n"];
    if(strMessageTemp.length > 0)
     {
        strMessage = strMessageTemp;
     }
    
    if (currentVersion.integerValue  < version.integerValue)
     {
        if (strForceUpgradeVersion.integerValue >= currentVersion.integerValue )
         {
            
            WCAlertview * alert = [[WCAlertview alloc] initWithTitle:@"Tite"
                                                             Message:strMessageTemp
                                                               Image:[UIImage imageNamed:@"up_ts"]
                                                        CancelButton:@"立即升级"
                                                            OkButton:@""];
            alert.strVerion = strV;
            alert.delegate = self;
            [alert show];
         }
        else{
            WCAlertview * alert = [[WCAlertview alloc] initWithTitle:@"Tite"
                                                             Message:strMessageTemp
                                                               Image:[UIImage imageNamed:@"up_ts"]
                                                        CancelButton:@"立即升级"
                                                            OkButton:@"下次再说"];
            alert.delegate = self;
            alert.strVerion = strV;
            [alert show];
        }
     }
    else
     {
        // 判断是否有普通消息通知
        [self messageDic:dic];
     }
}

// 判断是否弹通知
-(void) messageDic:(NSDictionary*) dicAll
{
    NSDictionary *dic = dicAll[@"notifyInfo"];
    if (!dic ||
        [dic count] <= 0)
     {
        return;
     }
    
    if ([PDAPI isTestUser])
     {
        // 如果是审核中，不弹普通消息
        return;
     }
    
    
    //    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    //    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    //
    //
    //    NSString *strNetVersion = dic[@"notifyVersion"];
    //    if (strNetVersion)
    //     {
    //        currentVersion = [currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    //        strNetVersion  = [strNetVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    //
    //        int iCurVersion = [currentVersion intValue];
    //        int iNetVersion = [strNetVersion intValue];
    //
    //        // 如果App版本号 大于 网络版本号
    //        if (iCurVersion > iNetVersion )
    //            return;
    //     }
    
    
    NSLog(@"dic : %@", dic);
    NSString *strMessageTemp = dic[@"content"];//@"尊敬的用户，为了优化抢单流程，小小金融抢单市场将于2017你那9月8日实行新的抢单规则。\n届时针对会员将开放‘会员特价’专区。普通单打5折，优质客户单打8折将自动取消。";
    NSString *strTitle = dic[@"title"];
    
    WCAlertview2 * alert = [[WCAlertview2 alloc] initWithTitle:strTitle
                                                       Message:strMessageTemp
                                                         Image:[UIImage imageNamed:@"up_tongzhi"]
                                                  CancelButton:@"我知道了"
                                                      OkButton:@""];
    alert.strVerion = @"";
    alert.parentVC = self;
    alert.strNoteMessage = dic[@"skipText"];
    alert.strUrl = dic[@"skipUrl"];
    //alert.delegate = self;
    [alert show];
}

// 调用网络接口，获取是否正在审核中
-(void)getCheckVersion{
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    currentVersion = [currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"appID"] = MY_APP_ID;
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[PDAPI getCheckVersionAPI]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                                                                      [self parseDic2:operation.jsonResult.attr];
                                                                                      
                                                                                      
                                                                                      
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      NSLog(@"error ==== %@",operation.jsonResult.message);
;
                                                                                      
                                                                                      
                                                                                  }];
    [operation start];
}

// 判断是否审核中
-(void) parseDic2:(NSDictionary*) dic
{
    if (!dic)
     {
        return;
     }
    NSLog(@"dic : %@", dic);

    // isTestByIos   1 表示审核中，   0  表示审核通过
    int     iisTestByIos  = [dic[@"isTestByIos"] boolValue];
    
    NSString *version = dic[@"upVersion"];
    version = [version stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    currentVersion = [currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    // 网络版本号 和 isTestByIos ，都匹配，才是审核中 (审核时，后台返回的版本号，要比自己的版本号小)
    if ([currentVersion floatValue] > [version floatValue] &&
        iisTestByIos == 1)
     {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"1" forKey:@"isAppReview"];
        
     }
    else
     {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"0" forKey:@"isAppReview"];
        
        // 重新属性tabbar ,切换到正式界面
        [self.navigationController popToRootViewControllerAnimated:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@(100),@"index":@(1)}];
        
     }
    
}




#pragma mark === UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 10000) {
        // 企业测试包地址
        // https://www.duoduozhifu.com/apps/ios/Download.html
        NSURL* url = [[ NSURL alloc ] initWithString :@"https://itunes.apple.com/us/app/xiao-xiao-jin-rong-jing-li-ban/id1084229599?l=zh&ls=1&mt=8"];
        [[UIApplication sharedApplication ] openURL:url];
    }
}

-(void)didClickButtonAtIndex:(NSUInteger)index{
    switch (index) {
        case 0:
     {
        //NSLog(@"Click Cancel");
        NSURL* url = [[ NSURL alloc ] initWithString :APP_URL];
        [[UIApplication sharedApplication] openURL:url];
        break;
     }
        case 1:
            //NSLog(@"Click OK");
            break;
        default:
            break;
    }
}



@end
