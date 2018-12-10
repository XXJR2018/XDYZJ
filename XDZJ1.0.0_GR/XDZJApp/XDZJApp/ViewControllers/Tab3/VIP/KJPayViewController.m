//
//  KJPayViewController.m
//  XXJR
//
//  Created by xxjr03 on 2017/5/22.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import "KJPayViewController.h"
#import "MyBankViewController.h"
#import "ForgetPayPs_WdViewController_1.h"
#import "ForgetPayPs_WdViewController_2.h"
#import "SIAlertView.h"
#import "DCPaymentView.h"
#import "TradingStautsVC.h"
#include<sys/time.h>

@interface KJPayViewController ()
{
    NSString *_bankCode;
    NSString *_bindId;
    NSString *_backCardNum;
    NSString *_payID;       // 支付的id, 在此页面只生成一次
   
    
    float fMoney;  // 余额的金额
}
@property (weak, nonatomic) IBOutlet UILabel *rechargeAmountLabel;  //充值金额
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;     //姓名
@property (weak, nonatomic) IBOutlet UILabel *identityLabel; //身份证号
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;    //手机号
@property (weak, nonatomic) IBOutlet UILabel *YHLabel;              //所选银行
@property (weak, nonatomic) IBOutlet UILabel *cardNumLabel;  //银行卡号

@end

@implementation KJPayViewController

-(void)loadData
{
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],@"busi/account/baofoo/bindcard/bankCard"]
                                                                               parameters:nil HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                     
                                                                                  }];
    operation.tag = 1001;
    [operation start];
}

-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    if (operation.tag == 1001) {
        NSDictionary *dic = operation.jsonResult.rows[0];
        if (dic.count > 0) {
            //重新赋值
            self.nameLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"hideName"]];
            self.identityLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"hideCertificateNo"]];
            self.cardNumLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"hideCardCode"]];
            self.phoneLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"hideTelephone"]];
            self.YHLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"bankName"]];
            self.YHLabel.textColor = [ResourceManager color_1];
            _bankCode = [NSString stringWithFormat:@"%@",[dic objectForKey:@"bankCode"]];
            _bindId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"bindId"]];
            _backCardNum = [NSString stringWithFormat:@"%@",[dic objectForKey:@"bankCardNo"]];
        }
    }else if (operation.tag == 1002) {
        [self payUrl];
    }else if (operation.tag == 1003) {
        NSDictionary *dic = operation.jsonResult.attr;
//        if ([[dic objectForKey:@"resp_code"] intValue] == 0000) {
//            [MBProgressHUD showSuccessWithStatus:@"支付成功" toView:self.view];
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        }
        
        TradingStautsVC *vc = [[TradingStautsVC alloc] init];
        vc.tradeId = _payID;
        vc.strStatus = [dic objectForKey:@"resp_code"];
        vc.strError = operation.jsonResult.message;
        vc.strAddMoney = _strAddMoney;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

/**
 * 请求发生错误的数据处理  (子类重写如果没有处理page，要先执行父类方法)
 */
-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation
{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    if (operation.tag == 1003) {
        NSDictionary *dic = operation.jsonResult.attr;
        
        TradingStautsVC *vc = [[TradingStautsVC alloc] init];
        vc.tradeId = _payID;
        vc.strStatus = [dic objectForKey:@"resp_code"];
        vc.strError = operation.jsonResult.message;
        [self.navigationController pushViewController:vc animated:YES];

    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNaviBarViewWithTitle:@"宝付支付"];
    
    if (self.moneyNum.length > 0) {
        self.rechargeAmountLabel.text = [NSString stringWithFormat:@"%@元",self.moneyNum];
    }
    if (_usableAmount.length > 0)
     {
        fMoney = [_usableAmount floatValue];
     }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payPassWord) name:@"PayPassWord" object:nil];
    
    // 获取当前时间戳
    struct timeval tv;
    gettimeofday(&tv,NULL);
    //printf("second:%ld\n",tv.tv_sec);  //秒
    //printf("millisecond:%ld\n",tv.tv_sec*1000 + tv.tv_usec/1000);  //毫秒
    //printf("microsecond:%ld\n",tv.tv_sec*1000000 + tv.tv_usec);  //微秒
    _payID = [NSString stringWithFormat:@"%ld",tv.tv_sec*1000 + tv.tv_usec/1000];
}

//更换银行卡
- (IBAction)changeBack:(id)sender {
    //我的银行卡
    //MyBankViewController *ctl = [[MyBankViewController alloc] init];
    //[self.navigationController pushViewController:ctl animated:YES];
}

//确认支付
- (IBAction)pay:(UIButton *)sender {

    
    // 如果是余额充值
    if ([self.rechargeType isEqualToString:@"r"])
    {
        [self getMoney];
    }
    else
    {
       [self realPay];
    }
    

}

