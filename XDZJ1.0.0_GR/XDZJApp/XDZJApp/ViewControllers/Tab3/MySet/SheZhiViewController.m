//
//  SheZhiViewController.m
//  XXJR
//
//  Created by 多多智富 on 16/1/7.
//  Copyright © 2016年 Cary. All rights reserved.
//

#import "SheZhiViewController.h"
#import "DDGAccountManager.h"

#import "AmendPassWordViewController.h"
#import "MyInfoViewController.h"
#import "FeedbackViewController.h"

#import "SetPayPs_WdViewController_2.h"
#import "ForgetPayPs_WdViewController_1.h"
#import "ForgetPayPs_WdViewController_2.h"

#import "CommonInfo.h"
#import "SIAlertView.h"
#import "UIImageView+WebCache.h"
#import "CCWebViewController.h"
//#import "BindWXVC.h"
#import "SwitchView.h"

@interface SheZhiViewController ()
{
    UILabel *_cacheNumLabel;
    UILabel *_payLabel;
    NSString *_unionid;
    NSString *_newTelephone;
    UIButton *_logoutBtn;
    
    SwitchView  *_switch_ts;                  // 消息推送开关按钮
    BOOL       _isTS;                        // 是否开启推送
}
@end

@implementation SheZhiViewController

#pragma mark - 友盟统计
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"设置"];
    
    if ([[DDGAccountManager sharedManager] isLoggedIn]) {
        [self InfoURL];
        [_logoutBtn setTitle:@"退出当前账号" forState:UIControlStateNormal];
        if ([[[DDGAccountManager sharedManager].userInfo objectForKey:@"hasJyPwd"] intValue] == 1) {
            _payLabel.text = @"修改支付密码";
        }
    }else{
        [_logoutBtn setTitle:@"登录" forState:UIControlStateNormal];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"设置"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNaviBarViewWithTitle:@"设置"];
    [self layoutUI];
}

-(void)layoutUI{
    
    //NSArray * amendArr = @[@"绑定微信",@"个人信息",@"修改密码"];
    NSArray * amendArr = @[@"个人信息",@"修改密码"];
    
    UIView * amendView = [[UIView alloc]initWithFrame:CGRectMake(0, NavHeight + 10, SCREEN_WIDTH, 45 * amendArr.count)];
    [self.view addSubview:amendView];
    amendView.backgroundColor = [UIColor whiteColor];
    UIFont * font = [UIFont systemFontOfSize:14];
    UIColor * color_1 = UIColorFromRGB(0x333333);
   

    for (int i = 0; i < amendArr.count; i++) {
        UIView * viewX = [[UIView alloc]initWithFrame:CGRectMake(0, 45 * i - 0.5, SCREEN_WIDTH, 0.5)];
        [amendView addSubview:viewX];
        viewX.backgroundColor = [ResourceManager color_5];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 45 * i, 100, 45)];
        [amendView addSubview:label];
        label.font = font;
        label.textColor = color_1;
        label.text = amendArr[i];
        UIImageView * arrowImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-18,45 * i + 45/2-9, 13, 18)];
        arrowImg.image=[UIImage imageNamed:@"arrow-2"];
        [amendView addSubview:arrowImg];
        UIButton * touchBtn = [[UIButton alloc]init];
        touchBtn.tag = 101 + i;
        touchBtn.frame = CGRectMake(0, 45 * i, SCREEN_WIDTH, 45);
        [amendView addSubview:touchBtn];
        [touchBtn addTarget:self action:@selector(touch:) forControlEvents:UIControlEventTouchUpInside];
    }
    UIView * payPswdView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(amendView.frame) + 15, SCREEN_WIDTH, 45 * 2 + 15 +45)];
    [self.view addSubview:payPswdView];
    payPswdView.backgroundColor = [UIColor whiteColor];
   
