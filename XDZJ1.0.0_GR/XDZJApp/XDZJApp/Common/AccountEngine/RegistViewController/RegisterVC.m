//
//  RegisterVC.m
//  XDZJApp
//
//  Created by xxjr02 on 2018/7/31
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import "RegisterVC.h"


@interface RegisterVC ()<UITextFieldDelegate>
{
    UITextField *fidldName;
    UITextField *fidldPhone;
    UITextField *fidldPassword;
    UITextField *fidldValidCode;
    
    UILabel *labelInput2;
    
    NSString *smsTokenId;
}
@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutNaviBarViewWithTitle:@"信贷员之家平台注册"];
    
    [self layoutUI];
    
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

#pragma mark --- 布局UI
-(void) layoutUI
{
    int iTopY = NavHeight;
    int iLeftX = 15;
    
    UIImageView *imgBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight)];
    [self.view addSubview:imgBG];
    imgBG.image = [UIImage imageNamed:@"rg_bg"];
    
    iTopY += 50;
    fidldName = [[UITextField alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2*iLeftX, 40)];
    [self.view addSubview:fidldName];
    fidldName.layer.borderWidth = 1;
    fidldName.layer.borderColor = [ResourceManager color_5].CGColor;
    fidldName.placeholder = @"请输入您的姓名";
    fidldName.font = [UIFont systemFontOfSize:14];
    fidldName.cornerRadius = 5;
    //fidldName.leftView =
    UIView *leftView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIImageView  *leftImg1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 20, 22)];
    [leftView1 addSubview:leftImg1];
    leftImg1.image = [UIImage imageNamed:@"rg_gr"];
    fidldName.leftView = leftView1;
    fidldName.leftViewMode = UITextFieldViewModeAlways;
    

    
    
    iTopY += 55;
    fidldPhone = [[UITextField alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2*iLeftX, 40)];
    [self.view addSubview:fidldPhone];
    fidldPhone.layer.borderWidth = 1;
    fidldPhone.layer.borderColor = [ResourceManager color_5].CGColor;
    fidldPhone.placeholder = @"请使用本人实名手机号注册";
    fidldPhone.keyboardType = UIKeyboardTypeNumberPad;
    fidldPhone.font = [UIFont systemFontOfSize:14];
    fidldPhone.cornerRadius = 5;
    //fidldName.leftView =
    UIView *leftView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIImageView  *leftImg2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 20, 22)];
    [leftView2 addSubview:leftImg2];
    leftImg2.image = [UIImage imageNamed:@"rg_sj"];
    fidldPhone.leftView = leftView2;
    fidldPhone.leftViewMode = UITextFieldViewModeAlways;
    
    iTopY += 55;
    fidldPassword = [[UITextField alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2*iLeftX, 40)];
    [self.view addSubview:fidldPassword];
    fidldPassword.layer.borderWidth = 1;
    fidldPassword.layer.borderColor = [ResourceManager color_5].CGColor;
    fidldPassword.placeholder = @"密码至少6位数字+字母组合";
    fidldPassword.font = [UIFont systemFontOfSize:14];
    fidldPassword.cornerRadius = 5;
    //fidldName.leftView =
    UIView *leftView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIImageView  *leftImg3 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 20, 22)];
    [leftView3 addSubview:leftImg3];
    leftImg3.image = [UIImage imageNamed:@"rg_mm"];
    fidldPassword.leftView = leftView3;
    fidldPassword.leftViewMode = UITextFieldViewModeAlways;
    
    iTopY += 55;
    fidldValidCode = [[UITextField alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2*iLeftX, 40)];
    [self.view addSubview:fidldValidCode];
    fidldValidCode.backgroundColor = [UIColor whiteColor];
    fidldValidCode.layer.borderWidth = 1;
    fidldValidCode.layer.borderColor = [ResourceManager color_5].CGColor;
    fidldValidCode.placeholder = @"请输入手机验证码";
    fidldValidCode.keyboardType = UIKeyboardTypeNumberPad;
    fidldValidCode.font = [UIFont systemFontOfSize:14];
    fidldValidCode.cornerRadius = 5;
    //fidldName.leftView =
    UIView *leftView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIImageView  *leftImg4 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 20, 22)];
    [leftView4 addSubview:leftImg4];
    leftImg4.image = [UIImage imageNamed:@"rg_yzm"];
    fidldValidCode.leftView = leftView4;
    fidldValidCode.leftViewMode = UITextFieldViewModeAlways;
    [fidldValidCode addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    
    UIView *viewInputFG2 = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 2*iLeftX - 85, 10, 1, 20)];
    [fidldValidCode addSubview:viewInputFG2];
    viewInputFG2.backgroundColor = [ResourceManager color_5];
    
    labelInput2 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 2*iLeftX - 83, 10, 80, 20)];
    [fidldValidCode addSubview:labelInput2];
    labelInput2.text = @"获取验证码";
    labelInput2.textAlignment = NSTextAlignmentCenter;
    labelInput2.font = [UIFont systemFontOfSize:12];
    labelInput2.textColor = [ResourceManager mainColor];
    


    
    UIButton *btnYZM = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 2*iLeftX - 83, iTopY, 120, 50)];
    [self.view addSubview:btnYZM];
    //btnYZM.backgroundColor = [UIColor yellowColor];
    [btnYZM addTarget:self action:@selector(actionYZM) forControlEvents:UIControlEventTouchUpInside];
    
    
    //登录按钮
    iTopY += 70;
    UIButton *btnRegister = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2*iLeftX, 50)];
    [self.view addSubview:btnRegister];
    btnRegister.cornerRadius = 5;
    [btnRegister setTitle:@"注册" forState:UIControlStateNormal];
    [btnRegister addTarget:self action:@selector(actionRegister) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 按钮设置渐变色
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, btnRegister.width, btnRegister.height);
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.locations = @[@(0.1),@(1.0)];
    [gradientLayer setColors:@[(id)[UIColorFromRGB(0x6494f6) CGColor],(id)[UIColorFromRGB(0x2d69e1) CGColor]]];
    [btnRegister.layer addSublayer:gradientLayer];
    
    
    //登录按钮
    iTopY += 70;
    UIButton *btnLogin = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2*iLeftX, 50)];
    [self.view addSubview:btnLogin];
    [btnLogin setTitle:@"已有账户，立即登录" forState:UIControlStateNormal];
    [btnLogin setTitleColor:[ResourceManager mainColor] forState:UIControlStateNormal];
    btnLogin.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnLogin addTarget:self action:@selector(actionLogin) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *lableXY = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 20)];
    [self.view addSubview:lableXY];
    lableXY.font = [UIFont systemFontOfSize:14];
    lableXY.textColor = [ResourceManager color_1];
    lableXY.textAlignment = NSTextAlignmentCenter;
    
    NSString *strNO = @"《信贷员之家用户协议》";//  @"10501";
    NSString *strAll = @"注册即表示您同意《信贷员之家用户协议》";
    
    NSMutableAttributedString *noteString = [[NSMutableAttributedString alloc] initWithString:strAll];
    NSRange stringRange =  [strAll rangeOfString:strNO];
    //[noteString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:stringRange];
    [noteString addAttribute:NSForegroundColorAttributeName value:[ResourceManager blueColor] range:stringRange];
    lableXY.attributedText = noteString;
    
    lableXY.userInteractionEnabled = YES;
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionXY)];
    gesture.numberOfTapsRequired  = 1;
    [lableXY addGestureRecognizer:gesture];
    
}

