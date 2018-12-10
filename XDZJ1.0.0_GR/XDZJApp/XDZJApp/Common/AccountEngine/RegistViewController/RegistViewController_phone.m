//
//  RegistViewController.m
//  ddgBank
//
//  Created by admin on 14/12/25.
//  Copyright (c) 2014年 com.ddg. All rights reserved.
//

#import "RegistViewController_phone.h"
#import "AgreementViewController.h"

@interface RegistViewController_phone ()<UITextFieldDelegate>

@end

@implementation RegistViewController_phone

{
    
    CGFloat _currentHeight;
    UITextField *_phoneField;     //输入手机号码
    UIButton * _getVerifyBtn;     //获取验证码
    UIButton * _isVoiceBtn;       //获取语音验证码
    UITextField *_verifyField;    //输入验证码
    UITextField *_pwdField;       //输入密码
    UITextField *_pwdField2;      //确认密码
    UIButton *_button;            // 提交
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"忘记密码"];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"忘记密码"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self layoutNaviBarViewWithTitle:@"忘记密码"];
    
    [self layoutTextField];
    [self setUpBtn];
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

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)layoutTextField{
    UIView *View=[[UIView alloc]initWithFrame:CGRectMake(0.f, NavHeight + 16, SCREEN_WIDTH, 44 * 4)];
    View.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:View];
    
    UIFont *font=[UIFont systemFontOfSize:13];
    UIColor *color = UIColorFromRGB(0x333333);
    _phoneField = [[UITextField alloc] initWithFrame:CGRectMake(70, 0, SCREEN_WIDTH-90, 44)];
    _phoneField.delegate = self;
    _phoneField.textColor=color;
    _phoneField.keyboardType = UIKeyboardTypeNumberPad;
    _phoneField.backgroundColor=[UIColor whiteColor];
    _phoneField.font=font;
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [ResourceManager TishiColor];
    _phoneField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入登录手机号" attributes:attrs];
    [View addSubview:_phoneField];
    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 50, 44)];
    label1.text=@"手机号";
    label1.font=font;
    label1.textColor = color;
    [View addSubview:label1];
    _verifyField = [[UITextField alloc] initWithFrame:CGRectMake(70, 44, SCREEN_WIDTH-70, 44)];
    _verifyField.delegate = self;
    _verifyField.backgroundColor = [UIColor colorWithRed:221.f/255.f green:223.f/255.f blue:224.f/255.f alpha:1];
    _verifyField.keyboardType = UIKeyboardTypeNumberPad;
    _verifyField.backgroundColor=[UIColor whiteColor];
    attrs[NSForegroundColorAttributeName] = [ResourceManager TishiColor];
    _verifyField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:attrs];
    _verifyField.textColor=color;
    _verifyField.font=font;
    [View addSubview:_verifyField];
    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(10, 44, 50, 44)];
    label2.text=@"验证码";
    label2.font=font;
    label2.textColor = color;
    [View addSubview:label2];
    //获取验证码按钮
    _getVerifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_getVerifyBtn setTitle:@"短信验证" forState:UIControlStateNormal];
    [_getVerifyBtn addTarget:self action:@selector(startTime) forControlEvents:UIControlEventTouchUpInside];
    [_getVerifyBtn setTitleColor:UIColorFromRGB(0x5d91de) forState:UIControlStateNormal];
    _getVerifyBtn.layer.borderWidth = .5f;
    _getVerifyBtn.layer.borderColor = UIColorFromRGB(0x5d91de).CGColor;
    _getVerifyBtn.titleLabel.font = [UIFont systemFontOfSize:11.f];
    _getVerifyBtn.frame = CGRectMake(_verifyField.width-140,44/2-30/2,65,30);
    _getVerifyBtn.layer.cornerRadius = 30/2;
    [_getVerifyBtn addTarget:self action:@selector(startTime) forControlEvents:UIControlEventTouchUpInside];
    _getVerifyBtn.userInteractionEnabled = YES;
    [_verifyField addSubview:_getVerifyBtn];
    
    //获取语音验证码按钮
    _isVoiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_isVoiceBtn setTitle:@"语音验证" forState:UIControlStateNormal];
    [_isVoiceBtn addTarget:self action:@selector(startTime2) forControlEvents:UIControlEventTouchUpInside];
    [_isVoiceBtn setTitleColor:UIColorFromRGB(0x5baf61) forState:UIControlStateNormal];
    _isVoiceBtn.layer.borderWidth = .5f;
    _isVoiceBtn.layer.borderColor = UIColorFromRGB(0x5baf61).CGColor;
    _isVoiceBtn.titleLabel.font = [UIFont systemFontOfSize:11.f];
    _isVoiceBtn.frame = CGRectMake(_verifyField.width-70,44/2-30/2,65,30);
    _isVoiceBtn.layer.cornerRadius = 30/2;
    [_isVoiceBtn addTarget:self action:@selector(startTime) forControlEvents:UIControlEventTouchUpInside];
    _isVoiceBtn.userInteractionEnabled = YES;
    [_verifyField addSubview:_isVoiceBtn];
    
    _pwdField = [[UITextField alloc] initWithFrame:CGRectMake(70, 44 * 2, SCREEN_WIDTH-90, 44)];
    _pwdField.textColor = color;
    _pwdField.backgroundColor = [UIColor colorWithRed:221.f/255.f green:223.f/255.f blue:224.f/255.f alpha:1];
    _pwdField.backgroundColor=[UIColor whiteColor];
    _pwdField.delegate = self;
    _pwdField.font=font;
    //密文
    _pwdField.secureTextEntry = YES;
    attrs[NSForegroundColorAttributeName] = [ResourceManager TishiColor];
    _pwdField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入新密码" attributes:attrs];
    _pwdField.textColor=[ResourceManager color_8];
    [View addSubview:_pwdField];
    UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(10, 44 * 2, 50, 44)];
    label3.text=@"新密码";
    label3.textColor = color;
    label3.font=font;
    
    [View addSubview:label3];
    _pwdField2 = [[UITextField alloc] initWithFrame:CGRectMake(70, 44 * 3, SCREEN_WIDTH-90, 44)];
    _pwdField2.textColor = color;
    _pwdField2.backgroundColor = [UIColor colorWithRed:221.f/255.f green:223.f/255.f blue:224.f/255.f alpha:1];
    _pwdField2.backgroundColor=[UIColor whiteColor];
    _pwdField2.delegate = self;
    attrs[NSForegroundColorAttributeName] = [ResourceManager TishiColor];
    _pwdField2.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请再次输入密码" attributes:attrs];
    _pwdField2.textColor=color;
    _pwdField2.font=font;
    //密文
    _pwdField2.secureTextEntry = YES;
    [View addSubview:_pwdField2];
    
    UILabel *label4=[[UILabel alloc]initWithFrame:CGRectMake(10, 44 * 3, 70,44)];
    label4.text=@"确认密码";
    label4.font=font;
    label4.textColor = color;
    [View addSubview:label4];
   
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(10, 44, SCREEN_WIDTH-10, 0.5)];
    view1.backgroundColor=[ResourceManager color_5];
    [View addSubview:view1];
    UIView *view2=[[UIView alloc]initWithFrame:CGRectMake(10, 44 * 2, SCREEN_WIDTH-10, 0.5)];
    view2.backgroundColor=[ResourceManager color_5];
    [View addSubview:view2];
    UIView *view3=[[UIView alloc]initWithFrame:CGRectMake(10, 44 * 3, SCREEN_WIDTH - 10, 0.5)];
    view3.backgroundColor=[ResourceManager color_5];
    [View addSubview:view3];
    _currentHeight = _phoneField.frame.origin.y + _phoneField.frame.size.height;
}