//    NSArray * payPswdArr = @[@"设置支付密码",@"忘记支付密码"];
//    for (int i = 0; i < payPswdArr.count; i++) {
//        UIView * viewX = [[UIView alloc]initWithFrame:CGRectMake(0, 45 * i - 0.5, SCREEN_WIDTH, 0.5)];
//        [payPswdView addSubview:viewX];
//        viewX.backgroundColor = [ResourceManager color_5];
//        if (i == 0) {
//            _payLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 45 * i, 100, 45)];
//            [payPswdView addSubview:_payLabel];
//            _payLabel.font = font;
//            _payLabel.textColor = color_1;
//            _payLabel.text = payPswdArr[i];
//        }else{
//            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 45 * i, 100, 45)];
//            [payPswdView addSubview:label];
//            label.font = font;
//            label.textColor = color_1;
//            label.text = payPswdArr[i];
//        }
//        UIImageView * arrowImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-18,45 * i + 45/2-9, 13, 18)];
//        arrowImg.image=[UIImage imageNamed:@"arrow-2"];
//        [payPswdView addSubview:arrowImg];
//        UIButton * touchBtn = [[UIButton alloc]init];
//        touchBtn.tag = 103 + i;
//        touchBtn.frame = CGRectMake(0, 45 * i, SCREEN_WIDTH, 45);
//        [payPswdView addSubview:touchBtn];
//        [touchBtn addTarget:self action:@selector(touch:) forControlEvents:UIControlEventTouchUpInside];
//    }
//
//    UIView *viewBG = [[UIView alloc] initWithFrame:CGRectMake(0, 2*45, SCREEN_WIDTH, 15)];
//    [payPswdView addSubview:viewBG];
//    viewBG.backgroundColor = [ResourceManager viewBackgroundColor];
//
//     __weak typeof(self) weakSelf = self;
//    _switch_ts = [[SwitchView alloc] initWithTitle:@"开启消息推送" origin_Y:2*45+15];
//    _switch_ts.switchBlock = ^(BOOL yesOrNo){
//        _isTS = yesOrNo;
//
//        [weakSelf setTSToWeb];
//
//
//    };
//    [payPswdView addSubview:_switch_ts];
    


    

    

    NSArray * cacheArr = @[@"清除缓存",@"意见反馈",@"关于我们"];
    cacheArr = @[@"清除缓存",@"意见反馈"];
    
    UIView * cacheView = nil;
    cacheView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(amendView.frame) + 15, SCREEN_WIDTH, 45 * [cacheArr count])];
    [self.view addSubview:cacheView];
    payPswdView.hidden = YES;
    cacheView.backgroundColor = [UIColor whiteColor];
    
    for (int i = 0; i < [cacheArr count]; i++) {
        UIView * viewX = [[UIView alloc]initWithFrame:CGRectMake(0, 45 * i - 0.5, SCREEN_WIDTH, 0.5)];
        [cacheView addSubview:viewX];
        viewX.backgroundColor = [ResourceManager color_5];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 45 * i, 100, 45)];
        [cacheView addSubview:label];
        label.font = font;
        label.textColor = color_1;
        label.text = cacheArr[i];
        UIImageView * arrowImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-18,45 * i + 45/2-9, 13, 18)];
        arrowImg.image=[UIImage imageNamed:@"arrow-2"];
        [cacheView addSubview:arrowImg];
        UIButton * touchBtn = [[UIButton alloc]init];
        touchBtn.tag = 105 + i;
        touchBtn.frame = CGRectMake(0, 45 * i, SCREEN_WIDTH, 45);
        [cacheView addSubview:touchBtn];
        [touchBtn addTarget:self action:@selector(touch:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    _cacheNumLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 200, 0, 180, 45)];
    _cacheNumLabel.textColor=UIColorFromRGB(0xfc7637);
    _cacheNumLabel.font=font;
    _cacheNumLabel.text=@"0.00M";
    _cacheNumLabel.textAlignment = NSTextAlignmentRight;
    [cacheView addSubview:_cacheNumLabel];
    NSString *PathStr = [XXJRUtils libraryPath];
    NSString *bundlePathStr = [PathStr stringByAppendingPathComponent:@"banner.plist"];
    NSString *contentPathStr = [PathStr stringByAppendingPathComponent:@"content.plist"];
    _cacheNumLabel.text = [NSString stringWithFormat:@"%.2f M", [SheZhiViewController sizeWithFilePath:bundlePathStr] + [SheZhiViewController sizeWithFilePath:contentPathStr] + [self checkTmpSize]];
    
    _logoutBtn=[[UIButton alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(cacheView.frame) + 45, SCREEN_WIDTH - 30, 40 * ScaleSize)];
    [_logoutBtn setTitle:@"退出当前账号" forState:UIControlStateNormal];
    _logoutBtn.layer.cornerRadius = 3;
    _logoutBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _logoutBtn.backgroundColor = [ResourceManager mainColor];
    [_logoutBtn addTarget:self action:@selector(touch:) forControlEvents:UIControlEventTouchUpInside];
    _logoutBtn.tag = 108;
    [self.view addSubview:_logoutBtn];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 120.f)/2, CGRectGetMaxY(_logoutBtn.frame) + 15.f, 120.f, 20)];
    NSString *bundleStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:13.f];
    label.textColor = [ResourceManager color_6];
    label.text  = [NSString stringWithFormat:@"版本: v%@", bundleStr];
    [self.view addSubview:label];
}