#pragma mark ---  UITextFieldDelegate
- (void)textFieldTextChange:(UITextField *)textField
{
    if (textField == fidldValidCode) {
        int iMaxLen = 10;
        if (textField.text.length > iMaxLen) {
            UITextRange *markedRange = [textField markedTextRange];
            if (markedRange) {
            return;
            }
            //Emoji占2个字符，如果是超出了半个Emoji，用15位置来截取会出现Emoji截为2半
            //超出最大长度的那个字符序列(Emoji算一个字符序列)的range
            NSRange range = [textField.text rangeOfComposedCharacterSequenceAtIndex:iMaxLen];
            textField.text = [textField.text substringToIndex:range.location];
        }
    }
}


#pragma mark --- action
-(void) actionYZM
{
    if ([fidldPhone.text isMobileNumber]) {
        
        [self getSMSFrist];
        
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
                //[_VerifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                labelInput2.text = @"获取验证码";
                labelInput2.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //[_VerifyBtn setTitle:[NSString stringWithFormat:@"重发(%@秒)",strTime] forState:UIControlStateNormal];
                labelInput2.text = [NSString stringWithFormat:@"重发(%@秒)",strTime];
                labelInput2.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

-(void) actionRegister
{
    if (!fidldName.text ||
        fidldName.text.length  <= 0) {
        [MBProgressHUD showErrorWithStatus:@"姓名不不能为空" toView:self.view];
        return;
    }
    if (![fidldPhone.text isMobileNumber])
     {
        [MBProgressHUD showErrorWithStatus:@"请填写正确的手机号码" toView:self.view];
        return;
     }
    if (![fidldPassword.text isPassWordLegal]) {
        [MBProgressHUD showErrorWithStatus:@"密码格式:数字+字母组合6~12位" toView:self.view];
        return;
    }
    if (!fidldValidCode.text ||
        fidldValidCode.text.length  <= 0) {
        [MBProgressHUD showErrorWithStatus:@"验证码不能为空" toView:self.view];
        return;
    }

    
    [self NetRegisterUser];
}

-(void) actionLogin
{
    [self.navigationController popViewControllerAnimated:NO];
}

-(void) actionXY
{
    NSString *url = [NSString stringWithFormat:@"%@xxapp/protocol/lendHomeUser",[PDAPI WXSysRouteAPI]];
    //url = @"http://www.tiangouwo.com/pages/agreement.html";
    if ([PDAPI isTestUser])
     {
        url = @"http://www.tiangouwo.com/pages/agreement2.html";
     }
    
    [CCWebViewController showWithContro:self withUrlStr:url withTitle:@"用户协议"];
}

#pragma mark ---  网络通讯
-(void)getSMSFrist
{
    smsTokenId = @"";
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGgetSmsToken];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    parmas[@"telephone"] = fidldPhone.text;

    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){

                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){

                                                                                      [self handleErrorData:operation];
                                                                                  }];
    operation.tag = 998;
    [operation start];
}


