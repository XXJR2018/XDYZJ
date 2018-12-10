//
//  VIPViewControllerCtl_2.m
//  XXJR
//
//  Created by xxjr03 on 16/10/27.
//  Copyright © 2016年 Cary. All rights reserved.
//

#import "VIPViewControllerCtl_2.h"
#import "KJPayViewController.h"
#import "MyBankViewController.h"
#import "CCWebViewController.h"
#import "LLPayVC.h"

@interface VIPViewControllerCtl_2 ()<UITextFieldDelegate>
{
    NSInteger _suitNum;   // 充值的金额
    int       _zsNum;     // 赠送的金额
    UIButton *_vipBtn;
    NSMutableArray *_vipBtnArr;
    UIView *_vipView;
    BOOL _haveCard;
    int  iSelPay; // 支付的类型  1 - 连连认证支付，2-连连快捷支付，  2-宝付支付
    
    UIView *background;
    NSDictionary *dicCZQ;  //充值券DIC
    long   couponId;       // 充值券的ID
}
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;  //余额
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *lianlianRZImg;
@property (weak, nonatomic) IBOutlet UIImageView *lianlianKJImg;
@property (weak, nonatomic) IBOutlet UIImageView *baofuImg;

@property (weak, nonatomic) IBOutlet UILabel *llrzLabel;  // 连连认证支付Label
@property (weak, nonatomic) IBOutlet UILabel *llkjLabel;  // 连连快捷支付Label

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneyLayoutHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payBtnLayoutHeight;
@end

@implementation VIPViewControllerCtl_2

-(void)loadData
{
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],@"busi/account/baofoo/bindcard/bankCard"]
                                                                               parameters:nil HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                  }];
    
    operation.tag = 1000;
    [operation start];
}


-(void) getCZQ
{
    couponId = 0;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"rechargeAmt"] = @(_suitNum);
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],@"xxcust/account/coupon/queryCanUseCoupon"]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      
                                                                                  }];
    
    operation.tag = 1001;
    [operation start];
}

-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    if (1000 == operation.tag)
     {
        if (operation.jsonResult.rows.count > 0)
         {
            _haveCard = YES;
         }
     }
    
    if (1001 == operation.tag)
     {
        if (operation.jsonResult.rows.count > 0)
         {
            //_haveCard = YES;
            dicCZQ = operation.jsonResult.rows[0];
            [self tapAction];
            
         }
        else
         {
            [self realPay];
         }
     }

}




