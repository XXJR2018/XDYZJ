//
//  NewVipViewControllerCtl_2.m
//  XXJR
//
//  Created by xxjr02 on 2017/12/15.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import "NewVipViewControllerCtl_2.h"
#import "LLPayVC.h"
#import "KJPayViewController.h"
#import "MyBankViewController.h"
#import "CCWebViewController.h"
#import "PayRecordVC.h"


@interface NewVipViewControllerCtl_2 ()
{
    UIScrollView *scView;
    
    UIView *viewHead;
    
    UIView *viewMid;
    NSMutableArray *vipBtnArr;
    NSInteger _suitNum;   // 充值的金额
    int       _zsNum;     // 赠送的金额

    
    UIView *viewTail;
    //NSMutableArray *payBtnArr;
    UIImageView  *imgPaySel;
    NSArray *arrayPay;
    
    BOOL _haveCard;
    int  iSelPay; // 支付的类型  1 - 连连认证支付，2-连连快捷支付，  3-宝付支付 , 4 微信支付 ， 5 -多多连连认证 , 6 - 华移微信支付
    
    UIView *background;
    NSDictionary *dicCZQ;  //充值券DIC
    long   couponId;       // 充值券的ID
    NSString *_strAddMoney; // 支付成功时的奖励
    
    UIButton *bt1;
  
}
@end

@implementation NewVipViewControllerCtl_2

-(void) viewWillAppear:(BOOL)animated
{
    if (!_haveAppeared)
     {
        [self getPayWay];
        
        [self vipPackageUrl];
     }
    
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CustomNavigationBarView *nav = [self layoutNaviBarViewWithTitle:@"充值"];
    
    
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
    
    scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.f, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight - 60 - 30)];
    //关闭翻页效果
    scView.pagingEnabled = NO;
    //隐藏滚动条
    scView.showsVerticalScrollIndicator = NO;
    scView.backgroundColor = [ResourceManager viewBackgroundColor];
    scView.contentSize = CGSizeMake(0, 800);
    [self.view addSubview:scView];
    
    //_scView.contentSize = CGSizeMake(0, CGRectGetMaxY(noticeViwe.frame));
    [self layoutUI];
}

#pragma mark ---  布局UI
-(void) layoutUI
{
    [self layoutHead];
    
    [self layoutMid];
    
    [self layoutTail];
    
    int iLeftX = 15;
    int iTopY = SCREEN_HEIGHT - 60 - 25;
    
    bt1 = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 20, 20)];
    [self.view addSubview:bt1];
    UIImage *image1= [UIImage imageNamed:@"yzd_select"];
    UIImage *image2= [UIImage imageNamed:@"yzd_unselect"];
    [bt1 setImage:image2 forState:UIControlStateNormal];
    [bt1 setImage:image1 forState:UIControlStateSelected];
    bt1.selected = NO;
    [bt1 addTarget:self action:@selector(bt1Action) forControlEvents:UIControlEventTouchUpInside];
    

    
    
    UILabel *labelTitle4 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX+ 23, iTopY, SCREEN_WIDTH/2, 15)];
    labelTitle4.text = @"点击立即充值，即表示你已经同意";
    labelTitle4.font = [UIFont systemFontOfSize:12];
    labelTitle4.textColor = [ResourceManager color_7];
    [self.view addSubview:labelTitle4];
    [labelTitle4 sizeToFit];
    
    UILabel *labelTitle3 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX+ 23 + labelTitle4.width, iTopY, SCREEN_WIDTH/2, 15)];
    labelTitle3.text = @"《充值服务协议》";
    labelTitle3.font = [UIFont systemFontOfSize:12];
    labelTitle3.textColor = [ResourceManager mainColor];  // 淡蓝色
                                                       //添加手势点击
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(treatyButton)];
    gesture.numberOfTapsRequired  = 1;
    [labelTitle3 addGestureRecognizer:gesture];
    labelTitle3.userInteractionEnabled = YES;
    [self.view addSubview:labelTitle3];

    
    //
    UIButton  *btnApply = [[UIButton alloc]initWithFrame:CGRectMake(15, SCREEN_HEIGHT-50, SCREEN_WIDTH-30, 40)];
    [btnApply setTitle:@"充值" forState:UIControlStateNormal];
    btnApply.titleLabel.font=[UIFont systemFontOfSize:15];
    [btnApply setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnApply.cornerRadius = btnApply.height/2;
    btnApply.backgroundColor = [ResourceManager mainColor];
    [btnApply addTarget:self action:@selector(payOrRefrsh) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnApply];
}


