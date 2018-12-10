//
//  LightingSucces.m
//  XXJR
//
//  Created by xxjr02 on 2018/2/7.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import "LightingSucces.h"

@interface LightingSucces ()
{
    UIScrollView *viewBack;
    UILabel *labelRightView1;
    UILabel *labelRightView2;
    UILabel *labelRightView3;
    UIButton *btnShare;
    
    UIView *background;
    
    
    UIView *viewTail;    //  底部的view
    
    
    
    int  iHongBaoOrder;  // 最大红包位置
    int  iHongBaoPrice;  // 最大红包金额
    
    int  iStatus;  // 1- 不能分享
    NSString  *recordId; // 分享的记录id
    NSString *message; // 不能分享时， 弹框的内容
    NSString *shareUrl;
    NSString *shareTitle;
    NSString *shareContent;
    

}
@end

@implementation LightingSucces

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutNaviBarViewWithTitle:@"抢单成功"];
    
    [self layoutUI];
    

    iHongBaoOrder = 1;
    iHongBaoPrice = 20;
    shareUrl = @"adsfs";
    shareTitle = @"【小小信贷经理】第1个领取的人红包最大！";
    shareContent =  @"最高20元红包，手快有，手慢无！";
    //[self getHongbao];
    
}

-(void)clickNavButton:(UIButton *)button{
    
    [self.navigationController popViewControllerAnimated:YES];
    //[[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@(2),@"index":@(0)}];
    //[[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@(3),@"index":@(0)}];
}

-(void) layoutUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    viewBack = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, 470)];
    [self.view addSubview:viewBack];
    viewBack.backgroundColor = [UIColor whiteColor];
    
    int iTopY = 0;
    int iLeftX = 10;
    int iImgWdith = 80;
    int iImgLeftX = (SCREEN_WIDTH - iImgWdith)/2;
    UIColor *color1 = UIColorFromRGB(0x666666);
    
    UIImageView *imgSuccess = [[UIImageView alloc] initWithFrame:CGRectMake(iImgLeftX, iTopY, iImgWdith, iImgWdith)];
    [viewBack addSubview:imgSuccess];
    imgSuccess.image = [UIImage imageNamed:@"light_suess_ok"];
    
    iTopY += imgSuccess.height + 10;
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 20)];
    [viewBack addSubview:label1];
    label1.font = [UIFont systemFontOfSize:18];
    label1.textColor = [ResourceManager color_1];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = @"付款成功";
    
    iTopY += label1.height + 10;
    UILabel *labelJG = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 30)];
    [viewBack addSubview:labelJG];
    labelJG.font = [UIFont systemFontOfSize:35];
    labelJG.textColor = [ResourceManager color_1];
    labelJG.textAlignment = NSTextAlignmentCenter;
    if (_ffRealMoney <= 0)
     {
        _ffRealMoney = 0.00;
     }
    NSString *strRealJG = [NSString stringWithFormat:@"%.2f", (float)_ffRealMoney];//@"42.00"
    labelJG.text = strRealJG;
    
    iTopY += labelJG.height +5;
    UILabel *labelYuanJG = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 20)];
    [viewBack addSubview:labelYuanJG];
    labelYuanJG.font = [UIFont systemFontOfSize:14];
    labelYuanJG.textColor = [ResourceManager lightGrayColor];
    labelYuanJG.textAlignment = NSTextAlignmentCenter;
    NSString *strOrderJE =  [NSString stringWithFormat:@"%.2f", (float)_fOrderMoney];//@"72.00";
    labelYuanJG.text = strOrderJE;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:strOrderJE];
    NSRange strRange = {0,[strOrderJE length]};
    [str addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    labelYuanJG.attributedText = str;
    
    // 如果优惠价格为0
    if (_fYHMoney <= 0.00000 ||
        _fYHMoney == 0)
     {
        labelYuanJG.hidden = YES;
     }
    
    // 如果优惠价格大于订单的价格
    if (_fYHMoney > _fOrderMoney)
     {
        _fYHMoney = _fOrderMoney;
     }
    
    
    iTopY += labelYuanJG.height +5;
    UILabel *labelCK = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 20)];
    [viewBack addSubview:labelCK];
    labelCK.font = [UIFont systemFontOfSize:14];
    labelCK.textColor = color1;
    labelCK.textAlignment = NSTextAlignmentCenter;
    labelCK.text = @"查看我的客户>>";
    
    // 查看详情
    UIButton *xqBtn = [[UIButton alloc] initWithFrame:labelCK.frame];
    [viewBack addSubview:xqBtn];
    [xqBtn addTarget:self action:@selector(actionCKKH) forControlEvents:UIControlEventTouchUpInside];
    
    //虚线1
    iTopY +=labelCK.height +15;
    UIImageView *imgXu1 = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH-2*iLeftX, 1)];
    [viewBack addSubview:imgXu1];
    imgXu1.image = [UIImage imageNamed:@"light_suess_xuxian"];
    
    iTopY +=15;
    UILabel *labelT1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 100, 20)];
    [viewBack addSubview:labelT1];
    labelT1.font = [UIFont systemFontOfSize:15];
    labelT1.textColor = color1;
    labelT1.textAlignment = NSTextAlignmentLeft;
    labelT1.text = @"抢单优惠";
    
    UILabel *labelV1 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-210, iTopY, 200, 20)];
    [viewBack addSubview:labelV1];
    labelV1.font = [UIFont systemFontOfSize:17];
    labelV1.textColor = [UIColor orangeColor];
    labelV1.textAlignment = NSTextAlignmentRight;
    labelV1.text = [NSString stringWithFormat:@"%.2f", (float)_fYHMoney];//@"-28.00";
    
    
    iTopY += labelT1.height +  10;
    UILabel *labelT2 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 100, 20)];
    [viewBack addSubview:labelT2];
    labelT2.font = [UIFont systemFontOfSize:15];
    labelT2.textColor = color1;
    labelT2.textAlignment = NSTextAlignmentLeft;
    labelT2.text = @"实付金额";
    
    
    UILabel *labelV2 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-210, iTopY, 200, 20)];
    [viewBack addSubview:labelV2];
    labelV2.font = [UIFont systemFontOfSize:17];
    labelV2.textColor = [ResourceManager color_1];
    labelV2.textAlignment = NSTextAlignmentRight;
    labelV2.text = strRealJG;//@"42.00";
    
    //虚线2
    iTopY +=labelT2.height +15;
    UIImageView *imgXu2 = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH-2*iLeftX, 1)];
    [viewBack addSubview:imgXu2];
    imgXu2.image = [UIImage imageNamed:@"light_suess_xuxian"];
    