-(void) realPay
{
    // 支付的类型  1 - 连连认证支付，2-连连快捷支付，  2-宝付支付
    if (1 == iSelPay)
     {
        LLPayVC *vc = [[LLPayVC alloc] init];
        vc.rechargeType =@"llrz";
        vc.moneyNum = [NSString stringWithFormat:@"%ld", (long)_suitNum];
        vc.couponId = couponId;
        [self.navigationController pushViewController:vc animated:YES];
     }
    if (2 == iSelPay)
     {
        LLPayVC *vc = [[LLPayVC alloc] init];
        vc.rechargeType =@"llkj";
        vc.moneyNum = [NSString stringWithFormat:@"%ld", (long)_suitNum];
        vc.couponId = couponId;
        [self.navigationController pushViewController:vc animated:YES];
     }
    
    if (3 == iSelPay )
     {
        if (_haveCard) {
            
            KJPayViewController *ctl = [[KJPayViewController alloc]init];
            ctl.moneyNum =  [NSString stringWithFormat:@"%ld", (long)_suitNum]; //@(_suitNum);
            ctl.usableAmount = self.usableAmount;
            ctl.rechargeType = @"r";
            ctl.couponId = couponId;
            [self.navigationController pushViewController:ctl animated:YES];
        }else{
            MyBankViewController *ctl = [[MyBankViewController alloc]init];
            [self.navigationController pushViewController:ctl animated:YES];
        }
     }

}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNaviBarViewWithTitle:@"VIP会员"];
    
    self.payBtnLayoutHeight.constant = 40 * ScaleSize;
    if(self.vipGrade == 1 && self.vipEndDate.length > 0) {
        self.timeLabel.text = [NSString stringWithFormat:@"%@到期",self.vipEndDate];
    }
    self.balanceLabel.text = [NSString stringWithFormat:@"%@元",self.usableAmount];
    
    _vipView = [[UIView alloc]initWithFrame:CGRectMake(0, 110, SCREEN_WIDTH, 30 + (65 + 10) * 1)];
    [self.view addSubview:_vipView];
    _vipView.backgroundColor = [UIColor whiteColor];
    if (self.vipDataArr.count > 0 && self.vipDataArr.count <= 9) {
        _vipView.frame = CGRectMake(0, 110, SCREEN_WIDTH, 30 + (60 + 10) * self.vipDataArr.count);
        
        if (IS_IPHONE_5_OR_LESS)
         {
            _vipView.frame = CGRectMake(0, 110, SCREEN_WIDTH, 30 + (40 + 10) * self.vipDataArr.count);
         }
    }
    self.moneyLayoutHeight.constant = CGRectGetMaxY(_vipView.frame) + 15 - 95;
    if (self.vipDataArr.count > 0) {
        [self vipUI];
    }
    
    iSelPay = 1; //支付的类型  1 - 连连认证支付，2-连连快捷支付，  2-宝付支付
    
    NSString *strTitle = @"连连认证支付";
    NSString *strSubTitle =@"  (支持借记卡)" ;
    NSString *strText = [strTitle stringByAppendingString:strSubTitle];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:strText];
    
    // 设置字体
    NSRange range = [strText rangeOfString:strSubTitle];//判断字符串是否包含
    [str addAttribute:NSFontAttributeName
                value:[UIFont systemFontOfSize:13]
                range:range];
    
    // 设置颜色
    [str addAttribute:NSForegroundColorAttributeName
                value:UIColorFromRGB(0x808080)
                range:range];
    
    _llrzLabel.attributedText = str;
    
    
    strTitle = @"连连快捷支付";
    strSubTitle =@"  (支持信用卡)" ;
    strText = [strTitle stringByAppendingString:strSubTitle];
    str = [[NSMutableAttributedString alloc] initWithString:strText];
    
    // 设置字体
    range = [strText rangeOfString:strSubTitle];//判断字符串是否包含
    [str addAttribute:NSFontAttributeName
                value:[UIFont systemFontOfSize:13]
                range:range];
    
    // 设置颜色
    [str addAttribute:NSForegroundColorAttributeName
                value:UIColorFromRGB(0x808080)
                range:range];
    
    _llkjLabel.attributedText = str;
}