-(void)getSMSSecond
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGgetSmsRegister];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    parmas[@"telephone"] = fidldPhone.text;
    parmas[@"smsTokenId"] = smsTokenId;
    NSString *strTemp = [NSString stringWithFormat:@"%@&%@",smsTokenId,fidldPhone.text];
    parmas[@"smsEnc"] = [strTemp stringTGWToMD5];

    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){

                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){

                                                                                      [self handleErrorData:operation];
                                                                                  }];
    operation.tag = 999;
    [operation start];
}




-(void)NetRegisterUser
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGRegisterUser];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    parmas[@"telephone"] = fidldPhone.text;
    parmas[@"userName"] = fidldName.text;
    parmas[@"password"] = fidldPassword.text;
    parmas[@"randomNo"] = fidldValidCode.text;
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    operation.tag = 1000;
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
                                                                                      
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    //    operation.timeoutInterval = 10;
    operation.tag = 1003;
    [operation start];
}

-(void)handleData:(DDGAFHTTPRequestOperation *)operation
{
    [self.view endEditing:YES];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (operation.tag == 998) {
        NSDictionary *dic = operation.jsonResult.attr;
        if (dic)
         {
            smsTokenId =  [NSString stringWithFormat:@"%@", dic[@"smsTokenId"]];
            [self getSMSSecond];
         }
        
    }else if (operation.tag == 999) {
        NSString *strOut = [NSString stringWithFormat:@"验证码发送到%@，请耐心等待。", fidldPhone.text];
        [MBProgressHUD showSuccessWithStatus:strOut toView:self.view];
        
    }else if (operation.tag == 1000) {

        [self InfoURL];
    }
    else if (operation.tag == 1003){
        // 保存数据 /////////////////////////////////////////////////
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:operation.jsonResult.rows[0]];

        [MBProgressHUD showSuccessWithStatus:@"登录成功" toView:self.view];
        
        // 1. 账号相关 mobile、 密码、真实姓名、用户信息
        [DDGAccountManager sharedManager].userInfo = dic;
        [[DDGAccountManager sharedManager] saveUserData];
        
        //跳转首页
        [[DDGUserInfoEngine engine] finishDoBlock];
        [[DDGUserInfoEngine engine] dismissFinishUserInfoController:nil];
        
        // 登录成功，刷新抢单列表，清除里面中的缓存（发送抢单成功的通知）
        [[NSNotificationCenter defaultCenter] postNotificationName:GrabSuccessNotification object:nil];
        

        // 发送通知，直接调用 认证界面
        [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@(3),@"index":@(10)}];
        
    }
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
    
}



@end
