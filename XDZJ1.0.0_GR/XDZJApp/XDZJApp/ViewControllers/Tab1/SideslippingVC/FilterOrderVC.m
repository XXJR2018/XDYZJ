//
//  FilterOrderVC.m
//  XXJR
//
//  Created by xxjr02 on 2018/3/29.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import "FilterOrderVC.h"
#import "HQButton.h"
#import "JYJAnimateViewController.h"

@interface FilterOrderVC ()<ButtonDelegateWithParameter>
{
    
    HQButton *btnZDY;
    HQButton *btnGood;
    HQButton *btnAll;
    
    
    int iViewWidth;  //当前view 的宽度
    int iChildViewTopY;  // 子view 的顶点坐标
    int iChildViewHeight; // 子view 的高度
    

    
    UIView *viewChild1;
    UIScrollView *scViewChild1; // 子类滚动view1
    NSMutableArray *arrySXBtn; // 按钮数组
    NSArray *arryBtnTitle; // 按钮标题数组
    NSArray  * arryParamsStr;  // 按钮参数数组
    
    HQButton  *btnDaiQ; // 待抢按钮
    HQButton  *btnYiQ; // 已抢按钮
    
    UIView *viewIncome;       // 月收入view
    NSMutableArray *arrayBtnIncome;  //月收入按钮数组
    NSArray *arrayIncomeTitle; // 月收入标题数组
    NSArray *arrayIncomParm; // 月收入参数数组
    UITextField *textYSRMin;  // 月收入最低金额
    UITextField *textYSRMax;  // 月收入最高金额
    
    UIView *viewJournal;      // 流水view
    NSMutableArray *arrayBtnJournal;  //流水按钮数组
    NSArray *arrayJournalTitle; // 流水标题数组
    NSArray *arrayJournalParm; // 流水参数数组
    
    
    
    UIButton *btnSBZ;   // 上班族的按钮
    UIButton *btnQYZ;   // 企业主的按钮
    
    UITextField *textDKMin;  // 贷款最低金额
    UITextField *textDKMax;  // 贷款最高金额

    UITextField *textJYLSMin;  // 经营流水最低金额
    UITextField *textJYLSMax;  // 经营流水最高金额


    int iOrgOtherTopY; // 其他筛选提交的顶点坐标 (月收入，经验流水)
    int iCurOtherTopY; // 其他筛选提交的当前顶点坐标 (月收入，经验流水)
    int iOtherNum;   //  表示当前插入在第几序列号
    
    UIView* viewChild1Tail;
    NSMutableArray *arryRZBtn; // 认证按钮数组
    NSArray *arryRZBtnTitle; // 认证按钮标题数组
    NSArray  * arryRZParamsStr;  // 认证按钮参数数组

    
    UIView *viewChild2;
    UIView *viewChild3;
    
    int iCurPage;  //当前所在页面   1 - 自定义   2- 资质客户   3- 所有订单
    int iQueryType; //  筛选类型(1-自定义类型 2-资质客户  3-全部订单)
}
@end

@implementation FilterOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 初始化的数据
    [self initData];
    
    [self layoutUI];
    
    [self getDataFromCach];
    
    //添加手势点击空白处隐藏键盘
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchViewKeyBoard)];
    gesture.numberOfTapsRequired  = 1;
    [self.view addGestureRecognizer:gesture];
}


//添加手势点击空白处隐藏键盘
-(void)TouchViewKeyBoard
{
    [self.view endEditing:YES];
}

-(void) initData
{
    
    arryBtnTitle = [NSArray arrayWithObjects:@"有房产",@"有车产",@"有保单",
                    @"有社保", @"有公积金", @"上班族",
                    @"企业主",  @"代发工资",  @"微粒贷",
                    @"有芝麻分",nil];
    arryParamsStr = @[@"houseType",@"carType",@"insurType",
                      @"socialType",@"fundType",@"inWorkType1",
                      @"inWorkType2",@"isPayroll",@"haveWeiLi",
                      @"zimaScore"];
    
    
    // 认证按钮标题数组
    arryRZBtnTitle = @[@"身份征认证",@"社保认证",@"公积金认证",
                       @"学信网认证",@"京东认证"];
    // 认证按钮参数数组
    arryRZParamsStr = @[@"cardNoIdentify",@"socialIdentify",@"fundIdentify",
                        @"chsiIdentify",@"jdIdentify"];
    
    
    NSDictionary *dicFilter = [CommonInfo getKeyOfDic:K_FILTER_ELEMENT];
    if ([dicFilter count] >=1)
     {
        NSDictionary *dicIncome = dicFilter[@"incomeInfo"];
        if ([dicIncome  count] > 0)
         {
            arrayIncomeTitle = dicIncome[@"incomeKey"]; // 月收入标题数组
            arrayIncomParm = dicIncome[@"incomeVal"]; // 月收入参数数组
         }
        
        NSDictionary *dicJournal = dicFilter[@"journalInfo"];
        if ([dicJournal  count] > 0)
         {
            arrayJournalTitle = dicJournal[@"journalKey"]; // 流水标题数组
            arrayJournalParm = dicJournal[@"journalVal"]; // 流水参数数组
         }
        
     }
    
    
    arrySXBtn  = [[NSMutableArray alloc] init];
    arrayBtnIncome  = [[NSMutableArray alloc] init];
    arrayBtnJournal = [[NSMutableArray alloc] init];
    arryRZBtn = [[NSMutableArray alloc] init];
    
    
}

-(void) layoutUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 获取当前view 的宽度
    iViewWidth = [UIScreen mainScreen].bounds.size.width - 50;
    if ([UIScreen mainScreen].bounds.size.width > 375) {
        iViewWidth -= 50;
    } else if ([UIScreen mainScreen].bounds.size.width > 320) {
        iViewWidth = iViewWidth - 25;
    }
    
    int iTopY =  IS_IPHONE_X_MORE? (39) : 30;
    int iLefx = 10;
    int iBtnWdith = (iViewWidth - 4 * iLefx)/3;
    int iBtnHeight = 30;
    btnZDY = [[HQButton alloc] initWithFrame:CGRectMake(iLefx, iTopY, iBtnWdith, iBtnHeight)];
    //[self.view addSubview:btnZDY];
    btnZDY.iStyle = 1;
    [btnZDY setTitle:@"自定义" forState:UIControlStateNormal];
    [btnZDY setNOSelected];
    btnZDY.delegateWithParamater = self;
    [btnZDY addTarget:self action:@selector(actionSelStyle:) forControlEvents:UIControlEventTouchUpInside];

