//
//  AppDelegate.m
//  XXStatshipApp
//
//  Created by xxjr02 on 2018/5/28.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import "AppDelegate.h"
#import "DemoPreDefine.h"
#import "iflyMSC/IFlyFaceSDK.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //初始化界面
    self.tabBarRootViewController = [[XXJRTabBarViewController alloc] init];
    
    [self setupMainUserInterface];
    
    // 初始化人脸识别
    [self initFace];
    
    return YES;
}



-(void) initFace
{
    NSLog(@"IFlyMSC version=%@",[IFlySetting getVersion]);
    
    //设置log等级，此处log为默认在app沙盒目录下的msc.log文件
    //[IFlySetting setLogFile:LVL_ALL];
    
    //输出在console的log开关
    [IFlySetting showLogcat:NO];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    //设置msc.log的保存路径
    [IFlySetting setLogFilePath:cachePath];
    
    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@,",USER_APPID];
    
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    //_backFromShare = YES;
    
    NSString *strURL = [url absoluteString];
    
    NSLog(@"openURL: %@  sourceApplication:%@", strURL, sourceApplication);
    
    // 跳转邀请好友页面
    //    if ([strURL rangeOfString:@"action=yqhy"].location != NSNotFound)
    //     {
    //        [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@(5),@"index":@(1)}];
    //        return  NO;
    //     }
    //
    //    // 跳转积分兑换页面
    //    if ([strURL rangeOfString:@"action=jfdh"].location != NSNotFound)
    //     {
    //        [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@(5),@"index":@(2)}];
    //        return  NO;
    //     }
    
    if ([sourceApplication isEqualToString:@"com.sina.weibo"]) {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }else if ([sourceApplication isEqualToString:@"com.tencent.xin"]){
        return [WXApi handleOpenURL:url delegate:[DDGWeChat getSharedWeChat]];
    }else if ([sourceApplication isEqualToString:@"com.tencent.mqq"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"QQShareResultNotification" object:url];
        return [TencentOAuth HandleOpenURL:url];
    }else if ([sourceApplication isEqualToString:@"com.apple.mobilesafari"]){
        return YES;
    }
    
    return NO;
}


#pragma mark -
#pragma mark ==== PrivateMethods ====
#pragma mark -
- (void)setupMainUserInterface
{
    //[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];

    // 设置状态栏为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //初始化界面
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self getStartUpViewController];
    
    self.window.backgroundColor = [ResourceManager navgationTitleColor];
    [self.window makeKeyAndVisible];
}

- (void)getStartUpViewController
{
//    // 第一次打开显示引导页
//    if ([XXJRUtils isAppFirstLoaded]){
//        self.window.rootViewController = [[DDGUserGuideViewController alloc] init];
//    }
    //    // 不是第一次打开，没有登录
    //    else if (![[DDGAccountManager sharedManager] isLoggedIn])
    //     {
    //        if (![[DDGAccountManager sharedManager] isLoggedIn])
    //         {
    //            [[DDGUserInfoEngine engine] finishUserInfoWithFinish:^{
    //                self.window.rootViewController = self.tabBarRootViewController;
    //            }];
    //
    //            LoginViewController *ctl = (LoginViewController *)[DDGUserInfoEngine engine].loginViewController;
    //            UINavigationController *navigationController = ctl.navigationController;
    //            if (!navigationController) {
    //                navigationController = [[UINavigationController alloc] initWithRootViewController:ctl];
    //                [navigationController setNavigationBarHidden:NO];
    //                [navigationController.navigationBar setHidden:YES];
    //            }
    //            self.window.rootViewController = navigationController;
    //        }
    //    }
    // 已经登录
    //else
     {
        self.window.rootViewController = self.tabBarRootViewController;
     }
    
}



@end