-(void) layoutHead
{
    viewHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    viewHead.backgroundColor = [UIColor whiteColor];
    [scView addSubview:viewHead];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 60, 40)];
    label1.textColor = [ResourceManager color_1];
    label1.font = [UIFont systemFontOfSize:14];
    label1.text = @"账号余额";
    [viewHead addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame)+10, 0, 100, 40)];
    label2.textColor = UIColorFromRGB(0xF34320);
    label2.font = [UIFont systemFontOfSize:15];
    NSString *strAomunt = [CommonInfo formatString:_usableAmount];
    label2.text = strAomunt;
    [viewHead addSubview:label2];
    
    
//    if(self.vipGrade == 1 && self.vipEndDate.length > 0) {
//        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label2.frame)+20, 0, 150, 40)];
//        label3.textColor = [ResourceManager lightGrayColor];
//        label3.font = [UIFont systemFontOfSize:14];
//        label3.text = [NSString stringWithFormat:@"%@到期",self.vipEndDate];
//        [viewHead addSubview:label3];
//    }
    
}

-(void) layoutMid
{
    if (viewMid)
     {
        [viewMid removeFromSuperview];
     }
    
    viewMid = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(viewHead.frame)+10, SCREEN_WIDTH, 300)];
    viewMid.backgroundColor = [UIColor whiteColor];
    [scView addSubview:viewMid];
    

    
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 160, 30)];
    label1.textColor = [ResourceManager color_1];
    label1.font = [UIFont systemFontOfSize:14];
    label1.text = @"充值金额";
    [viewMid addSubview:label1];
    
    int iCount = (int)[_vipDataArr count];
    vipBtnArr = [[NSMutableArray alloc] init];
    int iBtnTopY = 30;
    for (int i = 0; i < iCount; i++)
     {
        NSDictionary *dic = _vipDataArr[i];
        int iBtnLeftX = 0;
        if (i > 0 &&
            i % 2 == 0)
         {
            iBtnTopY += 70;
         }
        if (i % 2 == 1)
         {
            iBtnLeftX = SCREEN_WIDTH/2;
         }
        
        [self setViPViewWithDic:dic LeftX:iBtnLeftX  TopY:iBtnTopY  iTag:i];
     }
    

    
    // 点击优惠券时， 默认选择充值多少钱
    int iCurCount = 0;
    for (int i = 0; i < self.vipDataArr.count; i++)
     {
        int iTemp =  [[(NSDictionary *)self.vipDataArr[i] objectForKey:@"recharge"] intValue];
        if (iTemp == _iMoney)
         {

            ((UIButton *)vipBtnArr[i]).layer.borderColor = UIColorFromRGB(0xc69548).CGColor;
            ((UIButton *)vipBtnArr[i]).backgroundColor = UIColorFromRGB(0xfdf6ea);;
            
            _suitNum = [[(NSDictionary *)self.vipDataArr[i] objectForKey:@"recharge"] intValue];
            _zsNum = [[(NSDictionary *)self.vipDataArr[i] objectForKey:@"reward"] intValue];
            
            //_strAddMoney = [NSString stringWithFormat:@"送%@个月会员+价值%@元抢单券",[(NSDictionary *)self.vipDataArr[i] objectForKey:@"largessMonth"],[(NSDictionary *)self.vipDataArr[i] objectForKey:@"reward"]];
            _strAddMoney = [(NSDictionary *)self.vipDataArr[i] objectForKey:@"desc"];//[NSString stringWithFormat:@"送%@元抢单券",[(NSDictionary *)self.vipDataArr[i] objectForKey:@"reward"]];
            
            iCurCount = i;
         }
     }
    
    if (iCount >0  &&
        iCurCount == 0)
     {
        ((UIButton *)vipBtnArr[0]).layer.borderColor = UIColorFromRGB(0xc69548).CGColor;
        ((UIButton *)vipBtnArr[0]).backgroundColor = UIColorFromRGB(0xfdf6ea);;
        
        _suitNum = [[(NSDictionary *)self.vipDataArr[0] objectForKey:@"recharge"] intValue];
        _zsNum = [[(NSDictionary *)self.vipDataArr[0] objectForKey:@"reward"] intValue];
        //_strAddMoney =  [NSString stringWithFormat:@"送%@个月会员+价值%@元抢单券",[(NSDictionary *)self.vipDataArr[0] objectForKey:@"largessMonth"],[(NSDictionary *)self.vipDataArr[0] objectForKey:@"reward"]];
        //_strAddMoney = [NSString stringWithFormat:@"送%@元抢单券",[(NSDictionary *)self.vipDataArr[0] objectForKey:@"reward"]];
        _strAddMoney = [(NSDictionary *)self.vipDataArr[0] objectForKey:@"desc"];
     }
    
    viewMid.height = iBtnTopY + 70 ;
    

}