-(void)touch:(UIButton *)sender{
    if ([[DDGAccountManager sharedManager] isLoggedIn]) {
        switch (sender.tag) {
            case 100:{
                //绑定微信
//                if([PDAPI isTestUser])
//                 {
//                    [self bindWX];
//                 }
//                else
//                 {
//                BindWXVC *VC = [[BindWXVC alloc] init];
//                [self.navigationController pushViewController:VC  animated:YES];
//                 }
            }break;
            case 101:{
                //个人信息
                MyInfoViewController *info = [[MyInfoViewController alloc]init];
                [self.navigationController pushViewController:info animated:YES];
            }break;
            case 102:{
                //修改密码
                AmendPassWordViewController *Amend=[[AmendPassWordViewController alloc]init];
                [self.navigationController pushViewController: Amend animated:YES];
            }break;
            case 103:{
                //设置支付密码
                if ([_payLabel.text isEqualToString:@"设置支付密码"]) {
                    //设置支付密码
                    ForgetPayPs_WdViewController_2 *ctl = [[ForgetPayPs_WdViewController_2 alloc]init];
                    ctl.payType = 100;
                    [self.navigationController pushViewController:ctl animated:YES];
                }else{
                    //修改支付密码
                    SetPayPs_WdViewController_2 *ctl = [[SetPayPs_WdViewController_2 alloc]init];
                    [self.navigationController pushViewController:ctl animated:YES];
                }
            }break;
            case 104:{
                //忘记支付密码
                ForgetPayPs_WdViewController_1 *ctl = [[ForgetPayPs_WdViewController_1 alloc]init];
                [self.navigationController pushViewController:ctl animated:YES];
            }break;
            case 105:{
                //清除缓存
                [self clearCache];
            }break;
            case 106:{
                //意见反馈
                FeedbackViewController *ctl = [[FeedbackViewController alloc]init];
                [self.navigationController pushViewController:ctl animated:YES];
            }break;
            case 107:{
                //关于我们
                NSString *strUrl = [NSString stringWithFormat:@"%@%@" ,[PDAPI WXSysRouteAPI],@"xxapp/companyDesc"];
                [CCWebViewController showWithContro:self withUrlStr:strUrl withTitle:@"关于我们"];
            }break;
            case 108:{
                //退出当前账号
                [self BackBtn];
            }break;
            default:
                break;
        }
    }else {
        if (sender.tag == 105) {
            //清除缓存
            [self clearCache];
        }else{
            [DDGUserInfoEngine engine].parentViewController = self;
            [[DDGUserInfoEngine engine] finishUserInfoWithFinish:nil];
            return;
        }
    }
}