//    int iNextLefx =  iLefx + iBtnWdith + iLefx;
//    btnGood = [[HQButton alloc] initWithFrame:CGRectMake(iNextLefx, iTopY, iBtnWdith, iBtnHeight)];
//    [self.view addSubview:btnGood];
//    btnGood.iStyle = 1;
//
//    [btnGood setTitle:@"资质客户" forState:UIControlStateNormal];
//    [btnGood setNOSelected];
//    btnGood.delegateWithParamater = self;
//    [btnGood addTarget:self action:@selector(actionSelStyle:) forControlEvents:UIControlEventTouchUpInside];
//
//
//    iNextLefx +=  iLefx + iBtnWdith;
//    btnAll = [[HQButton alloc] initWithFrame:CGRectMake(iNextLefx, iTopY, iBtnWdith, iBtnHeight)];
//    [self.view addSubview:btnAll];
//    btnAll.iStyle = 1;
//    [btnAll setTitle:@"所有订单" forState:UIControlStateNormal];
//    [btnAll setNOSelected];
//    btnAll.delegateWithParamater = self;
//    [btnAll addTarget:self action:@selector(actionSelStyle:) forControlEvents:UIControlEventTouchUpInside];
    
    //分割线
    //iTopY += btnZDY.height + 10;
    iTopY +=  10;
    UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(iLefx, iTopY, iViewWidth - 2*iLefx, 1)];
    //[self.view addSubview:viewFG];
    viewFG.backgroundColor = [ResourceManager color_5];
    
    iChildViewTopY  = iTopY;
    iChildViewHeight = SCREEN_HEIGHT - iChildViewTopY;

    
    [self layoutChild1];
    [self layoutChild2];
    [self layoutChild3];
    
    
    
}

-(void) layoutChild1
{
    viewChild1 = [[UIView alloc] initWithFrame:CGRectMake(0, iChildViewTopY, iViewWidth, iChildViewHeight)];
    [self.view addSubview:viewChild1];
    //viewChild1.backgroundColor = [UIColor greenColor];
    
    scViewChild1 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, iViewWidth, iChildViewHeight -43)];
    [viewChild1 addSubview:scViewChild1];
    scViewChild1.contentSize = CGSizeMake(0, 550);
    //scViewChild1.backgroundColor = [UIColor yellowColor];
    
    
    // 加入贷款金额范围
    int iTopY =  10;
    int iLeftX = 10;
    
    
    NSDictionary *dicRet =   [self createInputViewAtTopY:iTopY labelText:@"贷款金额范围（万元）" unitText:@"万元" ];
    textDKMin = dicRet[@"minText"];
    textDKMax = dicRet[@"maxText"];
    UIView *viewDK = dicRet[@"view"];
    [scViewChild1 addSubview:viewDK];
    
    //分割线
    iTopY += viewDK.height + 10;
    UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iViewWidth - 2*iLeftX, 1)];
    [scViewChild1 addSubview:viewFG];
    viewFG.backgroundColor = [ResourceManager color_5];
    
    // 列表类型(1-优质客户，2-直借客户)
    if (1 == _borrowType)
     {
        iTopY += 10;
        UILabel *labelText = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 100, 20)];
        [scViewChild1 addSubview:labelText];
        labelText.textColor = [ResourceManager color_1];
        labelText.font = [UIFont systemFontOfSize:14];
        labelText.text = @"订单状态";
        
        
        // 布局按钮
        iTopY += labelText.height + 10;
        int iBtnLeftX = iLeftX;
        int iBtnTopY = iTopY;
        int iBtnWdith = (iViewWidth - 4 * iLeftX)/3;
        int iBtnHeight = 30;
        
        
        btnDaiQ = [[HQButton alloc] initWithFrame:CGRectMake(iBtnLeftX, iBtnTopY, iBtnWdith, iBtnHeight)];
        [scViewChild1 addSubview:btnDaiQ];
        btnDaiQ.iStyle = 2;
        btnDaiQ.tag = 0;
        [btnDaiQ setTitle:@"待抢" forState:UIControlStateNormal];
        [btnDaiQ setNOSelected];
        btnDaiQ.delegateWithParamater = self;
        [btnDaiQ addTarget:self action:@selector(actionIncome:) forControlEvents:UIControlEventTouchUpInside];
        
        iBtnLeftX += iLeftX + iBtnWdith;
        btnYiQ = [[HQButton alloc] initWithFrame:CGRectMake(iBtnLeftX, iBtnTopY, iBtnWdith, iBtnHeight)];
        [scViewChild1 addSubview:btnYiQ];
        btnYiQ.iStyle = 2;
        btnYiQ.tag = 1;
        [btnYiQ setTitle:@"已抢" forState:UIControlStateNormal];
        [btnYiQ setNOSelected];
        btnYiQ.delegateWithParamater = self;
        [btnYiQ addTarget:self action:@selector(actionIncome:) forControlEvents:UIControlEventTouchUpInside];
        
        iTopY += btnYiQ.height + 10;
        UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iViewWidth - 2*iLeftX, 1)];
        [scViewChild1 addSubview:viewFG];
        viewFG.backgroundColor = [ResourceManager color_5];
     }
    
    iTopY += 10;
    UILabel *labelText = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 100, 20)];
    [scViewChild1 addSubview:labelText];
    labelText.textColor = [ResourceManager color_1];
    labelText.font = [UIFont systemFontOfSize:14];
    labelText.text = @"资质条件";
    
    // 布局按钮
    iTopY += labelText.height + 10;
    int iBtnLeftX = iLeftX;
    int iBtnTopY = iTopY;
    int iBtnWdith = (iViewWidth - 4 * iLeftX)/3;
    int iBtnHeight = 30;
    
   
    
