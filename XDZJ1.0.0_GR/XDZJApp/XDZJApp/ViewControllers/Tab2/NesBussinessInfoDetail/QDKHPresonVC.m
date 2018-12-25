//
//  QDKHPresonVC.m
//  XXJR
//
//  Created by xxjr02 on 2018/5/9.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import "QDKHPresonVC.h"
#import "SIEditAlertView.h"

@interface QDKHPresonVC ()<UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    DDGAFHTTPRequestOperation *_operation;
    UIScrollView *scView;
    
    UIView *viewHead;            // 头部view
    UIView *viewHead2;           // 头部2view
    UIView *viewKHYY;            // 客户预约view
    UIView *viewJBXX;            // 基本信息view
    UIView *viewXYQK;            // 信用情况view
    UIView *viewZCXX;            // 资产信息view
    UIView *viewMSXX;            // 描述信息view
    
    UIButton *btnApply;          // 抢单（按钮）

    NSNumber *_status;
    NSString *_desc;
    NSString *_amount;
    NSString *_period;
    
    
    // 新的退单弹框
    UIView *background;
    UITextView  *textViewTK; // 退单描述
    UIImageView *img1;       //  图片1
    NSString    *strImgUrl1;
    UIImageView *img2;       //  图片2
    NSString    *strImgUrl2;
    UIImageView *img3;       //  图片3
    NSString    *strImgUrl3;
    int  iSelImg;    // 1, 2, 3,
}
@end

@implementation QDKHPresonVC

@synthesize dataDicionary;
@synthesize applyID;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutNaviBarViewWithTitle:@"订单详情"];
    
    scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.f, NavHeight, SCREEN_WIDTH, self.view.size.height - 45 - NavHeight )];
    scView.backgroundColor = UIColorFromRGB(0xf5f5f5); //设置背景为灰色;
    scView.contentSize = CGSizeMake(0, 1050);
    //关闭翻页效果
    scView.pagingEnabled = NO;
    //隐藏滚动条
    scView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scView];
    scView.userInteractionEnabled = YES;
    
    [self loadData];
    
}



