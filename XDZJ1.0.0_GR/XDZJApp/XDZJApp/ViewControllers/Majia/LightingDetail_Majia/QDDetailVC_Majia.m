//
//  QDDetailVC.m
//  XXJR
//
//  Created by xxjr02 on 2017/5/19.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import "QDDetailVC_Majia.h"
#import "CDWAlertView.h"
#import "VIPViewController.h"
#import "CommonInfo.h"
#import "CCWebViewController.h"
#import "LightingPopMessage.h"

@interface QDDetailVC_Majia ()

@end

@implementation QDDetailVC_Majia
{
    DDGAFHTTPRequestOperation *_operation;
    UIScrollView *scView;
    
    UIView *viewHead;            // 头部view
    UIView *viewHead2;           // 头部2view
    UIView *viewKHYY;            // 客户预约view
    UIView *viewJBXX;            // 基本信息view
    UIView *viewXYQK;            // 信用情况view
    UIView *viewZCXX;            // 资产信息view
    UIView *viewRZXX;            // 认证信息view
    UIView *viewMSXX;            // 描述信息view
    
    UIButton *btnApply;          // 抢单（按钮）
    UILabel  *labelZKSS;         // 展开或者收缩的按钮
    UIImageView  *viewZKSS;       // 展开收缩图片
    
    BOOL bISHideKHYY;           // 是否隐藏客户预约
    
    UIView *_aleartView_1;
    UIView *_aleartView_2;
    UIView *_aleartView_3;
    UIView *_aleartView_CS;
    
    RCLabel *_rcLabel_1;
    RCLabel *_rcLabel_2;
    
    NSString *_isVip;        //是否是会员
    BOOL isDiscount;      //是否打折扣  0 - 不打折,  1 -打折
}

@synthesize dataDicionary;
@synthesize applyID;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self layoutWhiteNaviBarViewWithTitle:@"详情"];
    
    if ([[DDGAccountManager sharedManager].userInfo objectForKey:@"isVip"] &&  [NSString stringWithFormat:@"%@",[[DDGAccountManager sharedManager].userInfo objectForKey:@"isVip"]].length > 0) {
        _isVip = [NSString stringWithFormat:@"%@",[[DDGAccountManager sharedManager].userInfo objectForKey:@"isVip"]];
    }
    
    scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.f, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight - 45)];
    scView.backgroundColor = UIColorFromRGB(0xf5f5f5); //设置背景为灰色;
    scView.contentSize = CGSizeMake(0, 1050);
    //关闭翻页效果
    scView.pagingEnabled = NO;
    //隐藏滚动条
    scView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scView];
    
    [self loadData];
    
    //添加手势点击空白处隐藏键盘
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchViewKeyBoard)];
    gesture.numberOfTapsRequired  = 1;
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];
    
    
    NSString *strDiscount = [CommonInfo getKey:K_VIP_DISCOUNT_FLAG];
    if ([strDiscount isEqualToString:@"1"])
     {
        isDiscount = YES;
     }
    else
     {
        isDiscount = NO;
     }
    
    
}


//添加手势点击页面隐藏弹窗
-(void)TouchViewKeyBoard{
    
    _aleartView_1.hidden = YES;
    _aleartView_2.hidden = YES;
    _aleartView_3.hidden = YES;
    _aleartView_CS.hidden = YES;
    
}

-(void)loadData{
    if (_operation) {
        [_operation cancel];
        _operation = nil;
    }
    
    if (!applyID)
     {
        return;
     }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@%@%@",[PDAPI getBaseUrlString],@"mjb/borrow/list/borrowDetail/",applyID]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    operation.tag = 10210;
    _operation = operation;
    [_operation start];
}

-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    NSDictionary *attr =  operation.jsonResult.attr;
    
    NSLog(@"attr:%@" , attr);
    
    if (operation.tag == 10210) {
        
        dataDicionary = attr;
        
        // 布局UI
        [self layoutUI];
        
        NSLog(@"operation.jsonResult.rows:%@", operation.jsonResult.rows);
        
    }else if (operation.tag == 10211){
        // 抢单成功
        [self.navigationController popToRootViewControllerAnimated:NO];
        
        // 发送抢单成功的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:GrabSuccessNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@(3),@"index":@(0)}];
    }
    else if (operation.tag == 10212 ){
        
        [self.navigationController popToRootViewControllerAnimated:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@(3),@"index":@(0)}];
    }
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    if (operation.tag == 10210) {
        
    }
    else if (operation.tag == 10211
            ||operation.tag == 10212){
        
        if (operation.jsonResult.errorCode.intValue == 11006) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
            
           [MBProgressHUD showErrorWithStatus:@"免费抢单已经用完了" toView:self.view];
            
        }else if (operation.jsonResult.errorCode.intValue == 11008){
            [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
            
            SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"提示" andMessage:operation.jsonResult.message];
            [alertView addButtonWithTitle:@"取消"
                                     type:SIAlertViewButtonTypeDefault
                                  handler:^(SIAlertView *alertView) {
                                      
                                  }];
            [alertView addButtonWithTitle:@"确定"
                                     type:SIAlertViewButtonTypeCancel
                                  handler:^(SIAlertView *alertView) {
                                      // 切换到认证页面
                                      [self.navigationController popToRootViewControllerAnimated:NO];
                                      [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@(3),@"index":@(1)}];
                                      
                                  }];
            
            alertView.cornerRadius = 5;
            alertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
            alertView.transitionStyle = SIAlertViewTransitionStyleSlideFromTop;
            [alertView show];
            
        }
        else if ([operation.jsonResult.attr objectForKey:@"threeTime"] && [[operation.jsonResult.attr objectForKey:@"threeTime"] intValue] == 1) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
            //升级会员
            [self _aleartViewUI_1];
        }else{
            [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
        }
    }
    else{
        [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
    }
    
}

