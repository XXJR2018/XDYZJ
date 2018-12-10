//
//  RechargeHighViewController.m
//  XXJR
//
//  Created by xxjr02 on 2017/3/27.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import "RechargeHighViewController.h"
#import "CCWebViewController.h"
#import "PickerView.h"
#import "TextFieldView.h"
#import "CommonInfo.h"
#import "KJPayViewController.h"
#import "MyBankViewController.h"
@interface RechargeHighViewController ()
{
    TextFieldView *tfAcountAomunt;      // 账号余额
    TextFieldView *tfRechargeAomunt;    // 充值金额
    
    UIButton *bt1;
    BOOL _haveCard;
}

@end

@implementation RechargeHighViewController

-(void)loadData
{
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],@"busi/account/baofoo/bindcard/bankCard"]
                                                                               parameters:nil HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                     
                                                                                  }];
    
    [operation start];
}

-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    if (operation.jsonResult.rows.count > 0)
    {
        _haveCard = YES;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutNaviBarViewWithTitle:@"优质单充值"];
    
    [self layoutUI];
    //添加手势点击空白处隐藏键盘
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchViewKeyBoard)];
    gesture.numberOfTapsRequired  = 1;
    [self.view addGestureRecognizer:gesture];
    
    
}


//添加手势点击空白处隐藏键盘
-(void)TouchViewKeyBoard{
    [self.view endEditing:YES];
}

-(void) layoutUI
{
    
    
    UIView   *viewBack = [[UIView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, 50)];
    viewBack.backgroundColor = UIColorFromRGB(0xFDF9EC);
    [self.view addSubview:viewBack];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, NavHeight, SCREEN_WIDTH-30, 50)];
    label.backgroundColor = UIColorFromRGB(0xFDF9EC);
    NSString *strSM = [NSString stringWithFormat:@"说明:   最低充值金额%d元，充值金额仅作为抢优质单使用。提现时需要扣除手续费%d元/笔。",_iEveryAomunt, _iCharging];
    label.text = strSM;
    label.textColor = UIColorFromRGB(0x774311);
    label.font = [UIFont systemFontOfSize:13];
    label.numberOfLines = 0;
    [self.view addSubview:label];
    
    int iTopY = NavHeight + 50 + 15;
    int iPlaceHolderLeftX = 100;
    
    // 分割线1
    UILabel *labelFg = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY-0.6, SCREEN_WIDTH, 0.6)];
    labelFg.backgroundColor = UIColorFromRGB(0xd9d9d9);
    [self.view addSubview:labelFg];
    
    tfAcountAomunt = [[TextFieldView alloc]initWithTitle:@"账号余额" placeHolder:@"" textAlignment:NSTextAlignmentLeft width:SCREEN_WIDTH-iPlaceHolderLeftX  originY:iTopY fieldViewType:TextFieldViewNumber];
    [self.view addSubview:tfAcountAomunt];
    tfAcountAomunt.userInteractionEnabled = NO;
    NSString *strAomunt = _strAcountAmount;
    //strAomunt = [CommonInfo formatString:strAomunt];
    strAomunt = [strAomunt stringByAppendingString:@"元"];
    tfAcountAomunt.textField.text = strAomunt;
    tfAcountAomunt.textField.textColor = [UIColor orangeColor];
    
    iTopY += tfAcountAomunt.frame.size.height;
    tfRechargeAomunt = [[TextFieldView alloc]initWithTitle:@"充值金额" placeHolder:@"请输入金额" textAlignment:NSTextAlignmentLeft width:SCREEN_WIDTH-iPlaceHolderLeftX  originY:iTopY fieldViewType:TextFieldViewNumber];
    [self.view addSubview:tfRechargeAomunt];
    // 分割线
    labelFg = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY + tfRechargeAomunt.frame.size.height - 0.6, SCREEN_WIDTH, 0.6)];
    labelFg.backgroundColor = UIColorFromRGB(0xd9d9d9);
    [self.view addSubview:labelFg];
    
    iTopY += tfRechargeAomunt.frame.size.height +20;
    // 分割线
    labelFg = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY - 0.6, SCREEN_WIDTH, 0.6)];
    labelFg.backgroundColor = UIColorFromRGB(0xd9d9d9);
    [self.view addSubview:labelFg];
    
    UIView *viewWX = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 44)];
    viewWX.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewWX];
    UIImageView     *img = [[UIImageView alloc]initWithFrame:CGRectMake(10, 13.5, 36, 19)];
    img.image = [UIImage imageNamed:@"VIP-15"];
    [viewWX addSubview:img];
    UILabel *labelWXZF = [[UILabel alloc] initWithFrame:CGRectMake(50, 13, 100, 20)];
    labelWXZF.font = [UIFont systemFontOfSize:14];
    labelWXZF.text = @"银联支付";
    [viewWX addSubview:labelWXZF];
    