-(void)clearCache{
    
    //清除缓存
    NSString *s = [NSString stringWithFormat:@"缓存大小为%@,确定要清除吗?",_cacheNumLabel.text];
    SIAlertView * alertView = [[SIAlertView alloc]initWithTitle:@"清除缓存" andMessage:s];
    
    [alertView addButtonWithTitle:@"取消" type:SIAlertViewButtonTypeDefault handler:nil];
    [alertView addButtonWithTitle:@"确定" type:SIAlertViewButtonTypeCancel handler:^(SIAlertView *alertView){
        NSString *PathStr = [XXJRUtils libraryPath];
        NSString *bundlePathStr = [PathStr stringByAppendingPathComponent:@"banner.plist"];
        NSString *contentPathStr = [PathStr stringByAppendingPathComponent:@"content.plist"];
        [SheZhiViewController clearCachesWithFilePath:bundlePathStr];
        [SheZhiViewController clearCachesWithFilePath:contentPathStr];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *imagePath = [paths objectAtIndex:0];
        [SheZhiViewController clearCache:imagePath];
        _cacheNumLabel.text = [NSString stringWithFormat:@"%.2f M", [SheZhiViewController sizeWithFilePath:bundlePathStr] + [SheZhiViewController sizeWithFilePath:contentPathStr] + [self checkTmpSize]];
    }];
    alertView.cornerRadius = 5;
    alertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
    alertView.transitionStyle = SIAlertViewTransitionStyleSlideFromTop;
    
    [alertView show];
}
#pragma mark - 获取SDWImage缓存图片的大小
- (float)checkTmpSize
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *imagePath = [paths objectAtIndex:0];
    float totalSize = 0;
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:imagePath];
    for (NSString *fileName in fileEnumerator)
    {
        NSString *filePath = [imagePath stringByAppendingPathComponent:fileName];
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        unsigned long long length = [attrs fileSize];
        totalSize += length / 1024.0 / 1024.0;
    }
    return totalSize;
}
#pragma mark - 清除SDWImage缓存图片内存
+(void)clearCache:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    [[SDImageCache sharedImageCache] cleanDisk];
}
#pragma mark - 根据路径返回目录或文件的大小
+ (double)sizeWithFilePath:(NSString *)path{
    // 1.获得文件夹管理者
    NSFileManager *manger = [NSFileManager defaultManager];
    // 2.检测路径的合理性
    BOOL dir = NO;
    BOOL exits = [manger fileExistsAtPath:path isDirectory:&dir];
    if (!exits) return 0;
    // 3.判断是否为文件夹
    if (dir) { // 文件夹, 遍历文件夹里面的所有文件
        // 这个方法能获得这个文件夹下面的所有子路径(直接\间接子路径)
        NSArray *subpaths = [manger subpathsAtPath:path];
        int totalSize = 0;
        for (NSString *subpath in subpaths) {
            NSString *fullsubpath = [path stringByAppendingPathComponent:subpath];
            BOOL dir = NO;
            [manger fileExistsAtPath:fullsubpath isDirectory:&dir];
            if (!dir) { // 子路径是个文件
                NSDictionary *attrs = [manger attributesOfItemAtPath:fullsubpath error:nil];
                totalSize += [attrs[NSFileSize] intValue];
            }
        }
        return totalSize / (1024 * 1024.0);
    } else { // 文件
        NSDictionary *attrs = [manger attributesOfItemAtPath:path error:nil];
        return [attrs[NSFileSize] intValue] / (1024.0 * 1024.0);
    }
}
#pragma mark - 删除指定目录或文件
+ (BOOL)clearCachesWithFilePath:(NSString *)path{
    NSFileManager *mgr = [NSFileManager defaultManager];
    return [mgr removeItemAtPath:path error:nil];
}


//退出登录||登录
-(void)BackBtn{
    
    if ([[DDGAccountManager sharedManager] isLoggedIn]) {
        [self custUrl];
        
        [[DDGAccountManager sharedManager] deleteUserData];
        [self.navigationController popToRootViewControllerAnimated:NO];
        [[NSNotificationCenter defaultCenter] postNotification:[[NSNotification alloc]initWithName:DDGAccountEngineDidLogoutNotification object:self userInfo:nil]];
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@(4),@"index":@(0)}];
        // 注销推送
        //[JPUSHService setAlias:@"1234" callbackSelector:nil object:nil];
        [DDGUserInfoEngine engine].parentViewController = self;
        [[DDGUserInfoEngine engine] finishUserInfoWithFinish:nil];
        return;
    }else{
        [DDGUserInfoEngine engine].parentViewController = self;
        [[DDGUserInfoEngine engine] finishUserInfoWithFinish:nil];
        return;
    }
}

