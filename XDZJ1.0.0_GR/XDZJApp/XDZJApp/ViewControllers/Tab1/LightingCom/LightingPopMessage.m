//
//  LightingPopMessage.m
//  XXJR
//
//  Created by xxjr02 on 2018/2/7.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import "LightingPopMessage.h"
#import "SelectDZQController.h"
#import "CCWebViewController.h"
#import "VIPViewController.h"
#import "LightingSucces.h"
#import "SKAutoScrollLabel.h"
#import "NewVipViewControllerCtl_2.h"



#define UIColorFromRGB11(rgbValue) \
[UIColor colorWithRed:((rgbValue >> 16) & 0xFF)/255.f \
green:((rgbValue >> 8) & 0xFF)/255.f \
blue:(rgbValue & 0xFF)/255.f \
alpha:1.0f]

static const CGFloat alertviewWidth = 300.0;
static const CGFloat alertviewHeight = 420.0;
static const CGFloat titleHeight = 60.0;

static const CGFloat buttonHeight = 38;




@interface LightingPopMessage()
{
    float fOrderMoney; // 订单的金额
    BOOL  isSelQuan;  // 是否用券了
    NSString *ticketId;  //优惠券的ID
    int  iDZ;       //打几折
    int  iJMMoney;     // 不打折情况下，用券最多减去多少金额
    int  iDZMaxMoney;  // 打折的最多优惠金额
    float  fRealMoney;    // 真正的购买金额
    NSString *strTicketName; // 抢单券的名字
    
    UILabel * titleLabel;
    RCLabel *pointDZLable;
    UIButton * okButton;
    UIButton * cancelButton;
    
    UIButton *btnChange;
    SKAutoScrollLabel *paoma;
    NSString *msg;   // 显示给客户的提示语
}

@property (strong,nonatomic)UIDynamicAnimator * animator;
@property (strong,nonatomic)UIView * alertview;
@property (strong,nonatomic)UIView * backgroundview;
@property (strong,nonatomic)NSString * title;
@property (strong,nonatomic)NSString * message;


@property (strong,nonatomic)NSString * cancelButtonTitle;
@property (strong,nonatomic)NSString * okButtonTitle;

@property (strong,nonatomic)UILabel *label1_text;



@end


@implementation LightingPopMessage

#pragma mark - Gesture
-(void)click:(UITapGestureRecognizer *)sender{
    // 屏蔽掉点击任何区域，消失
    //    CGPoint tapLocation = [sender locationInView:self.backgroundview];
    //    CGRect alertFrame = self.alertview.frame;
    //    if (!CGRectContainsPoint(alertFrame, tapLocation)) {
    //        [self dismiss];
    //    }
}

#pragma mark -  private function
-(UIButton *)createButtonWithFrame:(CGRect)frame Title:(NSString *)title
{
    UIButton * button = [[UIButton alloc] initWithFrame:frame];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.layer.cornerRadius = 2;
    button.backgroundColor = [ResourceManager mainColor];
    //button.layer.borderWidth = 0.5;
    //button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [button addTarget:self action:@selector(clickOKButton:) forControlEvents:UIControlEventTouchUpInside];
    [button setShowsTouchWhenHighlighted:YES];
    return button;
}

// 创建灰色按钮
-(UIButton *)createButtonWithFrame2:(CGRect)frame Title:(NSString *)title
{
    UIButton * button = [[UIButton alloc] initWithFrame:frame];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.layer.cornerRadius = 2;
    button.backgroundColor = UIColorFromRGB11(0xd3cdca);
    //button.layer.borderWidth = 0.5;
    //button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [button setShowsTouchWhenHighlighted:YES];
    return button;
}

#pragma mark ---- 确定按钮
-(void)clickOKButton:(UIButton *)button{
    

    
    if (_fUsableAmount < fRealMoney)
     {
        [self dismiss];
        [self actionCZ];
        return;
     }
    
    // 调用后台接口，抢单
    [self qdTOWeb];
}