//    UIButton *WXPayBtn = [[UIButton alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(viewWX.frame), 240, 30)];
//    [WXPayBtn setTitle:@"微信支付请通过小小金融公众号进行充值!" forState:UIControlStateNormal];
//    [WXPayBtn setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
//    WXPayBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//    WXPayBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
//    [self.view addSubview:WXPayBtn];
    //[WXPayBtn addTarget:self action:@selector(WXPayXxjr) forControlEvents:UIControlEventTouchUpInside];
//    
    // 分割线
    labelFg = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY + viewWX.frame.size.height - 0.6, SCREEN_WIDTH, 0.6)];
    labelFg.backgroundColor = UIColorFromRGB(0xd9d9d9);
    [self.view addSubview:labelFg];
//
//    iTopY = CGRectGetMaxY(viewWX.frame) + 30;
//    int iLeftX = 10;

//    bt1 = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 20, 20)];
//    UIImage *image1= [UIImage imageNamed:@"yzd_select"];
//    UIImage *image2= [UIImage imageNamed:@"yzd_unselect"];
//    [bt1 setImage:image2 forState:UIControlStateNormal];
//    [bt1 setImage:image1 forState:UIControlStateSelected];
//    bt1.selected = YES;
//    [bt1 addTarget:self action:@selector(bt1Action) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:bt1];
//    
//    UILabel *labelTitle4 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX+ 23, iTopY, SCREEN_WIDTH/2, 20)];
//    labelTitle4.text = @"同意";
//    labelTitle4.font = [UIFont systemFontOfSize:12];
//    labelTitle4.textColor = [ResourceManager color_7];
//    [self.view addSubview:labelTitle4];
//    
//    UILabel *labelTitle3 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX+ 23 + 25, iTopY, SCREEN_WIDTH/2, 20)];
//    labelTitle3.text = @"《小小金融充值协议》";
//    labelTitle3.font = [UIFont systemFontOfSize:12];
//    labelTitle3.textColor = UIColorFromRGB(0x1f83d3);  // 淡蓝色
//    //添加手势点击
//    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(treatyButton)];
//    gesture.numberOfTapsRequired  = 1;
//    [labelTitle3 addGestureRecognizer:gesture];
//    labelTitle3.userInteractionEnabled = YES;
//    [self.view addSubview:labelTitle3];
    
    UIButton  *btnApply = [[UIButton alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(labelFg.frame) + 40, SCREEN_WIDTH-30, 45)];
    [btnApply setTitle:@"立即充值" forState:UIControlStateNormal];
    btnApply.titleLabel.font=[UIFont systemFontOfSize:14];
    [btnApply setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnApply.cornerRadius = 5;
    btnApply.backgroundColor = UIColorFromRGB(0xc79548);
    [btnApply addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnApply];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) bt1Action
{
    bt1.selected = !bt1.selected;
}