-(void) layoutUI
{
    //self.view.backgroundColor = [UIColor yellowColor];
    [self layoutHead];
    
    [self layoutJBXX];
    
    [self layoutZCXX];
    
    [self layoutXYQK];
    
    [self layoutMSXX];
    
    //[self layoutMSXX];
    if ([PDAPI isTestUser])
     {
        return;
     }
    
    
    
    int iBtnApplyWdith = SCREEN_WIDTH;
    int iBtnApplyLeftX = 0;
    int iBtnApplyTopY = self.view.size.height - 45;
    NSDictionary *dicborrowInfo =  dataDicionary[@"borrowInfo"];
    
    
    int ireceiveStatus  = [[_lightDic objectForKey:@"receiveStatus"] intValue];
    if (2 == ireceiveStatus ||
        5 == ireceiveStatus ||
        3 == ireceiveStatus ||
        4 == ireceiveStatus)
     {
        //  成功放款， 退单处理  无效客户  不需要处理按钮
        return;
     }
    
    
    if (dicborrowInfo)
     {
        bool robBackFlag = [dicborrowInfo[@"robBackFlag"] boolValue];
        if (robBackFlag)
         {
            iBtnApplyWdith = SCREEN_WIDTH/2;
            iBtnApplyLeftX = SCREEN_WIDTH/2;
            
            UIButton*  btnTK = [[UIButton alloc]initWithFrame:CGRectMake(0, iBtnApplyTopY, iBtnApplyWdith, 45)];
            [btnTK setTitle:@"申请退单" forState:UIControlStateNormal];
            btnTK.titleLabel.font = [UIFont systemFontOfSize:16]; //[UIFont fontWithName:@"STHeitiSC-Light" size:15];
            [btnTK setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
            btnTK.backgroundColor = UIColorFromRGB(0xd7d7d7);
            

            
            [btnTK addTarget:self action:@selector(TKAction) forControlEvents:UIControlEventTouchUpInside];
             
            
            [self.view addSubview:btnTK];
         }
     }
    
    
    // 抢单按钮
    btnApply = [[UIButton alloc]initWithFrame:CGRectMake(iBtnApplyLeftX, iBtnApplyTopY, iBtnApplyWdith, 45)];
    [btnApply setTitle:@"立即处理" forState:UIControlStateNormal];
    btnApply.titleLabel.font = [UIFont systemFontOfSize:16]; //[UIFont fontWithName:@"STHeitiSC-Light" size:15];
    [btnApply setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnApply.backgroundColor = [ResourceManager mainColor];
    [btnApply addTarget:self action:@selector(handleAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self.view addSubview:btnApply];
}

#pragma mark --- 布局头部
//-(void) layoutHead
//{
//    // 设置头部  begin
//    viewHead =  [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, 165)];
//    viewHead.backgroundColor = [UIColor whiteColor];
//    [scView addSubview:viewHead];
//
//    int iLeftX = 10;
//    int iCurentX = iLeftX;
//    int iTopY = 15;
//
//    NSDictionary *dicApplyInfo = dataDicionary[@"borrowInfo"];
//    NSDictionary *dicBaseInfo = dataDicionary[@"borrowInfo"];
//
//    UILabel  *lableName = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 70, 40)];
//    lableName.text = dicApplyInfo[@"realName"];
//    if (lableName.text.length > 4)
//     {
//        lableName.text = [lableName.text substringToIndex:4];
//     }
//    // 动态调整文字宽度 begin
//    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:16]};
//    CGSize size=[lableName.text sizeWithAttributes:attrs];
//    [lableName setFrame:CGRectMake(iLeftX, iTopY, size.width, 20)];
//    // 动态调整文字宽度 end
//    lableName.font = [UIFont systemFontOfSize:16];
//    lableName.textColor = [ResourceManager color_1];
//    [viewHead addSubview:lableName];
//
//
//    UILabel  *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX + lableName.frame.size.width +10, iTopY , 100, 20)];
//    phoneLabel.text = _tel;//dicApplyInfo[@"telephone"];//@"136****6618";
//    phoneLabel.font = [UIFont systemFontOfSize:15];
//    phoneLabel.textColor = [ResourceManager color_1];
//    [viewHead addSubview:phoneLabel];
//
//    // 背景为圆形的lable
//    iCurentX = SCREEN_WIDTH - 45;
//    UIButton  *lableZhuangtai = [[UIButton alloc] initWithFrame:CGRectMake(iCurentX, iTopY+15, 30, 30)];
//    [lableZhuangtai  setBackgroundImage:[UIImage imageNamed:@"icon_l_phone"] forState:UIControlStateNormal];
//    [lableZhuangtai addTarget:self action:@selector(phoneAction) forControlEvents:UIControlEventTouchUpInside];
//    [viewHead addSubview:lableZhuangtai];
//
//
//    iCurentX = iLeftX;
//    iTopY = lableName.frame.origin.y + lableName.frame.size.height+10;
//    NSString *strTemp;
//    UILabel  *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(iCurentX, iTopY, 200, 15)];
//    if (dicBaseInfo[@"locaDesc"])
//     {
//        cityLabel.text = [NSString stringWithFormat:@"所在城市：%@",dicBaseInfo[@"locaDesc"]];
//
//     }
//    cityLabel.font = [UIFont systemFontOfSize:14];
//    cityLabel.textColor = [ResourceManager color_1];
//    [viewHead addSubview:cityLabel];
//
//    iTopY += cityLabel.height + 10;
//    UILabel  *labelSqshijian = [[UILabel alloc] initWithFrame:CGRectMake(iCurentX, iTopY, 300, 15)];
//    strTemp = [NSString stringWithFormat:@"申请时间：%@",dicApplyInfo[@"applyTime"]];
//    labelSqshijian.text = strTemp;//@"申请时间：2016-07-12  15:11:12";
//    labelSqshijian.textAlignment = NSTextAlignmentLeft;
//    labelSqshijian.font = [UIFont systemFontOfSize:14];
//    labelSqshijian.textColor = [ResourceManager color_1];
//    //labelSqshijian.backgroundColor = [UIColor blueColor];
//    [viewHead addSubview:labelSqshijian];
//
//    // 设置头部  end
//
//    // 设置头部2  begin
////    iTopY  += cityLabel.height + 10;
////    viewHead2 =  [[UIView alloc] initWithFrame:CGRectMake(10, iTopY, SCREEN_WIDTH-20, 50)];
////    viewHead2.backgroundColor = UIColorFromRGB(0xfffefc);
////    viewHead2.layer.cornerRadius = 5; //设置矩形四个圆角半径
////    viewHead2.layer.masksToBounds = YES;
////    viewHead2.layer.borderWidth = 0.05;
////    viewHead.layer.borderColor =  UIColorFromRGB(0xf2f4f2).CGColor;
////    [scView addSubview:viewHead2];
////
////    RCLabel *subTitleLabel1 = [[RCLabel alloc] initWithFrame:CGRectMake(0, 15, (SCREEN_WIDTH-20)/2, 30)];
////    [viewHead2 addSubview:subTitleLabel1];
////    subTitleLabel1.textAlignment = RTTextAlignmentCenter;
////    NSString *strQuan = [NSString stringWithFormat:@"<font size = 15 color=#808080>贷款金额  </font><font size = 15 color=#f5793b>%@万元</font></font>",dicBaseInfo[@"loanAmount"]];
////
////    int iReceiveStatus = [_lightDic[@"receiveStatus"] intValue];
////    // 成功放款
////    if (iReceiveStatus == 2)
////     {
////        strQuan = [NSString stringWithFormat:@"<font size = 15 color=#808080>放款金额  </font><font size = 15 color=#f5793b>%@万元</font></font>",dicBaseInfo[@"actualLoanAmount"]];
////
////        viewHead2.backgroundColor = UIColorFromRGB(0xfdf0e9);
////
////     }
////
////    subTitleLabel1.componentsAndPlainText = [RCLabel extractTextStyle: strQuan];
////
////    UIView*  viewMidFG = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-20)/2, 15, 0.5, 20)];
////    [viewHead2 addSubview:viewMidFG];
////    viewMidFG.backgroundColor = [ResourceManager color_5];
////
////
////    RCLabel *subTitleLabel2 = [[RCLabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-20)/2, 15, (SCREEN_WIDTH-20)/2, 30)];
////    [viewHead2 addSubview:subTitleLabel2];
////    subTitleLabel2.textAlignment = RTTextAlignmentCenter;
////    strQuan = [NSString stringWithFormat:@"<font size = 15 color=#808080>贷款期限  </font><font size = 15 color=#f5793b>%@个月</font></font>",dicBaseInfo[@"loanDeadline"]];
////
////    // 成功放款
////    if (iReceiveStatus == 2)
////     {
////        //NSString *strAmount = [NSString stringWithFormat:@"%@", [dicBaseInfo objectForKey:@"actualLoanAmount"] ];
////        strQuan = [NSString stringWithFormat:@"<font size = 15 color=#808080>放款期限  </font><font size = 15 color=#f5793b>%@个月</font></font>",dicBaseInfo[@"actualLoanPeriod"]];
////        //NSString *strPeriod = [NSString stringWithFormat:@"%@", [dicBaseInfo objectForKey:@"actualLoanPeriod"]];
////     }
////
////    subTitleLabel2.componentsAndPlainText = [RCLabel extractTextStyle: strQuan];
//
//}

-(void) layoutHead
{
    // 设置头部背景 begin
    UIView *viewBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 130)];
    [scView addSubview:viewBG];
    viewBG.backgroundColor = [UIColor whiteColor];
    // 设置头部背景 end
    
    // 设置头部  begin
    viewHead =  [[UIView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 120)];
    viewHead.layer.cornerRadius = 3; //设置矩形四个圆角半径
    viewHead.layer.masksToBounds = YES;
    
    // 设置背景为渐变色
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.startPoint = CGPointMake(0, 0);//（0，0）表示从左上角开始变化。默认值是(0.5,0.0)表示从x轴为中间，y为顶端的开始变化
    layer.endPoint = CGPointMake(1, 1);//（1，1）表示到右下角变化结束。默认值是(0.5,1.0)  表示从x轴为中间，y为低端的结束变化
                                       //0x6494f6
    UIColor *topColor = [UIColor colorWithRed:100.0/255.0 green:142.0/255.0 blue:246.0/255.0 alpha:1];
    //0x2d69e1
    UIColor *buttomColor = [UIColor colorWithRed:45.0/255.0 green:105.0/255.0 blue:225.0/255.0 alpha:1];
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
    
    iCurentX = iLeftX;
    iTopY = lableName.frame.origin.y + lableName.frame.size.height + 12;
    NSString *strTemp;
    
    int iWidth = SCREEN_WIDTH/3 - 10;
    UILabel  *jeLabel = [[UILabel alloc] initWithFrame:CGRectMake(iCurentX, iTopY, iWidth, 20)];
    jeLabel.text = [NSString stringWithFormat:@"%@万元",dicBaseInfo[@"loanAmount"]];
    //jeLabel.textAlignment = NSTextAlignmentCenter;
    jeLabel.font = [UIFont systemFontOfSize:15];
    jeLabel.textColor = [UIColor whiteColor];
    [viewHead addSubview:jeLabel];
    
    iCurentX = SCREEN_WIDTH/3;
    UILabel  *labelyueshu = [[UILabel alloc] initWithFrame:CGRectMake(iCurentX, iTopY, iWidth, 20)];
    labelyueshu.text = [NSString stringWithFormat:@"%@个月",dicBaseInfo[@"loanDeadline"]];//@"360个月";
    labelyueshu.textAlignment = NSTextAlignmentCenter;
    labelyueshu.font = [UIFont systemFontOfSize:15];
    labelyueshu.textColor = [UIColor whiteColor];
    [viewHead addSubview:labelyueshu];
    
    iCurentX = SCREEN_WIDTH*2/3;
    UILabel  *labelYongtuLabel = [[UILabel alloc] initWithFrame:CGRectMake(iCurentX, iTopY, iWidth, 20)];
    strTemp = [NSString stringWithFormat:@"%@", dicIncome[@"income"]];
    if(!dicIncome[@"income"])
     {
        strTemp = @"暂缺";
     }
    
    labelYongtuLabel.text = strTemp;//@"买车";
    labelYongtuLabel.textAlignment = NSTextAlignmentCenter;
    labelYongtuLabel.font = [UIFont systemFontOfSize:15];
    labelYongtuLabel.textColor = [UIColor whiteColor];
    [viewHead addSubview:labelYongtuLabel];
    
    iCurentX = iLeftX;
    iTopY = labelYongtuLabel.frame.origin.y + labelYongtuLabel.frame.size.height;
    UILabel  *labelTitle1 = [[UILabel alloc] initWithFrame:CGRectMake(iCurentX, iTopY, iWidth, 20)];
    labelTitle1.text = @"贷款金额";
    //labelTitle1.textAlignment = NSTextAlignmentCenter;
    labelTitle1.font = [UIFont systemFontOfSize:12];
    labelTitle1.textColor = [ResourceManager lightGrayColor];
    [viewHead addSubview:labelTitle1];
    
    iCurentX = SCREEN_WIDTH/3;
    UILabel  *labelTitle2 = [[UILabel alloc] initWithFrame:CGRectMake(iCurentX, iTopY, iWidth, 20)];
    labelTitle2.text = @"贷款期限";
    labelTitle2.textAlignment = NSTextAlignmentCenter;
    labelTitle2.font = [UIFont systemFontOfSize:12];
    labelTitle2.textColor = [ResourceManager lightGrayColor];
    [viewHead addSubview:labelTitle2];
    
    iCurentX = SCREEN_WIDTH*2/3;
    UILabel  *labelTitle3 = [[UILabel alloc] initWithFrame:CGRectMake(iCurentX, iTopY, iWidth, 20)];
    strTemp =  dicIncome[@"showIncome"]?dicIncome[@"showIncome"]:@"月收入";
    labelTitle3.text = strTemp;
    labelTitle3.textAlignment = NSTextAlignmentCenter;
    labelTitle3.font = [UIFont systemFontOfSize:12];
    labelTitle3.textColor = [ResourceManager lightGrayColor];
    [viewHead addSubview:labelTitle3];
    
    
    // 所在城市
    iCurentX = iLeftX;
    iTopY += jeLabel.height + 5;
    UILabel  *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(iCurentX, iTopY, 200, 20)];
    if (dicBaseInfo[@"locaDesc"])
     {
        cityLabel.text = [NSString stringWithFormat:@"所在城市：%@",dicBaseInfo[@"locaDesc"]];
        
     }
    
    cityLabel.font = [UIFont systemFontOfSize:11];
    cityLabel.textColor = [UIColor whiteColor];
    [viewHead addSubview:cityLabel];
    // 设置头部  end
    
    
    // 设置头部2  begin
    iTopY = cityLabel.frame.origin.y + cityLabel.frame.size.height+5;
    viewHead2 =  [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 100)];
    viewHead2.backgroundColor = [UIColor whiteColor];
    
    [scView addSubview:viewHead2];
    
    iLeftX = 15;
    iCurentX = iLeftX+5;
    iTopY = 10;
    UIImageView *imageHead2View = [[UIImageView alloc] initWithFrame:CGRectMake(iCurentX, iTopY+3, 14, 14)];
    imageHead2View.image = [UIImage imageNamed:@"sqshijian"];
    [viewHead2 addSubview:imageHead2View];
    
    iCurentX = 10;
    UILabel  *labelSqshijian = [[UILabel alloc] initWithFrame:CGRectMake(iCurentX, iTopY, 300, 20)];
    strTemp = [NSString stringWithFormat:@"申请时间：%@",dicApplyInfo[@"applyTime"]];
    labelSqshijian.text = strTemp;//@"申请时间：2016-07-12  15:11:12";
    labelSqshijian.textAlignment = NSTextAlignmentLeft;
    labelSqshijian.font = [UIFont systemFontOfSize:13];
    labelSqshijian.textColor = UIColorFromRGB(0x666666);
    //labelSqshijian.backgroundColor = [UIColor blueColor];
    [viewHead2 addSubview:labelSqshijian];
    

    
    