-(void)clickButton:(UIButton *)button
{
    [self dismiss];
//    if ([self.delegate respondsToSelector:@selector(didClickButtonAtIndex:)]) {
//        [self.delegate didClickButtonAtIndex:(2)];
//    }
}



#pragma  mark ---  抢单函数
-(void) qdTOWeb
{
    
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    NSString *url = kDDGrobByAmount;
    
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (1 == _flag)
     {
        params[@"ticketId"] = ticketId;
     }
    params[@"borrowId"] =  _dicData[@"borrowId"];
    // 特价抢单时
    if (7 == _iRobWay)
     {
            params[@"robWay"] = @(_iRobWay);
     }
    
    // 如果是推广客户单
    if(_isTGKH)
     {
        params[@"receiveId"] = _receiveId;
        params[@"robPrice"] = @(fOrderMoney);
        url = kDDGrobBorrowPay;
     }
    
    // 如果是优质客户
    if(_isYZKH)
     {
        url = kDDGseniorcustRobByAmount;
     }
    

    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@%@",[PDAPI getBusiUrlString],url]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                      
                                                                                  }failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self];
                                                                                  }];
    [operation start];
    operation.tag = 10212;
}

-(void)handleData:(DDGAFHTTPRequestOperation *)operation
{
    [MBProgressHUD hideAllHUDsForView:self animated:NO];
    
    if (operation.tag == 10212){
        
        
        [self dismiss];
        
        
        if  (_isTGKH)
         {
            // 发送推广订单抢单成功的通知
            [[NSNotificationCenter defaultCenter] postNotificationName:TGGrabSuccessNotification object:nil];
            return;
         }
        else
         {
            // 发送抢单成功的通知
            [[NSNotificationCenter defaultCenter] postNotificationName:GrabSuccessNotification object:nil];
         }
        
        LightingSucces *vc = [[LightingSucces alloc] init];
        vc.businessId = _dicData[@"borrowId"];

        
        NSDictionary *dic = operation.jsonResult.attr;
        if ([dic count]> 0 &&
            !_isTGKH)
         {
            vc.fOrderMoney = fOrderMoney; // 订单的原始价格
            vc.ffRealMoney = [dic[@"robPrice"] floatValue]; // 订单的实际购买价格
            vc.fYHMoney = [dic[@"saveAmount"] floatValue]; // 订单的优惠金额
            vc.iAddSocre = [dic[@"rewardScore"] intValue]; // 赠送积分
         }
        if ([dic count]> 0 &&
            _isTGKH)
         {
            vc.fOrderMoney = fOrderMoney; // 订单的原始价格
            vc.ffRealMoney = [dic[@"robPrice"] floatValue]; // 订单的实际购买价格
            vc.fYHMoney = [dic[@"spendScore"] floatValue]; // 订单的优惠金额
            vc.iAddSocre = 0; // 赠送积分
         }
        
        
        [self.parentVC.navigationController pushViewController:vc animated:NO];

        
    }
}

- (void) actionCZ
{
    
    
    
    NSDictionary *dic = [DDGAccountManager sharedManager].userInfo;
    NewVipViewControllerCtl_2 *ctl = [[NewVipViewControllerCtl_2 alloc]init];
    ctl.vipGrade = [[dic objectForKey:@"vipGrade"] integerValue];
    ctl.usableAmount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"usableAmount"]];
    ctl.vipEndDate = [NSString stringWithFormat:@"%@",[dic objectForKey:@"vipEndDate"]];
    //ctl.name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"realName"]];
    //ctl.imageUrl = [NSString stringWithFormat:@"%@",[dic objectForKey:@"userImage"]];
    
    
    [self.parentVC.navigationController pushViewController:ctl animated:YES];
}
-(void)dismiss{
    [self.animator removeAllBehaviors];
    [UIView animateWithDuration:0.7 animations:^{
        //        self.alpha = 0.0;
        //        CGAffineTransform rotate = CGAffineTransformMakeRotation(0.9 * M_PI);
        //        CGAffineTransform scale = CGAffineTransformMakeScale(0.1, 0.1);
        //        self.alertview.transform = CGAffineTransformConcat(rotate, scale);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.alertview = nil;
    }];
    
}