-(void)layoutUI
{
    NSLog(@"applyID:%@", applyID);
    
    
    [self layoutHead];
    
    [self layoutKHYY];
    
    [self layoutRZXX];
    
    [self layoutJBXX];
    
    [self layoutZCXX];
    
    [self layoutXYQK];
    
    [self layoutMSXX];
    
    
    // 抢单按钮

    btnApply = [[UIButton alloc]initWithFrame:CGRectMake(0, scView.frame.size.height+ NavHeight, SCREEN_WIDTH, 45)];
    [btnApply setTitle:@"抢单" forState:UIControlStateNormal];
    
    
    int iPrice = [_lightDic[@"price"]  intValue] / 100;
    
    if (iPrice > 0 &&
        ![PDAPI isTestUser])
     {
        NSString *strPrice = [NSString stringWithFormat:@"%d元抢单", iPrice];
        [btnApply setTitle:strPrice forState:UIControlStateNormal];
     }
    if (_freeHour)
     {
        [btnApply setTitle:@"抢单" forState:UIControlStateNormal];
     }
    
    btnApply.titleLabel.font = [UIFont systemFontOfSize:16]; //[UIFont fontWithName:@"STHeitiSC-Light" size:15];
    [btnApply setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    btnApply.backgroundColor = [UIColor whiteColor];
    [btnApply addTarget:self action:@selector(applyAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnApply];
    
    if(_isNotQD)
     {
        [btnApply setTitleColor:[ResourceManager color_5] forState:UIControlStateNormal];
        btnApply.userInteractionEnabled = NO;
     }

    
    // 分割线
    UIView * viewX_1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    viewX_1.backgroundColor = [UIColor orangeColor];
    [btnApply addSubview:viewX_1];
    
}



#pragma mark --- 布局头部
-(void) layoutHead
{
    // 设置头部  begin
    viewHead =  [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, 130)];
    
    // 设置背景为渐变色
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.startPoint = CGPointMake(0, 0);//（0，0）表示从左上角开始变化。默认值是(0.5,0.0)表示从x轴为中间，y为顶端的开始变化
    layer.endPoint = CGPointMake(1, 1);//（1，1）表示到右下角变化结束。默认值是(0.5,1.0)  表示从x轴为中间，y为低端的结束变化
    UIColor *topColor = [UIColor colorWithRed:252.0/255.0 green:128.0/255.0 blue:4.0/255.0 alpha:1];
    UIColor *buttomColor = [UIColor colorWithRed:243.0/255.0 green:104.0/255.0 blue:37.0/255.0 alpha:1];
    layer.colors = [NSArray arrayWithObjects:(id)topColor.CGColor,(id)buttomColor.CGColor, nil];
    layer.frame = viewHead.layer.bounds;
    [viewHead.layer insertSublayer:layer atIndex:0];
    [scView addSubview:viewHead];
    
    int iLeftX = 10;
    int iCurentX = iLeftX;
    int iTopY = 10;
    
    NSDictionary *dicApplyInfo = dataDicionary[@"borrowInfo"];
    NSDictionary *dicBaseInfo = dataDicionary[@"borrowInfo"];
    NSDictionary *dicIncome = dataDicionary[@"borrowInfo"];
    

    
    UILabel  *lableName = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 70, 40)];
    lableName.text = dicApplyInfo[@"realName"];
    // 动态调整文字宽度 begin
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:15]};
    CGSize size=[lableName.text sizeWithAttributes:attrs];
    [lableName setFrame:CGRectMake(iLeftX, iTopY, size.width, 20)];
    // 动态调整文字宽度 end
    lableName.font = [UIFont systemFontOfSize:15];
    lableName.textColor = [UIColor whiteColor];
    [viewHead addSubview:lableName];
    
    iCurentX += size.width + 5;
    UIImageView *viewImage = [[UIImageView alloc] initWithFrame:CGRectMake(iCurentX, iTopY+4, 13, 13)];
    viewImage.image = [UIImage imageNamed:@"dianhua2"];
    [viewHead addSubview:viewImage];
    
    iCurentX += 13 + 5 ;
    UILabel  *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(iCurentX, iTopY, 100, 20)];
    phoneLabel.text = dicApplyInfo[@"telephone"];//@"136****6618";
    phoneLabel.font = [UIFont systemFontOfSize:15];
    phoneLabel.textColor = [UIColor whiteColor];
    [viewHead addSubview:phoneLabel];
    
    // 背景为圆形的lable
    iCurentX = SCREEN_WIDTH - 65;
    UILabel  *lableZhuangtai = [[UILabel alloc] initWithFrame:CGRectMake(iCurentX, iTopY, 45, 45)];
    lableZhuangtai.text = @"待抢单";
    lableZhuangtai.textAlignment = NSTextAlignmentCenter;
    lableZhuangtai.font = [UIFont systemFontOfSize:14];
    lableZhuangtai.textColor = [UIColor orangeColor];
    lableZhuangtai.backgroundColor = [UIColor whiteColor];
    lableZhuangtai.layer.cornerRadius = 45/2;
    lableZhuangtai.layer.masksToBounds = YES; // 设置圆角
    [viewHead addSubview:lableZhuangtai];
    
    iCurentX = iLeftX;
    iTopY = lableName.frame.origin.y + lableName.frame.size.height + 5;
    NSString *strTemp;
//    UILabel  *labelTjr = [[UILabel alloc] initWithFrame:CGRectMake(iCurentX, iTopY, 100, 20)];
//    NSString *strUserName = dicApplyInfo[@"refererName"]? dicApplyInfo[@"refererName"]:@"无";
//    NSString *strTemp = [NSString stringWithFormat:@"推荐人：%@",strUserName];
//    labelTjr.text = strTemp;
//    labelTjr.font = [UIFont systemFontOfSize:13];
//    labelTjr.textColor = [UIColor whiteColor];
//    [viewHead addSubview:labelTjr];
//    
//    iCurentX = iLeftX;
//    iTopY = labelTjr.frame.origin.y + labelTjr.frame.size.height + 5;
    UILabel  *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(iCurentX, iTopY, 200, 40)];
    if (dicBaseInfo[@"locaDesc"])
     {
        cityLabel.text = [NSString stringWithFormat:@"所在城市：%@",dicBaseInfo[@"locaDesc"]];
        
     }

    
    cityLabel.font = [UIFont systemFontOfSize:15];
    cityLabel.textColor = [UIColor whiteColor];
    [viewHead addSubview:cityLabel];
    
    // 设置头部  end
    
    
    
    // 设置头部2  begin
    iTopY = cityLabel.frame.origin.y + cityLabel.frame.size.height + 10;
    viewHead2 =  [[UIView alloc] initWithFrame:CGRectMake(10, iTopY, SCREEN_WIDTH-20, 100)];
    viewHead2.backgroundColor = [UIColor whiteColor];
    viewHead2.layer.cornerRadius = 5; //设置矩形四个圆角半径
    viewHead2.layer.masksToBounds = YES;
    [scView addSubview:viewHead2];
    
    iLeftX = 15;
    iCurentX = iLeftX+5;
    iTopY = 10;
    UIImageView *imageHead2View = [[UIImageView alloc] initWithFrame:CGRectMake(iCurentX, iTopY+3, 14, 14)];
    imageHead2View.image = [UIImage imageNamed:@"sqshijian"];
    [viewHead2 addSubview:imageHead2View];
    
    iCurentX += 15 +5;
    UILabel  *labelSqshijian = [[UILabel alloc] initWithFrame:CGRectMake(iCurentX, iTopY, 300, 20)];
    strTemp = [NSString stringWithFormat:@"申请时间：%@",dicApplyInfo[@"applyTime"]];
    labelSqshijian.text = strTemp;//@"申请时间：2016-07-12  15:11:12";
    labelSqshijian.textAlignment = NSTextAlignmentLeft;
    labelSqshijian.font = [UIFont systemFontOfSize:13];
    labelSqshijian.textColor = UIColorFromRGB(0x666666);
    //labelSqshijian.backgroundColor = [UIColor blueColor];
    [viewHead2 addSubview:labelSqshijian];
    
    // 分割线1
    iTopY = labelSqshijian.frame.origin.y + labelSqshijian.frame.size.height +10;
    UILabel *labelfg1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH -20 -30, 1)];
    labelfg1.backgroundColor = UIColorFromRGB(0xd9d9d9);
    [viewHead2 addSubview:labelfg1];
    
    iTopY = labelfg1.frame.origin.y + labelfg1.frame.size.height +10;
    int iWidth = viewHead2.frame.size.width/3;
    UILabel  *jeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, iWidth, 20)];
    jeLabel.text = [NSString stringWithFormat:@"%@万元",dicBaseInfo[@"loanAmount"]];
    jeLabel.textAlignment = NSTextAlignmentCenter;
    jeLabel.font = [UIFont systemFontOfSize:15];
    jeLabel.textColor = [UIColor orangeColor];
    [viewHead2 addSubview:jeLabel];
    
    UILabel  *labelyueshu = [[UILabel alloc] initWithFrame:CGRectMake(iWidth, iTopY, iWidth, 20)];
    labelyueshu.text = [NSString stringWithFormat:@"%@个月",dicBaseInfo[@"loanDeadline"]];//@"360个月";
    labelyueshu.textAlignment = NSTextAlignmentCenter;
    labelyueshu.font = [UIFont systemFontOfSize:15];
    labelyueshu.textColor = [UIColor orangeColor];
    [viewHead2 addSubview:labelyueshu];
    
    UILabel  *labelYongtuLabel = [[UILabel alloc] initWithFrame:CGRectMake(2*iWidth, iTopY, iWidth, 20)];
    strTemp = [NSString stringWithFormat:@"%@", dicIncome[@"income"]];
    if(!dicIncome[@"income"])
     {
        strTemp = @"暂缺";
     }
    
    labelYongtuLabel.text = strTemp;//@"买车";
    labelYongtuLabel.textAlignment = NSTextAlignmentCenter;
    labelYongtuLabel.font = [UIFont systemFontOfSize:15];
    labelYongtuLabel.textColor = [UIColor orangeColor];
    [viewHead2 addSubview:labelYongtuLabel];
    
    // 分割线2
    UILabel *labelFg2 = [[UILabel alloc] initWithFrame:CGRectMake(iWidth, iTopY, 1, 40)];
    labelFg2.backgroundColor = UIColorFromRGB(0xd9d9d9);
    [viewHead2 addSubview:labelFg2];
    
    // 分割线3
    UILabel *labelFg3 = [[UILabel alloc] initWithFrame:CGRectMake(2*iWidth, iTopY, 1, 40)];
    labelFg3.backgroundColor = UIColorFromRGB(0xd9d9d9);
    [viewHead2 addSubview:labelFg3];
    
    iTopY = labelYongtuLabel.frame.origin.y + labelYongtuLabel.frame.size.height;
    UILabel  *labelTitle1 = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, iWidth, 20)];
    labelTitle1.text = @"贷款金额";
    labelTitle1.textAlignment = NSTextAlignmentCenter;
    labelTitle1.font = [UIFont systemFontOfSize:14];
    labelTitle1.textColor = UIColorFromRGB(0x808080);
    [viewHead2 addSubview:labelTitle1];
    
    UILabel  *labelTitle2 = [[UILabel alloc] initWithFrame:CGRectMake(iWidth, iTopY, iWidth, 20)];
    labelTitle2.text = @"贷款期限";
    labelTitle2.textAlignment = NSTextAlignmentCenter;
    labelTitle2.font = [UIFont systemFontOfSize:14];
    labelTitle2.textColor = UIColorFromRGB(0x808080);
    [viewHead2 addSubview:labelTitle2];
    
    UILabel  *labelTitle3 = [[UILabel alloc] initWithFrame:CGRectMake(2*iWidth, iTopY, iWidth, 20)];
    
    strTemp =  dicIncome[@"showIncome"]?dicIncome[@"showIncome"]:@"月收入";
    labelTitle3.text = strTemp;
    labelTitle3.textAlignment = NSTextAlignmentCenter;
    labelTitle3.font = [UIFont systemFontOfSize:14];
    labelTitle3.textColor = UIColorFromRGB(0x808080);
    [viewHead2 addSubview:labelTitle3];
    // 设置头部2  end
}

