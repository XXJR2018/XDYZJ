//
//  LLPayVC.m
//  XXJR
//
//  Created by xxjr02 on 2017/10/19.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import "LLPayVC.h"
#import "LLTradingStautsVC.h"

#import <objc/runtime.h>
#import <AipOcrSdk/AipOcrSdk.h>
//#import "ApplyProveViewController.h"

@interface LLPayVC ()<AipOcrDelegate>
{
    UIView  *viewNoCard;    // 无卡时的view
    UIButton  *btnApply1;
    UITextField *textBankCardNO;  // 银行卡号
    UILabel *labelTitle3;         // 操作提示 或者 银行卡  或者错误提示
    BOOL  isAddBankForPay;        // 添加银行时的支付
    
    
    UIView  *viewHaveCard;  // 有卡时的view
    int     iBindBankCount;    // 绑定银行个数
    NSMutableArray* arryBank;         // 银行数组
    NSMutableArray* arryImg;          // 银行数组后面的勾选图片
    int     iSelBankNO;        // 选择银行的序号
    BOOL    isAddBank;         // 点击了“添加银行”
    UIButton  *btnApply2;
}
@end

@implementation LLPayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self layoutNaviBarViewWithTitle:@"连连支付"];
    
    [self layoutUI];
    
    [self getBindBankList];

}

- (void) layoutUI
{
    viewNoCard = [[UIView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight)];
    viewNoCard.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewNoCard];
    
    viewHaveCard = [[UIView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight)];
    viewHaveCard.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewHaveCard];

    
    //[self layoutNoCard];
    
    //[self layoutHaveCard];
    
}