//    iTopY +=15;
//    UILabel *labelBCZF = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 20)];
//    [viewBack addSubview:labelBCZF];
//    labelBCZF.font = [UIFont systemFontOfSize:14];
//    labelBCZF.textColor = color1;
//    labelBCZF.textAlignment = NSTextAlignmentCenter;
//    labelBCZF.text = @"本次支付获得";
//
//
//    iTopY +=labelBCZF.height + 15;
//    int iViewImgWidth = (SCREEN_WIDTH - 2*iLeftX - 10)/2;
//    int iViewImgHeight = 110;
//    // 底部的左边view
//    UIView *viewLeft = [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iViewImgWidth, iViewImgHeight)];
//    [viewBack addSubview:viewLeft];
//    viewLeft.backgroundColor = UIColorFromRGB(0xfd6f37);
//
//    int iViewTempTop = 15;
//    UILabel *labelLeftView1 = [[UILabel alloc] initWithFrame:CGRectMake(0, iViewTempTop, iViewImgWidth, 20)];
//    [viewLeft addSubview:labelLeftView1];
//    labelLeftView1.font = [UIFont systemFontOfSize:17];
//    labelLeftView1.textColor = [UIColor whiteColor];
//    labelLeftView1.textAlignment = NSTextAlignmentCenter;
//    labelLeftView1.text = @"奖励积分";
//
//    iViewTempTop += labelLeftView1.height + 10;
//    UILabel *labelLeftView2 = [[UILabel alloc] initWithFrame:CGRectMake(0, iViewTempTop, iViewImgWidth, 20)];
//    [viewLeft addSubview:labelLeftView2];
//    labelLeftView2.font = [UIFont systemFontOfSize:17];
//    labelLeftView2.textColor = [UIColor whiteColor];
//    labelLeftView2.textAlignment = NSTextAlignmentCenter;
//    labelLeftView2.text = [NSString stringWithFormat:@"%d积分", _iAddSocre];//@"5积分";
//
//    iViewTempTop += labelLeftView2.height + 10;
//    UIImageView *imgJF = [[UIImageView alloc] initWithFrame:CGRectMake((iViewImgWidth-35)/2, iViewTempTop, 35, 25)];
//    [viewLeft addSubview:imgJF];
//    imgJF.image = [UIImage imageNamed:@"light_suess_jf"];
//
//
//
//
//    // 底部的右边view
//    UIView *viewRight = [[UIView alloc] initWithFrame:CGRectMake(iLeftX + iViewImgWidth + 10, iTopY, iViewImgWidth, iViewImgHeight)];
//    [viewBack addSubview:viewRight];
//    viewRight.backgroundColor = UIColorFromRGB(0xfff8ee);
//    viewRight.layer.borderColor = UIColorFromRGB(0xffce9f).CGColor;
//    viewRight.layer.borderWidth = 1;
//
//    iViewTempTop = 15;
//    labelRightView1 = [[UILabel alloc] initWithFrame:CGRectMake(0, iViewTempTop, iViewImgWidth, 20)];
//    [viewRight addSubview:labelRightView1];
//    labelRightView1.font = [UIFont systemFontOfSize:17];
//    labelRightView1.textColor = [UIColor orangeColor];
//    labelRightView1.textAlignment = NSTextAlignmentCenter;
//    labelRightView1.text = @"分享红包";
//
//    iViewTempTop += labelLeftView1.height + 5;
//    labelRightView2 = [[UILabel alloc] initWithFrame:CGRectMake(0, iViewTempTop, iViewImgWidth, 15)];
//    [viewRight addSubview:labelRightView2];
//    labelRightView2.font = [UIFont systemFontOfSize:14];
//    labelRightView2.textColor = [ResourceManager color_1];
//    labelRightView2.textAlignment = NSTextAlignmentCenter;
//    labelRightView2.text = @"最高可得20元";
//
//    iViewTempTop += labelLeftView2.height;
//    labelRightView3 = [[UILabel alloc] initWithFrame:CGRectMake(0, iViewTempTop, iViewImgWidth, 15)];
//    [viewRight addSubview:labelRightView3];
//    labelRightView3.font = [UIFont systemFontOfSize:14];
//    labelRightView3.textColor = [ResourceManager color_1];
//    labelRightView3.textAlignment = NSTextAlignmentCenter;
//    //labelRightView3.text = @"分享朋友后获得";
//
//    iHongBaoOrder = 1;
//    NSString *strNO = [NSString stringWithFormat:@"%d个", iHongBaoOrder];
//    NSString *strAll1 = [NSString stringWithFormat:@"第%@领红包最大！", strNO];
//    NSRange  rang1 = [strAll1 rangeOfString:strNO];
//
//    NSMutableAttributedString *attrStr1 = [[NSMutableAttributedString alloc] initWithString:strAll1];
//    [attrStr1 addAttribute:NSForegroundColorAttributeName
//                     value:[UIColor orangeColor]
//                     range:rang1];
//    labelRightView3.attributedText = attrStr1;
//
//    iViewTempTop += labelLeftView2.height +3;
//    btnShare = [[UIButton alloc] initWithFrame:CGRectMake((iViewImgWidth-70)/2, iViewTempTop, 70, 22)];
//    [viewRight addSubview:btnShare];
//    btnShare.backgroundColor = UIColorFromRGB(0xfd6f37);
//    [btnShare setTitle:@"发红包" forState:UIControlStateNormal];
//    btnShare.titleLabel.font = [UIFont systemFontOfSize:15];
//
//    [btnShare addTarget:self action:@selector(actionPopShare) forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(void) actionPopShare
{
    [self closeView];
    
    if (iStatus != 0)
     {
        [MBProgressHUD showErrorWithStatus:message toView:self.view];
        return;
     }
    
    [self layoutTail];
}