#pragma mark --- 布局客户预约时间
-(void) layoutKHYY
{
    NSDictionary *dicBaseInfo = dataDicionary[@"baseInfo"];
    if (dicBaseInfo[@"contactTime"] && ((NSString*)dicBaseInfo[@"contactTime"]).length >0)
     {
        bISHideKHYY = NO;
     }
    else
     {
        bISHideKHYY = YES;
     }
    
    if(bISHideKHYY)
     {
        return;
     }
    
    
    int iTop = viewHead2.frame.origin.y + viewHead2.frame.size.height + 10;
    viewKHYY =  [[UIView alloc] initWithFrame:CGRectMake(0, iTop, SCREEN_WIDTH, 40)];
    viewKHYY.backgroundColor = UIColorFromRGB(0xfaab22);
    [scView addSubview:viewKHYY];
    
    UIImageView *viewImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 18, 18)];
    viewImage.image = [UIImage imageNamed:@"kehuyy"];
    [viewKHYY addSubview:viewImage];
    
    UILabel  *labelTitle1 = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 300, 20)];
    NSString *strTemp = [NSString stringWithFormat:@"联系客户时间：%@", dicBaseInfo[@"contactTime"]];
    labelTitle1.text = strTemp;
    labelTitle1.textAlignment = NSTextAlignmentLeft;
    labelTitle1.font = [UIFont systemFontOfSize:15];
    labelTitle1.textColor = [UIColor whiteColor];
    [viewKHYY addSubview:labelTitle1];
    
}

#pragma mark --- 布局认证信息
-(void) layoutRZXX
{
    NSDictionary *dicBaseInfo = dataDicionary[@"borrowInfo"];     // 基本信息
    int  authStatus = [dicBaseInfo[@"authStatus"] intValue];
    
    if (authStatus == 0)
     {
        return;
     }
    
    int iTopY = 0;
    int iLeftX = 10;
    
    if (bISHideKHYY)
     {
        iTopY = viewHead2.frame.origin.y + viewHead2.frame.size.height + 10;
     }
    else
     {
        iTopY = viewKHYY.frame.origin.y + viewKHYY.frame.size.height + 10;
     }
    

    viewRZXX = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 200)];
    viewRZXX.backgroundColor = [UIColor whiteColor];
    [scView addSubview: viewRZXX];
    
    iTopY = 10;
    UIImageView *viewImage = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 13, 17)];
    viewImage.image = [UIImage imageNamed:@"yzd_rz"];
    [viewRZXX addSubview:viewImage];
    
    UILabel  *labelTitle1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX+20, iTopY, 100, 20)];
    labelTitle1.text = @"认证信息";
    labelTitle1.textAlignment = NSTextAlignmentLeft;
    labelTitle1.font = [UIFont systemFontOfSize:15];
    labelTitle1.textColor = [UIColor blackColor];
    [viewRZXX addSubview:labelTitle1];
    
    // 分割线1
    iTopY = labelTitle1.frame.origin.y + labelTitle1.frame.size.height +5;
    UILabel *labelfg1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH -20, 1)];
    labelfg1.backgroundColor = UIColorFromRGB(0xd9d9d9);
    [viewRZXX addSubview:labelfg1];
    
    iTopY +=labelfg1.height + 10;
    
    
    int iImgWidth = SCREEN_WIDTH/4;
    int iImgLetfX = 0;
    //if (1 == cardNoIdentify)
    NSArray *arrKeyName = @[@"cardNoIdentify",@"socialIdentify",@"fundIdentify",@"chsiIdentify",@"jdIdentify"];
    NSArray *arrImgName = @[@"MXApprove-SFRZ",@"MXapprove_SBRZ",@"MX_GJJRZ",@"MXApprove-XXWRZ",@"MXApprove-JDRZ"];
    NSArray *arrImgTitle = @[@"身份认证",@"社保认证",@"公积金认证",@"学信网认证",@"京东认证"];
    int iRealNo = -1;
    for (int i = 0;  i < [arrKeyName count]; i++)
     {
        
        int iValueTemp  = [dicBaseInfo[arrKeyName[i]] intValue];
        if (iValueTemp == 0)
            continue;
        
        iRealNo++;
        
        
        iImgLetfX  = (iRealNo%4) * iImgWidth;
        
        if (iRealNo %4 == 0 &&
            iRealNo != 0)
         {
            iTopY += 80;
            iImgLetfX = 0;
         }
        
        int iImgCenterWidth = 35;
        int iImgCenterLeft = iImgLetfX + (iImgWidth - iImgCenterWidth)/2;
        UIImageView *imgTemp = [[UIImageView alloc] initWithFrame:CGRectMake(iImgCenterLeft, iTopY, iImgCenterWidth, iImgCenterWidth)];
        [viewRZXX addSubview:imgTemp];
        imgTemp.image = [UIImage imageNamed:arrImgName[i]];
        
        UILabel *labelTemp = [[UILabel alloc] initWithFrame:CGRectMake(iImgLetfX, iTopY + iImgCenterWidth + 5, iImgWidth, 20)];
        [viewRZXX addSubview:labelTemp];
        labelTemp.textColor = UIColorFromRGB(0x4d4d4d);
        labelTemp.font = [UIFont systemFontOfSize:14];
        labelTemp.text = arrImgTitle[i];
        labelTemp.textAlignment = NSTextAlignmentCenter;
     }
    
    iTopY += 80;
    UILabel *labelfg2 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH -20, 1)];
    labelfg2.backgroundColor = UIColorFromRGB(0xd9d9d9);
    [viewRZXX addSubview:labelfg2];
    
    iTopY += 10;
    UILabel  *labelTitle2 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2*iLeftX, 20)];
    labelTitle2.text = @"抢单后可查看该客户更多认证信息";
    labelTitle2.textAlignment = NSTextAlignmentCenter;
    labelTitle2.font = [UIFont systemFontOfSize:14];
    labelTitle2.textColor = UIColorFromRGB(0x808080);
    [viewRZXX addSubview:labelTitle2];
    
    iTopY += 30;
    viewRZXX.height = iTopY;
    
    
}

