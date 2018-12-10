//
//  XDZJLoginViewController.m
//  XDZJApp
//
//  Created by xxjr02 on 2018/7/25.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import "XDZJLoginViewController.h"
#import "IdentifyAlertView.h"
#import "PassWordViewController.h"
#import "WXLoginViewController_2.h"
#import "UIButton+Gradient.h"
#import "RegisterVC.h"
#import "AmendPassWordViewController.h"

@interface XDZJLoginViewController ()
{
    int iLoginType;   //  1 - 快速登录   2 - 密码登录
    
    UIButton *btnLeft;
    UITextField *filedInput1;
    
    UIButton *btnRight;
    UITextField *filedInput2;
    UIImageView *imgInput2;
    UILabel *labelInput2;
    UIView *viewInputFG2;
    
    UIButton * btnForget;
    
    NSString *_unionid;
    
    NSString *smsTokenId;  // 短信防刷Token
    
}
@end

@implementation XDZJLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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


- (void) layoutUI
{
    iLoginType = 1;
    //self.view.backgroundColor =  [UIColor whiteColor];
    UIImageView *imBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:imBG];
    imBG.image = [UIImage imageNamed:@"lg_bg"];
    
    int iimgLogWidth = 130;
    int iLeftX =  (SCREEN_WIDTH -  iimgLogWidth)/2;
    int iTopY = 100;
    
    if (IS_IPHONE_5_OR_LESS)
     {
        iTopY = 50;
     }
    
    UIImageView  *imgLogo =  [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iimgLogWidth, 35)];
    [self.view addSubview:imgLogo];
    //imgLogo.backgroundColor = [UIColor yellowColor];
    imgLogo.image = [UIImage imageNamed:@"lg_logo"];
    
    iTopY += imgLogo.height + 40;
    btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH/2, 20)];
    [self.view addSubview:btnLeft];
    [btnLeft setTitle:@"快速登录" forState:UIControlStateNormal];
    [btnLeft setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(actionSelKSDL) forControlEvents:UIControlEventTouchUpInside];
    
    btnRight = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, iTopY, SCREEN_WIDTH/2, 20)];
    [self.view addSubview:btnRight];
    [btnRight setTitle:@"密码登录" forState:UIControlStateNormal];
    [btnRight setTitleColor:[ResourceManager lightGrayColor] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(actionSelMMDL) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, iTopY, 1, 20)];
    [self.view addSubview:viewFG];
    viewFG.backgroundColor = [ResourceManager color_5];
    
    // 第一个输入框
    iLeftX = 20;
    iTopY += viewFG.height + 30;
    int iViewInputHeight = 50;
    int iViewInputWdith = SCREEN_WIDTH - 2*iLeftX;
    UIView *viewInput1 = [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iViewInputWdith, iViewInputHeight)];
    [self.view addSubview:viewInput1];
    viewInput1.backgroundColor = [UIColor whiteColor];
    viewInput1.layer.cornerRadius = 5;
    viewInput1.layer.masksToBounds = YES;
    
    UIImageView *imgInput1 = [[UIImageView alloc]  initWithFrame:CGRectMake(10, 10, 25, 30)];
    [viewInput1 addSubview:imgInput1];
    //imgInput1.backgroundColor = [UIColor yellowColor];
    imgInput1.image = [UIImage imageNamed:@"lg_sj"];
    
    filedInput1 = [[UITextField alloc] initWithFrame:CGRectMake(50, 10, 150, 30)];
    filedInput1.keyboardType = UIKeyboardTypePhonePad;
    [viewInput1 addSubview:filedInput1];
    filedInput1.placeholder = @"请输入您的手机号";
    //filedInput1.backgroundColor = [UIColor yellowColor];
    
    
    //第二个输入框
    iTopY += viewInput1.height + 15;
    UIView *viewInput2 = [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iViewInputWdith, iViewInputHeight)];
    [self.view addSubview:viewInput2];
    viewInput2.backgroundColor = [UIColor whiteColor];
    viewInput2.layer.cornerRadius = 5;
    viewInput2.layer.masksToBounds = YES;
    
    imgInput2 = [[UIImageView alloc]  initWithFrame:CGRectMake(10, 10, 25, 30)];
    [viewInput2 addSubview:imgInput2];
    //imgInput2.backgroundColor = [UIColor yellowColor];
    imgInput2.image = [UIImage imageNamed:@"lg_yz"];
    
    filedInput2 = [[UITextField alloc] initWithFrame:CGRectMake(50, 10, 150, 30)];
    [viewInput2 addSubview:filedInput2];
    filedInput2.placeholder = @"请输入手机验证码";
    filedInput2.keyboardType = UIKeyboardTypePhonePad;
    //filedInput2.backgroundColor = [UIColor yellowColor];
    
    viewInputFG2 = [[UIView alloc] initWithFrame:CGRectMake(iViewInputWdith - 85, 10, 1, 30)];
    [viewInput2 addSubview:viewInputFG2];
    viewInputFG2.backgroundColor = [ResourceManager color_5];
    
    labelInput2 = [[UILabel alloc] initWithFrame:CGRectMake(iViewInputWdith - 83, 10, 80, 30)];
    [viewInput2 addSubview:labelInput2];
    labelInput2.text = @"获取验证码";
    labelInput2.textAlignment = NSTextAlignmentCenter;
    labelInput2.font = [UIFont systemFontOfSize:14];
    labelInput2.textColor = [ResourceManager mainColor];
    
    labelInput2.userInteractionEnabled = YES;
    UITapGestureRecognizer * gestureYZM = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionYZM)];
    gestureYZM.numberOfTapsRequired  = 1;
    [labelInput2 addGestureRecognizer:gestureYZM];
    
    //忘记密码按钮
    iTopY += viewInput2.height + 20;
    btnForget = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 75, 20)];
    [self.view addSubview:btnForget];
    [btnForget setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [btnForget setTitleColor:[ResourceManager mainColor] forState:UIControlStateNormal];
    btnForget.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnForget addTarget:self action:@selector(actionForget) forControlEvents:UIControlEventTouchUpInside];
    btnForget.hidden = YES;
    
    
    //免费注册按钮
    UIButton * btnRegister = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60 - iLeftX, iTopY, 60, 20)];
    [self.view addSubview:btnRegister];
    [btnRegister addTarget:self action:@selector(actionRegister) forControlEvents:UIControlEventTouchUpInside];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"免费注册"];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange]; //设置下划线
    [str addAttribute:NSForegroundColorAttributeName value:[ResourceManager mainColor] range:strRange]; //设置字体颜色
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:strRange]; // 设置字体
    [btnRegister setAttributedTitle:str forState:UIControlStateNormal];
    
    //登录按钮
    iTopY += btnForget.height + 25;
    UIButton *btnLogin = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iViewInputWdith, iViewInputHeight)];
    [self.view addSubview:btnLogin];
    //btnLogin.backgroundColor = [ResourceManager mainColor];
    btnLogin.cornerRadius = 5;
    [btnLogin setTitle:@"登录" forState:UIControlStateNormal];
    [btnLogin addTarget:self action:@selector(actionLogin) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 按钮设置渐变色
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, btnLogin.width, btnLogin.height);
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.locations = @[@(0.1),@(1.0)];
    [gradientLayer setColors:@[(id)[UIColorFromRGB(0x6494f6) CGColor],(id)[UIColorFromRGB(0x2d69e1) CGColor]]];
    [btnLogin.layer addSublayer:gradientLayer];
    
