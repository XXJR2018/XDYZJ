//
//  WXBindViewController.m
//  XXJR
//
//  Created by xxjr03 on 17/2/7.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import "WXBindViewController.h"

#import "CommonInfo.h"

#import "IdentifyAlertView.h"

@interface WXBindViewController ()
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIView *VerifyView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;//手机号
@property (weak, nonatomic) IBOutlet UITextField *VerifyTextField;//验证码
@property (weak, nonatomic) IBOutlet UIButton *VerifyBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *NavConstraint;


@end

@implementation WXBindViewController

-(NSMutableDictionary *)paramDictionary{
    if (!_paramDictionary) {
        _paramDictionary = [NSMutableDictionary dictionary];
    }
    return _paramDictionary;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutNaviBarViewWithTitle:@"绑定手机号码"];
    self.phoneView.layer.borderWidth = 0.5;
    self.phoneView.layer.borderColor = [ResourceManager color_5].CGColor;
    self.VerifyView.layer.borderWidth = 0.5;
    self.VerifyView.layer.borderColor = [ResourceManager color_5].CGColor;
    
    //添加手势点击空白处隐藏键盘
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchViewKeyBoard)];
    gesture.numberOfTapsRequired  = 1;
    [self.view addGestureRecognizer:gesture];
    
    if (IS_IPHONE_X_MORE)
     {
        _NavConstraint.constant = 90;
     }
    
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

//验证码
- (IBAction)VerifyBtn:(UIButton *)sender {
    
    
    [self.view endEditing:YES];
    
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (![XXJRUtils isNetworkReachable]) {
        [MBProgressHUD showErrorWithStatus:@"请检查网络" toView:self.view];
        return;
    }
    if ([_phoneTextField.text isMobileNumber]) {
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



//立即绑定
- (IBAction)bindBtn:(id)sender {
    [self.view endEditing:YES];
    if (_phoneTextField.text.length == 0) {
        [MBProgressHUD showErrorWithStatus:[LanguageManager wrongMobileNumberTipsString] toView:self.view];
        return;
    }else if (_VerifyTextField.text.length == 0) {
        [MBProgressHUD showErrorWithStatus:@"请输入验证码" toView:self.view];
        return;
    }else {
        [self bindUrl];
    }
}
-(void)bindUrl{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[PDAPI userWxLoginBindInfoAPI]
                                                                               parameters:@{@"telephone":_phoneTextField.text,@"randomNo":_VerifyTextField.text,@"unionid":self.unionid,kUUID:[DDGSetting sharedSettings].UUID_MD5} HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    operation.tag = 1001;
    [operation start];
    
}

//获取用户信息
-(void)handleData:(DDGAFHTTPRequestOperation *)operation
{
    if (operation.tag == 1001) {
        [MBProgressHUD showSuccessWithStatus:@"登录成功" toView:self.view];
        if ([[operation.jsonResult.attr objectForKey:@"isNewer"] intValue] == 1) {
            //注册进入,需完善信息
            [CommonInfo setRegistType:@"1"];
        }
               
        // 1. 账号相关：uid、 mobile、 密码、真实姓名
//        self.paramDictionary[kMobile] = [(NSDictionary *)operation.jsonResult.rows[0] objectForKey:@"telephone"];
        self.paramDictionary[kUser_ID] = [(NSDictionary *)operation.jsonResult.attr objectForKey:@"customerId"];
        self.paramDictionary[kRealName] = [(NSDictionary *)operation.jsonResult.rows[0] objectForKey:kRealName];
        
        //获取用户信息
        [self InfoURL];
    }else if (operation.tag == 1002){
        // 保存数据 /////////////////////////////////////////////////
        NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] initWithDictionary:operation.jsonResult.rows[0]];
        for (NSString *key in dataDic.allKeys) {   //避免NULL字段
            if ([[dataDic objectForKey:key] isEqual:[NSNull null]]) {
                [dataDic setValue:@"" forKey:key];
            }
        }
        self.paramDictionary[kMobile] = [dataDic objectForKey:@"telephone"];
        [DDGAccountManager sharedManager].userInfo = dataDic;
        [[DDGAccountManager sharedManager] setUserInfoWithDictionary:self.paramDictionary];
        [[DDGAccountManager sharedManager] saveUserData];
        //跳转首页
        [[DDGUserInfoEngine engine] finishDoBlock];
        [[DDGUserInfoEngine engine] dismissFinishUserInfoController:nil];
    }
  
    
   
}


//获取用户信息
-(void)InfoURL
{
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[PDAPI getUserBaseInfoAPI]
                                                                               parameters:@{kUser_ID:self.paramDictionary[kUser_ID],kUUID:[DDGSetting sharedSettings].UUID_MD5} HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                  }];
    //    operation.timeoutInterval = 10;
    operation.tag = 1002;
    [operation start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