#pragma mark --- 布局基本信息
-(void) layoutJBXX
{
    NSDictionary *dicBaseInfo = dataDicionary[@"borrowInfo"];
    NSDictionary *dicIncome = dataDicionary[@"borrowInfo"];
    
    int iTopY = 0;
    int iLeftX = 10;
    
    
    int  authStatus = [dicBaseInfo[@"authStatus"] intValue];
    if (authStatus == 1)
     {
        iTopY = viewRZXX.frame.origin.y + viewRZXX.frame.size.height + 10 ;
     }
    else
     {
        if (bISHideKHYY)
         {
            iTopY = viewHead2.frame.origin.y + viewHead2.frame.size.height + 10;
         }
        else
         {
            iTopY = viewKHYY.frame.origin.y + viewKHYY.frame.size.height + 10;
         }
     }
    
    viewJBXX = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 160)];
    viewJBXX.backgroundColor = [UIColor whiteColor];
    [scView addSubview:viewJBXX];
    
    iTopY = 10;
    UIImageView *viewImage = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY+2, 13, 15)];
    viewImage.image = [UIImage imageNamed:@"yzd_jbxx"];
    [viewJBXX addSubview:viewImage];
    
    UILabel  *labelTitle1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX + 20, iTopY, 100, 20)];
    labelTitle1.text = @"基本信息";
    labelTitle1.textAlignment = NSTextAlignmentLeft;
    labelTitle1.font = [UIFont systemFontOfSize:15];
    labelTitle1.textColor = [UIColor blackColor];
    [viewJBXX addSubview:labelTitle1];
    
    // 分割线1
    iTopY = labelTitle1.frame.origin.y + labelTitle1.frame.size.height +5;
    UILabel *labelfg1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH -20, 1)];
    labelfg1.backgroundColor = UIColorFromRGB(0xd9d9d9);
    [viewJBXX addSubview:labelfg1];
    

    CGRect frameTemp = CGRectMake(iLeftX, iTopY, 150, 15);
    UIFont * fontTemp = [UIFont systemFontOfSize:14];
    UIColor *color1 = UIColorFromRGB(0x808080);
    UIColor *color2 = UIColorFromRGB(0x4d4d4d);
    
    iTopY += 15;
    frameTemp = CGRectMake(iLeftX, iTopY, 150, 15);
    [self addLableToView:viewJBXX andFrame:frameTemp andString:@"是否有社保" andColor:color1 andFont:fontTemp];
    
    frameTemp = CGRectMake(iLeftX+150, iTopY, SCREEN_WIDTH - (iLeftX + 150 +10), 15);
    NSString *nstrSB =  [[dicBaseInfo objectForKey:@"socialType"] intValue] == 1?@"有社保":@"无社保";
    [self addLableToView:viewJBXX andFrame:frameTemp andString:nstrSB andColor:color2 andFont:fontTemp];
    
    iTopY += 25 ;
    frameTemp = CGRectMake(iLeftX, iTopY, 150, 15);
    [self addLableToView:viewJBXX andFrame:frameTemp andString:@"是否有公积金" andColor:color1 andFont:fontTemp];
    
    NSString *nstrGJJ =  [[dicBaseInfo objectForKey:@"fundType"] intValue] == 1?@"有公积金":@"无公积金";
    frameTemp = CGRectMake(iLeftX+150, iTopY, SCREEN_WIDTH - (iLeftX + 150 +10), 15);
    [self addLableToView:viewJBXX andFrame:frameTemp andString:nstrGJJ andColor:color2 andFont:fontTemp];
    
    
    iTopY += 25;
    frameTemp = CGRectMake(iLeftX, iTopY, 150, 15);
    [self addLableToView:viewJBXX andFrame:frameTemp andString:@"微粒贷额度" andColor:color1 andFont:fontTemp];
    
    
    NSString *strTemp = dicBaseInfo[@"haveWeiLiText"];
    frameTemp = CGRectMake(iLeftX+150, iTopY, SCREEN_WIDTH - (iLeftX + 150 +10), 15);
    if (strTemp.length <= 0)
     {
        strTemp = @"未知";
     }
    [self addLableToView:viewJBXX andFrame:frameTemp andString:strTemp andColor:color2 andFont:fontTemp];
    
    iTopY += 25 ;
    frameTemp = CGRectMake(iLeftX, iTopY, 150, 15);
    [self addLableToView:viewJBXX andFrame:frameTemp andString:@"职业身份" andColor:color1 andFont:fontTemp];
    
    frameTemp = CGRectMake(iLeftX+150, iTopY, SCREEN_WIDTH - (iLeftX + 150 +10), 15);
    strTemp = [NSString stringWithFormat:@"%@", dicBaseInfo[@"workTypeName"]];
    [self addLableToView:viewJBXX andFrame:frameTemp andString:strTemp andColor:color2 andFont:fontTemp];
    
    iTopY += 25 ;
    frameTemp = CGRectMake(iLeftX, iTopY, 150, 15);
    strTemp = dicIncome[@"showIncome"]?dicIncome[@"showIncome"]:@"月收入";
    [self addLableToView:viewJBXX andFrame:frameTemp andString:strTemp andColor:color1 andFont:fontTemp];
    
    frameTemp = CGRectMake(iLeftX+150, iTopY, SCREEN_WIDTH - (iLeftX + 150 +10), 15);
    strTemp = dicIncome[@"income"];
    if(!dicIncome[@"income"])
     {
        strTemp = @"未知";
     }
    [self addLableToView:viewJBXX andFrame:frameTemp andString:strTemp andColor:color2 andFont:fontTemp];
    
    
    
    strTemp = dicIncome[@"wagesType"];
    if ( strTemp &&
        ![strTemp isEqualToString:@""])
     {
        iTopY += 25 ;
        frameTemp = CGRectMake(iLeftX, iTopY, 150, 15);
        [self addLableToView:viewJBXX andFrame:frameTemp andString:@"工资发放形式" andColor:color1 andFont:fontTemp];
        
        frameTemp = CGRectMake(iLeftX+150, iTopY, SCREEN_WIDTH - (iLeftX + 150 +10), 15);
        [self addLableToView:viewJBXX andFrame:frameTemp andString:strTemp andColor:color2 andFont:fontTemp];
     }
    
    //workType: 1自由职业 2企业主 3个体户 4上班族
    int iWorkType = [dicBaseInfo[@"workType"] intValue];
    if(4 == iWorkType)
     {
        strTemp = dicIncome[@"jobMonth"];
        if (strTemp.length > 0)
         {
            iTopY += 25 ;
            frameTemp = CGRectMake(iLeftX, iTopY, 150, 15);
            [self addLableToView:viewJBXX andFrame:frameTemp andString:@"单位工龄" andColor:color1 andFont:fontTemp];
            
            frameTemp = CGRectMake(iLeftX+150, iTopY, SCREEN_WIDTH - (iLeftX + 150 +10), 15);
            [self addLableToView:viewJBXX andFrame:frameTemp andString:strTemp andColor:color2 andFont:fontTemp];
         }
        
        strTemp = dicIncome[@"cmpType"];
        if (strTemp.length > 0)
         {
            iTopY += 25 ;
            frameTemp = CGRectMake(iLeftX, iTopY, 150, 15);
            [self addLableToView:viewJBXX andFrame:frameTemp andString:@"公司性质" andColor:color1 andFont:fontTemp];
            
            frameTemp = CGRectMake(iLeftX+150, iTopY, SCREEN_WIDTH - (iLeftX + 150 +10), 15);
            [self addLableToView:viewJBXX andFrame:frameTemp andString:strTemp andColor:color2 andFont:fontTemp];
         }
     }
    
    //workType: 1自由职业 2企业主 3个体户 4上班族
    if(2 == iWorkType||
       3== iWorkType)
     {
        strTemp = dicIncome[@"hasLicenseText"];
        if (strTemp.length > 0)
         {
            iTopY += 25 ;
            frameTemp = CGRectMake(iLeftX, iTopY, 150, 15);
            [self addLableToView:viewJBXX andFrame:frameTemp andString:@"营业执照" andColor:color1 andFont:fontTemp];
            
            frameTemp = CGRectMake(iLeftX+150, iTopY, SCREEN_WIDTH - (iLeftX + 150 +10), 15);
            [self addLableToView:viewJBXX andFrame:frameTemp andString:strTemp andColor:color2 andFont:fontTemp];
         }
        
        strTemp = dicIncome[@"myLicenseText"];
        if (strTemp.length > 0)
         {
            iTopY += 25 ;
            frameTemp = CGRectMake(iLeftX, iTopY, 150, 15);
            [self addLableToView:viewJBXX andFrame:frameTemp andString:@"营业执照是否本人名下" andColor:color1 andFont:fontTemp];
            
            frameTemp = CGRectMake(iLeftX+150, iTopY, SCREEN_WIDTH - (iLeftX + 150 +10), 15);
            [self addLableToView:viewJBXX andFrame:frameTemp andString:strTemp andColor:color2 andFont:fontTemp];
         }
     }
    
    