- (void) setViPViewWithDic:(NSDictionary*) dic  LeftX:(int)leftX   TopY:(int) topY  iTag:(int) tag
{
    int iWdith = SCREEN_WIDTH/2 - 20 -10;
    UIButton *btn =  [[UIButton alloc] initWithFrame:CGRectMake(leftX + 20, topY, iWdith, 60)];
    
    if (leftX > 20)
     {
        btn =  [[UIButton alloc] initWithFrame:CGRectMake(leftX+10, topY, iWdith, 60)];
     }

    
    
    btn.layer.borderColor = [ResourceManager color_5].CGColor;
    btn.layer.borderWidth = 1;
    btn.tag = tag ;
    [viewMid addSubview:btn];
    [vipBtnArr addObject:btn];
    
    [btn addTarget:self action:@selector(touch:) forControlEvents:UIControlEventTouchUpInside];
    
    UIFont *font = [UIFont systemFontOfSize:15];
    UILabel *label_1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, iWdith, 20)];
    [btn addSubview:label_1];
    //label_1.textAlignment = NSTextAlignmentCenter;
    label_1.font = font;
    label_1.textColor = UIColorFromRGB(0x333333);
    label_1.textAlignment = NSTextAlignmentCenter;
    if ([NSString stringWithFormat:@"%@",[dic objectForKey:@"recharge"]].length > 0) {
        label_1.text = [NSString stringWithFormat:@"充值%@元",[dic objectForKey:@"recharge"]];
    }
    
        
    UILabel *label_3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, iWdith, 20)];
    [btn addSubview:label_3];
    //label_3.textAlignment = NSTextAlignmentCenter;
    label_3.font = [UIFont systemFontOfSize:12];
    label_3.textColor = UIColorFromRGB(0x666666);
    label_3.textAlignment = NSTextAlignmentCenter;
    if ([NSString stringWithFormat:@"%@",[dic objectForKey:@"desc"]].length > 0) {
        //label_3.text = [NSString stringWithFormat:@"送%@个月会员+价值%@元抢单券",[dic objectForKey:@"largessMonth"],[dic objectForKey:@"reward"]];
        label_3.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"desc"]];
    }
    
}