-(void)setUp{
    self.backgroundview = [[UIView alloc] initWithFrame:[[UIApplication sharedApplication] keyWindow].frame];
    self.backgroundview.backgroundColor = [UIColor blackColor];
    self.backgroundview.alpha = 0.4;
    [self addSubview:self.backgroundview];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
    [self.backgroundview addGestureRecognizer:tap];
    
    
    self.alertview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, alertviewWidth, alertviewHeight)];
    self.alertview.layer.cornerRadius = 5;
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    //self.alertview.center = CGPointMake(CGRectGetMidX(keywindow.frame), -CGRectGetMidY(keywindow.frame)-200);
    self.alertview.center = CGPointMake(CGRectGetMidX(keywindow.frame), -CGRectGetMidY(keywindow.frame));
    self.alertview.backgroundColor = [UIColor whiteColor];
    self.alertview.clipsToBounds = YES;
    
    [self addSubview:self.alertview];
    
    UIFont *font1 = [UIFont systemFontOfSize:16];

    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,alertviewWidth,titleHeight)];
    [self.alertview addSubview:titleLabel];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = font1;
    titleLabel.textColor = [ResourceManager color_1];
    
    // 设置标题
    [self setTitle];
    
    
    
    float  fLeftX = 10;
    float  fTopY =  titleHeight;
    
    // 分割线
    UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(fLeftX, fTopY, alertviewWidth - 2*fLeftX, 1)];
    [self.alertview addSubview:viewFG];
    viewFG.backgroundColor = [ResourceManager color_5];
    
    
    
    fTopY +=  15;
    _label1_text = [[UILabel alloc] initWithFrame:CGRectMake(fLeftX, fTopY, alertviewWidth - 2*fLeftX, 20)];
    [self.alertview addSubview:_label1_text];
    _label1_text.text = [NSString stringWithFormat:@" 当前余额为：%.2f元",(float)_fUsableAmount];
    _label1_text.numberOfLines = 0;
    _label1_text.font = [UIFont systemFontOfSize:15];
    _label1_text.textColor = [ResourceManager color_1];
    
    
    fTopY += _label1_text.height + 15;


    
    fTopY -= 10;
    pointDZLable = [[RCLabel alloc]initWithFrame:CGRectMake(fLeftX, fTopY, alertviewWidth - fLeftX - 100, 30)];
    [self.alertview addSubview:pointDZLable];
    pointDZLable.textAlignment = RTTextAlignmentLeft;
    // _label_11.componentsAndPlainText = [RCLabel extractTextStyle:[NSString stringWithFormat:@"<font size = 13 color=#333333>%@</font>",[_dataDic objectForKey:@"duty"]]];
    
    NSString *strQuan = [NSString stringWithFormat:@"<font size = 15 color=#333333>我的抢单券：</font><font size = 15 color=#306ce2>%@(说明)</font></font>",strTicketName];
    pointDZLable.componentsAndPlainText = [RCLabel extractTextStyle: strQuan];
    
    
    UIButton *smBtn = [[UIButton alloc] initWithFrame:pointDZLable.frame];
    [self.alertview addSubview:smBtn];
    [smBtn addTarget:self action:@selector(actionSYSM) forControlEvents:UIControlEventTouchUpInside];
    
    
    btnChange = [[UIButton alloc] initWithFrame:CGRectMake(alertviewWidth - 100, fTopY-5, 90, 30)];
    [self.alertview addSubview: btnChange];
    [btnChange setTitle:@"换一张>" forState:UIControlStateNormal];
    [btnChange setTitleColor:UIColorFromRGB(0xd1a53a) forState:UIControlStateNormal];
    btnChange.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnChange addTarget:self action:@selector(actionChange) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    if (!_canUseTicket ||
        !isSelQuan)
     {
        pointDZLable.width =  alertviewWidth - fLeftX -10;
        NSString *strQuan = [NSString stringWithFormat:@"<font size = 15 color=#333333>我的抢单券：</font><font size = 15 color=#306ce2>暂无</font></font>"];
        pointDZLable.componentsAndPlainText = [RCLabel extractTextStyle: strQuan];
        
        btnChange.hidden = YES;
     }
    
    
    
    fTopY += pointDZLable.height-5;
    
    paoma = [[SKAutoScrollLabel alloc] initWithFrame:CGRectMake(fLeftX+5, fTopY, alertviewWidth - 2*fLeftX -10, 15)];
    [self.alertview addSubview:paoma];
    paoma.backgroundColor = UIColorFromRGB(0xFDF9EC);
    paoma.font = [UIFont systemFontOfSize:11];
    paoma.textColor = UIColorFromRGB(0x774311);
    paoma.text = @"  充值赠送的金额使用完，才可以使用抢单券。";
    paoma.hidden = YES;
    

     
    fTopY += paoma.height + 5;
    
    
    RCLabel *pointLable = [[RCLabel alloc]initWithFrame:CGRectMake(fLeftX, fTopY, alertviewWidth - 2*fLeftX, 60)];
    [self.alertview addSubview:pointLable];
    pointLable.textAlignment = RTTextAlignmentLeft;
    pointLable.componentsAndPlainText = [RCLabel extractTextStyle: @"<font size = 13 color=#9a9a9a>注：平台贷款由客户自己申请，抢单成功后费用不可退。特殊情况可以退款，请于3日内提交申请。</font><font size = 13 color=#d1a53a>详情>></font></font>"];
    
    if (_isTGKH)
     {
        pointLable.componentsAndPlainText = [RCLabel extractTextStyle: @"<font size = 13 color=#9a9a9a>注：推广订单均由客户自己申请，付款成功后费用不可退。特殊情况可以退款，请于3日内提交申请。</font><font size = 13 color=#d1a53a>详情>></font></font>"];
        
     }
    
    // 查看详情
    UIButton *xqBtn = [[UIButton alloc] initWithFrame:pointLable.frame];
    [self.alertview addSubview:xqBtn];
    [xqBtn addTarget:self action:@selector(actionTKSM) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    int iTopY = CGRectGetMaxY(pointLable.frame) +10;
   
    CGRect cancelButtonFrame = CGRectMake(alertviewWidth / 2 +10 ,iTopY, alertviewWidth/2-40,buttonHeight);
    CGRect okButtonFrame = CGRectMake(30,iTopY, alertviewWidth/2 -40 ,buttonHeight);
    okButton = [self createButtonWithFrame2:okButtonFrame Title:@"取消"];
    okButton.tag = 2;
    [self.alertview addSubview:okButton];
        
    
    
    NSString *strMoney = [NSString stringWithFormat:@"%.2f元购买", fRealMoney];
    if (_fUsableAmount < fRealMoney)
     {
        strMoney = @"充值";
     }
    cancelButton = [self createButtonWithFrame:cancelButtonFrame Title:strMoney];
    cancelButton.tag = 1;
    [self.alertview addSubview:cancelButton];
    
    iTopY +=buttonHeight + 15;
    CGRect  frameTemp =  self.alertview.frame;
    frameTemp.size.height = iTopY;
    self.alertview.frame = frameTemp;
    
}

