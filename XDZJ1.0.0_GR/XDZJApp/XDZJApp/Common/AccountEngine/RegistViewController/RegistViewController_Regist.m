//
//  RegistViewController_Regist.m
//  XXJR
//
//  Created by xxjr03 on 16/11/14.
//  Copyright © 2016年 Cary. All rights reserved.
//

#import "RegistViewController_Regist.h"
#import "AgreementViewController.h"
#import "AccountOperationController.h"

@interface RegistViewController_Regist ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneField;       //手机号
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeField;  //验证码
@property (weak, nonatomic) IBOutlet UITextField *pwdField_1;       //输入密码
@property (weak, nonatomic) IBOutlet UITextField *pwdField_2;       //确认密码


@property (weak, nonatomic) IBOutlet UIButton *voiceVerifyBtn;      //获取语音验证码
@property (weak, nonatomic) IBOutlet UIButton *getVerifyBtn;        //获取短信验证码
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;            //同意协议按钮

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutHeigt; //高度约束


@end

@implementation RegistViewController_Regist

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.voiceVerifyBtn.layer.borderWidth = 0.5;
    self.voiceVerifyBtn.layer.borderColor = UIColorFromRGB(0x5baf61).CGColor;
    self.getVerifyBtn.layer.borderWidth = 0.5;
    self.getVerifyBtn.layer.borderColor = UIColorFromRGB(0x5d91de).CGColor;
    
    //重写约束
    self.layoutHeigt.constant = 145 * SCREEN_WIDTH/320;
    
    //添加手势点击空白处隐藏键盘
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchViewKeyBoard)];
    gesture.numberOfTapsRequired  = 1;
    
    [self.view addGestureRecognizer:gesture];
}
//添加手势点击空白处隐藏键盘
-(void)TouchViewKeyBoard
{
    [self resumeView];
    [self.view endEditing:YES];
}
//短信验证码
- (IBAction)getVerify:(id)sender {
    [self.view endEditing:YES];
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
                [self.getVerifyBtn setTitle:@"获取" forState:UIControlStateNormal];
                self.getVerifyBtn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.getVerifyBtn setTitle:[NSString stringWithFormat:@"重发(%@秒)",strTime] forState:UIControlStateNormal];
                self.getVerifyBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
//语音验证码
- (IBAction)voiceVerify:(id)sender {
    [self.view endEditing:YES];
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
                [self.voiceVerifyBtn setTitle:@"获取" forState:UIControlStateNormal];
                self.voiceVerifyBtn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.voiceVerifyBtn setTitle:[NSString stringWithFormat:@"重发(%@秒)",strTime] forState:UIControlStateNormal];
                self.voiceVerifyBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