//    UIButton *btnSuo = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100, iTopY, 90, 30)];
//    [viewHead2 addSubview:btnSuo];
//    btnSuo.backgroundColor = [ResourceManager mainColor];
//
//    int iPrice = [_lightDic[@"price"]  intValue] / 100;
//    if (iPrice > 0 &&
//        ![PDAPI isTestUser])
//     {
//        NSString *strPrice = [NSString stringWithFormat:@"%d元抢单", iPrice];
//        [btnSuo setTitle:strPrice forState:UIControlStateNormal];
//     }
//    if (_freeHour)
//     {
//        [btnSuo setTitle:@"抢单" forState:UIControlStateNormal];
//     }
//
//    btnSuo.titleLabel.font = [UIFont systemFontOfSize:13]; //[UIFont fontWithName:@"STHeitiSC-Light" size:15];
//    [btnSuo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    btnSuo.backgroundColor = [ResourceManager mainColor];
//    [btnSuo addTarget:self action:@selector(applyAction) forControlEvents:UIControlEventTouchUpInside];
    
    iTopY += labelSqshijian.height +10;
    viewHead2.height = iTopY;
    // 设置头部2  end
}


#pragma mark --- 布局基本信息
-(void) layoutJBXX
{
    NSDictionary *dicBaseInfo = dataDicionary[@"borrowInfo"];
    NSDictionary *dicIncome = dataDicionary[@"borrowInfo"];
    
    int iTopY = 0;
    int iLeftX = 10;

    iTopY = viewHead2.frame.origin.y + viewHead2.frame.size.height + 15;
    
    
    viewJBXX = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 160)];
    viewJBXX.backgroundColor = [UIColor whiteColor];
    [scView addSubview:viewJBXX];
    
    // 分割线1
    iTopY = 0;