//    //微信登录按钮
//    iTopY += btnLogin.height + 65;
//    if (IS_IPHONE_5_OR_LESS)
//     {
//        iTopY -= 30;
//     }
//    UIButton *btnWXLogin = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iViewInputWdith, iViewInputHeight)];
//    [self.view addSubview:btnWXLogin];
//    btnWXLogin.backgroundColor = [UIColor whiteColor];
//    btnWXLogin.cornerRadius = 5;
//    [btnWXLogin addTarget:self action:@selector(actionWXLogin) forControlEvents:UIControlEventTouchUpInside];
//    if ([PDAPI isTestUser])
//     {
//        btnWXLogin.hidden = YES;
//     }
//
//    UIImageView *imgWX = [[UIImageView alloc] initWithFrame:CGRectMake(iViewInputWdith/2 - 60, 13, 30, 24)];
//    [btnWXLogin addSubview:imgWX];
//    //imgWX.backgroundColor = [UIColor yellowColor];
//    imgWX.image = [UIImage imageNamed:@"lg_wx"];
//
//    UILabel *labelWX = [[UILabel alloc] initWithFrame:CGRectMake(iViewInputWdith/2 - 25, 10, 100, 30)];
//    [btnWXLogin addSubview:labelWX];
//    labelWX.text = @"微信登录";

    UILabel *lableXY = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 20)];
    [self.view addSubview:lableXY];
    lableXY.font = [UIFont systemFontOfSize:14];
    lableXY.textColor = [ResourceManager color_1];
    lableXY.textAlignment = NSTextAlignmentCenter;
    
    NSString *strNO = @"《信贷员之家用户协议》";//  @"10501";
    NSString *strAll = @"登录即表示您同意《信贷员之家用户协议》";
    
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