//跳转小小金融APP
-(void)WXPayXxjr{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"XXJRApp://"]]){
        NSURL *url = [NSURL URLWithString:@"XXJRApp://"];
        [[UIApplication sharedApplication] openURL:url];
    }else{
        NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/us/app/xiao-xiao-jin-rong-jing-li-ban/id1084229599?l=zh&ls=1&mt=8"];
        [[UIApplication sharedApplication] openURL:url];
    }
}

//协议
-(void) treatyButton
{
    NSString *url = [NSString stringWithFormat:@"%@xxapp/protocol/rechargeProtocol",[PDAPI WXSysRouteAPI]];
    [CCWebViewController showWithContro:self withUrlStr:url withTitle:@"小小金融充值协议"];
}

//判断是否为整形：
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

//立即充值
-(void) addAction
{
    if([tfRechargeAomunt.textField.text intValue] < _iEveryAomunt ){
        NSString *strOut = [NSString stringWithFormat:@"最低充值金额为%d元",_iEveryAomunt];
        [MBProgressHUD showErrorWithStatus:strOut toView:self.view];
        return;
    }
    
    if([tfRechargeAomunt.textField.text intValue] > 10000 ){
        NSString *strOut = @"最高充值金额不能超过1万";
        [MBProgressHUD showErrorWithStatus:strOut toView:self.view];
        return;
    }
    
    if(![self isPureInt:tfRechargeAomunt.textField.text] || [tfRechargeAomunt.textField.text intValue] < _iEveryAomunt || tfRechargeAomunt.textField.text.length == 0){
        [MBProgressHUD showErrorWithStatus:@"充值金额不符合规范，必须是整数" toView:self.view];
        return;
    
    }
    
    if (_haveCard) {
        KJPayViewController *ctl = [[KJPayViewController alloc]init];
        ctl.moneyNum = tfRechargeAomunt.textField.text;
        ctl.rechargeType = @"s";
        [self.navigationController pushViewController:ctl animated:YES];
    }else{
        MyBankViewController *ctl = [[MyBankViewController alloc]init];
        [self.navigationController pushViewController:ctl animated:YES];
    }
    
    
    //    [MBProgressHUD showErrorWithStatus:@"请通过小小金融公众号充值。" toView:self.view];

    return;
    
    if (!bt1.selected) {
        [MBProgressHUD showErrorWithStatus:@"请同意小小金融充值协议" toView:self.view];
        return;
    }
    
    double dVaule = [tfRechargeAomunt.textField.text doubleValue];
    
    if (dVaule <= 0.000001)
     {
        [MBProgressHUD showErrorWithStatus:@"输入正确充值金额" toView:self.view];
        return;
     }
    
    if (dVaule < _iEveryAomunt && _iEveryAomunt >0)
     {
      {
         [MBProgressHUD showErrorWithStatus:@"输入金额必须大于最低充值金额" toView:self.view];
         return;
      }
     }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rechargeType"] = @"s";
    
    params[@"amount"] = @(dVaule * 100);
  
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@xxcust/account/fund/recharge",[PDAPI getBaseUrlString]]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self wxPay:operation];
                                                                                      
                                                                                  }failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    [operation start];
    
}


-(void)wxPay:(DDGAFHTTPRequestOperation *)operation
{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    DDGWeChat *manager = [DDGWeChat getSharedWeChat];
    manager.block = ^{
        [self.navigationController popViewControllerAnimated:NO];
        //        [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@(2),@"index":@(0)}];
    };
    
    NSDictionary *payParams = [operation.jsonResult.attr objectForKey:@"payParams"];
    
    // 微信支付抢单
    WXPayModel *model = [[WXPayModel alloc] init];
    model.partnerId = payParams[@"mchId"];
    model.prepayid = payParams[@"prepayId"];
    model.timestamp = [NSString stringWithFormat:@"%@",payParams[@"timeStamp"]];
    model.sign = payParams[@"sign"];
    model.noncestr = payParams[@"nonceStr"];
    model.appid = payParams[@"appId"];
    model.partner_key = APPSecret_WC;
    
    [manager wxPayWith:model];
    
    
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