//选择套餐
- (void)touch:(UIButton *)sender {
    int iCount = (int)[_vipDataArr count];
    
    for (int i = 0; i < iCount; i++)
     {
        ((UIButton *)vipBtnArr[i]).layer.borderColor = [ResourceManager color_5].CGColor;
        ((UIButton *)vipBtnArr[i]).backgroundColor = [UIColor clearColor];
     }
    
    int iTag = (int)sender.tag ;
    if (iTag <= iCount)
     {
        UIButton * btn = (UIButton *)vipBtnArr[iTag];
        btn.layer.borderColor = UIColorFromRGB(0xc69548).CGColor;
        btn.backgroundColor = UIColorFromRGB(0xfdf6ea);
        //btn.backgroundColor = [ResourceManager mainColor];
        
        _suitNum = [[(NSDictionary *)self.vipDataArr[iTag] objectForKey:@"recharge"] intValue];
        _zsNum = [[(NSDictionary *)self.vipDataArr[iTag] objectForKey:@"reward"] intValue];
        //_strAddMoney =  [NSString stringWithFormat:@"送%@个月会员+价值%@元抢单券",[(NSDictionary *)self.vipDataArr[iTag] objectForKey:@"largessMonth"],[(NSDictionary *)self.vipDataArr[iTag] objectForKey:@"reward"]];
        _strAddMoney = [(NSDictionary *)self.vipDataArr[iTag] objectForKey:@"desc"];
     }
    

    
}

-(void) payOrRefrsh
{
    
    if (![CommonInfo isSMRZ:self])
     {
        return;
     }
    
//    if (!bt1.selected) {
//        [MBProgressHUD showErrorWithStatus:@"请同意小小金融充值协议" toView:self.view];
//        return;
//    }
    
    
    // 支付的类型  1 - 连连认证支付，2-连连快捷支付，  3-宝付支付 , 4 微信支付 ， 5 -多多连连认证 , 6 - 华移微信支付
    if (1 == iSelPay)
     {
        
        [self realPay];
        
     }
    if (2 == iSelPay)
     {
        
        [self realPay];
        
     }
    
    if (3 == iSelPay )
     {
        if (_haveCard) {
            
            [self realPay];
            
        }else{
            MyBankViewController *ctl = [[MyBankViewController alloc]init];
            [self.navigationController pushViewController:ctl animated:YES];
        }
     }
    
    if (4 == iSelPay ||
        5 == iSelPay ||
        6 == iSelPay ||
        7 == iSelPay)
     {
        
        [self realPay];
        
     }

    
}

-(void) layoutTail
{
    
    if (viewTail)
     {
        [viewTail removeFromSuperview];
     }
    
    viewTail = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(viewMid.frame)+10, SCREEN_WIDTH, 300)];
    viewTail.backgroundColor = [UIColor whiteColor];
    [scView addSubview:viewTail];
    
    int iCount = (int)[arrayPay count];
    //payBtnArr = [[NSMutableArray alloc] init];
    int iBtnTopY = 0;
    for (int i = 0; i < iCount; i++)
     {
        NSDictionary *dic = arrayPay[i];
        if (i > 0)
         {
            iBtnTopY += 50;
         }
        [self setPayViewWithDic:dic TopY:iBtnTopY  iTag:i];
     }
    
    iBtnTopY += 50 +5;
    viewTail.height = iBtnTopY;
    
    scView.contentSize = CGSizeMake(0, CGRectGetMaxY(viewTail.frame));

}