-(void)vipUI{
    _vipBtnArr = [[NSMutableArray alloc]init];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 200, 20)];
    [_vipView addSubview:label];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = UIColorFromRGB(0x333333);
    label.text = @"VIP会员优惠套餐";
    
    for (int i = 0; i < self.vipDataArr.count; i++)
     {
        UIFont *font = [UIFont systemFontOfSize:13];
        NSDictionary *dic = self.vipDataArr[i];
        _vipBtn = [[UIButton alloc]initWithFrame:CGRectMake(12.5, 30 + (60 + 10) * i, SCREEN_WIDTH - 25, 60)];
        
        if (IS_IPHONE_5_OR_LESS)
         {
            _vipBtn = [[UIButton alloc]initWithFrame:CGRectMake(12.5, 30 + (40 + 10) * i, SCREEN_WIDTH - 25, 40)];
         }
        
        [_vipView addSubview:_vipBtn];
        _vipBtn.backgroundColor = [UIColor clearColor];
        _vipBtn.layer.borderColor = [ResourceManager color_5].CGColor;
        _vipBtn.layer.borderWidth = 1;
        [_vipBtnArr addObject:_vipBtn];
        _vipBtn.tag = i;
        [_vipBtn addTarget:self action:@selector(touch:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *label_1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, _vipBtn.frame.size.width*2/3, 20)];
        [_vipBtn addSubview:label_1];
        //label_1.textAlignment = NSTextAlignmentCenter;
        label_1.font = font;
        label_1.textColor = UIColorFromRGB(0x333333);
        if ([NSString stringWithFormat:@"%@",[dic objectForKey:@"recharge"]].length > 0) {
            label_1.text = [NSString stringWithFormat:@"充值%@送%@",[dic objectForKey:@"recharge"],[dic objectForKey:@"reward"]];
        }
        
        if (i >= self.vipDataArr.count -2)
         {
            
            NSString *content = label_1.text;
            CGSize size =[content sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
            
            UIButton  *img = [[UIButton alloc] initWithFrame:CGRectMake(10 + size.width + 5, 14, 32, 12)];
            [img setBackgroundImage:[UIImage imageNamed:@"tab4_tuijian"] forState:UIControlStateNormal];
            [img setTitle:@" 推荐" forState:UIControlStateNormal];
            if ( self.vipDataArr.count -1 == i)
             {
                [img setTitle:@" 超值" forState:UIControlStateNormal];
             }
            img.titleLabel.font = [UIFont systemFontOfSize: 10.0];
            [_vipBtn addSubview:img];
            
         }
        
        UILabel *label_2 = [[UILabel alloc]initWithFrame:CGRectMake(_vipBtn.frame.size.width*2/3, 10, _vipBtn.frame.size.width/3-12.5, 20)];
        [_vipBtn addSubview:label_2];
        label_2.textAlignment = NSTextAlignmentRight;
        label_2.font = font;
        label_2.textColor = UIColorFromRGB(0xc79548);
        if ([NSString stringWithFormat:@"%@",[dic objectForKey:@"reward"]].length > 0) {
            label_2.text = [NSString stringWithFormat:@"%@元",[dic objectForKey:@"recharge"]];
            
            if (IS_IPHONE_5_OR_LESS)
             {
                if ([NSString stringWithFormat:@"%@",[dic objectForKey:@"largessMonth"]].length > 0) {
                    label_2.text = [NSString stringWithFormat:@"送%@个月会员",[dic objectForKey:@"largessMonth"]];
                }
             }
        }
        
        if (!IS_IPHONE_5_OR_LESS)
         {
            UILabel *label_3 = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, _vipBtn.frame.size.width*2/3, 20)];
            [_vipBtn addSubview:label_3];
            //label_3.textAlignment = NSTextAlignmentCenter;
            label_3.font = font;
            label_3.textColor = UIColorFromRGB(0x666666);
            if ([NSString stringWithFormat:@"%@",[dic objectForKey:@"largessMonth"]].length > 0) {
                label_3.text = [NSString stringWithFormat:@"送%@个月会员",[dic objectForKey:@"largessMonth"]];
            }
         }

        
    }
    ((UIButton *)_vipBtnArr[0]).layer.borderColor = UIColorFromRGB(0xc69548).CGColor;
    ((UIButton *)_vipBtnArr[0]).backgroundColor = UIColorFromRGB(0xfdf6ea);;
    
    _suitNum = [[(NSDictionary *)self.vipDataArr[0] objectForKey:@"recharge"] intValue];
    _zsNum = [[(NSDictionary *)self.vipDataArr[0] objectForKey:@"reward"] intValue];
    
    
    for (int i = 0; i < self.vipDataArr.count; i++)
     {
        int iTemp =  [[(NSDictionary *)self.vipDataArr[i] objectForKey:@"recharge"] intValue];
        if (iTemp == _iMoney)
         {
            [self touch:(UIButton *)_vipBtnArr[i]];

         }
        
     }

    
}



//选择套餐
- (void)touch:(UIButton *)sender {
    
    ((UIButton *)_vipBtnArr[0]).layer.borderColor = [ResourceManager color_5].CGColor;
    ((UIButton *)_vipBtnArr[0]).backgroundColor = [UIColor clearColor];
    if (sender != _vipBtn) {
        _vipBtn.layer.borderColor = [ResourceManager color_5].CGColor;
        _vipBtn.backgroundColor = [UIColor clearColor];
        _vipBtn = sender;
    }
    _vipBtn.layer.borderColor = UIColorFromRGB(0xc69548).CGColor;
    _vipBtn.backgroundColor = UIColorFromRGB(0xfdf6ea);;
    
    _suitNum = [[(NSDictionary *)self.vipDataArr[sender.tag] objectForKey:@"recharge"] intValue];
    _zsNum = [[(NSDictionary *)self.vipDataArr[sender.tag] objectForKey:@"reward"] intValue];

}