-(void) actionCKKH
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@(2),@"index":@(0)}];
}


- (void) tapAction{
    //创建一个黑色背景
    //初始化一个用来当做背景的View。我这里为了省时间计算，宽高直接用的5s的尺寸
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    background = bgView;
    bgView.backgroundColor =  [[UIColor blackColor]colorWithAlphaComponent:0.6];//[UIColor clearColor];
    [self.view addSubview:bgView];
    
    int iKuangWdith = 300;
    int iKuangHeight = 250;
    int iKuangTop = 185;
    
    // 创建背景框
    UIImageView *viewKuang = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-iKuangWdith)/2, iKuangTop, iKuangWdith , iKuangHeight ) ];
    [bgView addSubview:viewKuang];
    
    [viewKuang setImage:[UIImage imageNamed:@"shareS_bj"]];
    
    
    
  
    
    
    int iCurTop = 10;
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0,  iCurTop , iKuangWdith, 35)];
    label1.text = @"拼手气红包";
    label1.textAlignment = NSTextAlignmentCenter;
    [viewKuang addSubview:label1];
    label1.textColor = [UIColor whiteColor];
    label1.font = [UIFont systemFontOfSize:26];
    
    iCurTop += label1.height +5;
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, iCurTop, iKuangWdith, 15)];
    
    label2.textAlignment = NSTextAlignmentCenter;
    [viewKuang addSubview:label2];
    label2.textColor = [UIColor whiteColor];
    label2.font = [UIFont systemFontOfSize:15];
    
    NSString *strNO = [NSString stringWithFormat:@"%d个", iHongBaoOrder];
    NSString *strAll1 = [NSString stringWithFormat:@"第%@领红包最大！", strNO];
    NSRange  rang1 = [strAll1 rangeOfString:strNO];
    
    NSMutableAttributedString *attrStr1 = [[NSMutableAttributedString alloc] initWithString:strAll1];
    [attrStr1 addAttribute:NSForegroundColorAttributeName
                    value:[UIColor yellowColor]
                    range:rang1];
    label2.attributedText = attrStr1;
    
    
    
    UIButton * caseBackBtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-iKuangWdith)/2 - 30 , iKuangTop+ iKuangHeight/2,46 * SCREEN_WIDTH/320, 46 * SCREEN_WIDTH/320)];
    [bgView addSubview:caseBackBtn];
    [caseBackBtn setImage:[UIImage imageNamed:@"sharS_jinbi"] forState:UIControlStateNormal];
    caseBackBtn.userInteractionEnabled = NO;
    
    
    

    //初始化要显示的图片内容的imageView
    iCurTop += label2.height + 10;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, iCurTop, iKuangWdith - 2*20 , 160)];
    [viewKuang addSubview:imgView];
    [imgView setImage:[UIImage imageNamed:@"shareS_mid"]];
    
    
    iCurTop = 10;
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, iCurTop, imgView.width, 60)];
    label3.textAlignment = NSTextAlignmentCenter;
    [imgView addSubview:label3];
    label3.textColor = UIColorFromRGB(0xd00202);
    label3.font = [UIFont systemFontOfSize:20];
    
    
    NSString *strMoney = [NSString stringWithFormat:@"%d", iHongBaoPrice];
    NSString *strAll = [NSString stringWithFormat:@"￥%@抢单券", strMoney];
    NSRange  rang = [strAll rangeOfString:strMoney];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:strAll];
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:55]
                    range:rang];
    label3.attributedText = attrStr;
    
    iCurTop = imgView.height/2 + 15;
    UIImageView *imgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(50, iCurTop, imgView.width - 2*50 , 35)];
    [imgView addSubview:imgView2];
    [imgView2 setImage:[UIImage imageNamed:@"shareS_button"]];
    
    
    
    background.userInteractionEnabled = YES;
    //添加点击手势（点击任意地方，分享）
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionShare)];
    [bgView addGestureRecognizer:tapGesture];
    

    
    // 添加退出按钮
    iCurTop = iKuangTop + iKuangHeight + 20;
    UIButton  *btnClose = [[UIButton alloc] initWithFrame:CGRectMake( (SCREEN_WIDTH - 40)/2, iCurTop, 40, 40)];
    [bgView addSubview:btnClose];
    [btnClose setBackgroundImage:[UIImage imageNamed:@"sharS_close"] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)closeView{
    [background removeFromSuperview];
}