//    iTopY += 25 ;
//    frameTemp = CGRectMake(iLeftX, iTopY, 150, 15);
//    [self addLableToView:viewJBXX andFrame:frameTemp andString:@"是否有社保" andColor:color1 andFont:fontTemp];
//
//    frameTemp = CGRectMake(iLeftX+150, iTopY, SCREEN_WIDTH - (iLeftX + 150 +10), 15);
//    NSString *nstrSB =  [[dicBaseInfo objectForKey:@"socialType"] intValue] == 1?@"有社保":@"无社保";
//    [self addLableToView:viewJBXX andFrame:frameTemp andString:nstrSB andColor:color2 andFont:fontTemp];
//
//    iTopY += 25 ;
//    frameTemp = CGRectMake(iLeftX, iTopY, 150, 15);
//    [self addLableToView:viewJBXX andFrame:frameTemp andString:@"是否有公积金" andColor:color1 andFont:fontTemp];
//
//    NSString *nstrGJJ =  [[dicBaseInfo objectForKey:@"fundType"] intValue] == 1?@"有公积金":@"无公积金";
//    frameTemp = CGRectMake(iLeftX+150, iTopY, SCREEN_WIDTH - (iLeftX + 150 +10), 15);
//    [self addLableToView:viewJBXX andFrame:frameTemp andString:nstrGJJ andColor:color2 andFont:fontTemp];
    
    NSString *strEducation = dicBaseInfo[@"education"];
    if (strEducation.length > 0)
     {
        iTopY += 25 ;
        frameTemp = CGRectMake(iLeftX, iTopY, 150, 15);
        [self addLableToView:viewJBXX andFrame:frameTemp andString:@"最高学历" andColor:color1 andFont:fontTemp];
        
        frameTemp = CGRectMake(iLeftX+150, iTopY, SCREEN_WIDTH - (iLeftX + 150 +10), 15);
        [self addLableToView:viewJBXX andFrame:frameTemp andString:strEducation andColor:color2 andFont:fontTemp];
     }
    
   
    int iAge = [dicBaseInfo[@"age"] intValue];
    if (iAge > 0)
     {
         NSString *strAge =   [NSString stringWithFormat:@"%d岁", iAge];
        iTopY += 25 ;
        frameTemp = CGRectMake(iLeftX, iTopY, 150, 15);
        [self addLableToView:viewJBXX andFrame:frameTemp andString:@"年龄" andColor:color1 andFont:fontTemp];
        
        frameTemp = CGRectMake(iLeftX+150, iTopY, SCREEN_WIDTH - (iLeftX + 150 +10), 15);
        [self addLableToView:viewJBXX andFrame:frameTemp andString:strAge andColor:color2 andFont:fontTemp];
     }
    
    
    // 调整viewJBXX 大小
    CGRect rectTemp = viewJBXX.frame;
    rectTemp.size.height = iTopY +30;
    viewJBXX.frame = rectTemp;
}



#pragma mark --- 布局资产信息
-(void) layoutZCXX
{
    NSDictionary *dicBaseInfo = dataDicionary[@"borrowInfo"];     // 基本信息
    
    int iTopY = 0;
    int iLeftX = 10;
    NSString *strTemp = @"";
    
    iTopY = viewJBXX.frame.origin.y + viewJBXX.frame.size.height   + 10;
    viewZCXX = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 350-100)];
    viewZCXX.backgroundColor = [UIColor whiteColor];
    [scView addSubview: viewZCXX];
    
    iTopY = 10;
    UIImageView *viewImage = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY+2, 13, 16)];
    viewImage.image = [UIImage imageNamed:@"yzd_zc"];
    [viewZCXX addSubview:viewImage];
    
    UILabel  *labelTitle1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX+20, iTopY, 200, 20)];
    NSString *strlable = @"资产信息 ";

    labelTitle1.text = strlable;
    labelTitle1.textAlignment = NSTextAlignmentLeft;
    labelTitle1.font = [UIFont systemFontOfSize:15];
    labelTitle1.textColor = [UIColor blackColor];
    [viewZCXX addSubview:labelTitle1];
    

    
    // 分割线1
    iTopY = labelTitle1.frame.origin.y + labelTitle1.frame.size.height +5;
    UILabel *labelfg1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH -20, 1)];
    labelfg1.backgroundColor = UIColorFromRGB(0xd9d9d9);
    [viewZCXX addSubview:labelfg1];
    
    
    iTopY += 15;
    CGRect frameTemp = CGRectMake(iLeftX, iTopY, 150, 15);
    UIFont * font1 = [UIFont systemFontOfSize:14];
    UIFont * font2 = [UIFont systemFontOfSize:14];
    UIColor *color1 = UIColorFromRGB(0x808080);
    UIColor *color2 = UIColorFromRGB(0x4d4d4d);
    [self addLableToView:viewZCXX andFrame:frameTemp andString:@"房产信息" andColor:color1 andFont:font1];
    
    frameTemp = CGRectMake(iLeftX+150, iTopY, SCREEN_WIDTH - (iLeftX + 150 +10), 15);
    strTemp = [dicBaseInfo objectForKey:@"houseType"];
    if (strTemp.length <= 0)
     {
        strTemp = @"未知";
     }
    [self addLableToView:viewZCXX andFrame:frameTemp andString:strTemp andColor:color2 andFont:font2];
    
    
    int iHouseMonthPay = [dicBaseInfo[@"houseMonthPay"] intValue];
    if (iHouseMonthPay > 0)
     {
        strTemp = dicBaseInfo[@"houseMonthPay"];//[NSString stringWithFormat:@"%d元", iHouseMonthPay];
        iTopY += 25 ;
        frameTemp = CGRectMake(iLeftX, iTopY, 150, 15);
        [self addLableToView:viewZCXX andFrame:frameTemp andString:@"每月房贷" andColor:color1 andFont:font1];
        
        frameTemp = CGRectMake(iLeftX+150, iTopY, SCREEN_WIDTH - (iLeftX + 150 +10), 15);
        [self addLableToView:viewZCXX andFrame:frameTemp andString:strTemp andColor:color2 andFont:font2];
     }
    
    int iHouseMonth = [dicBaseInfo[@"houseMonth"] intValue];
    if (iHouseMonth > 0)
     {
        strTemp = dicBaseInfo[@"houseMonth"];//[NSString stringWithFormat:@"%d元", iHouseMonthPay];
        iTopY += 25 ;
        frameTemp = CGRectMake(iLeftX, iTopY, 150, 15);
        [self addLableToView:viewZCXX andFrame:frameTemp andString:@"房供时长(月)" andColor:color1 andFont:font1];
        
        frameTemp = CGRectMake(iLeftX+150, iTopY, SCREEN_WIDTH - (iLeftX + 150 +10), 15);
        [self addLableToView:viewZCXX andFrame:frameTemp andString:strTemp andColor:color2 andFont:font2];
     }
    
    
    NSString *strHousePlace = dicBaseInfo[@"housePlace"];
    if (strHousePlace.length > 0)
     {
        iTopY += 25 ;
        frameTemp = CGRectMake(iLeftX, iTopY, 150, 15);
        [self addLableToView:viewZCXX andFrame:frameTemp andString:@"房产位置" andColor:color1 andFont:font1];
        
        frameTemp = CGRectMake(iLeftX+150, iTopY, SCREEN_WIDTH - (iLeftX + 150 +10), 15);
        [self addLableToView:viewZCXX andFrame:frameTemp andString:strHousePlace andColor:color2 andFont:font2];
     }
    
    NSString *strMyLoanHouseText = dicBaseInfo[@"myLoanHouseText"];
    if (strMyLoanHouseText.length > 0)
     {
        iTopY += 25 ;
        frameTemp = CGRectMake(iLeftX, iTopY, 150, 15);
        [self addLableToView:viewZCXX andFrame:frameTemp andString:@"是否主贷人" andColor:color1 andFont:font1];
        
        frameTemp = CGRectMake(iLeftX+150, iTopY, SCREEN_WIDTH - (iLeftX + 150 +10), 15);
        [self addLableToView:viewZCXX andFrame:frameTemp andString:strMyLoanHouseText andColor:color2 andFont:font2];
     }
    
    
    iTopY += 25 ;
    frameTemp = CGRectMake(iLeftX, iTopY, 150, 15);
    strTemp = [dicBaseInfo objectForKey:@"carType"];
    if (strTemp.length <= 0)
     {
        strTemp = @"未知";
     }
    [self addLableToView:viewZCXX andFrame:frameTemp andString:@"车产信息" andColor:color1 andFont:font1];
    
    frameTemp = CGRectMake(iLeftX+150, iTopY, SCREEN_WIDTH - (iLeftX + 150 +10), 15);
    [self addLableToView:viewZCXX andFrame:frameTemp andString:strTemp andColor:color2 andFont:font2];
    
    
    int iCarMonthPay = [dicBaseInfo[@"carMonthPay"] intValue];
    if (iCarMonthPay > 0)
     {
        strTemp = dicBaseInfo[@"carMonthPay"];//[NSString stringWithFormat:@"%d元", iCarMonthPay];
        iTopY += 25 ;
        frameTemp = CGRectMake(iLeftX, iTopY, 150, 15);
        [self addLableToView:viewZCXX andFrame:frameTemp andString:@"每月车贷" andColor:color1 andFont:font1];
        
        frameTemp = CGRectMake(iLeftX+150, iTopY, SCREEN_WIDTH - (iLeftX + 150 +10), 15);
        [self addLableToView:viewZCXX andFrame:frameTemp andString:strTemp andColor:color2 andFont:font2];
     }
    
    int icarMonth = [dicBaseInfo[@"carMonth"] intValue];
    if (icarMonth > 0)
     {
        strTemp = dicBaseInfo[@"carMonth"];//[NSString stringWithFormat:@"%d元", iHouseMonthPay];
        iTopY += 25 ;
        frameTemp = CGRectMake(iLeftX, iTopY, 150, 15);
        [self addLableToView:viewZCXX andFrame:frameTemp andString:@"车供时长(月)" andColor:color1 andFont:font1];
        
        frameTemp = CGRectMake(iLeftX+150, iTopY, SCREEN_WIDTH - (iLeftX + 150 +10), 15);
        [self addLableToView:viewZCXX andFrame:frameTemp andString:strTemp andColor:color2 andFont:font2];
     }
    
    NSString *strCarLocal = dicBaseInfo[@"carLocal"];
    if (strCarLocal.length > 0)
     {
        iTopY += 25 ;
        frameTemp = CGRectMake(iLeftX, iTopY, 150, 15);
        [self addLableToView:viewZCXX andFrame:frameTemp andString:@"车牌所在地" andColor:color1 andFont:font1];
        
        frameTemp = CGRectMake(iLeftX+150, iTopY, SCREEN_WIDTH - (iLeftX + 150 +10), 15);
        [self addLableToView:viewZCXX andFrame:frameTemp andString:strCarLocal andColor:color2 andFont:font2];
     }

    iTopY += 25 ;
    frameTemp = CGRectMake(iLeftX, iTopY, 150, 15);
    [self addLableToView:viewZCXX andFrame:frameTemp andString:@"保险信息" andColor:color1 andFont:font1];
    
    frameTemp = CGRectMake(iLeftX+150, iTopY, SCREEN_WIDTH - (iLeftX + 150 +10), 15);
    strTemp = [dicBaseInfo objectForKey:@"insurType"];
    if (strTemp.length <= 0)
     {
        strTemp = @"未知";
     }
    [self addLableToView:viewZCXX andFrame:frameTemp andString:strTemp andColor:color2 andFont:font2];
    
    int iInsurMonth = [dicBaseInfo[@"insurMonth"] intValue];
    if (iInsurMonth > 0)
     {
        strTemp = dicBaseInfo[@"insurMonth"];//[NSString stringWithFormat:@"%d个月", iInsurMonth];
        iTopY += 25 ;
        frameTemp = CGRectMake(iLeftX, iTopY, 150, 15);
        [self addLableToView:viewZCXX andFrame:frameTemp andString:@"已交月份" andColor:color1 andFont:font1];
        
        frameTemp = CGRectMake(iLeftX+150, iTopY, SCREEN_WIDTH - (iLeftX + 150 +10), 15);
        [self addLableToView:viewZCXX andFrame:frameTemp andString:strTemp andColor:color2 andFont:font2];
     }
    
    int iInsurMonthAmt = [dicBaseInfo[@"insurMonthAmt"] intValue];
    if (iInsurMonthAmt > 0)
     {
        strTemp = dicBaseInfo[@"insurMonthAmt"];//[NSString stringWithFormat:@"%d元", iInsurMonthAmt];
        iTopY += 25 ;
        frameTemp = CGRectMake(iLeftX, iTopY, 150, 15);
        [self addLableToView:viewZCXX andFrame:frameTemp andString:@"每月保费" andColor:color1 andFont:font1];
        
        frameTemp = CGRectMake(iLeftX+150, iTopY, SCREEN_WIDTH - (iLeftX + 150 +10), 15);
        [self addLableToView:viewZCXX andFrame:frameTemp andString:strTemp andColor:color2 andFont:font2];
     }
    
    // 调整viewZCXX 大小
    CGRect rectTemp = viewZCXX.frame;
    rectTemp.size.height = iTopY +30;
    viewZCXX.frame = rectTemp;
    
    
    // 再底部加一个灰色的分割条
    iTopY = CGRectGetMaxY(viewZCXX.frame);
    UIView * viewAddFG = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 10)];
    viewAddFG.backgroundColor = UIColorFromRGB(0xf5f5f5); //设置背景为灰色;
    [scView addSubview:viewAddFG];
    
}