- (void) actionSYSM
{
    [self dismiss];
    NSString *url = [NSString stringWithFormat:@"%@xxapp/lend/coupon/explain2.html",[PDAPI WXSysRouteAPI]];
    [CCWebViewController showWithContro:self.parentVC withUrlStr:url withTitle:@"使用说明"];
}

-(void) actionTKSM
{
    [self dismiss];
    if (_isTGKH)
     {
        NSString *url = [NSString stringWithFormat:@"%@xxapp/protocol/tgProtocol.html",[PDAPI WXSysRouteAPI]];
        [CCWebViewController showWithContro:self.parentVC withUrlStr:url withTitle:@"推广协议"];
        return;
     }
    
    NSString *url = [NSString stringWithFormat:@"%@xxapp/protocol/lendHomeRob",[PDAPI WXSysRouteAPI]];
    [CCWebViewController showWithContro:self.parentVC withUrlStr:url withTitle:@"抢单协议"];
    
}

- (void) actionChange
{
    // -1 有券，但不使用  0 客户无券  1 该单有可使用的券(显示第一张)  2该单有可使用的券，但还有赠送金额不能用(暂不能使用)   3客户有券，但该单不可用(暂不能使用)
    
    // 去兑换
    if (0 == _flag)
     {
        
//        [self dismiss];
//
//        NSString *url = [NSString stringWithFormat:@"%@xxapp/lend/coupon/howget.html?signId=%@", [PDAPI WXSysRouteAPI],[DDGSetting sharedSettings].signId ];
//
//        CCWebViewController *webContro = [CCWebViewController new];
//        webContro.homeUrl = [NSURL URLWithString:url];
//        webContro.titleStr = @"获取途径";
//        webContro.isDHTJ = TRUE;
//        [self.parentVC.navigationController pushViewController:webContro animated:YES];
        
//        return;
     }
    
    if (_fUsableAmount <= 0)
     {
        [MBProgressHUD showErrorWithStatus:@"您余额不足，无法使用抢单券" toView:self];
        return;
     }
    
    self.hidden = YES;
    
    SelectDZQController *vc = [[SelectDZQController alloc] init];
    vc.iOrderMoney = fOrderMoney;
    vc.dicData = _dicData;
    vc.iRobWay = _iRobWay;
    vc.receiveId  = _receiveId;
    vc.isTGKH = _isTGKH;
    vc.ticketId = ticketId;
    [self.parentVC.navigationController pushViewController:vc animated:YES];
    
    if (1 == _flag ||
        -1 == _flag)
     {
        vc.selectBlock = ^(NSDictionary *dicSel){
            self.hidden = NO;
            
            if ([dicSel count]> 0)
             {
                _flag = 1;
                strTicketName = dicSel[@"ticketName"];// 抢单券的名字
                strTicketName = [strTicketName stringByReplacingOccurrencesOfString:@"抢单" withString:@""];
                iDZ = [dicSel[@"discount"] intValue];;       //打几折
                iJMMoney = [dicSel[@"maxDiscountAmount"] intValue];     // 不打折情况下，用券最多减去多少金额
                iDZMaxMoney = [dicSel[@"maxDiscountAmount"] intValue];  // 打折的最多优惠金额
                ticketId =  [NSString stringWithFormat:@"%@", dicSel[@"ticketId"]];
                
                [self setTitle];
                
             }
            else
             {
                _flag = -1;
                ticketId = @"";
                iJMMoney = 0;
                iDZ = 0;
                iDZMaxMoney = 0;
                [self setTitle];
             }
        };
     }
}