//支付类型
- (IBAction)payType:(UIButton *)sender {
    if (sender.tag == 101) {
        //连连支付(认证支付)
        iSelPay = 1;
        self.lianlianRZImg.hidden = NO;
        self.lianlianKJImg.hidden = YES;
        self.baofuImg.hidden = YES;
        
    }else if (sender.tag == 102) {
        //连连支付(快捷支付)
        iSelPay = 2;
        self.lianlianRZImg.hidden = YES;
        self.lianlianKJImg.hidden = NO;
        self.baofuImg.hidden = YES;

    }else if (sender.tag == 103) {
        //宝付支付
        iSelPay = 3;
        self.lianlianRZImg.hidden = YES;
        self.lianlianKJImg.hidden = YES;
        self.baofuImg.hidden = NO;
        
    }
}

//立即充值
- (IBAction)pay:(id)sender {
    
    
    // 支付的类型  1 - 连连认证支付，2-连连快捷支付，  2-宝付支付
    if (1 == iSelPay)
     {
        
        [self getCZQ];

     }
    if (2 == iSelPay)
     {
        
        [self getCZQ];
        
     }
    
    if (3 == iSelPay )
     {
        if (_haveCard) {
            
            [self getCZQ];
            
        }else{
            MyBankViewController *ctl = [[MyBankViewController alloc]init];
            [self.navigationController pushViewController:ctl animated:YES];
        }
     }
    


    


}