//    UILabel *labelfg1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH -20, 1)];
//    labelfg1.backgroundColor = UIColorFromRGB(0xd9d9d9);
//    [viewJBXX addSubview:labelfg1];
    
    iTopY = 15;
//    UIImageView *viewImage = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY+2, 13, 15)];
//    viewImage.image = [UIImage imageNamed:@"yzd_jbxx"];
//    [viewJBXX addSubview:viewImage];
    
    UILabel  *labelTitle1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 100, 20)];
    labelTitle1.text = @"基本信息";
    labelTitle1.textAlignment = NSTextAlignmentLeft;
    labelTitle1.font = [UIFont systemFontOfSize:15];
    labelTitle1.textColor = [UIColor blackColor];
    [viewJBXX addSubview:labelTitle1];
    
    // 分割线1
    iTopY = labelTitle1.frame.origin.y + labelTitle1.frame.size.height +10;
    //UILabel *labelfg1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH -20, 1)];
    //labelfg1.backgroundColor = UIColorFromRGB(0xd9d9d9);
    //[viewJBXX addSubview:labelfg1];
    
    
    
    //siTopY += 15;
    CGRect frameTemp = CGRectMake(iLeftX, iTopY, 150, 15);
    UIFont * fontTemp = [UIFont systemFontOfSize:14];
    UIColor *color1 = UIColorFromRGB(0x808080);
    UIColor *color2 = UIColorFromRGB(0x4d4d4d);
    [self addLableToView:viewJBXX andFrame:frameTemp andString:@"职业身份" andColor:color1 andFont:fontTemp];
    
    frameTemp = CGRectMake(iLeftX+150, iTopY, SCREEN_WIDTH - (iLeftX + 150 +10), 15);
    NSString *strTemp = [NSString stringWithFormat:@"%@", dicBaseInfo[@"workTypeName"]];
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
    
    
    iTopY += 25 ;
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
    
    iTopY = viewJBXX.frame.origin.y + viewJBXX.frame.size.height;
    viewZCXX = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 350-100)];
    viewZCXX.backgroundColor = [UIColor whiteColor];
    [scView addSubview: viewZCXX];
    
    // 分割线
    iTopY = 0;
    UILabel *labelfg1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH -20, 1)];
    labelfg1.backgroundColor = UIColorFromRGB(0xd9d9d9);
    [viewZCXX addSubview:labelfg1];
    
    iTopY = 15;