-(void) setTitle
{

    btnChange.hidden = NO;
    
    UIFont *font1_2 = [UIFont systemFontOfSize:18];
    UIFont *font1_3 = [UIFont systemFontOfSize:14];
    
    float fDZJE = fOrderMoney;
    // 用打折券
    if (iDZ > 0 &&
        iDZ <=10 &&
        isSelQuan &&
        _canUseTicket)
     {
        fDZJE = (float)fOrderMoney * iDZ/10;
        int iMaxDZJE = fOrderMoney - iDZMaxMoney;
        // 如果打完折，最大打折金额 大于 折后价格
        if (iMaxDZJE > fDZJE)
         {
            fDZJE = iMaxDZJE;
         }
     }
    
    
    // 用现金券
    if(0 == iDZ  &&
       iDZMaxMoney > 0 &&
       isSelQuan &&
       _canUseTicket)
     {
        fDZJE = fOrderMoney - iJMMoney;
        if (fDZJE < 0)
         {
            fDZJE = 0;
         }
     }
    
    NSString *strJE = [NSString stringWithFormat:@"%.2f元",(float)fOrderMoney];
    NSString *strDZJE = [NSString stringWithFormat:@"%.2f元",fDZJE];
    NSString *strAll =[NSString stringWithFormat:@"订单金额 %@ %@",strDZJE, strJE];
    if (fDZJE == fOrderMoney)
     {
        strAll =[NSString stringWithFormat:@"订单金额 %@", strJE];
     }
    
    fRealMoney = fDZJE;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:strAll];
    
    NSRange strRange = [strAll rangeOfString:strJE];
    [str addAttribute:NSForegroundColorAttributeName
                value:[ResourceManager mainColor] range:strRange]; //设置一段的字体颜色
    [str addAttribute:NSFontAttributeName
                value:font1_2 range:strRange];
    
    if (fDZJE != fOrderMoney)
     {
        
        NSRange strRange = [strAll rangeOfString:strDZJE];
        [str addAttribute:NSForegroundColorAttributeName
                    value:[ResourceManager mainColor] range:strRange]; //设置一段的字体颜色
        [str addAttribute:NSFontAttributeName
                    value:font1_2 range:strRange];
        
        NSRange strRange1 = [strAll rangeOfString:strJE];
        [str addAttribute:NSForegroundColorAttributeName
                    value:[ResourceManager lightGrayColor] range:strRange1]; //设置一段的字体颜色
        [str addAttribute:NSFontAttributeName
                    value:font1_3 range:strRange1];
        [str addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange1];
     }
    
    titleLabel.attributedText = str;
    
    
    // 抢单券 的名称
    NSString *strQuan = [NSString stringWithFormat:@"<font size = 15 color=#333333>我的抢单券：</font><font size = 15 color=#306ce2>%@(说明)</font></font>",strTicketName];
    pointDZLable.componentsAndPlainText = [RCLabel extractTextStyle: strQuan];
    
    // 修改最有下角按钮的名称
    if (_fUsableAmount < fRealMoney)
     {
        [cancelButton setTitle:@"充值" forState:UIControlStateNormal];
     }
    else
     {
        NSString *strMoney = [NSString stringWithFormat:@"%.2f元购买", fRealMoney];
        [cancelButton setTitle:strMoney forState:UIControlStateNormal];
     }
    
    paoma.hidden = YES;
    btnChange.hidden = NO;
    //flag   -1 有券，但不使用   0 客户无券  1 该单有可使用的券(显示第一张)  2该单有可使用的券，但还有赠送金额不能用(暂不能使用)   3客户有券，但该单不可用(暂不能使用)
     if(-1 == _flag)
      {
         pointDZLable.width =  alertviewWidth - 30 -10;
         NSString *strQuan = [NSString stringWithFormat:@"<font size = 15 color=#333333>我的抢单券：</font><font size = 15 color=#306ce2>不使用</font></font>"];
         pointDZLable.componentsAndPlainText = [RCLabel extractTextStyle: strQuan];
         [btnChange setTitle:@"换一张>" forState:UIControlStateNormal];
      }
    else  if(0 == _flag)
     {
        pointDZLable.width =  alertviewWidth - 30 -10;
        NSString *strQuan = [NSString stringWithFormat:@"<font size = 15 color=#333333>我的抢单券：</font><font size = 15 color=#306ce2>没有券</font></font>"];
        pointDZLable.componentsAndPlainText = [RCLabel extractTextStyle: strQuan];
        [btnChange setTitle:@"获取途径>" forState:UIControlStateNormal];
        [btnChange setTitle:@"" forState:UIControlStateNormal];
     }
    else if (2 == _flag)
     {
        NSString *strQuan = [NSString stringWithFormat:@"<font size = 15 color=#333333>我的抢单券：</font><font size = 15 color=#306ce2>暂不可用</font></font>"];
        pointDZLable.componentsAndPlainText = [RCLabel extractTextStyle: strQuan];
        paoma.text = msg;
        paoma.hidden = NO;
        btnChange.hidden = YES;
     }
    else if (3 == _flag)
     {
        NSString *strQuan = [NSString stringWithFormat:@"<font size = 15 color=#333333>我的抢单券：</font><font size = 15 color=#306ce2>暂不可用</font></font>"];
        pointDZLable.componentsAndPlainText = [RCLabel extractTextStyle: strQuan];
        btnChange.hidden = YES;
     }
    else if (4 == _flag)
     {
        NSString *strQuan = [NSString stringWithFormat:@"<font size = 15 color=#333333>我的抢单券：</font><font size = 15 color=#fc7637>暂不可用</font></font>"];
        pointDZLable.componentsAndPlainText = [RCLabel extractTextStyle: strQuan];
        btnChange.hidden = YES;
        
        paoma.hidden = NO;
        paoma.text = msg;
     }
    
}