- (void) tapAction{
    //创建一个黑色背景
    //初始化一个用来当做背景的View。我这里为了省时间计算，宽高直接用的5s的尺寸
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    background = bgView;
    bgView.backgroundColor =  [[UIColor blackColor]colorWithAlphaComponent:0.6];//[UIColor clearColor];
    [self.view addSubview:bgView];
    
    // 创建按钮的背景框
    UIView *viewKuang = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-330)/2, 85 +50, 300 + 30 , 230 ) ];
    viewKuang.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [bgView addSubview:viewKuang];
    
    // 关闭按钮
    UIButton * caseBackBtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-330)/2 + 300, 55 +50,46 * SCREEN_WIDTH/320, 46 * SCREEN_WIDTH/320)];
    [bgView addSubview:caseBackBtn];
    [caseBackBtn setImage:[UIImage imageNamed:@"privatism-45"] forState:UIControlStateNormal];
    caseBackBtn.userInteractionEnabled = YES;
    [caseBackBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    
    
    float fTopY = 25;
    float fLeftX = 0;
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(fLeftX, fTopY, 300+30, 15)];
    labelTitle.text = @"------  可使用券  ------";
    labelTitle.textAlignment = NSTextAlignmentCenter;
    labelTitle.font = [UIFont systemFontOfSize:14];
    labelTitle.textColor = [ResourceManager navgationTitleColor];
    [viewKuang addSubview:labelTitle];
    
    float CELL_HEIGHT = 100;
    float fCellWidth = 330-10;
    fLeftX = 5;
    fTopY += 30;
    UIView *viewCell = [[UIView alloc] initWithFrame:CGRectMake(5, fTopY, fCellWidth, CELL_HEIGHT - 20)];
    viewCell.backgroundColor = [UIColor whiteColor];
    [viewKuang addSubview:viewCell];
    
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CELL_HEIGHT - 20, CELL_HEIGHT - 20)];
    [img setImage:[UIImage imageNamed:@"card_unuse"]];
    [viewCell addSubview:img];
    
    
    UILabel *imglabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 12.5, CELL_HEIGHT - 20, 35)];
    imglabel1.font = [UIFont systemFontOfSize:18];
    imglabel1.textAlignment = NSTextAlignmentCenter;
    imglabel1.textColor = [UIColor whiteColor];
    
    NSDictionary *dic = dicCZQ;
    
    NSString *strMoney = [NSString stringWithFormat:@"%d", [dic[@"amount"] intValue]];
    NSString *strText = [NSString stringWithFormat:@"￥%@", strMoney];
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:strText];
    //获取要调字体的文字位置
    NSRange range1=[[hintString string]rangeOfString:strMoney];
    // 设置字体为粗体
    [hintString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial Rounded MT Bold" size:30.0] range:range1];
    
    imglabel1.attributedText=hintString;
    [img addSubview:imglabel1];
    
    
    UILabel *imglabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 15+ 35, CELL_HEIGHT - 20, 15)];
    imglabel2.font = [UIFont systemFontOfSize:11];
    imglabel2.textAlignment = NSTextAlignmentCenter;
    imglabel2.textColor = [UIColor whiteColor];
    imglabel2.text = dic[@"couponTypeText"];
    [img addSubview:imglabel2];
    
    
    fTopY = 10;
    fLeftX = CELL_HEIGHT - 20 + 10 ;
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(fLeftX,fTopY, fCellWidth - fLeftX, 20)];
    label1.font = [UIFont systemFontOfSize:15];
    label1.text =  dic[@"couponName"];
    label1.textColor = [ResourceManager navgationTitleColor];
    [viewCell addSubview:label1];
    
    
    fTopY += 20;
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(fLeftX,fTopY, fCellWidth - fLeftX, 20)];
    label2.font = [UIFont systemFontOfSize:11];
    NSString *strYXQ = [NSString stringWithFormat:@"有效期%@到%@", dic[@"startDate"], dic[@"endDate"]];
    label2.text =  strYXQ;
    label2.textColor = [ResourceManager lightGrayColor];
    [viewCell addSubview:label2];
    
    
    fTopY += 18;
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(fLeftX,fTopY, fCellWidth - fLeftX, 20)];
    label3.font = [UIFont systemFontOfSize:11];
    label3.textColor = [ResourceManager lightGrayColor];
    label3.text =  dic[@"remark"];
    [viewCell addSubview:label3];
    
    
    int iTotal = (int)_suitNum + _zsNum;
    iTotal += [dic[@"amount"] intValue];
    NSString *strTolMoney = [NSString stringWithFormat:@"%d元",iTotal];
    strText = [NSString stringWithFormat:@"用券充值后到账金额为%@", strTolMoney];
    hintString= [[NSMutableAttributedString alloc]initWithString:strText];
    //获取要调字体的文字位置
    range1=[[hintString string]rangeOfString:strTolMoney];
    // 设置字体颜色
    [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:range1];
    
    
    fTopY += 105;
    UILabel *labelTotal = [[UILabel alloc] initWithFrame:CGRectMake(10,fTopY, fCellWidth - fLeftX, 20)];
    labelTotal.font = [UIFont systemFontOfSize:14];
    labelTotal.textColor = [ResourceManager navgationTitleColor];
    labelTotal.attributedText=hintString;
    [viewKuang addSubview:labelTotal];

    fTopY += 40;
    UIButton  *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, fTopY, 330/2, 40)];
    btn1.layer.borderColor = [ResourceManager color_5].CGColor;
    btn1.layer.borderWidth = 1;
    btn1.backgroundColor = [UIColor whiteColor];
    [btn1 setTitle:@"直接充值" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [btn1 addTarget:self action:@selector(payNoCard) forControlEvents:UIControlEventTouchUpInside];
    [viewKuang addSubview:btn1];
    
    
    UIButton  *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(330/2, fTopY, 330/2, 40)];
    btn2.layer.borderColor = [ResourceManager color_5].CGColor;
    btn2.layer.borderWidth = 1;
    btn2.backgroundColor = [UIColor whiteColor];
    [btn2 setTitle:@"用券充值" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [btn2 addTarget:self action:@selector(payWithCard) forControlEvents:UIControlEventTouchUpInside];
    [viewKuang addSubview:btn2];





    

    
}


-(void)closeView
{
    [background removeFromSuperview];
}

- (void) payWithCard
{
    couponId = [dicCZQ[@"couponId"] longValue];
    [background removeFromSuperview];
    [self realPay];
}

-(void) payNoCard
{
    couponId = 0;
    [background removeFromSuperview];
    [self realPay];
}

//判断是否为整形：
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
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

//键盘落下事件
- (void)textFieldDidEndEditing:(UITextView *)textField{
    CGRect  rectTemp = self.view.frame;
    rectTemp.origin.y = 0;
    self.view.frame = rectTemp;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