#pragma mark --- 布局其他信息
-(void) layoutXYQK
{
    NSDictionary *dicBaseInfo = dataDicionary[@"borrowInfo"];     // 基本信息
    
    int iTopY = 0;
    int iLeftX = 10;
    
    iTopY = viewZCXX.frame.origin.y + viewZCXX.frame.size.height + 10;
    viewXYQK = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 350-100)];
    viewXYQK.backgroundColor = [UIColor whiteColor];
    [scView addSubview: viewXYQK];
    
    iTopY = 10;
    UIImageView *viewImage = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY+2, 13, 16)];
    viewImage.image = [UIImage imageNamed:@"yzd_xyqk"];
    [viewXYQK addSubview:viewImage];
    
    UILabel  *labelTitle1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX+20, iTopY, 200, 20)];
    NSString *strlable = @"其他信息";
    
    labelTitle1.text = strlable;
    labelTitle1.textAlignment = NSTextAlignmentLeft;
    labelTitle1.font = [UIFont systemFontOfSize:15];
    labelTitle1.textColor = [UIColor blackColor];
    [viewXYQK addSubview:labelTitle1];
    
    // 分割线1
    iTopY = labelTitle1.frame.origin.y + labelTitle1.frame.size.height +5;
    UILabel *labelfg1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH -20, 1)];
    labelfg1.backgroundColor = UIColorFromRGB(0xd9d9d9);
    [viewXYQK addSubview:labelfg1];
    
    
    CGRect frameTemp = CGRectMake(iLeftX, iTopY, 150, 15);
    UIFont * font1 = [UIFont systemFontOfSize:14];
    UIFont * font2 = [UIFont systemFontOfSize:14];
    UIColor *color1 = UIColorFromRGB(0x808080);
    UIColor *color2 = UIColorFromRGB(0x4d4d4d);
    
    NSString *strCreditType = dicBaseInfo[@"creditType"];
    if (strCreditType.length <= 0)
     {
        strCreditType = @"未知";
     }

    iTopY += 15 ;
    frameTemp = CGRectMake(iLeftX, iTopY, 150, 15);
    [self addLableToView:viewXYQK andFrame:frameTemp andString:@"征信情况" andColor:color1 andFont:font1];
    
    frameTemp = CGRectMake(iLeftX+150, iTopY, SCREEN_WIDTH - (iLeftX + 150 +10), 15);
    [self addLableToView:viewXYQK andFrame:frameTemp andString:strCreditType andColor:color2 andFont:font2];
    
    
    
    