#pragma mark --- action
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

-(void)actionSelKSDL
{
    iLoginType = 1;
    
    [btnLeft setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];

    [btnRight setTitleColor:[ResourceManager lightGrayColor] forState:UIControlStateNormal];
    imgInput2.image = [UIImage imageNamed:@"lg_yz"];
    filedInput2.placeholder = @"请输入手机验证码";
    labelInput2.hidden = NO;
    viewInputFG2.hidden = NO;
    btnForget.hidden = YES;
    
    filedInput2.keyboardType = UIKeyboardTypePhonePad;
    filedInput2.text = @"";
    [self TouchViewKeyBoard];
}

-(void)actionSelMMDL
{
    iLoginType = 2;
    [btnLeft setTitleColor:[ResourceManager lightGrayColor] forState:UIControlStateNormal];
    
    [btnRight setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
    imgInput2.image = [UIImage imageNamed:@"lg_mm"];
    filedInput2.placeholder = @"请输入密码";
    labelInput2.hidden = YES;
    viewInputFG2.hidden = YES;
    btnForget.hidden = NO;
    
    filedInput2.keyboardType = UIKeyboardTypeDefault;
    filedInput2.text = @"";
    [self TouchViewKeyBoard];

}

-(void) actionYZM
{
    
    if ([filedInput1.text isMobileNumber]) {
        
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

-(void) actionLogin
{
    
    
    
    if (filedInput1.text.length <= 0 ||
        ![filedInput1.text isMobileNumber] )
     {
        [MBProgressHUD showErrorWithStatus:@"请输入正确的手机号" toView:self.view];
        return;
     }
    
    if (filedInput2.text.length <= 0)
     {
        NSString *strOut = @"请输手机验证码";
        if (2 == iLoginType)
         {
            strOut = @"请输入密码";
         }

        [MBProgressHUD showErrorWithStatus:strOut toView:self.view];
        return;
     }
    
    if (2 == iLoginType)
     {
        if (![filedInput2.text isPassWordLegal]) {
            [MBProgressHUD showErrorWithStatus:@"密码格式:数字和字母组合6~12位" toView:self.view];
            return;
        }
     }
    
    if (1 == iLoginType)
     {
        [self netLogin];
     }
    else
     {
        [self netMMLogin];
     }
}



-(void) actionWXLogin
{
    [[DDGShareManager shareManager] loginType:2 block:^(id obj){
        NSDictionary *dic = (NSDictionary *)obj;
        _unionid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"unionid"]];
        if (_unionid && _unionid.length > 0) {
            
            //            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            //            [NSThread sleepForTimeInterval:5];//设置延迟时间
            //            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[PDAPI userWXLoginInfoAPI]
                                                                                       parameters:@{@"unionid":_unionid,@"sourceType":@"AppStore"} HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                          success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                              
                                                                                              [self handleData:operation];
                                                                                          }
                                                                                          failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                              [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                          }];
            operation.tag = 1000;
            [operation start];
        }
        
    } view:self.view];
}

