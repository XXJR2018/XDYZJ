//
//  WithdrawalsViewController.m
//  XXJR
//
//  Created by xxjr02 on 2017/3/27.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import "WithdrawalsViewController.h"
#import "WithdrawalsListViewController.h"
#import "TextFieldView.h"
#import "CommonInfo.h"

@interface WithdrawalsViewController ()<UITextFieldDelegate>
{
    TextFieldView *tfAcountAmount;
    TextFieldView *tfExtractAount;
    TextFieldView *tfPhone;
    TextFieldView *tfVerificationCode;
    
    UIButton *bt1; // 验证码按钮
}
@end

@implementation WithdrawalsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutNaviBarViewWithTitle:@"余额提现"];
    
    [self layoutUI];
    
    //添加手势点击空白处隐藏键盘
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchViewKeyBoard)];
    gesture.numberOfTapsRequired  = 1;
    [self.view addGestureRecognizer:gesture];
    
    
}

//添加手势点击空白处隐藏键盘
-(void)TouchViewKeyBoard{
    [self.view endEditing:YES];
    
    CGRect  rectTemp = self.view.frame;
    rectTemp.origin.y = 0;
    self.view.frame = rectTemp;
}

-(void) layoutUI
{
    
    UILabel *labelR = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-70, 23, 60, 20)];
    labelR.backgroundColor = [UIColor clearColor];
    labelR.text = @"提现记录";
    labelR.textColor = [UIColor grayColor];
    labelR.font = [UIFont systemFontOfSize:13];
    labelR.userInteractionEnabled = YES;
    UITapGestureRecognizer * gesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TXJL)];
    [labelR addGestureRecognizer:gesture1];
    [self.view addSubview:labelR];
    
    UIView   *viewBack = [[UIView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, 50)];
    viewBack.backgroundColor = UIColorFromRGB(0xFDF9EC);
    [self.view addSubview:viewBack];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, NavHeight, SCREEN_WIDTH-30, 50)];
    label.backgroundColor = UIColorFromRGB(0xFDF9EC);
    NSString *strSM = [NSString stringWithFormat:@"说明:    提现一笔扣费%d元，提现金额预计在2天内到达指定账户，请注意查收！",_iCharging];
    label.text = strSM;
    label.textColor = UIColorFromRGB(0x774311);
    label.font = [UIFont systemFontOfSize:13];
    label.numberOfLines = 0;
    [self.view addSubview:label];
    
    int iTopY = NavHeight + label.frame.size.height + 10;
    // 分割线
    UILabel *labelFg = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY-0.6, SCREEN_WIDTH, 0.6)];
    labelFg.backgroundColor = UIColorFromRGB(0xd9d9d9);
    [self.view addSubview:labelFg];
    
    UIView   *viewBack2 = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 44)];
    viewBack2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewBack2];