#pragma mark ---- 无卡的UI布局
-(void) layoutNoCard
{
    
    //授权方法1：请在 http://ai.baidu.com中 新建App, 绑定BundleId后，在此处填写App的Api Key/Secret Key
    //[[AipOcrService shardService] authWithAK:@"u9ArxBmGxiGwPfKByIPSeNCE" andSK:@"liMOceDTAMrIXapsp5Csh9jiAB6Ozkrs"];
    //[[AipOcrService shardService] authWithAK:@"YQGCiGzcvhPrVx9EVHQGl0af" andSK:@"RTAGqy6vkifhkcCnIy4OND0EdyScZ1p5"];
    
    
    NSString *licenseFile = [[NSBundle mainBundle] pathForResource:@"aip" ofType:@"license"];
    NSData *licenseFileData = [NSData dataWithContentsOfFile:licenseFile];
    [[AipOcrService shardService] authWithLicenseFileData:licenseFileData];
    
    viewNoCard.hidden = NO;
    viewHaveCard.hidden = YES;
    float fTopY = 30;
    float fLeftX = 0;
    
    UILabel *labelTitle1 = [[UILabel alloc] initWithFrame:CGRectMake(fLeftX, fTopY, SCREEN_WIDTH, 25)];
    labelTitle1.textColor = [ResourceManager color_1];
    labelTitle1.text = @"充值金额";
    labelTitle1.font = [UIFont systemFontOfSize:16];
    labelTitle1.textAlignment = NSTextAlignmentCenter;
    [viewNoCard addSubview:labelTitle1];
    
    fTopY += labelTitle1.size.height + 5;
    UILabel *labelMoney = [[UILabel alloc] initWithFrame:CGRectMake(fLeftX, fTopY, SCREEN_WIDTH, 40)];
    //labelMoney.textColor = [ResourceManager color_1];
    labelMoney.text = labelMoney.text =  [NSString stringWithFormat:@"￥ %@", _moneyNum];//@"￥ 500";
    labelMoney.font = [UIFont systemFontOfSize:30];
    labelMoney.textAlignment = NSTextAlignmentCenter;
    [viewNoCard addSubview:labelMoney];
    
    fTopY += labelMoney.size.height + 20;
    fLeftX = 20;
    UILabel *labelTitle2 = [[UILabel alloc] initWithFrame:CGRectMake(fLeftX, fTopY, SCREEN_WIDTH-fLeftX, 15)];
    labelTitle2.textColor = [ResourceManager color_1];
    labelTitle2.text = @"添加支付方式";
    labelTitle2.font = [UIFont systemFontOfSize:14];
    [viewNoCard addSubview:labelTitle2];
    
    fTopY += labelTitle2.size.height + 15;
    UIView *viewTextBackground = [[UIView alloc] initWithFrame:CGRectMake(fLeftX, fTopY, SCREEN_WIDTH-2*fLeftX, 50)];
    viewTextBackground.layer.borderColor = UIColorFromRGB(0xE0E0E0).CGColor;//边框颜色
    viewTextBackground.layer.borderWidth = 2;//边框宽度
    viewTextBackground.cornerRadius = 3;
    viewTextBackground.backgroundColor = UIColorFromRGB(0xFAFAFA);
    [viewNoCard addSubview:viewTextBackground];
    
    textBankCardNO = [[UITextField alloc] initWithFrame:CGRectMake(fLeftX+10, fTopY, SCREEN_WIDTH-2*fLeftX-20-50, 50)];
    textBankCardNO.textColor = [ResourceManager color_1];
    textBankCardNO.text = @"";
    textBankCardNO.placeholder = @"请填写持卡人卡号";
    textBankCardNO.keyboardType = UIKeyboardTypeNumberPad;
    textBankCardNO.font = [UIFont systemFontOfSize:15];
    [textBankCardNO addTarget:self action:@selector(bankCardNOFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [viewNoCard addSubview:textBankCardNO];
    
    
    // 相机图片
    UIImageView *imgXiangji = [[UIImageView alloc] initWithFrame:CGRectMake(viewTextBackground.size.width-40, 15, 30, 20)];
    imgXiangji.image = [UIImage imageNamed:@"jy_xiangji"];
    [viewTextBackground addSubview:imgXiangji];
    
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xjClick)];
    [imgXiangji addGestureRecognizer:labelTapGestureRecognizer];
    imgXiangji.userInteractionEnabled = YES;
    
    fTopY += textBankCardNO.size.height + 15;
    labelTitle3 = [[UILabel alloc] initWithFrame:CGRectMake(fLeftX, fTopY, SCREEN_WIDTH-fLeftX, 15)];
    labelTitle3.textColor = [UIColor grayColor];
    labelTitle3.text = @"持卡人的信息必须和实名认证相符";
    labelTitle3.font = [UIFont systemFontOfSize:13];
    [viewNoCard addSubview:labelTitle3];
    
    
    fTopY +=  labelTitle3.size.height + 15;
    btnApply1 = [[UIButton alloc]initWithFrame:CGRectMake(15, fTopY, SCREEN_WIDTH-30, 50)];
    [btnApply1 setTitle:@"确认支付" forState:UIControlStateNormal];
    btnApply1.titleLabel.font=[UIFont systemFontOfSize:15];
    [btnApply1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnApply1.cornerRadius = 5;
    //btnApply1.backgroundColor = [UIColor orangeColor];
    btnApply1.backgroundColor = UIColorFromRGB(0xcccccc);
    btnApply1.userInteractionEnabled = NO;
    [btnApply1 addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
    [viewNoCard addSubview:btnApply1];
    
    
}

-(void) xjClick
{
    [self.view endEditing:YES];
    
    UIViewController * vc = [AipCaptureCardVC ViewControllerWithCardType:CardTypeBankCard andDelegate:self];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark --- 银行卡号改变监听函数
- (void)bankCardNOFieldDidChange:(UITextField *)field
{
    NSLog(@"field.text:%@", field.text);
    if (field.text.length >=12)
     {
        [self queryBankCard];
     }
    else
     {
        btnApply1.backgroundColor = UIColorFromRGB(0xcccccc);
        btnApply1.userInteractionEnabled = NO;
        labelTitle3.text = @"持卡人的信息必须和实名认证相符";
     }
}


#pragma mark ---- 有卡的UI布局
-(void) layoutHaveCard
{
    viewNoCard.hidden = YES;
    viewHaveCard.hidden = NO;
    iSelBankNO = 0;
    float fTopY = 30;
    float fLeftX = 0;
    
    if (viewHaveCard)
     {
        [viewHaveCard removeAllSubviews];
     }
    
    UILabel *labelTitle1 = [[UILabel alloc] initWithFrame:CGRectMake(fLeftX, fTopY, SCREEN_WIDTH, 25)];
    labelTitle1.textColor = [ResourceManager color_1];
    labelTitle1.text = @"充值金额";
    labelTitle1.font = [UIFont systemFontOfSize:16];
    labelTitle1.textAlignment = NSTextAlignmentCenter;
    [viewHaveCard addSubview:labelTitle1];
    
    fTopY += labelTitle1.size.height + 5;
    UILabel *labelMoney = [[UILabel alloc] initWithFrame:CGRectMake(fLeftX, fTopY, SCREEN_WIDTH, 40)];
    //labelMoney.textColor = [ResourceManager color_1];
    labelMoney.text =  [NSString stringWithFormat:@"￥ %@", _moneyNum]; //@"￥ 500";
    labelMoney.font = [UIFont systemFontOfSize:30];
    labelMoney.textAlignment = NSTextAlignmentCenter;
    [viewHaveCard addSubview:labelMoney];
    
    fTopY += labelMoney.size.height + 20;
    fLeftX = 20;
    UILabel *labelTitle2 = [[UILabel alloc] initWithFrame:CGRectMake(fLeftX, fTopY, SCREEN_WIDTH-fLeftX, 15)];
    labelTitle2.textColor = [UIColor grayColor];
    labelTitle2.text = @"选择支付方式（长按删除银行卡）";
    labelTitle2.font = [UIFont systemFontOfSize:14];
    [viewHaveCard addSubview:labelTitle2];
    
    
    // add by baicai  test   begin
    //NSMutableDictionary *dicTemp = [[NSMutableDictionary alloc] init];
    //dicTemp[@"bank_code"] = @"01050000";
    //dicTemp[@"bank_name"] = @"中国建设银行";
    //dicTemp[@"card_no"] = @"6125";
    //[arryBank addObject:dicTemp];
    // add end
    
    iBindBankCount = (int)[arryBank count];
    [arryImg removeAllObjects];
    for (int i = 0; i < iBindBankCount; i ++)
     {
        if (0 == i)
         {
            fTopY += 25;
         }
        else
         {
            fTopY += 52;
         }
        
        NSDictionary *dic = arryBank[i];
        
        
        UILabel *labelfg1 = [[UILabel alloc] initWithFrame:CGRectMake(fLeftX, fTopY, SCREEN_WIDTH- 2*fLeftX, 1)];
        labelfg1.backgroundColor = UIColorFromRGB(0xf5f5f5); //设置背景为灰色;
        [viewHaveCard addSubview:labelfg1];
        
        UIView *viewTemp = [[UIView alloc] initWithFrame:CGRectMake(fLeftX, fTopY+1, SCREEN_WIDTH- 2*fLeftX, 50)];
        //viewTemp.backgroundColor = [UIColor yellowColor];
        viewTemp.tag = i;
        [viewHaveCard addSubview:viewTemp];
        
        
        // 点击手势
        UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgClick:)];
        [viewTemp addGestureRecognizer:labelTapGestureRecognizer];
        viewTemp.userInteractionEnabled = YES;
        
        // 长按手势
        UILongPressGestureRecognizer *longPressReger1 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
        longPressReger1.minimumPressDuration = 0.5;
        
        [viewTemp addGestureRecognizer:longPressReger1];
        
        
        UILabel *labelBank = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-2*fLeftX -20 -50, 50)];
        labelBank.textColor = [ResourceManager color_1];
        NSString *strText = [NSString stringWithFormat:@"%@ 尾号%@", dic[@"bank_name"], dic[@"card_no"]];
        labelBank.text = strText;
        labelBank.font = [UIFont systemFontOfSize:15];
        [viewTemp addSubview:labelBank];
        
        UIImageView *imgTemp = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-2*fLeftX -20 -10, 15, 20, 20)];
        imgTemp.image = [UIImage imageNamed:@"VIP-17"];
        [viewTemp addSubview:imgTemp];
        [arryImg addObject:imgTemp];
        
        
        UILabel *labelfg2 = [[UILabel alloc] initWithFrame:CGRectMake(fLeftX, fTopY + 51, SCREEN_WIDTH- 2*fLeftX, 1)];
        labelfg2.backgroundColor = UIColorFromRGB(0xf5f5f5); //设置背景为灰色;
        [viewHaveCard addSubview:labelfg2];
     }
    
    iSelBankNO = 0;
    [self selBank];
    
    // 添加银行卡
    fTopY += 52;
    UILabel *labelAdd = [[UILabel alloc] initWithFrame:CGRectMake(fLeftX, fTopY, SCREEN_WIDTH-2*fLeftX, 50)];
    labelAdd.textColor = [ResourceManager mainColor];
    labelAdd.text = @"+  添加银行卡";
    labelAdd.textAlignment = NSTextAlignmentCenter;
    labelAdd.font = [UIFont systemFontOfSize:15];
    [viewHaveCard addSubview:labelAdd];
    
    UITapGestureRecognizer *addTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addClick)];
    [labelAdd addGestureRecognizer:addTapGestureRecognizer];
    labelAdd.userInteractionEnabled = YES;
    
    
    fTopY +=  labelAdd.size.height + 15;
    btnApply2 = [[UIButton alloc]initWithFrame:CGRectMake(15, fTopY, SCREEN_WIDTH-30, 50)];
    [btnApply2 setTitle:@"确认支付" forState:UIControlStateNormal];
    btnApply2.titleLabel.font=[UIFont systemFontOfSize:15];
    [btnApply2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnApply2.cornerRadius = 5;
    btnApply2.backgroundColor = [ResourceManager mainColor];
    [btnApply2 addTarget:self action:@selector(secondPayAction) forControlEvents:UIControlEventTouchUpInside];
    [viewHaveCard addSubview:btnApply2];

    
    
}