-(void) realPay
{
    [self payPassWord];
}

-(void) possMessage
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PayPassWord" object:nil];
}

-(void) payPassWord
{

    
    if ([[[DDGAccountManager sharedManager].userInfo objectForKey:@"hasJyPwd"] intValue] == 1) {
        DCPaymentView *payAlert = [[DCPaymentView alloc]init];
        payAlert.title = @"请输入支付密码";
        [payAlert show];
        
        // 支付密码完成时
        __weak typeof(DCPaymentView *) weakSelf = payAlert;
        
        payAlert.completeHandle = ^(NSString *inputPwd) {
            NSLog(@"密码是%@",inputPwd);
            //校验密码
            [self checkTradeUrl:inputPwd];
            
            [weakSelf dismiss];
        };
        
        // 忘记密码响应函数
        payAlert.passWordBlock = ^(){
            [weakSelf removeFromSuperview];
            //忘记支付密码
            ForgetPayPs_WdViewController_1 *ctl = [[ForgetPayPs_WdViewController_1 alloc]init];
            [self.navigationController pushViewController:ctl animated:YES];
        };
    }else{
        SIAlertView * alertView = [[SIAlertView alloc]initWithTitle:@"设置支付密码" andMessage:@"您还没有设置支付密码，请先设置支付密码以完成支付"];
        
        [alertView addButtonWithTitle:@"再看看" type:SIAlertViewButtonTypeDefault handler:nil];
        [alertView addButtonWithTitle:@"设置支付密码" type:SIAlertViewButtonTypeCancel handler:^(SIAlertView *alertView){
            //设置支付密码
            ForgetPayPs_WdViewController_2 *ctl = [[ForgetPayPs_WdViewController_2 alloc]init];
            ctl.payType = 100;
            [self.navigationController pushViewController:ctl animated:YES];
        }];
        alertView.cornerRadius = 5;
        alertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
        alertView.transitionStyle = SIAlertViewTransitionStyleSlideFromTop;
        
        [alertView show];
    }
    
  
}

-(void)checkTradeUrl:(NSString *)inputPwd{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tradePwd"] = inputPwd;
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],@"xxcust/account/info/checkTradePwd"]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    
    operation.tag = 1002;
    [operation start];

}

-(void)payUrl{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"txn_amt"] = self.moneyNum;
    params[@"rechargeType"] = self.rechargeType;
    params[@"tradeId"] = _payID;
    
    // 如果有充值券
    if (_couponId !=0)
     {
        params[@"couponId"] = @(_couponId);
     }
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],@"busi/account/baofoo/pay/newPayDeal"]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      //[MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                       [self   handleErrorData:operation];
                                                                                  }];
    
    operation.tag = 1003;
    [operation start];

}

-(void)getMoney
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[PDAPI getUserBaseInfoAPI]
                                                                               parameters:@{kUUID:[DDGSetting sharedSettings].UUID_MD5} HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                                                                      [self handleMoneyData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    operation.tag = 1005;
    [operation start];
}

-(void)handleMoneyData:(DDGAFHTTPRequestOperation *)operation{

    NSArray *rows=operation.jsonResult.rows;
    NSDictionary *_dataDic;
    if (rows.count > 0) {
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithDictionary:rows[0]];
        _dataDic = dic;
        //避免NULL字段
        for (NSString *key in dic.allKeys) {
            if ([[dic objectForKey:key] isEqual:[NSNull null]]) {
                [dic setValue:@"" forKey:key];
            }
        }
        float  fCurentMoney = 0;
        
        
        if ([_dataDic objectForKey:@"usableAmount"] && [NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"usableAmount"]].length > 0) {
                
                fCurentMoney = [[_dataDic objectForKey:@"usableAmount"] floatValue];
                float fCZMoney = fCurentMoney - fMoney;
                if (( fCZMoney>= 500)&&
                    fMoney != 0)
                 {
                    //
                    NSString *payStr = [NSString stringWithFormat:@"您已经充值成功%.2f元",fCZMoney];
                    SIAlertView * alertView = [[SIAlertView alloc]initWithTitle:@"支付提醒" andMessage:payStr];
                    
                    
                    [alertView addButtonWithTitle:@"继续充值" type:SIAlertViewButtonTypeCancel handler:^(SIAlertView *alertView){
                        
                        
                        [self performSelector:@selector(possMessage) withObject:nil afterDelay:0.5f];
                        
                        
                    }];
                    [alertView addButtonWithTitle:@"不充值了" type:SIAlertViewButtonTypeDefault handler:nil];                    alertView.cornerRadius = 5;
                    alertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
                    alertView.transitionStyle = SIAlertViewTransitionStyleSlideFromTop;
                    
                    [alertView show];
                 }
                else
                 {
                    [self realPay];
                 }
                //fMoney = [[_dataDic objectForKey:@"usableAmount"] floatValue];
        }
        

    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
