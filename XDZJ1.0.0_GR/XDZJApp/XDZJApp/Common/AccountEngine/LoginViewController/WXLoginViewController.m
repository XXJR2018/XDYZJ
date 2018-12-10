//
//  WXLoginViewController.m
//  XXJR
//
//  Created by xxjr03 on 17/2/7.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import "WXLoginViewController.h"
#import "WXBindViewController.h"
#import "PassWordViewController.h"
#import "WXLoginViewController_2.h"

#import "CCWebViewController.h"

#import "IdentifyAlertView.h"

@interface WXLoginViewController ()
{
    NSString *_unionid;
    
}

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;//手机号
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField_2;//手机号
@property (weak, nonatomic) IBOutlet UITextField *VerifyTextField;//验证码
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;//密码

@property (weak, nonatomic) IBOutlet UIButton *VerifyBtn;

@property (weak, nonatomic) IBOutlet UIView *psLoginVIew;
@property (weak, nonatomic) IBOutlet UIView *wxLoginView;
@property (weak, nonatomic) IBOutlet UIButton *wxBtn;
@property (weak, nonatomic) IBOutlet UIButton *psBtn;
@property (weak, nonatomic) IBOutlet UIButton *passWordLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *realWxBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutSafeAreaTopHeight;

@end

@implementation WXLoginViewController

-(NSMutableDictionary *)paramDictionary{
    if (!_paramDictionary) {
        _paramDictionary = [NSMutableDictionary dictionary];
    }
    return _paramDictionary;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.layoutSafeAreaTopHeight.constant = NavHeight; //IS_IPHONE_X_MORE ? 80 : 64;
    
    [self layoutNaviBarViewWithTitle:@"快速登录"];
    self.wxLoginView.layer.borderWidth = 0.5;
    self.wxLoginView.layer.borderColor = [ResourceManager color_5].CGColor;
    self.psLoginVIew.layer.borderWidth = 0.5;
    self.psLoginVIew.layer.borderColor = [ResourceManager color_5].CGColor;
    
    //添加手势点击空白处隐藏键盘
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchViewKeyBoard)];
    gesture.numberOfTapsRequired  = 1;
    [self.view addGestureRecognizer:gesture];
    

    
    [self isWeiXin];


}

- (void) isWeiXin
{
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]] )
     {
        _realWxBtn.hidden = YES;
     }
    else
     {
         _realWxBtn.hidden = NO;
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

//是否密文
- (IBAction)passWord:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.passwordTextField.secureTextEntry = NO;
    }else{
        self.passwordTextField.secureTextEntry = YES;
    }
    
}

//切换登录类型
- (IBAction)loginType:(UIButton *)sender {
    [self.view endEditing:YES];
    if (sender.tag == 100) {
        _wxBtn.selected = YES;
        _psBtn.selected = NO;
        [_passWordLoginBtn setTitle:@"快速登录" forState:UIControlStateNormal];
        _wxLoginView.hidden = NO;
        _psLoginVIew.hidden = YES;
    }else{
        _wxBtn.selected = NO;
        _psBtn.selected = YES;
        [_passWordLoginBtn setTitle:@"立即登录" forState:UIControlStateNormal];
        _wxLoginView.hidden = YES;
        _psLoginVIew.hidden = NO;
    
    }
    
}