//    UIImageView *viewImage = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY+2, 13, 16)];
//    viewImage.image = [UIImage imageNamed:@"yzd_zc"];
//    [viewZCXX addSubview:viewImage];
    
    UILabel  *labelTitle1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 200, 20)];
    NSString *strlable = @"资产信息 ";
    
    labelTitle1.text = strlable;
    labelTitle1.textAlignment = NSTextAlignmentLeft;
    labelTitle1.font = [UIFont systemFontOfSize:15];
    labelTitle1.textColor = [UIColor blackColor];
    [viewZCXX addSubview:labelTitle1];
    
    
    
    iTopY = labelTitle1.frame.origin.y + labelTitle1.frame.size.height +10;
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
    
    iTopY = viewZCXX.frame.origin.y + viewZCXX.frame.size.height;
    viewXYQK = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 200)];
    viewXYQK.backgroundColor = [UIColor whiteColor];
    [scView addSubview: viewXYQK];
    
    // 分割线1
    iTopY = 0;
    UILabel *labelfg1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH -20, 1)];
    labelfg1.backgroundColor = UIColorFromRGB(0xd9d9d9);
    [viewXYQK addSubview:labelfg1];
    
    iTopY = 15;
//    UIImageView *viewImage = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY+2, 13, 16)];
//    viewImage.image = [UIImage imageNamed:@"yzd_xyqk"];
//    [viewXYQK addSubview:viewImage];
    
    UILabel  *labelTitle1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 200, 20)];
    NSString *strlable = @"其他信息";
    
    labelTitle1.text = strlable;
    labelTitle1.textAlignment = NSTextAlignmentLeft;
    labelTitle1.font = [UIFont systemFontOfSize:15];
    labelTitle1.textColor = [UIColor blackColor];
    [viewXYQK addSubview:labelTitle1];
    

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
    
    iTopY = labelTitle1.frame.origin.y + labelTitle1.frame.size.height;
    iTopY += 10 ;
    frameTemp = CGRectMake(iLeftX, iTopY, 150, 15);
    [self addLableToView:viewXYQK andFrame:frameTemp andString:@"征信情况" andColor:color1 andFont:font1];
    
    frameTemp = CGRectMake(iLeftX+150, iTopY, SCREEN_WIDTH - (iLeftX + 150 +10), 15);
    [self addLableToView:viewXYQK andFrame:frameTemp andString:strCreditType andColor:color2 andFont:font2];
    
    
    
    
    iTopY += 25;
    frameTemp = CGRectMake(iLeftX, iTopY, 150, 15);
    [self addLableToView:viewXYQK andFrame:frameTemp andString:@"微粒贷额度" andColor:color1 andFont:font1];
    
    
    NSString *strTemp = dicBaseInfo[@"haveWeiLiText"];
    frameTemp = CGRectMake(iLeftX+150, iTopY, SCREEN_WIDTH - (iLeftX + 150 +10), 15);
    if (strTemp.length <= 0)
     {
        strTemp = @"未知";
     }
    [self addLableToView:viewXYQK andFrame:frameTemp andString:strTemp andColor:color2 andFont:font2];
    
    
    iTopY += 25 ;
    frameTemp = CGRectMake(iLeftX, iTopY, 150, 15);
    [self addLableToView:viewXYQK andFrame:frameTemp andString:@"芝麻信用" andColor:color1 andFont:font1];
    
    int iZhiMa = [dicBaseInfo[@"zimaScore"] intValue];
    strTemp = @"未知";
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
    
    iTopY = viewXYQK.frame.origin.y + viewXYQK.frame.size.height + 15 ;
    
    
    
    viewMSXX = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 100)];
    viewMSXX.backgroundColor = [UIColor whiteColor];
    [scView addSubview: viewMSXX];
    viewZCXX.hidden = NO;
    
    iTopY = 10;
    //    UIImageView *viewImage = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY+2, 15, 15)];
    //    viewImage.image = [UIImage imageNamed:@"yzd_ms"];
    //    [viewMSXX addSubview:viewImage];
    
    UILabel  *labelTitle1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 100, 20)];
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