-(void)actionShare
{
    
    [self closeView];
    
    if (iStatus != 0)
     {
        [MBProgressHUD showErrorWithStatus:message toView:self.view];
        return;
     }
    
    [self layoutTail];
}

#pragma mark ---- 布局分享按钮
-(void) layoutTail
{
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    background = bgView;
    bgView.backgroundColor =  [[UIColor blackColor]colorWithAlphaComponent:0.6];//[UIColor clearColor];
    [self.view addSubview:bgView];
    
    int iViewTailHeight =  180;
    viewTail = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - iViewTailHeight, SCREEN_WIDTH, iViewTailHeight)];
    viewTail.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewTail];
    viewTail.userInteractionEnabled = YES;
    
    int iTopY = 10;


    
    UIColor *color1 =  UIColorFromRGB(0x4c4c4c);
    UILabel *labelTail1 = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 20)];
    labelTail1.font = [UIFont systemFontOfSize:16];
    labelTail1.textColor = color1;
    labelTail1.text = [NSString stringWithFormat:@"分享到"];
    labelTail1.textAlignment = NSTextAlignmentCenter;
    [viewTail addSubview:labelTail1];
    

    
    iTopY += labelTail1.height;
    int iIMGWdith = 40;
    int iViewWdith = SCREEN_WIDTH/3;
    
    // 微信图片和按钮
    UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(iViewWdith/3, iTopY, iViewWdith, 100)];
    [viewTail addSubview:view1];
    
    UIImageView *imag1 = [[UIImageView alloc] initWithFrame:CGRectMake((iViewWdith-iIMGWdith)/2, 30, iIMGWdith, iIMGWdith)];
    [view1 addSubview:imag1];
    imag1.image = [UIImage imageNamed:@"tihy_weixin"];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 30+iIMGWdith, iViewWdith, 20)];
    label1.font = [UIFont systemFontOfSize:12];
    label1.textColor = color1;
    label1.text = @"微信";
    label1.textAlignment = NSTextAlignmentCenter;
    [view1 addSubview:label1];
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sharWX)];
    [view1 addGestureRecognizer:singleTap];
    
    // 朋友圈图片和按钮
    UIView * view2 = [[UIView alloc] initWithFrame:CGRectMake(iViewWdith/3 + iViewWdith, iTopY, iViewWdith, 100)];
    [viewTail addSubview:view2];
    
    UIImageView *imag2 = [[UIImageView alloc] initWithFrame:CGRectMake((iViewWdith-iIMGWdith)/2, 30, iIMGWdith, iIMGWdith)];
    [view2 addSubview:imag2];
    imag2.image = [UIImage imageNamed:@"tihy_pengyou"];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 30+iIMGWdith, iViewWdith, 20)];
    label2.font = [UIFont systemFontOfSize:12];
    label2.textColor = color1;
    label2.text = @"朋友圈";
    label2.textAlignment = NSTextAlignmentCenter;
    [view2 addSubview:label2];
    
    UITapGestureRecognizer* singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sharPYQ)];
    [view2 addGestureRecognizer:singleTap2];
    
    


    
    // 分割线
    iTopY += view1.height + 5;
    UIView *viewFG1 = [[UIView alloc] initWithFrame:CGRectMake(0 , iTopY, SCREEN_WIDTH,1)];
    viewFG1.backgroundColor = [ResourceManager lightGrayColor];
    [viewTail addSubview:viewFG1];
    
    iTopY +=1;
    UIButton * btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 40)];
    [viewTail addSubview:btnBack];
    [btnBack setTitle:@"取消" forState:UIControlStateNormal];
    [btnBack setTitleColor:color1 forState:UIControlStateNormal];
    btnBack.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnBack addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void) sharWX
{
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]] )
     {
        [MBProgressHUD showErrorWithStatus:@"请先安装微信APP" toView:self.view];
        return;
     }
    
    NSString *url = shareUrl;
    UIImage *image = [UIImage imageNamed:@"shareS_hongbao"];
    if (image && (image.size.width > 100  || image.size.height > 100)) {
        image = [image scaledToSize:CGSizeMake(100, 100*image.size.height/image.size.width)];
    }
    
    // 分享到微信朋友
    DDGShareManager * share = [DDGShareManager shareManager];

    [share weChatShare:@{@"title":shareTitle, @"subTitle":shareContent,@"image":UIImageJPEGRepresentation(image,1.0),@"url": url} shareScene:0 block:^(id result){
        NSDictionary *dic = (NSDictionary *)result;
        if ([[dic objectForKey:@"success"] boolValue]) {
           
            [MBProgressHUD showSuccessWithStatus:@"分享成功" toView:self.view];
            
        }else{
            
            [MBProgressHUD showErrorWithStatus:@"分享失败" toView:self.view];
        }
    }];
}

