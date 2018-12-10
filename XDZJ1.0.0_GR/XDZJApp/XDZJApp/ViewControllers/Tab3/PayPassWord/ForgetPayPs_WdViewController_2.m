//
//  ForgetPayPs_WdViewController_2.m
//  XXJR
//
//  Created by xxjr03 on 2017/8/24.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import "ForgetPayPs_WdViewController_2.h"

#import "ForgetPayPs_WdViewController_3.h"
#import "SetPayPs_WdViewController_1.h"
#import "CommonInfo.h"
@interface ForgetPayPs_WdViewController_2 ()
{

    NSString *_phoneStr;
}

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;//手机号
@property (weak, nonatomic) IBOutlet UITextField *VerifyTextField;//验证码
@property (weak, nonatomic) IBOutlet UIButton *VerifyBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextBtnLayoutHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextBtnLayoutWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *NavConstraint;


@end

@implementation ForgetPayPs_WdViewController_2

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNaviBarViewWithTitle:@"手机验证"];
    
    self.nextBtnLayoutHeight.constant = 40 * ScaleSize;
    self.nextBtnLayoutWidth.constant = 290 * ScaleSize;
    if ([DDGAccountManager sharedManager].userInfo.count > 0) {
        _phoneStr = [[DDGAccountManager sharedManager].userInfo objectForKey:@"telephone"];
        self.phoneLabel.text = [NSString stringWithFormat:@"请输入手机号为%@的验证码",_phoneStr];
    }
    
    if (IS_IPHONE_X_MORE)
     {
        _NavConstraint.constant = 70+14;
     }
}

//获取验证码
- (IBAction)VerifyBtn:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    if (![XXJRUtils isNetworkReachable]) {
        [MBProgressHUD showErrorWithStatus:@"请检查网络" toView:self.view];
        return;
    }
    [self getVerifyData];
    
//    if ([_phoneStr isMobileNumber]) {
//        [self getVerifyData];
//    }else{
//        [MBProgressHUD showErrorWithStatus:@"请输入正确的手机号码" toView:self.view];
//        return;
//    }
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

-(void)getVerifyData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],@"xxcust/smsAction/login/forgetTrade"] parameters:@{@"telephone":self.phoneLabel.text} HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray success:^(DDGAFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        if (operation.jsonResult.success) {
            NSLog(@"----验证码发送成功----");
            MBProgressHUD *hud  = [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
            hud.completionBlock = ^{};
        } else {
            NSLog(@"-------验证码发送失败----");
            [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [MBProgressHUD showErrorWithStatus:[((DDGAFHTTPRequestOperation *)operation).errorDDG localizedDescription] toView:self.view];
    }];
    
    [operation start];
}


- (IBAction)nextBtn:(id)sender {
    [self.view endEditing:YES];
    
    if (self.VerifyTextField.text.length == 0) {
        [MBProgressHUD showErrorWithStatus:@"请输入验证码" toView:self.view];
        return;
    }
    [self forgetTradeUrl];
}


-(void)forgetTradeUrl{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],@"xxcust/smsAction/valid/login/forgetTrade"]
                                                                               parameters:@{@"smsNo":self.VerifyTextField.text} HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      if (self.payType == 100) {
                                                                                          SetPayPs_WdViewController_1 *ctl = [[SetPayPs_WdViewController_1 alloc]init];
                                                                                          [self.navigationController pushViewController:ctl animated:YES];
                                                                                      }else {
                                                                                          ForgetPayPs_WdViewController_3 *ctl = [[ForgetPayPs_WdViewController_3 alloc]init];
                                                                                          [self.navigationController pushViewController:ctl animated:YES];
                                                                                      }
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
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