#pragma mark -  API
- (void)show {
    
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:self];
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    
    
    CGPoint setCenter = self.center;
    //setCenter.y =150; // 修改弹出框的位置
    UISnapBehavior * sanp = [[UISnapBehavior alloc] initWithItem:self.alertview snapToPoint:setCenter];
    
    
    sanp.damping = 0.5;
    [self.animator addBehavior:sanp];
    
}


-(instancetype)initWithDic:(NSDictionary*) dicValue  arraryDZQ:(NSArray*) arrValue
              usebleAmount:(float) fValue  canUse:(BOOL) bValue
{
    if (self = [super initWithFrame:[[UIApplication sharedApplication] keyWindow].frame])
     {
        _dicData = dicValue ; // 抢单的本身信息
        _arrDZQ = arrValue ; // 打折券的数组（未过滤）
        _fUsableAmount = fValue;
        _canUseTicket = bValue;
        
        // 初始化为0
        fOrderMoney = 0; // 订单的金额
        isSelQuan = FALSE;  // 是否用券
        iDZ = 0;       //打几折
        iJMMoney = 0;     // 不打折情况下，用券最多减去多少金额
        iDZMaxMoney = 0;  // 打折的最多优惠金额
        
        if ([_dicData count] > 0)
         {
            fOrderMoney = [_dicData[@"price"] intValue]/ 100;
         }
        
 

        // 先用缓存数据
        //[self setSelQuan];
        
        
        [self setUp];
        
        
        // 如果没有选择任何券，从后台拿一次数据，预防券的数据不对
        if (!isSelQuan)
         {
            [self getTicke];
         }
    }
    return self;
}