//退出登录
-(void)custUrl
{
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
       // 发送请求POST
    [[NSOperationQueue mainQueue] addOperation:[[DDGAFHTTPRequestOperation alloc] initWithURL:[PDAPI userDoLogoutAPI] parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray success:^(DDGAFHTTPRequestOperation *operation, id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if (operation.jsonResult.success!=0){
            
        } else {
            [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
        }
        
    } failure:^(DDGAFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
    }
                                                ]];
    
}

//绑定微信
-(void)bindWX
{
    [[DDGShareManager shareManager] loginType:2 block:^(id obj){
        NSDictionary *dic = (NSDictionary *)obj;
        _unionid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"unionid"]];
        if (_unionid && _unionid.length > 0) {
            [self bindWXUrl];
        }
        
    } view:self.view];

}

-(void)bindWXUrl{
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[PDAPI userInfoBindingWXWXAPI]
                                                                               parameters:@{@"unionid":_unionid} HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    operation.tag = 1000;
    [operation start];

}

-(void)forceBindWXUrl{
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[PDAPI userForceBindingWXAPI]
                                                                               parameters:@{@"unionid":_unionid} HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    operation.tag = 1001;
    [operation start];
    
}
//获取用户信息
-(void)InfoURL
{
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[PDAPI getUserBaseInfoAPI]
                                                                               parameters:@{kUUID:[DDGSetting sharedSettings].UUID_MD5} HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                  }];
    [operation start];
    operation.tag = 1002;
}

// 设置推送到WEB
-(void)setTSToWeb
{
    NSString *strUrl = [NSString stringWithFormat:@"%@xxcust/account/info/setRemindStatus",[PDAPI getBaseUrlString]];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"remindStatus"] = @((int)_isTS);
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:param HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                  }];
    [operation start];

}

//获取用户信息
-(void)handleData:(DDGAFHTTPRequestOperation *)operation
{
    if (operation.tag == 1000) {
        _newTelephone = [NSString stringWithFormat:@"%@",[operation.jsonResult.attr objectForKey:@"telephone"]];
        NSString *str = [NSString stringWithFormat:@"您的微信已绑定号码 %@,\n是否绑定当前号码 %@",_newTelephone,[DDGSetting sharedSettings].mobile];
        
        if ([operation.jsonResult.attr objectForKey:@"bindedDiff"] && [[operation.jsonResult.attr objectForKey:@"bindedDiff"] intValue] == 1) {
            SIAlertView * alertView = [[SIAlertView alloc]initWithTitle:@"绑定微信" andMessage:str];
            
            [alertView addButtonWithTitle:@"取消" type:SIAlertViewButtonTypeDefault handler:nil];
            [alertView addButtonWithTitle:@"绑定" type:SIAlertViewButtonTypeCancel handler:^(SIAlertView *alertView){
                [self forceBindWXUrl];
            }];
            alertView.cornerRadius = 5;
            alertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
            alertView.transitionStyle = SIAlertViewTransitionStyleSlideFromTop;
            
            [alertView show];
        }else{
        [MBProgressHUD showSuccessWithStatus:@"绑定成功" toView:self.view];
        
        }
            
    }else if (operation.tag == 1001){
        [[DDGSetting sharedSettings] setMobile:_newTelephone];
        [MBProgressHUD showSuccessWithStatus:@"绑定成功" toView:self.view];
    }else if (operation.tag == 1002){
        if (operation.jsonResult.rows.count > 0) {
            NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithDictionary:operation.jsonResult.rows[0]];
            //避免NULL字段
            for (NSString *key in dic.allKeys) {
                if ([[dic objectForKey:key] isEqual:[NSNull null]]) {
                    [dic setValue:@"" forKey:key];
                }
            }
            [[DDGAccountManager sharedManager] setUserInfo:dic];
            
            
            int remindStatus = [dic[@"remindStatus"] intValue];
            if (1 == remindStatus)
             {
                _switch_ts.switchOn = YES;
             }
        }
        
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