-(void) secondPayAction
{
    isAddBankForPay = FALSE;
    [self getPayInfo];
}

-(void)clickNavButton:(UIButton *)button
{
    if (isAddBank)
     {
        isAddBank = FALSE;
        [self layoutHaveCard];
        return;
     }
    [self.navigationController popViewControllerAnimated:YES];
}


-(void) addClick
{
    isAddBank = TRUE;
    [self layoutNoCard];
    
}

-(void) longPressed:(UILongPressGestureRecognizer*) sender
{
    UILongPressGestureRecognizer *tap = (UILongPressGestureRecognizer*)sender;
    UIView *views = (UIView*) tap.view;
    int tag = (int)views.tag;
    
    if (tag <= [arryBank count])
     {
        // 防止长按手势触发两次
        if(tap.state == UIGestureRecognizerStateBegan)
         {
            NSLog(@"longPressed  view.tag:%d", tag);
            NSDictionary *dicBand = arryBank[tag];
            NSString *strDel = [NSString stringWithFormat:@"是否删除%@的银行卡？", dicBand[@"bank_name"]];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                           message:strDel
                                              preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确认"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action){
                                                        [self delBank:tag];
                                                    }]];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                      style:UIAlertActionStyleCancel
                                                    handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
            
         }
     }
    
}