//返回
- (IBAction)back:(id)sender {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
//同意协议按钮
- (IBAction)agreeBtn:(UIButton *)sender {
    [self.view endEditing:YES];
    sender.selected = !sender.selected;
}
//协议
- (IBAction)treaty:(id)sender {
    [self.view endEditing:YES];
    AgreementViewController * agree = [[AgreementViewController alloc]init];
    [self.navigationController pushViewController:agree animated:YES];
}
#pragma mark - 获取验证码
//注册界面获取短信验证码
-(void)getVerifyData
{
    
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"telephone"] = _phoneField.text;
    [[NSOperationQueue mainQueue] addOperation:[[DDGAFHTTPRequestOperation alloc] initWithURL:[PDAPI userRegisterPasswordAPI] parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray success:^(DDGAFHTTPRequestOperation *operation, id responseObject) {
        
        NSString * Message=((DDGAFHTTPRequestOperation *)operation).jsonResult.message;
        if (operation.jsonResult.success!=0) {
            NSLog(@"----验证码发送成功----");
            MBProgressHUD *hud  = [MBProgressHUD showErrorWithStatus:Message toView:self.view];
            hud.completionBlock = ^{};
        }else{
            NSLog(@"-------验证码发送失败----");
            [MBProgressHUD showErrorWithStatus:Message toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        [MBProgressHUD showErrorWithStatus:[((DDGAFHTTPRequestOperation *)operation).errorDDG localizedDescription] toView:self.view];
    }]];
}
#pragma mark - 获取验证码
//注册界面获取语音验证码
-(void)getVerifyData2
{
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"telephone"] = _phoneField.text;
    params[@"isVoice"] = @"voice";
    
    [[NSOperationQueue mainQueue] addOperation:[[DDGAFHTTPRequestOperation alloc] initWithURL:[PDAPI userRegisterPasswordAPI] parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray success:^(DDGAFHTTPRequestOperation *operation, id responseObject) {
        
        NSString * Message=((DDGAFHTTPRequestOperation *)operation).jsonResult.message;
        if (operation.jsonResult.success!=0) {
            NSLog(@"----验证码发送成功----");
            MBProgressHUD *hud  = [MBProgressHUD showErrorWithStatus:Message toView:self.view];
            hud.completionBlock = ^{};
        }else{
            NSLog(@"-------验证码发送失败----");
            [MBProgressHUD showErrorWithStatus:Message toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        [MBProgressHUD showErrorWithStatus:[((DDGAFHTTPRequestOperation *)operation).errorDDG localizedDescription] toView:self.view];
    }]];
}



//  注册按钮事件
- (IBAction)registBtnClick:(id)sender {
    [self.view endEditing:YES];
    if (![self.phoneField.text isMobileNumber]) {
        [MBProgressHUD showErrorWithStatus:[LanguageManager wrongMobileNumberTipsString] toView:self.view];
        return;
    }else if (self.verifyCodeField.text==nil)
    {
        [MBProgressHUD showErrorWithStatus:@"请输入验证码" toView:self.view];
        return;
        
    }else if (![self.pwdField_1.text isPassWordLegal]) {
        [MBProgressHUD showErrorWithStatus:@"密码格式:数字和字母组合6~12位" toView:self.view];
        return;
    }else if (![self.pwdField_1.text isEqualToString:self.pwdField_2.text]) {
        [MBProgressHUD showErrorWithStatus:@"两次输入密码不一致" toView:self.view];
        return;
    }
    else if (!self.agreeBtn.selected) {
        [MBProgressHUD showErrorWithStatus:@"请阅读并同意注册协议" toView:self.view];
        return;
    }
    else{
        [self regist];
    }

}

#pragma mark - 注册信息提交
-(void)regist
{
    AccountOperationController *controller = [[AccountOperationController alloc] init];
    controller.viewControler = self;
    [controller.paramDictionary setObject:_phoneField.text forKey:kMobile];
    [controller.paramDictionary setObject:_pwdField_1.text forKey:kPassword];
    [controller.paramDictionary setObject:_verifyCodeField.text forKey:@"randomNo"];
    
    //userType=1信贷经理入驻
    //userType=2借款人
    int iType = 2;
    int iXDJL= [DDGUserInfoEngine engine].iISXDJL;
    
    
    if ( 1 == iXDJL)
     {
        iType = 1;
        [DDGUserInfoEngine engine].iISXDJL = 3;
     }
    [controller.paramDictionary setObject:@(iType) forKey:@"userType"];

    [controller accountRequest:AccountRequestTypeRegister success:nil fail:nil];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

//开始编辑时,键盘遮挡文本框，视图上移
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 100) {
        NSTimeInterval animationDuration=0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        float width = self.view.frame.size.width;
        float height = self.view.frame.size.height;
        //上移30个单位，按实际情况设置
        CGRect rect=CGRectMake(0.0f,-200,width,height);
        self.view.frame=rect;
        [UIView commitAnimations];
    }
   
    return YES;
}
//恢复原始视图位置
-(void)resumeView
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //如果当前View是父视图，则Y为20个像素高度，如果当前View为其他View的子视图，则动态调节Y的高度
    
    CGRect rect=CGRectMake(0.0f,0,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
}
//键盘落下事件
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 100) {
        [self resumeView];
    }
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [self resumeView];
    [super viewDidDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