//    arryBtnTitle = [NSArray arrayWithObjects:@"有房产",@"有车产",@"有保单",
//                    @"有社保", @"有公积金", @"上班族",
//                    @"企业主",  @"代发工资",  @"微粒贷",
//                    @"有芝麻分",nil];
//    arryParamsStr = @[@"houseType",@"carType",@"insurType",
//                      @"socialType",@"fundType",@"inWorkType1",
//                      @"inWorkType2",@"isPayroll",@"zimaScore",
//                      @"haveWeiLi"];
    
    [arrySXBtn removeAllObjects];
    for (int i  = 0;  i < [arryBtnTitle count]; i++ )
     {
        int iCurNum  = i +1;
        int iCurH =  iCurNum %3 ;
        if ( 0 == i)
         {
            iBtnLeftX = iLeftX;
            iBtnTopY = iTopY;
         }
        else if (1 == iCurH &&
                iCurNum >= 4)
         {
             // 换行
            iBtnLeftX = iLeftX;
            iBtnTopY += iBtnHeight + 10;
         }
        else
         {
            // 换列
            iBtnLeftX += iLeftX + iBtnWdith;
         }
        
        HQButton  *btnTemp = [[HQButton alloc] initWithFrame:CGRectMake(iBtnLeftX, iBtnTopY, iBtnWdith, iBtnHeight)];
        [scViewChild1 addSubview:btnTemp];
        btnTemp.iStyle = 2;
        btnTemp.tag = i;
        [btnTemp setTitle:arryBtnTitle[i] forState:UIControlStateNormal];
        [btnTemp setNOSelected];
        btnTemp.delegateWithParamater = self;
        [btnTemp addTarget:self action:@selector(actionShaiXuan:) forControlEvents:UIControlEventTouchUpInside];
        
        // 记录下上班族 和 企业主的按钮
        if( 5 == i)
         {
            btnSBZ = btnTemp;
         }
        if (6 == i)
         {
            btnQYZ = btnTemp;
         }
        
        [arrySXBtn addObject:btnTemp];
     }
    
    iOrgOtherTopY = iBtnTopY + iBtnHeight + 20;
    iOtherNum = 0;
    
    iTopY = iOrgOtherTopY;

    
//    dicRet = [self createViewInCome];
//    viewIncome = dicRet[@"view"];
//    viewIncome.hidden = YES;
    
    dicRet =   [self createInputViewAtTopY:iTopY labelText:@"月收入（元）" unitText:@"元" ];
    textYSRMin = dicRet[@"minText"];
    textYSRMax = dicRet[@"maxText"];
    viewIncome = dicRet[@"view"];
    viewIncome.hidden = YES;

    

    iTopY += viewIncome.height + 10;
    dicRet = [self createViewJounal];
    viewJournal = dicRet[@"view"];
    viewJournal.hidden = YES;
    
    // 底部的 “认证view”
//    viewChild1Tail = [[UIView alloc] initWithFrame:CGRectMake(0, iOrgOtherTopY, iViewWidth, 120)];
//    [scViewChild1 addSubview:viewChild1Tail];
//    viewChild1Tail.backgroundColor = [UIColor clearColor];
//    [self creatViewRZ];
    
    scViewChild1.contentSize = CGSizeMake(0, iOrgOtherTopY + viewJournal.height + viewIncome.height + viewChild1Tail.height + 30);
    
    
    
    // 底部按钮
    UIButton * btnRest  = [[UIButton alloc] initWithFrame:CGRectMake(0, iChildViewHeight - 40, iViewWidth/2, 40)];
    [viewChild1 addSubview:btnRest];
    btnRest.backgroundColor = [ResourceManager viewBackgroundColor];
    btnRest.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnRest setTitle:@"重置" forState:UIControlStateNormal];
    [btnRest setTitleColor:[ResourceManager lightGrayColor] forState:UIControlStateNormal];
    [btnRest addTarget:self action:@selector(actionRest) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton * btnOK  = [[UIButton alloc] initWithFrame:CGRectMake(iViewWidth/2, iChildViewHeight - 40, iViewWidth/2, 40)];
    [viewChild1 addSubview:btnOK];
    btnOK.backgroundColor = [UIColor orangeColor];
    btnOK.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnOK setTitle:@"确定" forState:UIControlStateNormal];
    [btnOK addTarget:self action:@selector(actionOK) forControlEvents:UIControlEventTouchUpInside];
}


-(void) layoutChild2
{
    viewChild2 = [[UIView alloc] initWithFrame:CGRectMake(0, iChildViewTopY, iViewWidth, iChildViewHeight)];
    [self.view addSubview:viewChild2];
    //viewChild2.backgroundColor = [UIColor blueColor];
    
    
    int iTopY = 10;
    int iLeftX = 10;
    UILabel *labelShaiXuan = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iViewWidth - 2*iLeftX, 40)];
    [viewChild2 addSubview:labelShaiXuan];
    //labelShaiXuan.backgroundColor = UIColorFromRGB(0xFDF9EC);
    labelShaiXuan.textColor =  [UIColor orangeColor];//UIColorFromRGB(0x774311);
    labelShaiXuan.font = [UIFont systemFontOfSize:14];
    labelShaiXuan.text = @"满足有房、有车、有保单、有微粒贷任意一条";
    labelShaiXuan.numberOfLines = 0;
    
    UIButton * btnOK  = [[UIButton alloc] initWithFrame:CGRectMake(0, iChildViewHeight - 40, iViewWidth, 40)];
    [viewChild2 addSubview:btnOK];
    btnOK.backgroundColor = [UIColor orangeColor];
    btnOK.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnOK setTitle:@"确定" forState:UIControlStateNormal];
    [btnOK addTarget:self action:@selector(actionOK) forControlEvents:UIControlEventTouchUpInside];
    
}