-(void) delBank:(int) iBankNO
{
    
     NSDictionary *dicBand = arryBank[iBankNO];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],@"mjb/account/lianlian/pay/unbindBankCard"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"lianType"] = _rechargeType;
    params[@"noAgree"] = dicBand[@"no_agree"];
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:url
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                      
                                                                                      
                                                                                  }];
    
    
    operation.tag = 10213;
    [operation start];
    
}

-(void) imgClick:(UITapGestureRecognizer*) sender
{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UIView *views = (UIView*) tap.view;
    int tag = (int)views.tag;
    
    NSLog(@"view.tag:%d", tag);
    iSelBankNO = tag;
    [self selBank];
}

-(void) selBank
{
    int iImgCount = (int)[arryImg count];
    for (int i = 0; i < iImgCount; i++)
     {
        UIImageView *imgView = arryImg[i];
        if (iSelBankNO == i)
         {
            [imgView setImage:[UIImage imageNamed:@"VIP-17"]];
         }
        else
         {
            [imgView setImage:[UIImage imageNamed:@"gou1"]];
         }
     }
}

-(void) payAction
{
    isAddBankForPay = TRUE;
    [self getPayInfo];
}

-(void) realPay:(NSDictionary*) info
{
    [LLPaySdk sharedSdk].sdkDelegate = self;
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    //接入什么产品就传什么LLPayType
    //LLPayTypeQuick,     // 快捷
    //LLPayTypeVerify,    // 认证
    LLPayType type = LLPayTypeQuick;
    if ([_rechargeType isEqualToString:@"llrz"])
     {
        type = LLPayTypeVerify;
     }
    if ([_rechargeType isEqualToString:@"ddllrz"])
     {
        type = LLPayTypeVerify;
     }
    [[LLPaySdk sharedSdk] presentLLPaySDKInViewController:self
                                              withPayType:type
                                            andTraderInfo:info];
}

#pragma mark 网络请求函数
// 查询卡的真实信息
-(void) queryBankCard
{
    btnApply1.backgroundColor = UIColorFromRGB(0xcccccc);
    btnApply1.userInteractionEnabled = NO;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],@"mjb/account/lianlian/pay/queryAppCardBin"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"lianType"] = _rechargeType;
    params[@"cardNo"] = textBankCardNO.text;
    
    
    
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:url
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                            
//                                                                                      labelTitle3.text = operation.jsonResult.message;
                                                                                      
                                                                                  }];
    
    
    operation.tag = 10210;
    [operation start];

}