-(void)setUpBtn{
    
    CGFloat buttonHeight = 40.f;
    CGFloat spaceReserved = 15.f;
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = CGRectMake(spaceReserved, 290, SCREEN_WIDTH - 2*spaceReserved, buttonHeight);
    _button.backgroundColor = [ResourceManager anjianColor];
    _button.layer.cornerRadius = 5;
    [_button setTitle:@"提交" forState:UIControlStateNormal];
    
    _button.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(nextStepBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
    _currentHeight = _button.frame.origin.y + _button.frame.size.height;
    

}


#pragma mark - 提交按钮事件  _nextBtnClick
-(void)nextStepBtnClick
{
    
    if (![_phoneField.text isMobileNumber]) {
        [MBProgressHUD showErrorWithStatus:[LanguageManager wrongMobileNumberTipsString] toView:self.view];
        return;
    }else if(_verifyField.text == nil){
        
        [MBProgressHUD showErrorWithStatus:@"请输入验证码" toView:self.view];
        return;
    }else if (![_pwdField.text isPassWordLegal]) {
        [MBProgressHUD showErrorWithStatus:@"密码格式:数字和字母组合6~12位" toView:self.view];
        return;
    }else if (_pwdField.text && ![_pwdField.text isValidPassword]) {
        [MBProgressHUD showErrorWithStatus:[LanguageManager errowPasswordString] toView:self.view];
        return;
    }else if ([_pwdField.text integerValue] != [_pwdField2.text integerValue]) {
        [MBProgressHUD showErrorWithStatus:@"两次输入密码的不一致" toView:self.view];
        return;
    
    }
    else
    {
        [self forgetBtn];
    }
}

-(void)forgetBtn
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
     //忘记密码
    //http://192.168.31.50/cust/forgetPwd
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"telephone"] = _phoneField.text;
        params[@"password"] =  _pwdField.text;
        params[@"randomNo"] = _verifyField.text; 
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[PDAPI userForgetPasswordAPI] parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray success:^(DDGAFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
        if (operation.jsonResult.success){
            
            dic[kPassword] = _pwdField.text;
            dic[kMobile] = _phoneField.text;
            
            [[DDGAccountManager sharedManager] setUserInfoWithDictionary:dic];
            [[DDGAccountManager sharedManager] saveUserData];
            MBProgressHUD *hud  = [MBProgressHUD showSuccessWithStatus:@"重置密码成功" toView:self.view];
            hud.completionBlock = ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            };
        }else{
            [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       [MBProgressHUD showErrorWithStatus:[((DDGAFHTTPRequestOperation *)operation).errorDDG localizedDescription] toView:self.view];
    }];
    [operation start];
}