-(void) actionForget
{
    AmendPassWordViewController *Amend=[[AmendPassWordViewController alloc]init];
    [self.navigationController pushViewController: Amend animated:YES];
}

-(void) actionRegister
{
    RegisterVC *VC = [[RegisterVC alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark ---  网络通讯
-(void) netLogin
{
    NSString *strUrl = [PDAPI userKJLoginInfoAPI];
    //[NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGGetLoginAPIString];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    parmas[@"telephone"] = filedInput1.text;
    parmas[@"randomNo"] = filedInput2.text;
    parmas[@"sourceType"] = @"AppStore";
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    operation.tag = 1001;
    [operation start];
}

-(void) netMMLogin
{
    NSString *strUrl = [PDAPI userPassWordLoginInfoAPI];
    //[NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGGetLoginAPIString];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    parmas[@"telephone"] = filedInput1.text;
    parmas[@"password"] = filedInput2.text;
    parmas[@"sourceType"] = @"AppStore";
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
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
                                                                                      
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    //    operation.timeoutInterval = 10;
    operation.tag = 1003;
    [operation start];
}

-(void)getSMSFrist
{
    smsTokenId = @"";
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGgetSmsToken];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    parmas[@"telephone"] = filedInput1.text;
    
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
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGgetSmsLogin];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    parmas[@"telephone"] = filedInput1.text;
    parmas[@"smsTokenId"] = smsTokenId;
    NSString *strTemp = [NSString stringWithFormat:@"%@&%@",smsTokenId,filedInput1.text];
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


-(void)handleData:(DDGAFHTTPRequestOperation *)operation
{
    [self.view endEditing:YES];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (operation.tag == 998) {
        NSDictionary *dic = operation.jsonResult.attr;
        if (dic)
         {
            smsTokenId =  [NSString stringWithFormat:@"%@", dic[@"smsTokenId"]];
            [self getSMSSecond];
         }
        
    }else if (operation.tag == 999) {
        NSString *strOut = [NSString stringWithFormat:@"验证码发送到%@，请耐心等待。", filedInput1.text];
        [MBProgressHUD showSuccessWithStatus:strOut toView:self.view];
        
    }else if (operation.tag == 1000) {
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
            AmendPassWordViewController *ctl = [[AmendPassWordViewController alloc]init];
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
//        for (NSString *key in dic.allKeys) {   //避免NULL字段
//            if ([[dic objectForKey:key] isEqual:[NSNull null]]) {
//                [dic setValue:@"" forKey:key];
//            }
//        }
        [MBProgressHUD showSuccessWithStatus:@"登录成功" toView:self.view];
        
        if ([dic objectForKey:@"encryptId"]) {
            [[DDGSetting sharedSettings] setUid:[dic objectForKey:@"encryptId"]];
        }
        
        // 1. 账号相关 mobile、 密码、真实姓名、用户信息
//        self.paramDictionary[kRealName] = [dic objectForKey:kRealName];
//        self.paramDictionary[kMobile] = [dic objectForKey:kMobile];
        [DDGAccountManager sharedManager].userInfo = dic;
        //[[DDGAccountManager sharedManager] setUserInfoWithDictionary:self.paramDictionary];
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
//    if (operation.tag == 1002) {
//        if ([[operation.jsonResult.attr objectForKey:@"errorMore"] intValue] == 1 || [[operation.jsonResult.attr objectForKey:@"newUser"] intValue] == 1)
//         {
//            //切换到快捷登陆
//            [self loginType:self.wxBtn];
//         }
//    }
    
    
}


@end