#pragma mark --- 布局退款弹框
- (void) tukuanAction{
    //创建一个黑色背景
    //初始化一个用来当做背景的View。我这里为了省时间计算，宽高直接用的5s的尺寸
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    background = bgView;
    bgView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.2];//[UIColor clearColor];
    bgView.cornerRadius = 8;
    [self.view addSubview:bgView];
    
    // 创建按钮的背景框
    int iKuangHight = 380;
    int iKuangWidth = 330;
    UIView *viewKuang = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-iKuangWidth)/2, 65, iKuangWidth , iKuangHight  ) ];
    viewKuang.backgroundColor = [UIColor whiteColor];//UIColorFromRGB(0xf2f2f2);
    [bgView addSubview:viewKuang];
    
    
    
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 300+30, 16)];
    label1.text = @"申请退单";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont systemFontOfSize:16];
    [viewKuang addSubview:label1];
    
    int iLeftX = 15;
    int iTopY = 50;
    
    textViewTK = [[UITextView alloc]  initWithFrame:CGRectMake(iLeftX, iTopY, iKuangWidth - 2*iLeftX, 90)];
    textViewTK.text = @"退单描述";
    //设置圆角边框
    textViewTK.cornerRadius = 8;
    textViewTK.font = [UIFont systemFontOfSize:14];
    textViewTK.layer.masksToBounds = YES;
    textViewTK.layer.borderWidth = 0.5;
    textViewTK.layer.borderColor = [ResourceManager color_5].CGColor;
    textViewTK.delegate = self;
    [viewKuang addSubview:textViewTK];
    
    iTopY += 100;
    //    UILabel *labelTiShi = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iKuangWidth - 2*iLeftX, 60)];
    //    labelTiShi.numberOfLines = 0;
    //    labelTiShi.font = [UIFont systemFontOfSize:13];
    //    labelTiShi.textColor = [ResourceManager lightGrayColor];
    //    labelTiShi.text = @"注：你可以上传图片证明以便客服审核（如：征信截图，同行截图、电话拨打记录等）提供截图证明可以加快退单进度";
    //    [viewKuang addSubview:labelTiShi];
    
    RCLabel *pointLable = [[RCLabel alloc]initWithFrame:CGRectMake(iLeftX, iTopY, iKuangWidth - 2*iLeftX, 60)];
    [viewKuang addSubview:pointLable];
    pointLable.textAlignment = RTTextAlignmentLeft;
    pointLable.componentsAndPlainText = [RCLabel extractTextStyle: @"<font size = 13 color=#9a9a9a>注：你可以上传图片证明以便客服审核（如：征信截图，同行截图、电话拨打记录等）提供截图证明可以加快退单进度。</font><font size = 13 color=#3897f5>查看订单退单规则>></font></font>"];
    
    // 查看详情
    UIButton *xqBtn = [[UIButton alloc] initWithFrame:pointLable.frame];
    [viewKuang addSubview:xqBtn];
    [xqBtn addTarget:self action:@selector(actionTKXQ) forControlEvents:UIControlEventTouchUpInside];
    
    
    iTopY += 70;
    int iImgWdith = (iKuangWidth - 4*iLeftX ) /3;
    int iImgLeft = iLeftX;
    img1 = [[UIImageView alloc] initWithFrame:CGRectMake(iImgLeft, iTopY, iImgWdith , iImgWdith)];
    img1.tag = 1;
    [img1 setImage:[UIImage imageNamed:@"light_sctp"]];
    img1.userInteractionEnabled = YES;
    [viewKuang addSubview:img1];
    
    //添加图片手势
    UITapGestureRecognizer *imgGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgBtn:)];
    [img1 addGestureRecognizer:imgGesture];
    
    iImgLeft += iImgWdith + iLeftX;
    img2 = [[UIImageView alloc] initWithFrame:CGRectMake(iImgLeft, iTopY, iImgWdith , iImgWdith)];
    [img2 setImage:[UIImage imageNamed:@"light_sctp"]];
    img2.tag = 2;
    img2.userInteractionEnabled = YES;
    img2.hidden = YES;
    [viewKuang addSubview:img2];
    
    //添加图片手势
    UITapGestureRecognizer *imgGesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgBtn:)];
    [img2 addGestureRecognizer:imgGesture2];
    
    iImgLeft += iImgWdith + iLeftX;
    img3 = [[UIImageView alloc] initWithFrame:CGRectMake(iImgLeft, iTopY, iImgWdith , iImgWdith)];
    [img3 setImage:[UIImage imageNamed:@"light_sctp"]];
    img3.tag = 3;
    img3.userInteractionEnabled = YES;
    img3.hidden = YES;
    [viewKuang addSubview:img3];
    
    //添加图片手势
    UITapGestureRecognizer *imgGesture3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgBtn:)];
    [img3 addGestureRecognizer:imgGesture3];
    
    strImgUrl1 = nil;
    strImgUrl2 = nil;
    strImgUrl3 = nil;
    
    
    iTopY += iImgWdith +20;
    iLeftX = 15;
    int iBtnWidth = (iKuangWidth-3*iLeftX)/2;
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iBtnWidth, 35)];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button setTitle:@"取消" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.layer.cornerRadius = 35/2;
    button.backgroundColor = UIColorFromRGB(0xd3cdca);
    //button.layer.borderWidth = 0.5;
    //button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [button addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [viewKuang addSubview:button];
    
    iLeftX += iBtnWidth + 15;
    UIButton * buttonOK = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iBtnWidth, 35)];
    buttonOK.titleLabel.textAlignment = NSTextAlignmentCenter;
    [buttonOK setTitle:@"确定" forState:UIControlStateNormal];
    buttonOK.titleLabel.font = [UIFont systemFontOfSize:15];
    buttonOK.titleLabel.textColor = [UIColor whiteColor];
    buttonOK.titleLabel.textAlignment = NSTextAlignmentCenter;
    buttonOK.layer.cornerRadius = 35/2;
    buttonOK.backgroundColor = [ResourceManager mainColor];
    [buttonOK addTarget:self action:@selector(tkOK) forControlEvents:UIControlEventTouchUpInside];
    [viewKuang addSubview:buttonOK];
    
    
    
    
    
    //    background.userInteractionEnabled = YES;
    //添加点击手势（点击任意地方，退出全屏）
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEditView)];
    [bgView addGestureRecognizer:tapGesture];
    
    //[self shakeToShow:bgView];//放大过程中的动画
}


-(void) actionTKXQ
{
    NSString *url = [NSString stringWithFormat:@"%@xxapp/protocol/lendHomeRob",[PDAPI WXSysRouteAPI]];
    [CCWebViewController showWithContro:self withUrlStr:url withTitle:@"抢单协议"];
}

-(void)endEditView
{
    [self.view endEditing:YES];
}

-(void)closeView
{
    [self.view endEditing:YES];
    [background removeFromSuperview];
}


-(void) imgBtn:(id)sender
{
    UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)sender;
    int iTag = (int)[singleTap view].tag;
    iSelImg = iTag;
    NSLog(@"iTag:%d",iTag);
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
     {
        return;
     }
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerController.allowsEditing = YES;
    
    [self.navigationController presentViewController:pickerController animated:YES completion:nil];
}
-(void)tkOK
{
    if (textViewTK.text.length <=0 ||
        [textViewTK.text isEqualToString:@"退单描述"])
     {
        [MBProgressHUD showErrorWithStatus:@"请填写退单描述" toView:self.view];
        return;
     }
    
    
    // 发出请求，作处理  // 退单的TYPE 是5
    [self handleLightingOrder:@(5) descreption:textViewTK.text img1:strImgUrl1 img2:strImgUrl2 img3:strImgUrl3];
}