-(void) sharPYQ
{
    
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]] )
     {
        [MBProgressHUD showErrorWithStatus:@"请先安装微信APP" toView:self.view];
        return;
     }
    
    
    

    
    NSString *url = shareUrl;
    UIImage *image = [UIImage imageNamed:@"shareS_hongbao"];
    if (image && (image.size.width > 100  || image.size.height > 100)) {
        image = [image scaledToSize:CGSizeMake(100, 100*image.size.height/image.size.width)];
    }
    
    // 分享到微信朋友圈
    DDGShareManager * share = [DDGShareManager shareManager];
    
    
    [share weChatShare:@{@"title":shareTitle, @"subTitle":shareContent,@"image":UIImageJPEGRepresentation(image,1.0),@"url": url} shareScene:1 block:^(id result){
        NSDictionary *dic = (NSDictionary *)result;
        if ([[dic objectForKey:@"success"] boolValue]) {
            
            [MBProgressHUD showSuccessWithStatus:@"分享成功" toView:self.view];
        }else{
            [MBProgressHUD showErrorWithStatus:@"分享失败" toView:self.view];
        }
    }];
    
}

-(void)back
{
    
    [self closeView];
    
    [viewTail removeFromSuperview];
}


#pragma mark --- 网络通讯

-(void) getHongbao
{
    iStatus = 1;
    message = @"红包功能暂未启用";
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    NSString *url = kDDGpreShareTicket;
    
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"businessId"] =  _businessId;
    params[@"platform"] = @"IOS";

    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@%@",[PDAPI getBusiUrlString],url]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                      
                                                                                  }failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                      
                                                                                      [self setHongBaoUI];
                                                                                  }];
    [operation start];
    operation.tag = 10212;
}