//获取验证码
- (IBAction)VerifyBtn:(UIButton *)sender {
 
    

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



//协议
- (IBAction)treaty:(id)sender {
    [self.view endEditing:YES];
    NSString *url = [NSString stringWithFormat:@"%@xxapp/protocol/loanProtocol",[PDAPI WXSysRouteAPI]];
    if ([PDAPI isTestUser])
     {
        url = [NSString stringWithFormat:@"%@xxapp/protocol/loanProtocol2",[PDAPI WXSysRouteAPI]];
     }
    
    [CCWebViewController showWithContro:self withUrlStr:url withTitle:@"小小信贷用户协议"];
}

//快速登录
- (IBAction)KSLoginBtn:(id)sender {
    [self.view endEditing:YES];
    
    //快捷登录
    if (_wxBtn.selected) {        
        if (![_phoneTextField.text isMobileNumber]) {
            [MBProgressHUD showErrorWithStatus:[LanguageManager wrongMobileNumberTipsString] toView:self.view];
            return;
        }else if (_VerifyTextField.text.length == 0) {
            [MBProgressHUD showErrorWithStatus:@"请输入验证码" toView:self.view];
            return;
        }else {
            [self KSLoginUrl];
        }
    }else if (_psBtn.selected) {
        //密码登录
        if (![_phoneTextField_2.text isMobileNumber]) {
            [MBProgressHUD showErrorWithStatus:[LanguageManager wrongMobileNumberTipsString] toView:self.view];
            return;
        }else if (_passwordTextField.text.length == 0) {
            [MBProgressHUD showErrorWithStatus:@"请输入您的密码" toView:self.view];
            return;
        }else if (![_passwordTextField.text isPassWordLegal]) {
            [MBProgressHUD showErrorWithStatus:@"密码格式:数字和字母组合6~12位" toView:self.view];
            return;
        }else {
            [self passWordUrl];
            return;
        }
    }
}



////微信登录
//- (IBAction)WXLoginBtn:(id)sender {
//    [self.view endEditing:YES];
//    
//    [[DDGShareManager shareManager] loginType:2 block:^(id obj){
//        NSDictionary *dic = (NSDictionary *)obj;
//        _unionid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"unionid"]];
//        if (_unionid && _unionid.length > 0) {
//            
//
//            
//            DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[PDAPI userWXLoginInfoAPI]
//                                                                                       parameters:@{@"unionid":_unionid,@"sourceType":@"AppStore"} HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
//                                                                                          success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
//                                                                                              
//                                                                                              [self handleData:operation];
//                                                                                          }
//                                                                                          failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
//                                                                                              [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
//                                                                                          }];
//            operation.tag = 1000;
//            [operation start];
//        }
//        
//    } view:self.view];
//
//}



//获取用户信息
-(void)handleData:(DDGAFHTTPRequestOperation *)operation
{
    [self.view endEditing:YES];
    if (operation.tag == 1000) {
        //微信登陆
        if (operation.jsonResult.signId && operation.jsonResult.signId.length > 0) {
            [[DDGSetting sharedSettings] setSignId:operation.jsonResult.signId];
        }
        
        if ([operation.jsonResult.attr objectForKey:@"unbind"] && [[operation.jsonResult.attr objectForKey:@"unbind"] intValue] == 1) {
            //绑定手机
            WXLoginViewController_2 *ctl = [[WXLoginViewController_2 alloc]init];
            ctl.unionid = _unionid;
            [self.navigationController pushViewController:ctl animated:YES];
            return;
        }else if([operation.jsonResult.attr objectForKey:@"noPwd"] && [[operation.jsonResult.attr objectForKey:@"noPwd"] intValue] == 1) {
            NSDictionary *rowsDic = operation.jsonResult.rows[0];
            if ([rowsDic objectForKey:@"customerId"]) {
                [[DDGSetting sharedSettings] setUid:[rowsDic objectForKey:@"customerId"]];
            }
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
            [self.navigationController pushViewController:ctl animated:YES];
            return;
        
        }else{
            NSDictionary *rowsDic = operation.jsonResult.rows[0];
            if ([rowsDic objectForKey:@"customerId"]) {
                [[DDGSetting sharedSettings] setUid:[rowsDic objectForKey:@"customerId"]];
            }
            //获取用户信息
            [self InfoURL];
        }
        
    }else if (operation.tag == 1001){
        //快速登陆
        if (operation.jsonResult.signId && operation.jsonResult.signId.length > 0) {
            [[DDGSetting sharedSettings] setSignId:operation.jsonResult.signId];
        }
        NSDictionary *dic = operation.jsonResult.rows[0];
        if ([dic objectForKey:@"customerId"]) {
            [[DDGSetting sharedSettings] setUid:[dic objectForKey:@"customerId"]];
        }
        if ([[operation.jsonResult.attr objectForKey:@"noPwd"]intValue] == 1 || [[operation.jsonResult.attr objectForKey:@"newUser"] intValue] == 1) {
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
        }
        //获取用户信息
        [self InfoURL];
    
    }else if (operation.tag == 1002){
        if (operation.jsonResult.signId && operation.jsonResult.signId.length > 0) {
            [[DDGSetting sharedSettings] setSignId:operation.jsonResult.signId];
        }
        NSDictionary *dic = operation.jsonResult.rows[0];
        if ([dic objectForKey:@"customerId"]) {
            [[DDGSetting sharedSettings] setUid:[dic objectForKey:@"customerId"]];
        }
        //获取用户信息
        [self InfoURL];
    }else if (operation.tag == 1003){
        // 保存数据 /////////////////////////////////////////////////
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:operation.jsonResult.rows[0]];
        for (NSString *key in dic.allKeys) {   //避免NULL字段
            if ([[dic objectForKey:key] isEqual:[NSNull null]]) {
                [dic setValue:@"" forKey:key];
            }
        }
        [MBProgressHUD showSuccessWithStatus:@"登录成功" toView:self.view];

        
        // 1. 账号相关 mobile、 密码、真实姓名、用户信息
        self.paramDictionary[kRealName] = [dic objectForKey:kRealName];
        self.paramDictionary[kMobile] = [dic objectForKey:kMobile];
        [DDGAccountManager sharedManager].userInfo = dic;
        [[DDGAccountManager sharedManager] setUserInfoWithDictionary:self.paramDictionary];
        [[DDGAccountManager sharedManager] saveUserData];
        
        //跳转首页
        [[DDGUserInfoEngine engine] finishDoBlock];
        [[DDGUserInfoEngine engine] dismissFinishUserInfoController:nil];
        
        
        // 登录成功，刷新抢单列表，清除里面中的缓存（发送抢单成功的通知）
        [[NSNotificationCenter defaultCenter] postNotificationName:GrabSuccessNotification object:nil];
        
    }
    
}
//获取用户信息
-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation
{
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
    if (operation.tag == 1002) {
        if ([[operation.jsonResult.attr objectForKey:@"errorMore"] intValue] == 1 || [[operation.jsonResult.attr objectForKey:@"newUser"] intValue] == 1)
        {
            //切换到快捷登陆
            [self loginType:self.wxBtn];
        }
    }
    
    
}
//快速登陆
-(void)KSLoginUrl{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[PDAPI userKJLoginInfoAPI]
                                                                               parameters:@{@"telephone":_phoneTextField.text,@"randomNo":_VerifyTextField.text,@"sourceType":@"AppStore"} HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    operation.tag = 1001;
    [operation start];

}

//密码登陆
-(void)passWordUrl{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[PDAPI userPassWordLoginInfoAPI]
                                                                               parameters:@{@"telephone":self.phoneTextField_2.text,@"password":self.passwordTextField.text,@"sourceType":@"AppStore"} HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    operation.tag = 1002;
    [operation start];
    
    
}


//获取用户信息
-(void)InfoURL
{
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[PDAPI getUserBaseInfoAPI]                                                                               parameters:nil HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                     
                                                                                     [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                  }];
//    operation.timeoutInterval = 10;
    operation.tag = 1003;
    [operation start];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