//    iTopY += 25;
//    frameTemp = CGRectMake(iLeftX, iTopY, 150, 15);
//    [self addLableToView:viewXYQK andFrame:frameTemp andString:@"微粒贷额度" andColor:color1 andFont:font1];
//
//
//    NSString *strTemp = dicBaseInfo[@"haveWeiLiText"];
//    frameTemp = CGRectMake(iLeftX+150, iTopY, SCREEN_WIDTH - (iLeftX + 150 +10), 15);
//    if (strTemp.length <= 0)
//     {
//        strTemp = @"未知";
//     }
//    [self addLableToView:viewXYQK andFrame:frameTemp andString:strTemp andColor:color2 andFont:font2];
    
    
    iTopY += 25 ;
    frameTemp = CGRectMake(iLeftX, iTopY, 150, 15);
    [self addLableToView:viewXYQK andFrame:frameTemp andString:@"芝麻信用" andColor:color1 andFont:font1];
    
    int iZhiMa = [dicBaseInfo[@"zimaScore"] intValue];
    NSString *strTemp = @"未知";
    if (iZhiMa > 0)
     {
        strTemp  = [NSString stringWithFormat:@"%d分",iZhiMa];
        strTemp =  dicBaseInfo[@"zimaScoreText"];
     }
    frameTemp = CGRectMake(iLeftX+150, iTopY, SCREEN_WIDTH - (iLeftX + 150 +10), 15);
    [self addLableToView:viewXYQK andFrame:frameTemp andString:strTemp andColor:color2 andFont:font2];
    
    
    // 调整viewXYQK 大小
    CGRect rectTemp = viewXYQK.frame;
    rectTemp.size.height = iTopY +30;
    viewXYQK.frame = rectTemp;
    
    
    
}


#pragma mark --- 布局描述信息
-(void) layoutMSXX
{
    NSDictionary *dicBaseInfo = dataDicionary[@"borrowInfo"];     // 基本信息
    int iTopY = 0;
    int iLeftX = 10;
    
    if (viewMSXX)
     {
        viewMSXX.hidden = YES;
     }
    
    iTopY = viewXYQK.frame.origin.y + viewXYQK.frame.size.height + 10 ;
    
    
    
    viewMSXX = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 100)];
    viewMSXX.backgroundColor = [UIColor whiteColor];
    [scView addSubview: viewMSXX];
    viewZCXX.hidden = NO;
    
    iTopY = 10;
    UIImageView *viewImage = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY+2, 15, 15)];
    viewImage.image = [UIImage imageNamed:@"yzd_ms"];
    [viewMSXX addSubview:viewImage];
    
    UILabel  *labelTitle1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX+20, iTopY, 100, 20)];
    labelTitle1.text = @"描述信息";
    labelTitle1.textAlignment = NSTextAlignmentLeft;
    labelTitle1.font = [UIFont systemFontOfSize:15];
    labelTitle1.textColor = [UIColor blackColor];
    [viewMSXX addSubview:labelTitle1];
    
    // 分割线1
    iTopY = labelTitle1.frame.origin.y + labelTitle1.frame.size.height +5;
    UILabel *labelfg1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH -20, 1)];
    labelfg1.backgroundColor = UIColorFromRGB(0xd9d9d9);
    [viewMSXX addSubview:labelfg1];
    
    iTopY += 15;
    UILabel  *labelDescrption = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX+5, iTopY, SCREEN_WIDTH -20, 60)];
    labelDescrption.textAlignment = NSTextAlignmentLeft;
    labelDescrption.font = [UIFont systemFontOfSize:14];
    labelDescrption.textColor = UIColorFromRGB(0x4d4d4d);
    NSString *strDes =dicBaseInfo[@"loanDesc"];
    labelDescrption.text = strDes;
    labelDescrption.numberOfLines = 0; // 多行显示
    [labelDescrption sizeToFit];//一定要设置好文字， 设置好多行显示后， 调用此句，让label根据文字长度，调整大小
    [viewMSXX addSubview:labelDescrption];
    
    
    NSArray *array =  dataDicionary[@"storeRecords"];
    int iDKJLCount = (int)[array count]; // 客服记录条数
    if ( 0 == iDKJLCount )
     {
        // 调整viewZCXX 大小
        CGRect rectTemp = viewMSXX.frame;
        iTopY = labelDescrption.frame.origin.y + labelDescrption.frame.size.height +15;
        rectTemp.size.height = iTopY;
        viewMSXX.frame = rectTemp;
        
        // 调整大小
        scView.contentSize = CGSizeMake(0, CGRectGetMaxY(viewMSXX.frame) + 15);
        return;
     }
    
    // 加入宽的灰色分割线
    iTopY = labelDescrption.frame.origin.y + labelDescrption.frame.size.height +15;
    UILabel *labelfg2 = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 10)];
    labelfg2.backgroundColor = UIColorFromRGB(0xf5f5f5); //设置背景为灰色;
    [viewMSXX addSubview:labelfg2];
    iTopY += 10;
    
    if(iDKJLCount >= 3)
     {
        iDKJLCount = 3;
     }
    
    for (int i = 0; i < iDKJLCount; i++)
     {
        NSDictionary * dicTemp = array[i];
        iTopY += 10;
        CGRect frameTemp = CGRectMake(iLeftX, iTopY, SCREEN_WIDTH-2*iLeftX, 15);
        UIFont * font1 = [UIFont systemFontOfSize:12];
        UIColor *color1 = UIColorFromRGB(0x808080);
        UIColor *color2 = UIColorFromRGB(0x1f83d3);
        
        NSString *strKF2 = [NSString stringWithFormat:@"您于%@处理：%@",dicTemp[@"createTime"], dicTemp[@"handleType"]];
        frameTemp = CGRectMake(iLeftX, iTopY, SCREEN_WIDTH-2*iLeftX, 15);
        [self addLableToView:viewMSXX andFrame:frameTemp andString:strKF2 andColor:color1 andFont:font1];
        
        iTopY += 20;
        NSString *strMS1 = @"描述：";
        frameTemp = CGRectMake(iLeftX, iTopY, SCREEN_WIDTH-2*iLeftX, 15);
        [self addLableToView:viewMSXX andFrame:frameTemp andString:strMS1 andColor:color1 andFont:font1];
        
        NSString *strMS2 = dicTemp[@"handleDesc"];
        frameTemp = CGRectMake(iLeftX+35, iTopY, SCREEN_WIDTH-2*iLeftX, 15);
        UILabel *labelTemp = [self addLableToView:viewMSXX andFrame:frameTemp andString:strMS2 andColor:color2 andFont:font1];
        
        if(iDKJLCount-1 == i)
         {
            break;
         }
        // 加入分割线
        iTopY = labelTemp.frame.origin.y + labelTemp.frame.size.height +10;
        UILabel *labelfg1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH -2*iLeftX, 1)];
        labelfg1.backgroundColor = UIColorFromRGB(0xd9d9d9);
        [viewMSXX addSubview:labelfg1];
     }
    
    // 调整viewZCXX 大小
    CGRect rectTemp = viewMSXX.frame;
    rectTemp.size.height = iTopY +90;
    viewMSXX.frame = rectTemp;
    
    // 调整大小
    scView.contentSize = CGSizeMake(0, CGRectGetMaxY(viewMSXX.frame) + 15);
    
}




// 通用的加lable方法
-(UILabel *) addLableToView:(UIView*) view  andFrame:(CGRect) frame
                  andString:(NSString*) string  andColor:(UIColor*) color
                    andFont:(UIFont*) font
{
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.text = string;
    label.font = font;
    label.textColor = color;
    [view addSubview:label];
    return  label;
}

#pragma mark ---  抢单按钮
-(void) applyAction
{
    // 修改，判断城市是否为个人信息城市
    
    bool  cityEqual = [CommonInfo isCityEqual];
    if (!cityEqual)
     {
        [self _aleartViewUI_CS];
        return;
     }
    
    [self realQD];


    
}

-(void) realQD
{
    if (![CommonInfo isGZRZannSMRZ:self])
     {
        return;
     }
    
    // 如果是审核中
    if([PDAPI isTestUser])
     {
        _haveFreeRob = NO;
        [self lightingOrderForCellAtIndex];
        return;
     }
    
    if (self.lightDic.count == 0) {
        return;
    }
    NSDictionary *dataDic = self.lightDic;
    
    int robType = [[dataDic objectForKey:@"robType"] intValue];  // 单的类型  1 可参与免费抢单  2 只能积分   3 只能支付
    
    
    if((_freeHour && _haveFreeRob && robType == 1) ) {
        // 直接抢单，免费抢单
        [self lightingOrderForCellAtIndex];
        
    }else{

        // 抢单扣款功能
        LightingPopMessage * alert = [[LightingPopMessage alloc] initWithDic:dataDic
                                                                   arraryDZQ:_arrCustTickets
                                                                usebleAmount:_usableAmount
                                                                      canUse:_canUseTicket];
        alert.parentVC = self;
        [alert show];

        
    }
}