//    UIImageView  *img2 = [[UIImageView alloc]initWithFrame:CGRectMake(10 ,5 ,30 , 30)];
//    img2.backgroundColor = [UIColor blueColor];
//    [viewBack2 addSubview:img2];
    UILabel *labelYH = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 30)];
    NSString *strYH = _strHideCard;// [NSString stringWithFormat:@"中国银行（尾号1230）"];
    labelYH.text = strYH;
    labelYH.font = [UIFont systemFontOfSize:14];
    [viewBack2 addSubview:labelYH];
    
    // 分割线
    labelFg = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY+ 44 - 0.6, SCREEN_WIDTH, 0.6)];
    labelFg.backgroundColor = UIColorFromRGB(0xd9d9d9);
    [self.view addSubview:labelFg];
    
    
    
    iTopY +=  viewBack2.frame.size.height + 20;
    int iPlaceHolderLeftX = 120;
    // 分割线
    labelFg = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY - 0.6, SCREEN_WIDTH, 0.6)];
    labelFg.backgroundColor = UIColorFromRGB(0xd9d9d9);
    [self.view addSubview:labelFg];
    
    tfAcountAmount = [[TextFieldView alloc]initWithTitle:@"可用余额" placeHolder:@"" textAlignment:NSTextAlignmentLeft width:SCREEN_WIDTH-iPlaceHolderLeftX  originY:iTopY fieldViewType:TextFieldViewDefault];
    [self.view addSubview:tfAcountAmount];
    tfAcountAmount.userInteractionEnabled = NO;
    NSString *strAomunt = _strAcountAmount;
    //strAomunt = [CommonInfo formatString:strAomunt];
    strAomunt = [strAomunt stringByAppendingString:@"元"];
    tfAcountAmount.textField.text = strAomunt;
    tfAcountAmount.textField.textColor = [UIColor orangeColor];
    
    iTopY += tfAcountAmount.frame.size.height;
    tfExtractAount = [[TextFieldView alloc]initWithTitle:@"提取余额" placeHolder:@"请输入金额" textAlignment:NSTextAlignmentLeft width:SCREEN_WIDTH-iPlaceHolderLeftX  originY:iTopY fieldViewType:TextFieldViewNumber];
    [self.view addSubview:tfExtractAount];

    iTopY += tfExtractAount.frame.size.height;
    tfPhone = [[TextFieldView alloc]initWithTitle:@"手机号码" placeHolder:@"" textAlignment:NSTextAlignmentLeft width:SCREEN_WIDTH-iPlaceHolderLeftX  originY:iTopY fieldViewType:TextFieldViewDefault];
    [self.view addSubview:tfPhone];
    tfPhone.textField.text = _strHidePhone;
    tfPhone.userInteractionEnabled = NO;

    iTopY += tfPhone.frame.size.height;
    tfVerificationCode = [[TextFieldView alloc]initWithTitle:@"手机验证码" placeHolder:@"请输入验证码" textAlignment:NSTextAlignmentLeft width:SCREEN_WIDTH-iPlaceHolderLeftX  originY:iTopY fieldViewType:TextFieldViewNumber];
    [self.view addSubview:tfVerificationCode];
    tfVerificationCode.textField.delegate = self;
    bt1 = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 90, iTopY+7, 80, 30)];
    [bt1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bt1 setTitle:@"获取验证码" forState:UIControlStateNormal];
    bt1.backgroundColor = UIColorFromRGB(0xf8aa3b);
    bt1.titleLabel.font = [UIFont systemFontOfSize:12];
    bt1.cornerRadius = 15;
    [bt1 addTarget:self action:@selector(bt1Action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt1];
    
    // 分割线
    labelFg = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY + tfVerificationCode.frame.size.height - 0.6, SCREEN_WIDTH, 0.6)];
    labelFg.backgroundColor = UIColorFromRGB(0xd9d9d9);
    [self.view addSubview:labelFg];
    
    iTopY += tfVerificationCode.frame.size.height  + 30;
    UIButton  *btnApply = [[UIButton alloc]initWithFrame:CGRectMake(15, iTopY, SCREEN_WIDTH-30, 45)];
    [btnApply setTitle:@"确认提现" forState:UIControlStateNormal];
    btnApply.titleLabel.font=[UIFont systemFontOfSize:14];
    [btnApply setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnApply.cornerRadius = 5;
    btnApply.backgroundColor = [UIColor orangeColor];
    [btnApply addTarget:self action:@selector(applyAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnApply];
    

}

-(void) TXJL
{
    WithdrawalsListViewController *vc = [[WithdrawalsListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void) bt1Action
{
    if (![XXJRUtils isNetworkReachable]) {
        [MBProgressHUD showErrorWithStatus:@"请检查网络" toView:self.view];
        return;
    }
    
    NSLog(@"bt1Action");
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    params[@"telephone"] = _strPhone;
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],@"xxcust/smsAction/login/withdraw"]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      [MBProgressHUD showErrorWithStatus:@"验证码发送成功" toView:self.view];
                                                                                      [self startTime];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    
    operation.tag = 1000;
    [operation start];

}



-(void)startTime
{
    
    __block int timeout=59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [bt1 setTitle:@"获取验证码" forState:UIControlStateNormal];
                bt1.userInteractionEnabled = YES;
                
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [bt1 setTitle:[NSString stringWithFormat:@"重发(%@秒)",strTime] forState:UIControlStateNormal];
                bt1.userInteractionEnabled = NO;
                //                [_getVerifyBtn setBackgroundColor:[UIColor grayColor]];
                
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}

-(void) applyAction
{
    
    double dVaule = [tfExtractAount.textField.text doubleValue];
    
    if (dVaule <= 0.000001)
     {
        [MBProgressHUD showErrorWithStatus:@"请输入正确金额" toView:self.view];
        return;
     }
    
    NSString *strAmount = [_strAcountAmount stringByReplacingOccurrencesOfString:@"," withString:@""];
    double dAcountAmount = [strAmount doubleValue];
    if (dVaule > dAcountAmount && dAcountAmount > 0.00001)
     {
        [MBProgressHUD showErrorWithStatus:@"输入金额大于可用余额" toView:self.view];
        return;
     }
    
    if (dVaule < _iCharging)
     {
        [MBProgressHUD showErrorWithStatus:@"输入金额小于每笔扣费" toView:self.view];
        return;
     }
    
    if (tfVerificationCode.textField.text.length <=0 ||
        [tfVerificationCode.textField.text isEqualToString:@""])
     {
        [MBProgressHUD showErrorWithStatus:@"请输入验证码" toView:self.view];
        return;
     }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
   
    params[@"amount"] = @(dVaule);
    params[@"randomNo"] = tfVerificationCode.textField.text;
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],@"xxcust/account/fund/withdraw"]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                       [MBProgressHUD showErrorWithStatus:@"提现申请成功，请耐心等待审核" toView:self.view];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    
    operation.tag = 1000;
    [operation start];
    

}

#pragma mark === UITextFieldDelegate
//开始编辑时,键盘遮挡文本框，视图上移
-(BOOL)textFieldShouldBeginEditing:(UITextView *)textField
{
    CGRect  rectTemp = self.view.frame;
    rectTemp.origin.y = -100;
    self.view.frame = rectTemp;
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

//键盘落下事件
- (void)textFieldDidEndEditing:(UITextView *)textField{
    CGRect  rectTemp = self.view.frame;
    rectTemp.origin.y = 0;
    self.view.frame = rectTemp;
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
