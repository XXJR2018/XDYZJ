//
//  AmendPassWordViewController.m
//  XXJR
//
//  Created by xxjr03 on 16/1/20.
//  Copyright © 2016年 Cary. All rights reserved.
//

#import "AmendPassWordViewController.h"
#import "IdentifyAlertView.h"

@interface AmendPassWordViewController ()<UITextFieldDelegate>
{
    NSString   *smsTokenId;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *verifTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWdTextField;
@property (weak, nonatomic) IBOutlet UIButton *verifBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *HeadViewTop;


@end

@implementation AmendPassWordViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    [self layoutNaviBarViewWithTitle:@"修改密码"];
    //密文
    self.passWdTextField.secureTextEntry = YES;
    if ([DDGSetting sharedSettings].mobile.length > 0) {
        self.phoneTextField.text = [DDGSetting sharedSettings].mobile;
        self.phoneTextField.userInteractionEnabled = NO;
    }
    
    //添加手势点击空白处隐藏键盘
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchViewKeyBoard)];
    gesture.numberOfTapsRequired  = 1;
    [self.view addGestureRecognizer:gesture];
    
    if (IS_IPHONE_X_MORE)
     {
        _HeadViewTop.constant = 95;
     }
}
//添加手势点击空白处隐藏键盘
-(void)TouchViewKeyBoard
{
    [self.view endEditing:YES];
}
- (IBAction)saveBtn:(id)sender {
    [self.view endEditing:YES];
    if (![self.phoneTextField.text isMobileNumber]) {
        [MBProgressHUD showErrorWithStatus:[LanguageManager wrongMobileNumberTipsString] toView:self.view];
        return;
    }else if (self.verifTextField.text.length == 0) {
        [MBProgressHUD showErrorWithStatus:@"请输入验证码" toView:self.view];
        return;
    }else if (![self.passWdTextField.text isPassWordLegal]) {
        [MBProgressHUD showErrorWithStatus:@"密码格式:数字和字母组合6~12位" toView:self.view];
        return;
    }else {
        [self amendPassWdUrl];
    }
}


//获取验证码
- (IBAction)verify:(id)sender {
    

    
    if (![XXJRUtils isNetworkReachable]) {
        [MBProgressHUD showErrorWithStatus:@"请检查网络" toView:self.view];
        return;
    }
    if ([self.phoneTextField.text isMobileNumber]) {

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
                [self.verifBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                self.verifBtn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.verifBtn setTitle:[NSString stringWithFormat:@"重发(%@秒)",strTime] forState:UIControlStateNormal];
                
                self.verifBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}

-(void)getSMSFrist
{
    smsTokenId = @"";
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGgetSmsToken];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    parmas[@"telephone"] = self.phoneTextField.text;
    
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
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString], kDDGgetSmsUpdatePwd];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    parmas[@"telephone"] = self.phoneTextField.text;
    parmas[@"smsTokenId"] = smsTokenId;
    NSString *strTemp = [NSString stringWithFormat:@"%@&%@",smsTokenId,self.phoneTextField.text];
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


-(void)getVerifyData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"telephone"] = self.phoneTextField.text;
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],kDDGgetSmsUpdatePwd] parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray success:^(DDGAFHTTPRequestOperation *operation, id responseObject) {
        if (operation.jsonResult.success) {
            NSLog(@"----验证码发送成功----");
            MBProgressHUD *hud  = [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
            hud.completionBlock = ^{};
        } else {
            NSLog(@"-------验证码发送失败----");
            [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD showErrorWithStatus:[((DDGAFHTTPRequestOperation *)operation).errorDDG localizedDescription] toView:self.view];
    }];
    
    [operation start];
}




-(void)amendPassWdUrl
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    params[kUUID] = [DDGSetting sharedSettings].UUID_MD5;
    params[@"telephone"]=self.phoneTextField.text;
    params[@"randomNo"]=self.verifTextField.text;
    params[@"password"]=self.passWdTextField.text;
    // 发送请求POST
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[PDAPI userChangeLoginPwdAPI] parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray success:^(DDGAFHTTPRequestOperation *operation, id responseObject) {
        
        [MBProgressHUD showSuccessWithStatus:@"修改成功" toView:self.view];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(DDGAFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
    }];
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
        NSString *strOut = [NSString stringWithFormat:@"验证码发送到%@，请耐心等待。", self.phoneTextField.text];
        [MBProgressHUD showSuccessWithStatus:strOut toView:self.view];
        
    }
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