// 获取绑定银行卡列表
-(void) getBindBankList
{
    arryBank = nil;
    arryImg = [[NSMutableArray alloc] init];
    iBindBankCount = 0;
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],@"mjb/account/lianlian/pay/queryBindCard"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"lianType"] = _rechargeType;
    
    
    
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:url
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      
                                                          [self layoutNoCard];
                                                                                      
                                                         }];
    
    
    operation.tag = 10211;
    [operation start];

}



// 得到交易报文
-(void) getPayInfo
{

    
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],@"mjb/account/lianlian/pay/appPay"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"lianType"] = _rechargeType;
    // 添加银行卡时的支付
    if (isAddBankForPay)
     {
        params[@"cardNo"] = textBankCardNO.text;
     }
    else
     {
        NSDictionary *dicBank = arryBank[iSelBankNO];
        NSString *strNoAgree = dicBank[@"no_agree"];
        params[@"bindAgree"] = strNoAgree;
        params[@"bankCardNo"] = dicBank[@"card_no"];
     }
    params[@"amount"] = _moneyNum;
    
    
    // 如果有充值券
    if (_couponId !=0)
     {
        params[@"couponId"] = @(_couponId);
     }

    
    
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:url
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      
                                                                                      NSDictionary *dicAttr = operation.jsonResult.attr;
                                                              if ([dicAttr count] > 0)
                                                               {
                                                                  NSLog(@"dicAttr:%@",dicAttr);
                                                                  int errCode = [dicAttr[@"errCode"] intValue];
                                                                  if (errCode == 1010)
                                                                   {
                                                                      
                                                                      UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请先实名认证" preferredStyle:UIAlertControllerStyleAlert];
                                                                                                                                                                                                                  
                                                                      [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                                          
                                                                          // 切换到认证页面
                                                                          [self.navigationController popToRootViewControllerAnimated:NO];
                                                                          [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@(3),@"index":@(1)}];
                                                                          NSLog(@"点击确认");
                                                                          
                                                                      }]];
                                                                      
                                                                      [self presentViewController:alertController animated:YES completion:nil];
                                                                      
                                                                      return;
                                                                   }
                                                               }
                                                                  
                                                               [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                      
                                                                
                                                                                      
                                                                                  }];
    
    
    operation.tag = 10212;
    [operation start];
    
}

//请求成功 ，做数据处理
-(void)handleData:(DDGAFHTTPRequestOperation *)operation
{
    // 查询卡信息接口
    if (10210 == operation.tag)
     {
        NSDictionary *dicAttr = operation.jsonResult.attr;
        if ([dicAttr count] > 0)
         {
            NSDictionary *dicResult = dicAttr[@"resultMap"];
            if ([dicResult count]>0)
             {
                NSString *strBankName = dicResult[@"bank_name"];
                if (strBankName.length > 0)
                 {
                    labelTitle3.text = strBankName;
                    btnApply1.backgroundColor = [UIColor orangeColor];
                    btnApply1.userInteractionEnabled = YES;
                    
                 }
             }
         }
     }
    
    // 查询已经绑定卡列表
    if (10211 == operation.tag)
     {
        NSDictionary *dicAttr = operation.jsonResult.attr;
        if ([dicAttr count] > 0)
         {
            NSValue *value = dicAttr[@"result"];
            if ([value isKindOfClass:NSArray.class])
             {
                arryBank = dicAttr[@"result"];
                iBindBankCount = (int)[arryBank count];
                if (iBindBankCount > 0)
                 {
                    [self layoutHaveCard];
                 }
                else
                 {
                    [self layoutNoCard];
                 }
                return;
             }

         }
        [self layoutNoCard];
        //[MBProgressHUD showErrorWithStatus:@"接口查询失败" toView:self.view];
     }
    
    // 得到交易报文
    if (10212 == operation.tag)
     {
        NSDictionary *dicAttr = operation.jsonResult.attr;
        if (dicAttr)
         {
            NSLog(@"dicAttr:%@",dicAttr);
            
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params addEntriesFromDictionary:dicAttr[@"signedOrder"]];
            [self realPay:params];
         }
        
     }
    
    // 删除卡成功
    if (10213 == operation.tag)
     {
        //[self.navigationController popToRootViewControllerAnimated:NO];
        [self getBindBankList];
     }
    

}