#pragma mark - 按钮事件
//获取验证码   数秒
-(void)startTime{
    if (![XXJRUtils isNetworkReachable]) {
        [MBProgressHUD showErrorWithStatus:@"请检查网络" toView:self.view];
        return;
    }
    if ([_phoneField.text isMobileNumber]) {
        [self getVerifyData];
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
                [_getVerifyBtn setTitle:@"获取" forState:UIControlStateNormal];
                _getVerifyBtn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_getVerifyBtn setTitle:[NSString stringWithFormat:@"重发(%@秒)",strTime] forState:UIControlStateNormal];
                _getVerifyBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark - 获取验证码
//忘记密码获取短信验证码
//http://192.168.31.209/smsAction/nologin/forgetPwd?telephone=18898615961
-(void)getVerifyData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"telephone"] = _phoneField.text;
   
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[PDAPI userForgetPwdSendMsgAPI] parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray success:^(DDGAFHTTPRequestOperation *operation, id responseObject) {
        if (operation.jsonResult.success) {
            NSLog(@"----验证码发送成功----");
            MBProgressHUD *hud  = [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
            hud.completionBlock = ^{};
        } else {
            NSLog(@"-------验证码发送失败----");
            [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        [MBProgressHUD showErrorWithStatus:[((DDGAFHTTPRequestOperation *)operation).errorDDG localizedDescription] toView:self.view];
    }];
    
    [operation start];
}
#pragma mark - 按钮事件
//获取语音验证码   数秒
-(void)startTime2{
    if (![XXJRUtils isNetworkReachable]) {
        [MBProgressHUD showErrorWithStatus:@"请检查网络" toView:self.view];
        return;
    }
    if ([_phoneField.text isMobileNumber]) {
        [self getVerifyData2];
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
                [_isVoiceBtn setTitle:@"获取" forState:UIControlStateNormal];
                _isVoiceBtn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_isVoiceBtn setTitle:[NSString stringWithFormat:@"重发(%@秒)",strTime] forState:UIControlStateNormal];
                _isVoiceBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark - 获取验证码
//忘记密码获取语音验证码

-(void)getVerifyData2
{
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"telephone"] = _phoneField.text;
    params[@"isVoice"] = @"voice";
    
    [[NSOperationQueue mainQueue] addOperation:[[DDGAFHTTPRequestOperation alloc] initWithURL:[PDAPI userForgetPwdSendMsgAPI] parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray success:^(DDGAFHTTPRequestOperation *operation, id responseObject) {
        
        [MBProgressHUD showSuccessWithStatus:operation.jsonResult.message toView:self.view];
        
    } failure:^(DDGAFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
    }]];
}


@end