#pragma mark ---  网络请求
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
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@",[PDAPI getBaseUrlString],KDDGrobDetail,applyID];
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:url
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
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    NSDictionary *attr =  operation.jsonResult.attr;
    
    NSLog(@"attr:%@" , attr);
    
    if (operation.tag == 10210) {
        
        dataDicionary = attr;
        
        // 布局UI
        [self layoutUI];
        
        NSLog(@"operation.jsonResult.rows:%@", operation.jsonResult.rows);
        
        _usableAmount = [dataDicionary[@"usableAmount"] floatValue];
        
    }
    else if (10200 == operation.tag)
     {
        // 发送处理成功的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:GrabSuccessNotification object:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
     }
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    
    if (operation.tag == 10210) {
        
    }
    else{
        [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
    }
    
}

-(void)handleLightingOrder:(NSNumber *)status descreption:(NSString *)desc loanAmount:(NSString *)amount loanPeriod:(NSString *)period{
    NSDictionary *dic = nil;
    
    
    dic = self.lightDic;
    
    
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"borrowId"] = dic[@"borrowId"];
    params[@"receiveId"] = dic[@"receiveId"];
    params[@"receiveStatus"] = _status = status;
    
    
    
    if (amount) {
        params[@"actualLoanAmount"] = _amount = amount;
    }
    if (period) {
        params[@"actualLoanPeriod"] = _period = period;
    }
    
    params[@"receiveDesc"] = _desc = desc;
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],@"mjb/account/dai/rob/handleTheRob"]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    operation.tag = 10200;
    [operation start];
}

-(void)handleLightingOrder:(NSNumber *)status descreption:(NSString *)desc img1:(NSString *)url1 img2:(NSString *)url2
                      img3:(NSString*) url3{
    NSDictionary *dic = self.lightDic;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"borrowId"] = dic[@"borrowId"];
    params[@"receiveId"] = dic[@"receiveId"];
    params[@"receiveStatus"] = _status = status;
    
    
    if (url1) {
        params[@"refundImg1"] = url1;
    }
    if (url2) {
        params[@"refundImg2"] = url2;
    }
    if (url3) {
        params[@"refundImg3"] = url3;
    }
    
    
    // 描述
    params[@"receiveDesc"] = _desc = desc;
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@%@",[PDAPI getBusiUrlString],@"mjb/account/dai/rob/handleTheRob"]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self closeView];
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    operation.tag = 10200;
    [operation start];
}

#pragma mark ---  action
-(void) phoneAction
{
    NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:+86%@",_tel]];
    UIWebView*callWebview =[[UIWebView alloc] init];
    
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    
    //记得添加到view上
    [self.view addSubview:callWebview];
}

// 退单按钮
-(void) TKAction
{
    [self tukuanAction];
}

// 处理按钮
-(void) handleAction
{
    [self showAlertView_Step1:1];
}


-(void)showAlertView_Step1:(int)index{
    
    
    
    NSDictionary *dic = self.lightDic;
    //int irobWay = [dic[@"robWay"] intValue];
    
    NSString *title1_a = @"跟进中",*title1_d = @"继续跟进",*title1 = @"不能做",*title2 = @"无效用户",*title3 = @"成功放款";
    NSString *title1_b = @"审批中",*title1_c = @"审批通过";
    
    int ireceiveStatus  = [[dic objectForKey:@"receiveStatus"] intValue];
    
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"直借单处理" andMessage:nil];
    
    
    if (ireceiveStatus == 1||
        ireceiveStatus == 3||
        ireceiveStatus == 4)
     {
        [alertView addButtonWithTitle:title1_a
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alertView) {
                                  [self showAlertView_Step2_Type:7 title:title1_a];
                              }];
     }
    
    if (1 == ireceiveStatus||
        7 == ireceiveStatus||
        8 == ireceiveStatus||
        3 == ireceiveStatus||
        4 == ireceiveStatus )
     {
        
        [alertView addButtonWithTitle:title1_d
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alertView) {
                                  [self showAlertView_Step2_Type:8 title:title1_d];
                              }];
        
        [alertView addButtonWithTitle:title1_b
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alertView) {
                                  [self showAlertView_Step2_Type:9 title:title1_b];
                              }];
        
     }
    
    if (1 == ireceiveStatus||
        7 == ireceiveStatus||
        8 == ireceiveStatus||
        9 == ireceiveStatus||
        3 == ireceiveStatus||
        4 == ireceiveStatus)
     {
        [alertView addButtonWithTitle:title1_c
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alertView) {
                                  [self showAlertView_Step2_Type:10 title:title1_c];
                              }];
     }
    
    [alertView addButtonWithTitle:title1
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView) {
                              [self showAlertView_Step2_Type:3 title:title1];
                          }];
    [alertView addButtonWithTitle:title2
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView) {
                              [self showAlertView_Step2_Type:4 title:title2];
                          }];
    [alertView addButtonWithTitle:title3
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView) {
                              [self showAlertView_Step2_Type:2 title:title3];
                          }];
    
    alertView.cornerRadius = 5;
    alertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
    alertView.transitionStyle = SIAlertViewTransitionStyleSlideFromTop;
    [alertView show];
    
}