#pragma - mark 支付结果 LLPaySdkDelegate
// 订单支付结果返回，主要是异常和成功的不同状态
- (void)paymentEnd:(LLPayResult)resultCode withResultDic:(NSDictionary *)dic {
    NSString *msg = @"异常";
    switch (resultCode) {
        case kLLPayResultSuccess: {
            msg = @"成功";
            
            LLTradingStautsVC *vc = [[LLTradingStautsVC alloc] init];
            vc.strStatus = @"0000";
            vc.strError = @"交易成功";
            vc.strAddMoney = _strAddMoney;
            [self.navigationController pushViewController:vc animated:YES];
            return;
            
        } break;
        case kLLPayResultFail: {
            msg = @"失败";
            LLTradingStautsVC *vc = [[LLTradingStautsVC alloc] init];
            vc.strStatus = @"123123123131";
            vc.strError = dic[@"ret_msg"];
            [self.navigationController pushViewController:vc animated:YES];
            return;
        } break;
        case kLLPayResultCancel: {
            msg = @"取消";
            return;
        } break;
        case kLLPayResultInitError: {
            msg = @"支付sdk初始化异常";
        } break;
        case kLLPayResultInitParamError: {
            msg = dic[@"ret_msg"];
        } break;
        default:
            break;
    }
    //NSString *showMsg = [msg stringByAppendingString:[self jsonStringOfObj:dic]];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:dic[@"ret_msg"]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确认"
                                              style:UIAlertActionStyleDefault
                                            handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
    
    
    return;
}



- (NSString*)jsonStringOfObj:(NSDictionary*)dic{
    NSError *err = nil;
    
    NSData *stringData = [NSJSONSerialization dataWithJSONObject:dic
                                                         options:0
                                                           error:&err];
    
    NSString *str = [[NSString alloc] initWithData:stringData encoding:NSUTF8StringEncoding];
    
    return str;
}

#pragma mark AipOcrResultDelegate

- (void)ocrOnIdCardSuccessful:(id)result {
    NSLog(@"%@", result);
    NSString *title = nil;
    NSMutableString *message = [NSMutableString string];
    
    if(((NSDictionary *)result)[@"words_result"]){
        [((NSDictionary *)result)[@"words_result"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [message appendFormat:@"%@: %@\n", key, ((NSDictionary *)obj)[@"words"]];
            
        }];
    }
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSDictionary *dic = ((NSDictionary *)result)[@"words_result"];
        NSDictionary *dic_Name =[dic objectForKey:@"姓名"];
        NSDictionary *dic_CardNum = [dic objectForKey:@"公民身份号码"];
        if ([NSString stringWithFormat:@"%@",  [dic_Name objectForKey:@"words"]].length > 0) {
            //self.nameField.text = [NSString stringWithFormat:@"%@",   [dic_Name objectForKey:@"words"]];
        }
        if ([NSString stringWithFormat:@"%@",   [dic_CardNum objectForKey:@"words"]].length > 0) {
            //self.cardNumField.text = [NSString stringWithFormat:@"%@",  [dic_CardNum objectForKey:@"words"]];
        }
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }];
}

- (void)ocrOnBankCardSuccessful:(id)result {
    NSLog(@"%@", result);
    NSString *title = nil;
    NSMutableString *message = [NSMutableString string];
    NSDictionary *dic = ((NSDictionary *)result)[@"result"];
    title = @"银行卡信息";
    //    [message appendFormat:@"%@", result[@"result"]];
    [message appendFormat:@"卡号：%@\n", dic[@"bank_card_number"]];
    [message appendFormat:@"类型：%@\n", dic[@"bank_card_type"]];
    [message appendFormat:@"发卡行：%@\n", dic[@"bank_name"]];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if ([NSString stringWithFormat:@"%@", dic[@"bank_card_number"]].length > 10) {
            NSString* strBankNO = [NSString stringWithFormat:@"%@", dic[@"bank_card_number"]];
            strBankNO = [strBankNO stringByReplacingOccurrencesOfString:@" " withString:@""];
            textBankCardNO.text = strBankNO;
            [self queryBankCard];
        }
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }];
}

- (void)ocrOnFail:(NSError *)error {
    NSLog(@"%@", error);
//    NSString *msg = [NSString stringWithFormat:@"%li:%@", (long)[error code], [error localizedDescription]];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[[UIAlertView alloc] initWithTitle:@"识别失败" message:@"请重新识别或者手动输入信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }];
}


#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // 退到父视图
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
