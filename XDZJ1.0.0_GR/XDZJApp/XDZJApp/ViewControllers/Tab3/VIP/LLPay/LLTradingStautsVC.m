//
//  LLTradingStautsVC.m
//  XXJR
//
//  Created by xxjr02 on 2017/10/19.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import "LLTradingStautsVC.h"
#import "NewVipViewControllerCtl_2.h"
#import "PayRecordVC.h"

#import "QuestionVC.h"

@interface LLTradingStautsVC ()


@end

@implementation LLTradingStautsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.hideBackButton = YES;
    CustomNavigationBarView *nav = [self layoutNaviBarViewWithTitle:@"交易状态"];
    
    float fRightBtnTopY =  NavHeight - 40;
    if (IS_IPHONE_X_MORE)
     {
        fRightBtnTopY = NavHeight - 42;
        
     }
    
    UIButton *rightNavBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80.f,fRightBtnTopY,80.f, 35.0f)];
    [rightNavBtn setTitle:@"充值记录" forState:UIControlStateNormal];
    [rightNavBtn setTitleColor:[ResourceManager navgationTitleColor] forState:UIControlStateNormal];
    [rightNavBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [rightNavBtn addTarget:self action:@selector(actionRecord) forControlEvents:UIControlEventTouchUpInside];
    rightNavBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [nav addSubview:rightNavBtn];
    
    barStyle = UIStatusBarStyleDefault;
    [[UIApplication sharedApplication] setStatusBarStyle:barStyle];
    
    
    [self layoutUI];
    
}


-(void) actionRecord
{
    PayRecordVC  *vc = [[PayRecordVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) layoutUI
{
    
    _iStatus = 3;

    
    //"0000" to "交易成功",
    //"BF00100" to "系统异常，请联系宝付",
    //"BF00112" to "系统繁忙，请稍后再试",
    //"BF00113" to "交易结果未知，请稍后查询",
    //"BF00144" to "该交易有风险,订单处理中",
    //"BF00115" to "交易处理中，请稍后查询",
    //"BF00202" to "交易超时，请稍后查询")
    //@property (nonatomic, strong) NSString  *strStatus; // 状态码
    
    //@property (nonatomic, assign) int  iStatus; // 1 - 交易成功，  2 - 交易中，  3 - 交易失败
    if ([_strStatus isEqualToString:@"0000"])
     {
        _iStatus = 1;
     }

    
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *viewBack = [[UIView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT-NavHeight)];
    viewBack.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewBack];
    
    float fTopY = NavHeight;
    float fLeftX = 0;
    // 分割线
    UIView *viewFG =[[UIView alloc] initWithFrame:CGRectMake(fLeftX, fTopY, SCREEN_WIDTH,0.5)];
    viewFG.backgroundColor = [ResourceManager color_5];
    [self.view addSubview:viewFG];
    
    // 交易状态的图片
    fTopY = 50;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-60, fTopY, 120, 120)];
    [imgView setImage:[UIImage imageNamed:@"jy_failed"]];
    [viewBack addSubview:imgView];
    
    // 交易状态的文字
    fTopY += 120 + 15;
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(fLeftX, fTopY, SCREEN_WIDTH, 20)];
    labelTitle.textColor = [UIColor blackColor];
    labelTitle.font = [UIFont systemFontOfSize:15];
    labelTitle.text = @"交易失败";
    labelTitle.textAlignment = NSTextAlignmentCenter;
    [viewBack addSubview:labelTitle];
    
    // 失败或者交易中提醒
    fTopY += 30;
    UILabel *labelError = [[UILabel alloc] initWithFrame:CGRectMake(0, fTopY, SCREEN_WIDTH, 20)];
    labelError.textColor = [UIColor grayColor];
    labelError.font = [UIFont systemFontOfSize:14];
    labelError.text = @"";
    labelError.textAlignment = NSTextAlignmentCenter;
    [viewBack addSubview:labelError];
    
    
    // 交易成功时，所送的奖励的提示
    if (1 == _iStatus)
     {
        fTopY += 10;
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, fTopY, SCREEN_WIDTH, 20)];
        [viewBack addSubview:btn];
        NSString *strTitle = [NSString stringWithFormat:@"  %@",_strAddMoney];
        [btn setTitle:strTitle forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setImage:[UIImage imageNamed:@"tab4_money_jl"] forState:UIControlStateNormal];
        
        