// 会员特价  初始化
-(instancetype)initWithDic:(NSDictionary*) dicValue  robWay:(int) iValue  arraryDZQ:(NSArray*) arrValue
              usebleAmount:(float) fValue  canUse:(BOOL) bValue
{
    if (self = [super initWithFrame:[[UIApplication sharedApplication] keyWindow].frame])
     {
        _dicData = dicValue ; // 抢单的本身信息
        _arrDZQ = arrValue ; // 打折券的数组（未过滤）
        _iRobWay = iValue;
        _fUsableAmount = fValue;
        _canUseTicket = bValue;
        
        // 初始化为0
        fOrderMoney = 0; // 订单的金额
        isSelQuan = FALSE;  // 是否用券
        iDZ = 0;       //打几折
        iJMMoney = 0;     // 不打折情况下，用券最多减去多少金额
        iDZMaxMoney = 0;  // 打折的最多优惠金额
        
        if ([_dicData count] > 0)
         {
            fOrderMoney = [_dicData[@"price"] intValue]/ 100;
         }
        
        
        
        // 先用缓存数据
        //[self setSelQuan];
        
        
        [self setUp];
        
        
        // 如果没有选择任何券，从后台拿一次数据，预防券的数据不对
        if (!isSelQuan)
         {
            [self getTicke];
         }
     }
    return self;

}