-(void) layoutChild3
{
    viewChild3 = [[UIView alloc] initWithFrame:CGRectMake(0, iChildViewTopY, iViewWidth, iChildViewHeight)];
    [self.view addSubview:viewChild3];
    //viewChild3.backgroundColor = [UIColor redColor];
    
    int  iTopY = 10;
    int iLeftX = 10;
    UILabel *labelShaiXuan = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iViewWidth - 2*iLeftX, 30)];
    [viewChild3 addSubview:labelShaiXuan];
    //labelShaiXuan.backgroundColor = UIColorFromRGB(0xFDF9EC);
    labelShaiXuan.textColor = [UIColor orangeColor];//UIColorFromRGB(0x774311);;
    labelShaiXuan.font = [UIFont systemFontOfSize:14];
    labelShaiXuan.text = @"  查询所有的订单";
    
    UIButton * btnOK  = [[UIButton alloc] initWithFrame:CGRectMake(0, iChildViewHeight - 40, iViewWidth, 40)];
    [viewChild3 addSubview:btnOK];
    btnOK.backgroundColor = [UIColor orangeColor];
    btnOK.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnOK setTitle:@"确定" forState:UIControlStateNormal];
    [btnOK addTarget:self action:@selector(actionOK) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void) creatViewRZ
{
    int iTopY = 0;
    int iLeftX = 10;
    iTopY += 10;
    UILabel *labelText = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 100, 20)];
    [viewChild1Tail addSubview:labelText];
    labelText.textColor = [ResourceManager color_1];
    labelText.font = [UIFont systemFontOfSize:14];
    labelText.text = @"信用认证";
    
    // 布局按钮
    iTopY += labelText.height + 10;
    int iBtnLeftX = iLeftX;
    int iBtnTopY = iTopY;
    int iBtnWdith = (iViewWidth - 4 * iLeftX)/3;
    int iBtnHeight = 30;
    
    [arryRZBtn removeAllObjects];
    for (int i  = 0;  i < [arryRZBtnTitle count]; i++ )
     {
        int iCurNum  = i +1;
        int iCurH =  iCurNum %3 ;
        if ( 0 == i)
         {
            iBtnLeftX = iLeftX;
            iBtnTopY = iTopY;
         }
        else if (1 == iCurH &&
                 iCurNum >= 4)
         {
            // 换行
            iBtnLeftX = iLeftX;
            iBtnTopY += iBtnHeight + 10;
         }
        else
         {
            // 换列
            iBtnLeftX += iLeftX + iBtnWdith;
         }
        
        HQButton  *btnTemp = [[HQButton alloc] initWithFrame:CGRectMake(iBtnLeftX, iBtnTopY, iBtnWdith, iBtnHeight)];
        [viewChild1Tail addSubview:btnTemp];
        btnTemp.iStyle = 2;
        btnTemp.tag = i;
        [btnTemp setTitle:arryRZBtnTitle[i] forState:UIControlStateNormal];
        [btnTemp setNOSelected];
        btnTemp.delegateWithParamater = self;
        //[btnTemp addTarget:self action:@selector(actionShaiXuan:) forControlEvents:UIControlEventTouchUpInside];
        
        [arryRZBtn addObject:btnTemp];
     }
    
}

-(NSDictionary *) createInputViewAtTopY:(int) iParentTopY    labelText:(NSString*) strTitle   unitText:(NSString*) strUnit
{
    UIView *viewInput = [[UIView alloc] initWithFrame:CGRectMake(0, iParentTopY, SCREEN_WIDTH, 60)];
    
    
    int iLeftX = 10;
    int iTopY = 0;
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 200, 20)];
    [viewInput addSubview:labelTitle];
    labelTitle.textColor = [ResourceManager color_1];
    labelTitle.font = [UIFont systemFontOfSize:14];
    labelTitle.text =  strTitle;//@"贷款金额范围(万元)";
    
    iTopY += labelTitle.height + 10;
    int iTextWidth = (iViewWidth - 2*10 - 30 - 2 *30 )/2;
    int iTextHeight = 30;
    
    UIView *viewBackground1 =  [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iTextWidth, iTextHeight)];
    [viewInput addSubview:viewBackground1];
    viewBackground1.backgroundColor = [ResourceManager viewBackgroundColor];
    
    
    UITextField *minText = [[UITextField alloc] initWithFrame:CGRectMake(iTextWidth/4, 0, iTextWidth*3/4, iTextHeight)];
    [viewBackground1 addSubview:minText];
    minText.backgroundColor = [ResourceManager viewBackgroundColor];
    minText.placeholder = @"最低金额";
    minText.font = [UIFont systemFontOfSize:14];
    minText.keyboardType = UIKeyboardTypeDecimalPad;
    
    iLeftX += viewBackground1.width + 3;
    UILabel *labelUnit1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 30, iTextHeight)];
    [viewInput addSubview:labelUnit1];
    labelUnit1.textColor = [ResourceManager  color_1];
    labelUnit1.font = [UIFont systemFontOfSize:14];
    labelUnit1.text = strUnit;//@"万元";
    
    iLeftX += labelUnit1.width + 5;
    UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(iLeftX,  iTopY +iTextHeight/2, 20, 1)];
    [viewInput addSubview:viewFG];
    viewFG.backgroundColor = [ResourceManager  color_1];
    
    iLeftX += 5 + viewFG.width;
    UIView *viewBackground2 =  [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iTextWidth, iTextHeight)];
    [viewInput addSubview:viewBackground2];
    viewBackground2.backgroundColor = [ResourceManager viewBackgroundColor];
    
    UITextField *maxText = [[UITextField alloc] initWithFrame:CGRectMake(iTextWidth/4, 0, iTextWidth*3/4, iTextHeight)];
    [viewBackground2 addSubview:maxText];
    maxText.backgroundColor = [ResourceManager viewBackgroundColor];
    maxText.placeholder = @"最高金额";
    maxText.font = [UIFont systemFontOfSize:14];
    maxText.keyboardType = UIKeyboardTypeDecimalPad;
    
    iLeftX += viewBackground2.width + 3;
    UILabel *labelUnit2 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 30, iTextHeight)];
    [viewInput addSubview:labelUnit2];
    labelUnit2.textColor = [ResourceManager  color_1];
    labelUnit2.font = [UIFont systemFontOfSize:14];
    labelUnit2.text = strUnit;//@"万元";
    
    NSMutableDictionary *retDic = [[NSMutableDictionary alloc] init];
    retDic[@"view"] = viewInput;
    retDic[@"maxText"] = maxText;
    retDic[@"minText"] = minText;
    return retDic;
}