- (void) setPayViewWithDic:(NSDictionary*) dic  TopY:(int) topY  iTag:(int) tag
{
    UIButton *btn =  [[UIButton alloc] initWithFrame:CGRectMake(0, topY, SCREEN_WIDTH, 50)];
    btn.tag = tag ;
    [viewTail addSubview:btn];
    [vipBtnArr addObject:btn];
    
    [btn addTarget:self action:@selector(touchPay:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 38, 30)];
    imgView.image = [UIImage imageNamed:@"VIP-15"];
    [btn addSubview:imgView];
    
    NSString *rechargeType = dic[@"rechargeType"];
    if ([rechargeType isEqualToString:@"hywx"])
     {
        imgView.image = [UIImage imageNamed:@"tab4_weixin_zhifu"];
     }
    else if ([rechargeType isEqualToString:@"wx"])
     {
        imgView.image = [UIImage imageNamed:@"tab4_weixin_zhifu"];
     }
    else if ([rechargeType isEqualToString:@"baofoo"])
     {
        imgView.image = [UIImage imageNamed:@"VIP-16"];
     }
    else if ([rechargeType isEqualToString:@"llrz"])
     {
        imgView.image = [UIImage imageNamed:@"VIP-15"];
     }
    else if ([rechargeType isEqualToString:@"llkj"])
     {
        imgView.image = [UIImage imageNamed:@"VIP-15"];
     }

    NSString *channelName = dic[@"channelName"];
    UILabel *labelTitle =  [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 250, 50)];
    [btn addSubview:labelTitle];
    labelTitle.font =  [UIFont systemFontOfSize:14];
    labelTitle.textColor = [ResourceManager color_1];
    labelTitle.text = channelName;
    
    if ([channelName isEqualToString:@"连连认证"])
     {
        labelTitle.text = @"连连认证(只支持借记卡)";
     }
    
    if ([channelName isEqualToString:@"连连快捷"])
     {
        labelTitle.text = @"连连快捷(只支持信用卡)";
     }
    
    // 默认选择第一个支付方式
    if (0 == tag)
     {
        imgPaySel = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 30, 15, 20, 20)];
        imgPaySel.image = [UIImage imageNamed:@"VIP-17"];
        [btn addSubview:imgPaySel];
        
        [self touchPay:btn];
     }
    
    UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 1)];
    viewFG.backgroundColor = [ResourceManager color_5];
    [btn addSubview:viewFG];
}

#pragma mark ---  action
-(void) touchPay:(UIButton*) sender
{
    int iTag = (int) sender.tag;
    if (iTag < [arrayPay count])
     {
        imgPaySel.hidden = YES;
        UIButton *btn = sender;
        imgPaySel = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 30, 15, 20, 20)];
        imgPaySel.image = [UIImage imageNamed:@"VIP-17"];
        [btn addSubview:imgPaySel];
        
        NSDictionary *dic = arrayPay[iTag];
        NSString *rechargeType = dic[@"rechargeType"];
        //int  iSelPay; // 支付的类型  1 - 连连认证支付，2-连连快捷支付，  3-宝付支付 , 4 微信支付 ，5  多多连连认证 , 6 - 华移微信支付
        if ([rechargeType isEqualToString:@"wx"])
         {
            iSelPay = 4;
         }
        else if ([rechargeType isEqualToString:@"baofoo"])
         {
            iSelPay = 3;
         }
        else if ([rechargeType isEqualToString:@"llrz"])
         {
            iSelPay = 1;
         }
        else if ([rechargeType isEqualToString:@"llkj"])
         {
            iSelPay = 2;
         }
        else if ([rechargeType isEqualToString:@"ddllrz"])
         {
            iSelPay = 5;
         }
        else if ([rechargeType isEqualToString:@"hywx"])
         {
            iSelPay = 6;
         }
        else if ([rechargeType isEqualToString:@"ddllkj"])
         {
            iSelPay = 7;
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

-(void)closeView
{
    [background removeFromSuperview];
}

//协议
-(void) treatyButton
{
    NSString *url = [NSString stringWithFormat:@"%@xxapp/protocol/lendHomeRecharge",[PDAPI WXSysRouteAPI]];
    [CCWebViewController showWithContro:self withUrlStr:url withTitle:@"充值协议"];
}

-(void) bt1Action
{
    bt1.selected = !bt1.selected;
    
}


-(void) realPay
{

    
    // 支付的类型  1 - 连连认证支付，2-连连快捷支付，  3-宝付支付 , 4 微信支付 ， 5 -多多连连认证 , 6 - 华移微信支付
    if (1 == iSelPay)
     {
        LLPayVC *vc = [[LLPayVC alloc] init];
        vc.rechargeType =@"llrz";
        vc.moneyNum = [NSString stringWithFormat:@"%ld", (long)_suitNum];
        vc.couponId = couponId;
        vc.strAddMoney = _strAddMoney;
        [self.navigationController pushViewController:vc animated:YES];
     }
    if (2 == iSelPay)
     {
        LLPayVC *vc = [[LLPayVC alloc] init];
        vc.rechargeType =@"llkj";
        vc.moneyNum = [NSString stringWithFormat:@"%ld", (long)_suitNum];
        vc.couponId = couponId;
        vc.strAddMoney = _strAddMoney;
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
            ctl.strAddMoney = _strAddMoney;
            [self.navigationController pushViewController:ctl animated:YES];
        }else{
            MyBankViewController *ctl = [[MyBankViewController alloc]init];
            [self.navigationController pushViewController:ctl animated:YES];
        }
     }
    
    if (4 == iSelPay )
     {
        [self getWXUrl];
     }
    
    if (5 == iSelPay )
     {
        LLPayVC *vc = [[LLPayVC alloc] init];
        vc.rechargeType =@"ddllrz";
        vc.moneyNum = [NSString stringWithFormat:@"%ld", (long)_suitNum];
        vc.couponId = couponId;
        vc.strAddMoney = _strAddMoney;
        [self.navigationController pushViewController:vc animated:YES];
     }
    
    if (6 == iSelPay )
     {
        [self getWXUrl];
     }
    
    if (7 == iSelPay )
     {
        LLPayVC *vc = [[LLPayVC alloc] init];
        vc.rechargeType =@"ddllkj";
        vc.moneyNum = [NSString stringWithFormat:@"%ld", (long)_suitNum];
        vc.couponId = couponId;
        vc.strAddMoney = _strAddMoney;
        [self.navigationController pushViewController:vc animated:YES];
     }
    
}