//        fTopY +=  50;
//        UIButton  *btnYQHY = [[UIButton alloc]initWithFrame:CGRectMake(15, fTopY, SCREEN_WIDTH-30, 40)];
//        [btnYQHY setTitle:@"邀请好友领券" forState:UIControlStateNormal];
//        btnYQHY.titleLabel.font=[UIFont systemFontOfSize:15];
//        [btnYQHY setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        btnYQHY.cornerRadius = 5;
//        btnYQHY.backgroundColor = [UIColor orangeColor];
//        [btnYQHY addTarget:self action:@selector(actionYQHY) forControlEvents:UIControlEventTouchUpInside];
//        [viewBack addSubview:btnYQHY];
     }
    
    
    fTopY +=  50;
    UIButton  *btnApply = [[UIButton alloc]initWithFrame:CGRectMake(15, fTopY, SCREEN_WIDTH-30, 40)];
    [btnApply setTitle:@"重新支付" forState:UIControlStateNormal];
    btnApply.titleLabel.font=[UIFont systemFontOfSize:15];
    [btnApply setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnApply.cornerRadius = 5;
    btnApply.backgroundColor = [UIColor orangeColor];
    [btnApply addTarget:self action:@selector(payAfterRefrsh) forControlEvents:UIControlEventTouchUpInside];
    [viewBack addSubview:btnApply];
    
    fTopY +=  50;
    UIButton  *btnRet = [[UIButton alloc]initWithFrame:CGRectMake(15, fTopY, SCREEN_WIDTH-30, 40)];
    [btnRet setTitle:@"返回" forState:UIControlStateNormal];
    btnRet.titleLabel.font=[UIFont systemFontOfSize:15];
    [btnRet setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    btnRet.cornerRadius = 5;
    btnRet.backgroundColor = [UIColor clearColor];
    [btnRet addTarget:self action:@selector(retAction) forControlEvents:UIControlEventTouchUpInside];
    btnRet.layer.borderColor = [UIColor orangeColor].CGColor;//边框颜色
    btnRet.layer.borderWidth = 1;//边框宽度
    [viewBack addSubview:btnRet];
    
    //int  iStatus; // 1 - 交易成功，  2 - 交易中，  3 - 交易失败
    if (1 == _iStatus)
     {
        [imgView setImage:[UIImage imageNamed:@"jy_sucess"]];
        labelTitle.text = @"交易成功";
        labelError.text = @"";
        [btnApply setTitle:@"去抢单" forState:UIControlStateNormal];
        btnApply.backgroundColor = UIColorFromRGB(0x40c484);
        [btnRet setTitleColor:UIColorFromRGB(0x40c484) forState:UIControlStateNormal];
        btnRet.layer.borderColor = UIColorFromRGB(0x40c484).CGColor;//边框颜色
     }

    if (3 == _iStatus)
     {
        [imgView setImage:[UIImage imageNamed:@"jy_failed"]];
        labelTitle.text = @"交易失败";
        labelError.text = _strError;
        [btnApply setTitle:@"继续支付" forState:UIControlStateNormal];
     }
    
    
}


-(void) actionYQHY
{
    NSString *url = [NSString stringWithFormat:@"%@mjb/invit/app.html?signId=%@",[PDAPI WXSysRouteAPI],[DDGSetting sharedSettings].signId];
    QuestionVC *webContro = [QuestionVC new];
    webContro.homeUrl = [NSURL URLWithString:url];
    webContro.titleStr = @"邀请有奖";
    [self.navigationController pushViewController:webContro animated:YES];
}

-(void) payAfterRefrsh
{
    
    // 交易成功
    if (1 == _iStatus)
     {
        //快速抢单
        [self.navigationController popToRootViewControllerAnimated:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@(1),@"index":@(0)}];
        return;
     }
    
    // 交易失败
    if (3 == _iStatus)
     {
        // 进入此页面前，先要刷新用户的余额
        [self InfoURL];
    
        return;
     }
    
    
    return;
    
}

-(void) realPay
{
    NSDictionary *dic = [DDGAccountManager sharedManager].userInfo;

    
    NewVipViewControllerCtl_2 *ctl = [[NewVipViewControllerCtl_2 alloc]init];
    ctl.usableAmount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"usableAmount"]];
    ctl.vipGrade = [[dic objectForKey:@"vipGrade"] integerValue];;
    ctl.vipEndDate = [NSString stringWithFormat:@"%@",[dic objectForKey:@"vipEndDate"]];
    [self.navigationController pushViewController:ctl animated:YES];
    
    [self.navigationController pushViewController:ctl animated:YES];
}



-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    NSDictionary *dic = operation.jsonResult.attr;
    
    _strStatus = [dic objectForKey:@"resp_code"];
    _strError = operation.jsonResult.message;
    // 处理
    [self layoutUI];
}



-(void) retAction
{
    // 交易失败
    [self.navigationController popToRootViewControllerAnimated:YES];
}


//获取用户信息
-(void)InfoURL
{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[PDAPI getUserBaseInfoAPI]
                                                                               parameters:@{kUUID:[DDGSetting sharedSettings].UUID_MD5} HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleInofData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    [operation start];
}


-(void)handleInofData:(DDGAFHTTPRequestOperation *)operation
{
    // 处理
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    
    NSArray *rows=operation.jsonResult.rows;
    if (rows.count > 0) {
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithDictionary:rows[0]];
        
        //避免NULL字段
        for (NSString *key in dic.allKeys) {
            if ([[dic objectForKey:key] isEqual:[NSNull null]]) {
                [dic setValue:@"" forKey:key];
            }
        }
        
        
        [[DDGAccountManager sharedManager] setUserInfo:dic];
        
        [self realPay];
        
    }
}

@end