-(void)showAlertView_Step2_Type:(int)type title:(NSString *)title{
    NSDictionary *dic = self.lightDic;
    
    
    SIEditAlertView *alertView = [[SIEditAlertView alloc] initWithTitle:title andMessage:nil];
    [alertView addButtonWithTitle:@"取消"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIEditAlertView *alertView) {
                              
                          }];
    [alertView addButtonWithTitle:@"确定"
                             type:SIAlertViewButtonTypeCancel
                          handler:^(SIEditAlertView *alertView) {
                              NSString *str1 = alertView.fieldView1.text;
                              NSString *str2 = alertView.fieldView2.text;
                              NSString *str3 = alertView.textView.text;
                              if (type == 2 && (str1.length <= 0 || str1.intValue <= 0)) {
                                  [self showTipsAlertView:@"请填写金额"];
                                  return ;
                              }else if (type == 2 && (str2.length <= 0 || str2.intValue <= 0)) {
                                  [self showTipsAlertView:@"请填写周期"];
                                  return ;
                              }else if (str3.length <= 0 || [str3 isEqualToString:@"描述..."]) {
                                  [self showTipsAlertView:@"请填写描述"];
                                  return ;
                              }else if (type == 5 && [str3 isEqualToString:@"描述..."]) {
                                  [self showTipsAlertView:@"请填写描述"];
                                  return ;
                              }
                              // 发出请求，作处理
                              [self handleLightingOrder:@(type) descreption:str3 loanAmount:str1 loanPeriod:str2];
                          }];
    
    alertView.didShowHandler = ^(SIEditAlertView *alertView) {
        alertView.fieldView1.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"loanAmount"]];
        alertView.fieldView2.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"loanDeadline"]];
    };
    
    alertView.showFieldEditView = type == 2;
    alertView.cornerRadius = 5;
    alertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
    alertView.transitionStyle = SIAlertViewTransitionStyleSlideFromTop;
    alertView.titleFont = [UIFont systemFontOfSize:14];
    
    [alertView show];
}


// 提示
-(void)showTipsAlertView:(NSString *)tipsTitle{
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"提示" andMessage:tipsTitle];
    [alertView addButtonWithTitle:@"确定"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView) {
                              
                          }];
    
    alertView.cornerRadius = 5;
    alertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
    alertView.transitionStyle = SIAlertViewTransitionStyleSlideFromTop;
    [alertView show];
    
}

#pragma mark === UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([textView.text isEqualToString:@"退单描述"]) {
        textView.text = @"";
        
    }
    return YES;
}


#pragma mark UIImagePickerViewControllerDelegate
/**
 *  Tells the delegate that the user picked a still image or movie.
 *
 *  @param picker
 *  @param info
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
#define dataSize 1024.0f
#define imageSize CGSizeMake(600.0f, 600.0f)
    //    //先把原图保存到图片库
    //    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    //     {
    //        UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    //        UIImageWriteToSavedPhotosAlbum(originalImage, nil, nil, nil);
    //     }
    //获取用户选取的图片并转换成NSData
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    //缩小图片的size
    image = [self imageByRedraw:image];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.2f);
    if (imageData){
        self.imageData = imageData;
        // 上传
        [self upLoadImageData];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}
/**
 *  截图
 *
 *  @param image
 *
 *  @return UIImage
 */
- (UIImage *)imageByRedraw:(UIImage *)image
{
    if (image.size.width == image.size.height)
     {
        UIGraphicsBeginImageContext(imageSize);
        CGRect rect = CGRectZero;
        rect.size = imageSize;
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
        CGContextFillRect(ctx, rect);
        [image drawInRect:rect];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
     }else{
         CGFloat ratio = image.size.width / image.size.height;
         CGSize size = CGSizeZero;
         
         if (image.size.width > imageSize.width)
          {
             size.width = imageSize.width;
             size.height = size.width / ratio;
          }
         else if (image.size.height > imageSize.height)
          {
             size.height = imageSize.height;
             size.width = size.height * ratio;
          }
         else
          {
             size.width = image.size.width;
             size.height = image.size.height;
          }
         //这里的size是最终获取到的图片的大小
         UIGraphicsBeginImageContext(imageSize);
         CGRect rect = CGRectZero;
         rect.size = imageSize;
         //先填充整个图片区域的颜色为黑色
         CGContextRef ctx = UIGraphicsGetCurrentContext();
         CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
         CGContextFillRect(ctx, rect);
         rect.origin = CGPointMake((imageSize.width - size.width)/2, (imageSize.height - size.height)/2);
         rect.size = size;
         //画图
         [image drawInRect:rect];
         image = UIGraphicsGetImageFromCurrentImageContext();
         UIGraphicsEndImageContext();
     }
    return image;
}

-(void)upLoadImageData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"fileType"] = @"refundImg";
    params[@"signId"] = [DDGSetting sharedSettings].signId;
    params[kUUID] = [DDGSetting sharedSettings].UUID_MD5;
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSString *versionStr = [NSString stringWithFormat:@"xdjlIOS%@",currentVersion];
    params[@"appVersion"] = versionStr;
    
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    requestManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestManager POST:[PDAPI getSendFileAPI] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:self.imageData name:@"img" fileName:@"head.jpg" mimeType:@"image/jpg"];
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        //把图片添加到视图框内
        
        
        id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([[(NSDictionary *)json objectForKey:@"state"] isEqualToString:@"SUCCESS"]) {
            [MBProgressHUD showSuccessWithStatus:@"上传成功" toView:self.view];
            //[self handleData];
            //_headImgStr = [(NSDictionary *)json objectForKey:@"fileId"];
            
            if (iSelImg == 1)
             {
                img1.image=[UIImage imageWithData:self.imageData];
                strImgUrl1 = [(NSDictionary *)json objectForKey:@"fileId"];
                img2.hidden = NO;
                
             }
            else if (iSelImg == 2)
             {
                img2.image=[UIImage imageWithData:self.imageData];
                strImgUrl2 = [(NSDictionary *)json objectForKey:@"fileId"];
                img3.hidden = NO;
             }
            else if (iSelImg == 3)
             {
                img3.image=[UIImage imageWithData:self.imageData];
                strImgUrl3 = [(NSDictionary *)json objectForKey:@"fileId"];
             }
        }else{
            [MBProgressHUD showErrorWithStatus:[(NSDictionary *)json objectForKey:@"statusText"] toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [MBProgressHUD showErrorWithStatus:[operation.error localizedDescription] toView:self.view];
        self.imageData = nil;
    }];
}





@end