-(NSDictionary*) createViewInCome
{
    int iBtnHeight = 30;
    int iLineCount =  (int)[arrayIncomeTitle count]/3;
    if ([arrayIncomeTitle count]%3 != 0)
     {
        iLineCount += 1;
     }
    
    
    int iViewHeight = iLineCount* iBtnHeight  + iLineCount*10   + 20 + 5;
    UIView *viewInput = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, iViewHeight)];
    //viewInput.backgroundColor = [UIColor blueColor];
    
    int iLeftX = 10;
    int iTopY = 0;
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 200, 20)];
    [viewInput addSubview:labelTitle];
    labelTitle.textColor = [ResourceManager color_1];
    labelTitle.font = [UIFont systemFontOfSize:14];
    labelTitle.text = @"月收入(元)";
    
    iTopY += labelTitle.height + 10;


    int iBtnLeftX = iLeftX;
    int iBtnTopY = iTopY;
    int iBtnWdith = (iViewWidth - 4 * iLeftX)/3;
    
    [arrayBtnIncome removeAllObjects];
    
    //NSArray *arrayBtnIncome;  //月收入按钮数组
    //NSArray *arrayIncomeTitle; // 月收入标题数组
    //NSString *arrayIncomParm; // 月收入参数数组
    for (int i  = 0;  i < [arrayIncomeTitle count]; i++ )
     {
        int iCurNum  = i +1;
        int iCurH =  iCurNum %3 ;
        if ( 0 == i)
         {
            iBtnLeftX = iLeftX;
            iBtnTopY = iTopY;
         }
        else if (1 == iCurH &&
                 iCurNum >= 4)
         {
            // 换行
            iBtnLeftX = iLeftX;
            iBtnTopY += iBtnHeight + 10;
         }
        else
         {
            // 换列
            iBtnLeftX += iLeftX + iBtnWdith;
         }
        
        HQButton  *btnTemp = [[HQButton alloc] initWithFrame:CGRectMake(iBtnLeftX, iBtnTopY, iBtnWdith, iBtnHeight)];
        [viewInput addSubview:btnTemp];
        btnTemp.iStyle = 2;
        btnTemp.tag = 100+i;
        [btnTemp setTitle:arrayIncomeTitle[i] forState:UIControlStateNormal];
        btnTemp.titleLabel.font = [UIFont systemFontOfSize:13];
        btnTemp.iFontSize = 13;
        [btnTemp setNOSelected];
        btnTemp.delegateWithParamater = self;
        [btnTemp addTarget:self action:@selector(actionIncome:) forControlEvents:UIControlEventTouchUpInside];
        

        
        [arrayBtnIncome addObject:btnTemp];
     }
    
    NSMutableDictionary *retDic = [[NSMutableDictionary alloc] init];
    retDic[@"view"] = viewInput;
    return retDic;
    

}