-(void) shareAction:(NSString *) payUrl
{
    CCWebViewController *webContro = [[CCWebViewController alloc] init];
    
    NSString *url = [NSString stringWithFormat:@"%@xxapp/ios/wxpay2.html",[PDAPI WXSysRouteAPI]];
    //CCWebViewController *webContro = [CCWebViewController new];
    webContro.homeUrl = [NSURL URLWithString:url];
    webContro.isWeiXinPay = YES;
    webContro.payUrl = payUrl;
    webContro.titleStr = @"微信支付教程";
    [self.navigationController pushViewController:webContro animated:YES];
}

-(void) actionRecord
{
    PayRecordVC  *vc = [[PayRecordVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark  ---- 网络通讯
-(void) getPayWay
{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    
    NSString *strUrl =  @"mjb/account/fund/getIOSRechargeChannel";
    //strUrl =  @"mjb/account/fund/getRechargeChannel";
    arrayPay = nil;
    // 得到支付的方式
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@%@",[PDAPI getBusiUrlString],strUrl]
                                                                               parameters:nil HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    
    operation.tag = 999;
    [operation start];
}


//会员套餐
- (void)vipPackageUrl{
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@mjb/account/fund/getVipConfig",[PDAPI getBaseUrlString]]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      _vipDataArr = operation.jsonResult.rows;
                                                                                      
                                                                                      [self layoutUI];
                                                                                  }failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      
                                                                                  }];
    [operation start];
    operation.tag = 10212;
}


-(void)loadData
{
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],@"mjb/account/baofoo/bindcard/bankCard"]
                                                                               parameters:nil HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                  }];
    
    operation.tag = 1000;
    [operation start];
}




-(void) getWXUrl
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"amount"] = @(_suitNum);
    params[@"project"] = @"mjbRecharge";

    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],@"mjb/comm/saveOrderInfo"]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                      
                                                                                  }];
    
    operation.tag = 1003;
    [operation start];
}



-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    
    if (999 == operation.tag)
     {
        if (operation.jsonResult.attr.count > 0)
         {
            arrayPay = operation.jsonResult.attr[@"channel"];
            
            [self layoutTail];
            
            [self performSelector:@selector(bt1Action) withObject:nil/*可传任意类型参数*/ afterDelay:0.1];
         }
     }
    
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
    if (1003 == operation.tag)
     {
        NSDictionary *dic = operation.jsonResult.attr;
        if (dic)
         {
            NSString *payUrl = dic[@"payUrl"];
            [self  shareAction:payUrl];
         }
        else
         {
            [MBProgressHUD showErrorWithStatus:@"获取微信支付参数失败。" toView:self.view];
         }
     }

}



@end
