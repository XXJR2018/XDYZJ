//
//  WXLoginViewController_2.m
//  XXJR
//
//  Created by xxjr03 on 17/3/27.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import "WXLoginViewController_2.h"
#import "PassWordViewController.h"
#import "IdentifyAlertView.h"
@interface WXLoginViewController_2 ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *VerifyTextField;//验证码
@property (weak, nonatomic) IBOutlet UIButton *VerifyBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutSafeAreaTopHeight;


@end

@implementation WXLoginViewController_2

-(NSMutableDictionary *)paramDictionary{
    if (!_paramDictionary) {
        _paramDictionary = [NSMutableDictionary dictionary];
    }
    return _paramDictionary;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.layoutSafeAreaTopHeight.constant = IS_IPHONE_X_MORE ? 80 : 64;
    
    [self layoutNaviBarViewWithTitle:@"设置个人信息"];
    
    //添加手势点击空白处隐藏键盘
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchViewKeyBoard)];
    gesture.numberOfTapsRequired  = 1;
    [self.view addGestureRecognizer:gesture];
    
}

//添加手势点击空白处隐藏键盘
-(void)TouchViewKeyBoard
{
    [self.view endEditing:YES];
}

//返回按钮
-(void)clickNavButton:(UIButton *)button{
    [self dismissViewControllerAnimated:YES completion:nil];
}


//下一步
- (IBAction)next:(id)sender {
    
    if (![_phoneTextField.text isMobileNumber]) {
        [MBProgressHUD showErrorWithStatus:[LanguageManager wrongMobileNumberTipsString] toView:self.view];
        return;
    }else if (self.VerifyTextField.text.length == 0) {
        [MBProgressHUD showErrorWithStatus:@"请输入短信验证码" toView:self.view];
        return;
    }else{
        [self nextUrl];
    }
}

//下一步
-(void)nextUrl{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@xxcust/comm/app/xdjl/wxLoginBind",[PDAPI getBaseUrlString]]
                                                                               parameters:@{@"unionid":self.unionid,@"telephone":self.phoneTextField.text,@"randomNo":self.VerifyTextField.text} HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    operation.tag = 1000;
    [operation start];    
}

-(void)handleData:(DDGAFHTTPRequestOperation *)operation
{
    [self.view endEditing:YES];
    if (operation.tag == 1000) {
        if (operation.jsonResult.signId && operation.jsonResult.signId.length > 0) {
            [[DDGSetting sharedSettings] setSignId:operation.jsonResult.signId];
        }
        NSDictionary *rowsDic = operation.jsonResult.rows[0];
        if ([rowsDic objectForKey:@"customerId"]) {
            [[DDGSetting sharedSettings] setUid:[rowsDic objectForKey:@"customerId"]];
        }
        if([[operation.jsonResult.attr objectForKey:@"noPwd"]intValue] == 1 || [[operation.jsonResult.attr objectForKey:@"newUser"] intValue] == 1) {
            //未设置密码
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:operation.jsonResult.rows[0]];
            for (NSString *key in dic.allKeys) {   //避免NULL字段
                if ([[dic objectForKey:key] isEqual:[NSNull null]]) {
                    [dic setValue:@"" forKey:key];
                }
            }
            PassWordViewController *ctl = [[PassWordViewController alloc]init];
            if ([dic objectForKey:@"userName"] && [NSString stringWithFormat:@"%@",[dic objectForKey:@"userName"]].length > 0) {
                ctl.userName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"userName"]];
            }
            [self.navigationController pushViewController:ctl animated:YES];;
            return;
        }else{
            //获取用户信息
            [self InfoURL];
        }
    }else if (operation.tag == 1001) {
        //微信登陆
        [MBProgressHUD showSuccessWithStatus:@"登录成功" toView:self.view];
        // 保存数据 /////////////////////////////////////////////////
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:operation.jsonResult.rows[0]];
        for (NSString *key in dic.allKeys) {   //避免NULL字段
            if ([[dic objectForKey:key] isEqual:[NSNull null]]) {
                [dic setValue:@"" forKey:key];
            }
        }
        // 1. 账号相关 mobile、 密码、真实姓名、用户信息
        self.paramDictionary[kRealName] = [dic objectForKey:kRealName];
        self.paramDictionary[kMobile] = [dic objectForKey:kMobile];
        [DDGAccountManager sharedManager].userInfo = dic;
        
        [[DDGAccountManager sharedManager] setUserInfoWithDictionary:self.paramDictionary];
        [[DDGAccountManager sharedManager] saveUserData];
        //跳转首页
        [[DDGUserInfoEngine engine] finishDoBlock];
        [[DDGUserInfoEngine engine] dismissFinishUserInfoController:nil];
    
    }
    

}

//获取验证码
- (IBAction)verify:(id)sender {
    if (![XXJRUtils isNetworkReachable]) {
        [MBProgressHUD showErrorWithStatus:@"请检查网络" toView:self.view];
        return;
    }
    if ([self.phoneTextField.text isMobileNumber]) {
        //[self getVerifyData];
        
        IdentifyAlertView * alert = [[IdentifyAlertView alloc] initWithTitle:@"图形验证码"
                                                                CancelButton:@"确定"
                                                                    OkButton:@"取消"];
        alert.parentVC = self;
        
        alert.strPhone = _phoneTextField.text;
        
        alert.strRequestURL = kDDGGetNologinKjlogAPIString;
        
        [alert show];
        
    }else{
        [MBProgressHUD showErrorWithStatus:@"请输入正确的手机号码" toView:self.view];
        return;
    }
    __block int timeout=59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_VerifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                _VerifyBtn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_VerifyBtn setTitle:[NSString stringWithFormat:@"重发(%@秒)",strTime] forState:UIControlStateNormal];
                
                _VerifyBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}



//获取用户信息
-(void)InfoURL
{
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[PDAPI getUserBaseInfoAPI]
                                                                               parameters:nil HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                  }];
    operation.tag = 1001;
    [operation start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