// 提示城市是否相同
-(void)_aleartViewUI_CS{
    if (!_aleartView_CS) {
        _aleartView_CS = [[UIView alloc]initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, self.view.frame.size.height - 70)];
        [self.view addSubview:_aleartView_CS];
        _aleartView_CS.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
        
        
        
        UIView *alertView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 280)/2, (_aleartView_CS.frame.size.height - 175)/2 - 50, 280, 125)];
        [_aleartView_CS addSubview:alertView];
        alertView.backgroundColor = [UIColor whiteColor];
        alertView.layer.cornerRadius = 5;
        
        
        
        _rcLabel_1 = [[RCLabel alloc]initWithFrame:CGRectMake(30,  10, alertView.frame.size.width - 60, 20)];
        [alertView addSubview:_rcLabel_1];
        _rcLabel_1.textAlignment = RTTextAlignmentCenter;
        _rcLabel_1.componentsAndPlainText = [RCLabel extractTextStyle:@"<font size = 13 color=#676767>提示</font>"];
        
        _rcLabel_2 = [[RCLabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(_rcLabel_1.frame)+10, alertView.frame.size.width - 20, 40)];
        [alertView addSubview:_rcLabel_2];
        _rcLabel_2.textAlignment = RTTextAlignmentLeft;
        
        NSString *strCT = [CommonInfo getKey:K_TS_City];
        if (!strCT || [strCT isEqualToString:@""])
         {
            strCT = @"深圳市";
         }
        NSString * strTSCT = [NSString stringWithFormat:@"您抢单的城市为%@，是否一定要抢单?",strCT];
        
        _rcLabel_2.componentsAndPlainText = [RCLabel extractTextStyle:[NSString stringWithFormat:@"<font size = 13 color=#676767>%@</font>",strTSCT]];
        
        
        UIButton *btn_1 = [[UIButton alloc]initWithFrame:CGRectMake(30, alertView.frame.size.height - 45, 100, 30)];
        [alertView addSubview:btn_1];
        btn_1.backgroundColor = UIColorFromRGB(0xf1f0f0);
        [btn_1 setTitle:@"抢单" forState:UIControlStateNormal];
        btn_1.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn_1 setTitleColor:[ResourceManager color_6] forState:UIControlStateNormal];
        [btn_1 addTarget:self action:@selector(btn_CS1) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *btn_2 = [[UIButton alloc]initWithFrame:CGRectMake(alertView.frame.size.width - 130, alertView.frame.size.height - 45, 100, 30)];
        [alertView addSubview:btn_2];
        btn_2.backgroundColor = UIColorFromRGB(0xffcc00);
        [btn_2 setTitle:@"不抢单" forState:UIControlStateNormal];
        btn_2.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn_2 setTitleColor:UIColorFromRGB(0xaa2721) forState:UIControlStateNormal];
        [btn_2 addTarget:self action:@selector(btn_CS2) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        _aleartView_CS.hidden = NO;
    }
    
}



-(void) btn_CS1
{
    _aleartView_CS.hidden = YES;
    [self realQD];
}

-(void) btn_CS2
{
    _aleartView_1.hidden = YES;
    _aleartView_2.hidden = YES;
    _aleartView_3.hidden = YES;
    _aleartView_CS.hidden = YES;
}




//非会员免费单抢完后弹窗提示成为会员
-(void)_aleartViewUI_1{
    if (!_aleartView_1) {
        _aleartView_1 = [[UIView alloc]initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, self.view.frame.size.height - 70)];
        [self.view addSubview:_aleartView_1];
        _aleartView_1.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
        
        UIView *alertView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 280)/2, (_aleartView_1.frame.size.height - 175)/2 - 50, 280, 175)];
        [_aleartView_1 addSubview:alertView];
        alertView.backgroundColor = [UIColor whiteColor];
        alertView.layer.cornerRadius = 5;
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake((alertView.frame.size.width - 267)/2, 0, 267, 32)];
        [alertView addSubview:imgView];
        imgView.image = [UIImage imageNamed:@"VIP-14"];
        
        _rcLabel_1 = [[RCLabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(imgView.frame) + 20, alertView.frame.size.width - 60, 40)];
        [alertView addSubview:_rcLabel_1];
        _rcLabel_1.textAlignment = RTTextAlignmentLeft;
        _rcLabel_1.componentsAndPlainText = [RCLabel extractTextStyle:@"<font size = 13 color=#676767>1.会员每天都可参与免费抢单(普通用户最多</font><font size = 13 color=#930000>3</font><font size = 13 color=#676767>单)！</font>"];
        _rcLabel_2 = [[RCLabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(_rcLabel_1.frame), alertView.frame.size.width - 60, 20)];
        [alertView addSubview:_rcLabel_2];
        _rcLabel_2.textAlignment = RTTextAlignmentLeft;
        _rcLabel_2.componentsAndPlainText = [RCLabel extractTextStyle: @"<font size = 13 color=#676767>2.每单现金购买</font><font size = 13 color=#930000>五折</font><font size = 13 color=#676767>优惠！</font>"];
        
        UIButton *btn_1 = [[UIButton alloc]initWithFrame:CGRectMake(30, alertView.frame.size.height - 45, 100, 30)];
        [alertView addSubview:btn_1];
        btn_1.backgroundColor = UIColorFromRGB(0xf1f0f0);
        [btn_1 setTitle:@"再看看" forState:UIControlStateNormal];
        btn_1.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn_1 setTitleColor:[ResourceManager color_6] forState:UIControlStateNormal];
        [btn_1 addTarget:self action:@selector(btn_1) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *btn_2 = [[UIButton alloc]initWithFrame:CGRectMake(alertView.frame.size.width - 130, alertView.frame.size.height - 45, 100, 30)];
        [alertView addSubview:btn_2];
        btn_2.backgroundColor = UIColorFromRGB(0xffcc00);
        [btn_2 setTitle:@"成为会员" forState:UIControlStateNormal];
        btn_2.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn_2 setTitleColor:UIColorFromRGB(0xaa2721) forState:UIControlStateNormal];
        [btn_2 addTarget:self action:@selector(btn_2) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        _aleartView_1.hidden = NO;
    }
    
}


-(void)btn_1{
    
    _aleartView_1.hidden = YES;
}
//成为会员
-(void)btn_2{
    _aleartView_1.hidden = YES;
    _aleartView_2.hidden = YES;
    _aleartView_3.hidden = YES;
    _aleartView_CS.hidden = YES;
    NSDictionary *dic = [DDGAccountManager sharedManager].userInfo;
    VIPViewController *ctl = [[VIPViewController alloc]init];
    ctl.vipGrade = [[dic objectForKey:@"vipGrade"] integerValue];
    ctl.usableAmount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"usableAmount"]];
    ctl.vipEndDate = [NSString stringWithFormat:@"%@",[dic objectForKey:@"vipEndDate"]];
    ctl.name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"realName"]];
    ctl.imageUrl = [NSString stringWithFormat:@"%@",[dic objectForKey:@"userImage"]];
    [self.navigationController pushViewController:ctl animated:YES];
    
}

// 查看详情
-(void)btn_xq{
    _aleartView_1.hidden = YES;
    _aleartView_2.hidden = YES;
    _aleartView_3.hidden = YES;
    _aleartView_CS.hidden = YES;
    
    NSString *url = [NSString stringWithFormat:@"%@xxapp/protocol/robProtocol",[PDAPI WXSysRouteAPI]];
    [CCWebViewController showWithContro:self withUrlStr:url withTitle:@"抢单协议"];
    
    
}








// 抢单请求
-(void)lightingOrderForCellAtIndex{
    NSDictionary *dataDic = self.lightDic;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    

    NSString *api = ![PDAPI isTestUser] ? [NSString stringWithFormat:@"%@busi/account/dai/rob/robFree",[PDAPI getBaseUrlString]] : [NSString stringWithFormat:@"%@busi/account/dai/rob/scoreBorrow",[PDAPI getBaseUrlString]];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:api
                                                                               parameters:@{@"borrowId":dataDic[@"borrowId"],@"sourceType":dataDic[@"sourceType"],@"score":dataDic[@"score"]} HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    operation.tag = 10211;
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