-(instancetype)initTGKHWithDic:(NSDictionary*) dicValue  arraryDZQ:(NSArray*) arrValue
              usebleAmount:(float) fValue
{
    if (self = [super initWithFrame:[[UIApplication sharedApplication] keyWindow].frame])
     {
        _dicData = dicValue ; // 抢单的本身信息
        _arrDZQ = arrValue ; // 打折券的数组（未过滤）
        _fUsableAmount = fValue;
        _canUseTicket = FALSE;
        _isTGKH = TRUE;
        
        // 初始化为0
        fOrderMoney = 0; // 订单的金额
        isSelQuan = FALSE;  // 是否用券
        iDZ = 0;       //打几折
        iJMMoney = 0;     // 不打折情况下，用券最多减去多少金额
        iDZMaxMoney = 0;  // 打折的最多优惠金额
        
        if ([_dicData count] > 0)
         {
            fOrderMoney = [_dicData[@"robPrice"] floatValue];
            _receiveId = _dicData[@"receiveId"];
         }
        
        
        
        [self setUp];
        
        [self getTicke];
        
        

     }
    return self;
}

-(void) setSelQuan
{
    int iCount = (int)[_arrDZQ count];
    if ( iCount<= 0)
     {
        isSelQuan = FALSE;
        return;
     }
    

    for (int i = 0; i < iCount; i++)
     {
        NSDictionary *dic = _arrDZQ[i];
        int iMinPrice = [dic[@"minPrice"] intValue];
        
        // 最小订单金额 大于本次订单金额
        if (iMinPrice > fOrderMoney)
         {
            continue;
         }
        
        if (iMinPrice <= fOrderMoney)
         {
            isSelQuan = TRUE;
            
            strTicketName = dic[@"ticketName"];// 抢单券的名字
            strTicketName = [strTicketName stringByReplacingOccurrencesOfString:@"抢单" withString:@""];
            iDZ = [dic[@"discount"] intValue];       //打几折
            iJMMoney = [dic[@"maxDiscountAmount"] intValue];     // 不打折情况下，用券最多减去多少金额
            iDZMaxMoney = [dic[@"maxDiscountAmount"] intValue];  // 打折的最多优惠金额
            ticketId = [NSString stringWithFormat:@"%@", dic[@"ticketId"]];
            
            [self setTitle];
            return;
         }
        
     }
    
    
}


-(void)getTicke{
    
    [MBProgressHUD showHUDAddedTo:self animated:NO];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBusiUrlString],kDDGgetTicketInfo];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    currentPage：当前页
    //    everyPage：每页多少条
    //    status:(0-未激活 1-有效 2-使用中 3-已使用 4-过期)
    params[kPage] = @(1);
    params[kPageSize] = @(500);
    params[@"status"] = @(1);
    params[@"robWay"] = @(_iRobWay);
    if (_isTGKH)
     {
        params[@"receiveId"] = _receiveId;
     }
    else
     {
        params[@"borrowId"] = _dicData[@"borrowId"];
     }
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleTitkeData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self];
                                                                                  }];
    [operation start];
    
}

-(void)handleTitkeData:(DDGAFHTTPRequestOperation *)operation{

    
    [MBProgressHUD hideHUDForView:self animated:NO];
    
    _canUseTicket = [operation.jsonResult.attr[@"canUseTicket"] boolValue];
    
    //flag    0 客户无券  1 该单有可使用的券(显示第一张)  2该单有可使用的券，但还有赠送金额不能用(暂不能使用)   3客户有券，但该单不可用(暂不能使用)
    _flag = [operation.jsonResult.attr[@"flag"] intValue];
    msg = operation.jsonResult.attr[@"msg"];
    
    if (operation.jsonResult.rows && operation.jsonResult.rows.count > 0) {
        
        _arrDZQ = operation.jsonResult.rows;

        [self setSelQuan];
        
    }
    
    [self setTitle];
    
    
}



@end