-(void) shareSucessToWeb:(int) iType
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    NSString *url = kDDGaddShareRecord;
    
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"recordId"] =  recordId;
    params[@"activeType"] =  @(1);
    params[@"shareType"] =  @(iType);
    params[@"platform"] =  @"IOS";
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@%@",[PDAPI getBusiUrlString],url]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [MBProgressHUD showSuccessWithStatus:@"分享成功" toView:self.view];
                                                                                      
                                                                                  }failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      
                                                                                      iStatus = 1;
                                                                                      
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    [operation start];
    operation.tag = 10212;
}

-(void)handleData:(DDGAFHTTPRequestOperation *)operation
{
    
    if (operation.tag == 10212)
     {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        
        NSDictionary *dic = operation.jsonResult.attr;
        
        if ([dic count] > 0)
         {
            iHongBaoOrder = [dic[@"order"] intValue];
            
            iHongBaoPrice  = [dic[@"price"] intValue];
            
            recordId = dic[@"recordId"];
            
            message = operation.jsonResult.message;
            
            iStatus = [dic[@"status"] intValue];
            
            [self setHongBaoUI];
            
            if (iStatus != 1)
             {
                [self tapAction];
             }
            
            NSDictionary *dicShareInfo = dic[@"shareInfo"];
         
            if ([dicShareInfo count] > 0)
             {
                shareUrl = dicShareInfo[@"url"];
                shareTitle = dicShareInfo[@"title"];
                shareContent =  dicShareInfo[@"content"];
             }
         }
        
     }
}

-(void) setHongBaoUI
{
    
    NSString *strPrice = [NSString stringWithFormat:@"%d", iHongBaoPrice];
    NSString *strAll = [NSString stringWithFormat:@"最高可得%@元", strPrice];
    NSRange  rang = [strAll rangeOfString:strPrice];
    
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:strAll];
    [attrStr addAttribute:NSForegroundColorAttributeName
                     value:[UIColor orangeColor]
                     range:rang];
    labelRightView2.attributedText = attrStr;
    
    
    NSString *strNO = [NSString stringWithFormat:@"%d个", iHongBaoOrder];
    NSString *strAll1 = [NSString stringWithFormat:@"第%@领红包最大！", strNO];
    NSRange  rang1 = [strAll1 rangeOfString:strNO];
    
    NSMutableAttributedString *attrStr1 = [[NSMutableAttributedString alloc] initWithString:strAll1];
    [attrStr1 addAttribute:NSForegroundColorAttributeName
                     value:[UIColor orangeColor]
                     range:rang1];
    labelRightView3.attributedText = attrStr1;
    
    if (iStatus != 0)
     {
        labelRightView1.text = @"更多惊喜奖励";
        labelRightView2.text = @"即将推出";
        labelRightView3.text = @"敬请期待";
        btnShare.hidden = YES;
     }
}

@end