-(NSDictionary*) createViewJounal
{
    int iBtnHeight = 30;
    int iLineCount =  (int)[arrayJournalTitle count]/3;
    if ([arrayJournalTitle count]%3 != 0)
     {
        iLineCount += 1;
     }
    
    int iViewHeight = iLineCount * iBtnHeight  +  iLineCount *10   + 20 + 5;
    UIView *viewInput = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, iViewHeight)];
    //viewInput.backgroundColor = [UIColor blueColor];
    
    int iLeftX = 10;
    int iTopY = 0;
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 200, 20)];
    [viewInput addSubview:labelTitle];
    labelTitle.textColor = [ResourceManager color_1];
    labelTitle.font = [UIFont systemFontOfSize:14];
    labelTitle.text = @"营业执照";
    
    iTopY += labelTitle.height + 10;
    
    
    int iBtnLeftX = iLeftX;
    int iBtnTopY = iTopY;
    int iBtnWdith = (iViewWidth - 4 * iLeftX)/3;
    
    [arrayBtnJournal removeAllObjects];
    
    //NSMutableArray *arrayBtnJournal;  //流水按钮数组
    //NSArray *arrayJournalTitle; // 流水标题数组
    //NSString *arrayJournalParm; // 流水参数数组
    for (int i  = 0;  i < [arrayJournalTitle count]; i++ )
     {
        int iCurNum  = i +1;
        int iCurH =  iCurNum %3 ;
        if ( 0 == i)
         {
            iBtnLeftX = iLeftX;
            iBtnTopY = iTopY;
         }
        else if (1 == iCurH &&
                 iCurNum >= 4)
         {
            // 换行
            iBtnLeftX = iLeftX;
            iBtnTopY += iBtnHeight + 10;
         }
        else
         {
            // 换列
            iBtnLeftX += iLeftX + iBtnWdith;
         }
        
        HQButton  *btnTemp = [[HQButton alloc] initWithFrame:CGRectMake(iBtnLeftX, iBtnTopY, iBtnWdith, iBtnHeight)];
        [viewInput addSubview:btnTemp];
        btnTemp.iStyle = 2;
        btnTemp.tag = 200+i;
        [btnTemp setTitle:arrayJournalTitle[i] forState:UIControlStateNormal];
        btnTemp.titleLabel.font = [UIFont systemFontOfSize:14];
        btnTemp.iFontSize = 11;
        [btnTemp setNOSelected];
        btnTemp.delegateWithParamater = self;
        [btnTemp addTarget:self action:@selector(actionIncome:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [arrayBtnJournal addObject:btnTemp];
     }
    
    NSMutableDictionary *retDic = [[NSMutableDictionary alloc] init];
    retDic[@"view"] = viewInput;
    return retDic;
}




-(void) getDataFromCach
{
    // borrowType; // 列表类型(1-优质客户，2-直借客户)
    NSString *strQuerKey =  K_GOOD_QueryType;
    NSString *strDicKey =  K_GOOD_FIlTER;
    
    if (1 == _borrowType)
     {
        strQuerKey =  K_GOOD_QueryType;
        strDicKey =  K_GOOD_FIlTER;
     }
    else if (2 == _borrowType)
     {
        strQuerKey =  K_ZHIJIE_QueryType;
        strDicKey =  K_ZHIJIE_FILTER;
     }
    

    NSString *strQueryType = [CommonInfo getKey:strQuerKey];
    if (strQueryType.length > 0)
     {
        
        // 如果是自定义
        if ([strQueryType isEqualToString:@"1"] )
         {
            NSDictionary *dicSX = [CommonInfo getKeyOfDic:strDicKey];
            [self actionSelStyle:btnZDY];
            [self setBtnSelected:dicSX];
         }
        else  if ([strQueryType isEqualToString:@"2"])
         {
            [self actionSelStyle:btnGood];
         }
        else
         {
            [self actionSelStyle:btnAll];
         }
     }
    else
     {
        [self actionSelStyle:btnZDY];
     }
    
    

}

-(void) setBtnSelected:(NSDictionary*) dic
{
    
    //arrySXBtn  与  arryParamsStr  一一对应
    
    // 先排序key
    NSArray *keys = [dic allKeys];
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    
    for (NSString *key in sortedArray) {
    
        
        NSLog(@"paixu  key: %@ value: %@", key, dic[key]);
        
        if ([key isEqualToString:@"queryType"])
         {
            continue;
         }
        
        
        // 设置筛选按钮
        for (int i = 0; i < [arryParamsStr count]; i++)
         {
            // 如果字典中的key 与 按钮的字符串 相等， 选择字符串
            if ([arryParamsStr[i] isEqualToString:key] &&
                [dic[key] intValue] == 1)
             {
                UIButton *btnTemp = (UIButton*)arrySXBtn[i];
                
                if (!btnTemp.selected)
                 {
                    // 触发系统的点击事件
                    [btnTemp sendActionsForControlEvents:UIControlEventTouchUpInside];
                 }
             }
         }
        
        // 设置认证按钮
        for (int i = 0; i < [arryRZParamsStr count]; i++)
         {
            // 如果字典中的key 与 按钮的字符串 相等， 选择字符串
            if ([arryRZParamsStr[i] isEqualToString:key] &&
                [dic[key] intValue] == 1)
             {
                UIButton *btnTemp = (UIButton*)arryRZBtn[i];
                
                if (!btnTemp.selected)
                 {
                    // 触发系统的点击事件
                    [btnTemp sendActionsForControlEvents:UIControlEventTouchUpInside];
                 }
             }
         }
        
    }
    


    
    
    // 设置贷款金额, 防止崩溃
    if (dic[@"minLoanAmount"])
     {
        NSString *strMinTemp = [NSString stringWithFormat:@"%@", dic[@"minLoanAmount"]];
        
        if (strMinTemp &&
            strMinTemp.length > 0)
         {
            textDKMin.text = strMinTemp;
         }
     }

    if (dic[@"maxLoanAmount"])
     {
        NSString *strMaxTemp = [NSString stringWithFormat:@"%@", dic[@"maxLoanAmount"]];
        if (strMaxTemp &&
            strMaxTemp.length > 0)
         {
            textDKMax.text = strMaxTemp;
         }
     }

    
    if (dic[@"minIncome"])
     {
        NSString *strMinTemp = [NSString stringWithFormat:@"%@", dic[@"minIncome"]];
        
        if (strMinTemp &&
            strMinTemp.length > 0)
         {
            textYSRMin.text = strMinTemp;
         }
     }
    
    if (dic[@"maxIncome"])
     {
        NSString *strMaxTemp = [NSString stringWithFormat:@"%@", dic[@"maxIncome"]];
        if (strMaxTemp &&
            strMaxTemp.length > 0)
         {
            textYSRMax.text = strMaxTemp;
         }
     }

    NSObject  *object = dic[@"orderStatus"];
    // 读取的本地设置
    if ([object isKindOfClass:[NSString class]])
     {
        NSString *strOrderStatus = dic[@"orderStatus"];
        if ([strOrderStatus containsString:@"0"])
         {
            // 触发系统的点击事件
            if (!btnDaiQ.selected)
             {
                [btnDaiQ sendActionsForControlEvents:UIControlEventTouchUpInside];
             }

         }
        if ([strOrderStatus containsString:@"1"])
         {
            // 触发系统的点击事件
            if (!btnYiQ.selected)
             {
                [btnYiQ sendActionsForControlEvents:UIControlEventTouchUpInside];
             }
         }
        
     }
    
    // 读取的网络设置
    if ([object isKindOfClass:[NSArray class]])
     {
        NSArray* arrInCome = dic[@"orderStatus"];
        if ([arrInCome count] > 0)
         {
            for (int i = 0; i < [arrInCome count]; i++)
             {
                NSString *strTemp = arrInCome[i];
                
                if ([strTemp containsString:@"0"])
                 {
                    // 触发系统的点击事件
                    if (!btnDaiQ.selected)
                     {
                        [btnDaiQ sendActionsForControlEvents:UIControlEventTouchUpInside];
                     }
                    
                 }
                if ([strTemp containsString:@"1"])
                 {
                    // 触发系统的点击事件
                    if (!btnYiQ.selected)
                     {
                        [btnYiQ sendActionsForControlEvents:UIControlEventTouchUpInside];
                     }
                 }
             }
         }
     }
    

    

    // 设置企业主
    NSString *strYYZZ =  [NSString stringWithFormat:@"%@",  dic[@"hasLicense"]];
    if ([strYYZZ isEqualToString:@"1"])
     {
        for (int j = 0; j < [arrayJournalParm count]; j++)
         {
            UIButton *btnTemp = (UIButton*)arrayBtnJournal[0];
            if (!btnTemp.selected)
             {
                // 触发系统的点击事件
                [btnTemp sendActionsForControlEvents:UIControlEventTouchUpInside];
             }
            
         }
     }

    // 设置企业主
    object = dic[@"inJournal"];
    if ([object isKindOfClass:[NSArray class]])
     {
        NSArray* arrInCome = dic[@"inJournal"];
        if ([arrInCome count] > 0)
         {
            for (int i = 0; i < [arrInCome count]; i++)
             {
                NSString *strTemp = arrInCome[i];
                for (int j = 0; j < [arrayJournalParm count]; j++)
                 {
                    if ([strTemp isEqualToString:arrayJournalParm[j]])
                     {
                        UIButton *btnTemp = (UIButton*)arrayBtnJournal[j];
                        if (!btnTemp.selected)
                         {
                            // 触发系统的点击事件
                            [btnTemp sendActionsForControlEvents:UIControlEventTouchUpInside];
                         }
                     }
                 }
             }
         }
     }
    else
     {
        NSString *strInJournal = dic[@"inJournal"];
        if (strInJournal.length > 0)
         {
            NSArray *arrInCome = [strInJournal componentsSeparatedByString:@","];
            if ([arrInCome count] > 0)
             {
                for (int i = 0; i < [arrInCome count]; i++)
                 {
                    NSString *strTemp = arrInCome[i];
                    for (int j = 0; j < [arrayJournalParm count]; j++)
                     {
                        if ([strTemp isEqualToString:arrayJournalParm[j]])
                         {
                            UIButton *btnTemp = (UIButton*)arrayBtnJournal[j];
                            if (!btnTemp.selected)
                             {
                                // 触发系统的点击事件
                                [btnTemp sendActionsForControlEvents:UIControlEventTouchUpInside];
                             }
                         }
                     }
                 }
             }
         }
     }
    
    
    
    


}

#pragma mark  ---   实现HQButton 协议里的方法
-(void)delegateFunctionWithParameter:(id)parameter{
    NSLog(@"%@",parameter);
    HQButton *btn = (HQButton*)parameter;
    //((UIButton*)parameter).tag = 1000;
    
    if (btn.selected)
     {
        [btn setNOSelected];
     }
    else
     {
        [btn setIsSelected];
     }
    btn.selected = !btn.selected;
    
}

#pragma mark --- action
-(void) actionSelStyle:(UIButton*) sender
{
    
    [btnZDY setNOSelected];
    [btnGood setNOSelected];
    [btnAll setNOSelected];

    [viewChild1 removeFromSuperview];
    [viewChild2 removeFromSuperview];
    [viewChild3 removeFromSuperview];
    
    if ([sender isEqual:btnZDY])
     {
        iCurPage = 1;
        [btnZDY setIsSelected];
        [self.view addSubview:viewChild1];
        [self getChild1Select];
        
     }
    else if ([sender isEqual:btnGood])
     {
        iCurPage = 2;
        [btnGood setIsSelected];
        [self.view addSubview:viewChild2];

     }
    else if ([sender isEqual:btnAll])
     {
        iCurPage = 3;
        [btnAll setIsSelected];
        [self.view addSubview:viewChild3];

     }

}

-(void) getChild1Select
{
    NSString *strQuerKey =  K_GOOD_QueryType;
    NSString *strDicKey =  K_GOOD_FIlTER;
    
    if (1 == _borrowType)
     {
        strQuerKey =  K_GOOD_QueryType;
        strDicKey =  K_GOOD_FIlTER;
     }
    else if (2 == _borrowType)
     {
        strQuerKey =  K_ZHIJIE_QueryType;
        strDicKey =  K_ZHIJIE_FILTER;
     }
    
    NSDictionary *dicSX = [CommonInfo getKeyOfDic:strDicKey];
    [self setBtnSelected:dicSX];
}

-(void) actionShaiXuan:(UIButton*) sender
{
  
    //[self setParams];
    
    int iTag =  (int)sender.tag;
    if ( 5 == iTag)
     {

        if(sender.selected)
         {
            if (viewJournal.hidden)
             {
                viewIncome.top = iOrgOtherTopY;
                [scViewChild1 addSubview:viewIncome];
                viewIncome.hidden = NO;

                iOtherNum = 1;
             }
            else
             {
                if (iOtherNum == 1)
                 {
                    viewIncome.top = iOrgOtherTopY + viewJournal.height +10;
                    [scViewChild1 addSubview:viewIncome];
                    viewIncome.hidden = NO;

                 }
                else
                 {
                    viewIncome.top = iOrgOtherTopY;
                    [scViewChild1 addSubview:viewIncome];
                    viewIncome.hidden = NO;

                 }
             }
         }
        else
         {
            viewIncome.hidden = YES;
            
            if (viewIncome.top == iOrgOtherTopY)
             {
                iOtherNum = 0;
             }
            else
             {
                iOtherNum = 1;
             }
         }
        
        
        

     }
    if (6 == iTag)
     {
        

        if(sender.selected)
         {
            if (viewIncome.hidden)
             {
                viewJournal.top = iOrgOtherTopY;
                [scViewChild1 addSubview:viewJournal];
                viewJournal.hidden = NO;

                iOtherNum = 1;
             }
            else
             {
                if (iOtherNum == 1)
                 {
                    viewJournal.top = iOrgOtherTopY + viewIncome.height + 10;
                    [scViewChild1 addSubview:viewJournal];
                    viewJournal.hidden = NO;


                 }
                else
                 {
                    viewJournal.top = iOrgOtherTopY;
                    [scViewChild1 addSubview:viewJournal];
                    viewJournal.hidden = NO;

                 }
             }
         }
        else
         {
            viewJournal.hidden = YES;

            if (viewJournal.top == iOrgOtherTopY)
             {
                iOtherNum = 0;
             }
            else
             {
                iOtherNum = 1;
             }
         }
        
     }
    
    if (!viewIncome.hidden  &&
        !viewJournal.hidden)
     {
        viewChild1Tail.top = iOrgOtherTopY + viewIncome.height + 10 + viewJournal.height + 10;
     }
    else if (!viewJournal.hidden)
     {
        viewChild1Tail.top = iOrgOtherTopY  + viewJournal.height + 10;
        if(viewJournal.top != iOrgOtherTopY)
         {
            viewChild1Tail.top +=  viewIncome.height + 10;
         }
     }
    else if (!viewIncome.hidden)
     {
        viewChild1Tail.top = iOrgOtherTopY + viewIncome.height + 10 ;
        if(viewIncome.top != iOrgOtherTopY)
         {
            viewChild1Tail.top +=  viewJournal.height + 10;
         }
     }
    else
     {
        viewChild1Tail.top = iOrgOtherTopY;
     }
    
}

-(void) actionIncome:(UIButton*) sender
{
    
}

-(void) actionJournal:(UIButton*) sender
{
    
}

-(NSDictionary*) setParams
{
    
    NSMutableDictionary *paramsValue = [[NSMutableDictionary alloc] init];
    
    // 筛选类型(1-自定义类型 2-资质客户 3-全部订单)
    paramsValue[@"queryType"] = @(iCurPage);
    NSString *strQueryType = [NSString stringWithFormat:@"%d", iCurPage];
    
    
    //#define  K_GOOD_FIlTER  @"K_Good_Filter"    //资质客户筛选条件（存取的都是字典）
    //#define  K_GOOD_QueryType  @"K_GOOD_QueryType"    //资质客户筛选类型  (1-自定义类型 2-资质客户3-全部订单)
    //
    //#define  K_ZHIJIE_FILTER  @"K_ZhiJie_Filter"  // 直接客户筛选条件 （存取的都是字典）
    //#define  K_ZHIJIE_QueryType  @"K_ZhiJie_QueryType"    //资质客户筛选类型  (1-自定义类型 2-资质客户3-全部订单)
    if (1 == _borrowType)
     {
        [CommonInfo setKey:K_GOOD_QueryType withValue:strQueryType];
        paramsValue[@"borrowType"] = @(1);
     }
    else if (2 == _borrowType)
     {
        [CommonInfo setKey:K_ZHIJIE_QueryType withValue:strQueryType];
        paramsValue[@"borrowType"] = @(2);
     }

    if (iCurPage != 1 )
     {
        return  paramsValue;
     }
    


    
    //NSArray *arryBtnTitle = [NSArray arrayWithObjects:@"有房产",@"有车产",@"有保单",
    //                         @"有社保", @"有公积金", @"上班族",
    //                         @"企业主",  @"代发工资",  @"微粒贷",
    //                         @"有芝麻分",nil];
//    NSArray  * arryParamsStr = @[@"houseType",@"carType",@"insurType",
//                                @"socialType",@"fundType",@"inWorkType1",
//                                @"inWorkType2",@"isPayroll",@"zimaScore",
//                                @"haveWeiLi"];
    NSString *keyName;
    for (int i = 0; i < [arrySXBtn count];  i++ )
     {
        UIButton *btnTemp = (UIButton*)arrySXBtn[i];
        //keyName = arryParamsStr[i];
        if (btnTemp.selected)
         {
            int iTag = (int)btnTemp.tag;
            
            keyName = arryParamsStr[iTag];
            
            paramsValue[keyName] = @"1";
         }
     }
    
    // 设置信用情况
    for (int i = 0; i < [arryRZBtn count];  i++ )
     {
        UIButton *btnTemp = (UIButton*)arryRZBtn[i];
        //keyName = arryParamsStr[i];
        if (btnTemp.selected)
         {
            int iTag = (int)btnTemp.tag;
            
            keyName = arryRZParamsStr[iTag];
            
            paramsValue[keyName] = @"1";
         }
     }
    
    
    // 设置贷款金额
    if (textDKMin.text.length > 0)
     {
        paramsValue[@"minLoanAmount"] = textDKMin.text;
     }
    if (textDKMax.text.length > 0)
     {
        paramsValue[@"maxLoanAmount"] = textDKMax.text;
     }
    
    //if （[[paramsValue allKeys] containsObject:@"inWorkType1"]）
    if ([paramsValue  objectForKey:@"inWorkType1"])
     {
        // objectForKey will return nil if a key doesn't exists.
        // 设置月收入
//        NSString *strTemp = [self setIncomeParm];
//        if(strTemp.length > 0)
//         {
//            paramsValue[@"inIncome"] = strTemp;
//         }
        if (textYSRMin.text.length > 0)
         {
            paramsValue[@"minIncome"] = textYSRMin.text;
         }
        if (textYSRMax.text.length > 0)
         {
           paramsValue[@"maxIncome"] = textYSRMax.text;
         }
        

    }
    
    if ([paramsValue  objectForKey:@"inWorkType2"])
     {
        // 设置经营流水

        NSString *strTemp = [self setJouanlParm];
        if(strTemp.length > 0)
         {
            paramsValue[@"inJournal"] = strTemp;
            paramsValue[@"hasLicense"] = @"1";
         }
     }
    
    NSLog(@"paramsValue:%@", paramsValue);
    

    // 设置已抢和待抢 订单状态：0-待抢，1-已抢(优质客户才有改条件)
    if (btnDaiQ.selected &&
        btnYiQ.selected)
     {
        paramsValue[@"orderStatus"] = @"0,1";
     }
    else if (btnYiQ.selected)
     {
        paramsValue[@"orderStatus"] = @"1";
     }
    else if (btnDaiQ.selected)
     {
        paramsValue[@"orderStatus"] = @"0";
     }
    
    if (1 == _borrowType)
     {
        [CommonInfo setKey:K_GOOD_FIlTER withDicValue:paramsValue];
     }
    else if (2 == _borrowType)
     {
        [CommonInfo setKey:K_ZHIJIE_FILTER withDicValue:paramsValue];
     }
    
    return  paramsValue;
    
}

-(NSString*) setIncomeParm
{
    NSString *str = @"";
    int iAddCount = 0;
    for (int i = 0; i < [arrayBtnIncome count]; i++)
     {
        UIButton *btnTemp = (UIButton*)arrayBtnIncome[i];
        if(btnTemp.selected)
         {
            //arrayIncomParm[i];
            NSString * strTemp = [NSString stringWithFormat:@"%@,", arrayIncomParm[i]];
            str = [str stringByAppendingString:strTemp];
            iAddCount++;
         }
     }
    if (iAddCount &&
        str.length > 0)
     {
        str = [str substringToIndex:str.length-1];
     }
    
    return str;
}

-(NSString*) setJouanlParm
{
    NSString *str = @"";
    int iAddCount = 0;
    for (int i = 0; i < [arrayBtnJournal count]; i++)
     {
        UIButton *btnTemp = (UIButton*)arrayBtnJournal[i];
        if(btnTemp.selected)
         {
            //arrayIncomParm[i];
            NSString * strTemp = [NSString stringWithFormat:@"%@,", arrayJournalParm[i]];
            str = [str stringByAppendingString:strTemp];
            iAddCount++;
         }
     }
    if (iAddCount &&
        str.length > 0)
     {
        str = [str substringToIndex:str.length-1];
     }
    
    return str;
}

-(void) actionOK
{
    
    if (textDKMin.text.length > 4)
     {
        [MBProgressHUD showErrorWithStatus:@"贷款金额最小值不能大于9999万" toView:self.view];
        return;
     }
    
    if (textDKMax.text.length > 4)
     {
        [MBProgressHUD showErrorWithStatus:@"贷款金额最大值不能大于9999万" toView:self.view];
        return;
     }
    
    // 设置贷款金额
    if (textDKMin.text.length > 0  &&
       textDKMax.text.length > 0 )
     {
       if ([textDKMin.text intValue] > [textDKMax.text intValue])
        {
           [MBProgressHUD showErrorWithStatus:@"请输入正确的贷款金额范围" toView:self.view];
           return;
        }
     }
    
    
    if (textYSRMin.text.length > 5)
     {
        [MBProgressHUD showErrorWithStatus:@"月收入最小值不能大于99999元" toView:self.view];
        return;
     }
    
    if (textYSRMax.text.length > 5)
     {
        [MBProgressHUD showErrorWithStatus:@"月收入最大值不能大于99999元" toView:self.view];
        return;
     }
    
    // 设置贷款金额
    if (textYSRMin.text.length > 0  &&
        textYSRMax.text.length > 0 )
     {
        if ([textYSRMin.text intValue] > [textYSRMax.text intValue])
         {
            [MBProgressHUD showErrorWithStatus:@"请输入正确的月收入范围" toView:self.view];
            return;
         }
     }

    NSDictionary *dic =  [self setParams];
    
    [self saveDic:dic];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CLOSE_SIDE_VIEW object:nil];
}

-(void) actionRest
{
    [viewChild1 removeFromSuperview];
    
    [self layoutChild1];
    

    [self setParams];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CLOSE_SIDE_VIEW object:nil];
    
}

#pragma mark  ---  网络请求
-(void) saveDic:(NSDictionary *) dic
{
    if (iCurPage != 1)
     {
        return;
     }
    
    NSString *url = [NSString stringWithFormat:@"%@%@",[PDAPI getBusiUrlString],KDDGcustCondition];
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:url
                                                                               parameters:dic HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      //[self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      //[MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                                      //[self handleErrorData:operation];
                                                                                  }];
    operation.tag = 10210;
    

    [operation start];
    
}


@end
