//
//  FilerBussinessVC.m
//  XXJR
//
//  Created by xxjr02 on 2018/4/8.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import "FilerBussinessVC.h"
#import "JYJAnimateViewController.h"
#import "HQButton.h"
#import "XHDatePickerView_1.h"
//#import "XHDatePickerView.h"

@interface FilerBussinessVC ()<ButtonDelegateWithParameter>
{
    int iViewWidth;  //当前view 的宽度
    int iChildViewTopY;  // 子view 的顶点坐标
    int iChildViewHeight; // 子view 的高度
    
    BOOL isAllSel;    //是否全选
    UIImageView *imgGou;
    
    UIView *viewChild1;
    UIScrollView *scViewChild1; // 子类滚动view1
    
    UIView *viewStaut;
    NSMutableArray *arrySXBtn; // 按钮数组
    NSArray *arryBtnTitle; // 按钮标题数组
    NSArray  * arryParamsStr;  // 按钮参数数组
    
    HQButton *btnManual; // 手动抢单按钮
    HQButton *btnAuto;   // 自动抢单按钮
    
    UITextField *textFind1;  // 客户姓名/手机号码
    
    UILabel  *labelTimeBegin;
    UILabel  *labelTimeEnd;
}

@end

@implementation FilerBussinessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 初始化的数据
    [self initData];
    
    [self layoutUI];
    
    //[self getDataFromCach];


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
    // 抢单客户
    arryBtnTitle = @[@"新订单",@"跟进中",@"继续跟进",
                     @"审批中", @"审批通过",@"成功放款",
                     @"无效客户", @"退单处理"];
    arryParamsStr = @[@"1",@"7",@"8",
                      @"9",@"10",@"2",
                      @"3,4",@"5"];
    
    if (2 == _bussinessType)
     {
        // 推广客户
        arryBtnTitle = @[@"待确认",@"待处理",@"跟进中",
                         @"继续跟进",@"审批中", @"审批通过",
                         @"成功放款",@"无效客户", @"退单处理"];
        arryParamsStr = @[@"0",@"1",@"7",
                          @"10",@"8",@"9",
                          @"2",@"3,4",@"5"];
     }
    else if (3 == _bussinessType)
     {
        // 短信客户
        //0-待处理 1-跟进中 2-成功放款 3-无效用户 4-删除 5-继续跟进 6-审批中 7-审批通过
        arryBtnTitle = @[@"待处理",@"跟进中",@"继续跟进",
                         @"审批中",@"审批通过",@"成功放款",
                         @"无效客户"];
        arryParamsStr = @[@"0",@"1",@"5",
                          @"6",@"7",@"2",
                          @"3"];
     }
    
    arrySXBtn  = [[NSMutableArray alloc] init];
    
}

-(void) getDataFromCach
{
    NSDictionary *dicParam = nil;
    NSArray *arrySetBtn = nil;
    if (1 == _bussinessType )
     {
        dicParam = [CommonInfo getKeyOfDic:K_FILTER_ELEMENT_QD];
        arrySetBtn = [CommonInfo getKeyOfArray:K_FILTER_BTNARRY_QD];
     }
    else if (2 == _bussinessType )
     {
        dicParam = [CommonInfo getKeyOfDic:K_FILTER_ELEMENT_TG];
        arrySetBtn = [CommonInfo getKeyOfArray:K_FILTER_BTNARRY_TG];

     }
    else if (3 == _bussinessType)
     {
        dicParam = [CommonInfo getKeyOfDic:K_FILTER_ELEMENT_DX];
        arrySetBtn = [CommonInfo getKeyOfArray:K_FILTER_BTNARRY_DX];
     }
    
    
    // 设置按钮选中状态
    for (int i = 0; i < [arrySetBtn count]; i++)
     {
        int iBtnNO =  [arrySetBtn[i] intValue];
        if (iBtnNO < [arrySXBtn count])
         {
            UIButton *btnTemp = (UIButton*)arrySXBtn[iBtnNO];
            if (!btnTemp.selected)
             {
                // 触发系统的点击事件
                [btnTemp sendActionsForControlEvents:UIControlEventTouchUpInside];
             }
         }
     }
    
    // 默认全选按钮选择
    isAllSel = YES;
    imgGou.image = [UIImage imageNamed:@"select_yes"];
    for (int i = 0; i < [arrySXBtn count]; i++)
     {
        UIButton *btnTemp = (UIButton*)arrySXBtn[i];
        if (!btnTemp.selected)
         {
            isAllSel = NO;
            imgGou.image = [UIImage imageNamed:@"select_no"];
         }
     }
    
    // 时间值
    if ([dicParam count] > 0)
     {
        NSString *strTimeBegin = dicParam[@"startTime"];
        NSString *strTimeEnd = dicParam[@"endTime"];
        if (strTimeBegin.length >4)
         {
            labelTimeBegin.text = strTimeBegin;
            labelTimeEnd.text = strTimeEnd;
            labelTimeBegin.textColor = [ResourceManager CellTitleColor];
            labelTimeEnd.textColor = [ResourceManager CellTitleColor];
         }
        
        NSString *strFind1 = dicParam[@"userName"];
        if (strFind1.length > 0)
         {
            textFind1.text = strFind1;
         }
     }
    
}

#pragma mark  --- 布局UI
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
    int iLeftX = 10;

    
    iChildViewTopY  = iTopY;
    iChildViewHeight = SCREEN_HEIGHT - iChildViewTopY;
    
    scViewChild1 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, iTopY, iViewWidth, iChildViewHeight -40)];
    [self.view addSubview:scViewChild1];
    scViewChild1.contentSize = CGSizeMake(0, 550);
    scViewChild1.backgroundColor = [UIColor whiteColor];
    
    iTopY = 10;
    iLeftX =10;
    UILabel *labelT1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 100, 20)];
    [scViewChild1 addSubview:labelT1];
    labelT1.textColor = [ResourceManager CellTitleColor];
    labelT1.font = [UIFont systemFontOfSize:14];
    labelT1.text = @"订单状态";
    
    UILabel *labelAllSel = [[UILabel alloc] initWithFrame:CGRectMake(iViewWidth - 60, iTopY+ 3,60,20)];
    [scViewChild1 addSubview:labelAllSel];
    labelAllSel.textColor = [ResourceManager CellTitleColor];
    labelAllSel.font = [UIFont systemFontOfSize:14];
    labelAllSel.text = @"全选";
    isAllSel = NO;
    
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionAllSel)];
    labelAllSel.userInteractionEnabled = YES;
    [labelAllSel addGestureRecognizer:labelTapGestureRecognizer];
    
    imgGou = [[UIImageView alloc] initWithFrame:CGRectMake(30, 3, 13, 13)];
    [labelAllSel addSubview:imgGou];
    imgGou.image = [UIImage imageNamed:@"select_no"];
    
    iTopY += labelT1.height +10;
    // 创建状态的view
    [self createViewStatus:iTopY];
    
    iTopY += viewStaut.height;
    
    // // 客户页面的类型(1-抢单客户，2-推广客户， 3-短信客户)
//    if (1 == _bussinessType)
//     {
//        iTopY += 10;
//        UILabel *labelText = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 100, 20)];
//        [scViewChild1 addSubview:labelText];
//        labelText.textColor = [ResourceManager color_1];
//        labelText.font = [UIFont systemFontOfSize:14];
//        labelText.text = @"抢单方式";
//        
//        
//        // 布局按钮
//        iTopY += labelText.height + 10;
//        int iBtnLeftX = iLeftX;
//        int iBtnTopY = iTopY;
//        int iBtnWdith = (iViewWidth - 4 * iLeftX)/3;
//        int iBtnHeight = 30;
//        
//        
//        btnManual = [[HQButton alloc] initWithFrame:CGRectMake(iBtnLeftX, iBtnTopY, iBtnWdith, iBtnHeight)];
//        [scViewChild1 addSubview:btnManual];
//        btnManual.iStyle = 2;
//        btnManual.tag = 0;
//        [btnManual setTitle:@"手动抢单" forState:UIControlStateNormal];
//        [btnManual setNOSelected];
//        btnManual.delegateWithParamater = self;
//        //[btnManual addTarget:self action:@selector(actionQD:) forControlEvents:UIControlEventTouchUpInside];
//
//        iBtnLeftX += iLeftX + iBtnWdith;
//        btnAuto = [[HQButton alloc] initWithFrame:CGRectMake(iBtnLeftX, iBtnTopY, iBtnWdith, iBtnHeight)];
//        [scViewChild1 addSubview:btnAuto];
//        btnAuto.iStyle = 2;
//        btnAuto.tag = 1;
//        [btnAuto setTitle:@"自动抢单" forState:UIControlStateNormal];
//        [btnAuto setNOSelected];
//        btnAuto.delegateWithParamater = self;
//        //[btnAuto addTarget:self action:@selector(actionQD:) forControlEvents:UIControlEventTouchUpInside];
//        
//        iTopY += iBtnHeight;
//
//     }

    
    
    // 客户搜索
    iTopY +=   10;
    UILabel *labelT2 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 100, 20)];
    [scViewChild1 addSubview:labelT2];
    labelT2.textColor = [ResourceManager CellTitleColor];
    labelT2.font = [UIFont systemFontOfSize:14];
    labelT2.text = @"客户搜索";
    
    iTopY += labelT2.height + 10;
    
    UIView* viewBackground1 = [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iViewWidth-2*iLeftX, 30)];
    [scViewChild1 addSubview:viewBackground1];
    viewBackground1.backgroundColor = [ResourceManager viewBackgroundColor];
    
    int iTextWidth = viewBackground1.width;
    textFind1 = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, iTextWidth - 20, 30)];
    [viewBackground1 addSubview:textFind1];
    textFind1.backgroundColor = [ResourceManager viewBackgroundColor];
    textFind1.placeholder = @"输入客户姓名/手机号码搜索";
    textFind1.font = [UIFont systemFontOfSize:14];
    
    // 按抢单时间搜索
    iTopY += viewBackground1.height + 20;
    UILabel *labelT3 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 100, 20)];
    [scViewChild1 addSubview:labelT3];
    labelT3.textColor = [ResourceManager CellTitleColor];
    labelT3.font = [UIFont systemFontOfSize:14];
    labelT3.text = @"按抢单时间搜索";
    if(_bussinessType !=1)
     {
        labelT3.text = @"按申请时间搜索";
     }
    iTextWidth = (iViewWidth - 2 * iLeftX  - 30)/2;
    
    iTopY += labelT3.height + 10;
    labelTimeBegin = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iTextWidth, 30)];
    [scViewChild1 addSubview:labelTimeBegin];
    labelTimeBegin.textColor = [ResourceManager lightGrayColor];
    labelTimeBegin.backgroundColor = [ResourceManager viewBackgroundColor];
    labelTimeBegin.font = [UIFont systemFontOfSize:14];
    labelTimeBegin.textAlignment = NSTextAlignmentCenter;
    labelTimeBegin.text = @"开始时间";
    
    UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(iLeftX + iTextWidth + 5,  iTopY + 15, 20, 1)];
    [scViewChild1 addSubview:viewFG];
    viewFG.backgroundColor = [ResourceManager color_1];
    
    labelTimeEnd = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX + iTextWidth + 30, iTopY, iTextWidth, 30)];
    [scViewChild1 addSubview:labelTimeEnd];
    labelTimeEnd.textColor = [ResourceManager lightGrayColor];
    labelTimeEnd.backgroundColor = [ResourceManager viewBackgroundColor];
    labelTimeEnd.font = [UIFont systemFontOfSize:14];
    labelTimeEnd.textAlignment = NSTextAlignmentCenter;
    labelTimeEnd.text = @"结束时间";
    
    UITapGestureRecognizer *labelTapGestureTime = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionSelTime)];
    UITapGestureRecognizer *labelTapGestureTime2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionSelTime)];
    labelTimeBegin.userInteractionEnabled = YES;
    [labelTimeBegin addGestureRecognizer:labelTapGestureTime2];
    labelTimeEnd.userInteractionEnabled = YES;
    [labelTimeEnd addGestureRecognizer:labelTapGestureTime];

    
    
    
    
    // 底部按钮
    UIButton * btnRest  = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 40, iViewWidth/2, 40)];
    [self.view addSubview:btnRest];
    btnRest.backgroundColor = [ResourceManager viewBackgroundColor];
    btnRest.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnRest setTitle:@"重置" forState:UIControlStateNormal];
    [btnRest setTitleColor:[ResourceManager lightGrayColor] forState:UIControlStateNormal];
    [btnRest addTarget:self action:@selector(actionRest) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton * btnOK  = [[UIButton alloc] initWithFrame:CGRectMake(iViewWidth/2, SCREEN_HEIGHT - 40, iViewWidth/2, 40)];
    [self.view addSubview:btnOK];
    btnOK.backgroundColor = [UIColor orangeColor];
    btnOK.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnOK setTitle:@"确定" forState:UIControlStateNormal];
    [btnOK addTarget:self action:@selector(actionOK) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void) createViewStatus:(int) iViewTopY
{
    
    // 布局按钮
    int iTopY = 10;
    int iLeftX = 10;
    int iBtnLeftX = iLeftX;
    int iBtnTopY = iTopY;
    int iBtnWdith = (iViewWidth - 4 * iLeftX)/3;
    int iBtnHeight = 30;
    

    int iLineCount =  (int)[arryBtnTitle count]/3;
    if ([arryBtnTitle count]%3 != 0)
     {
        iLineCount += 1;
     }
    
    
    int iViewHeight = iLineCount* iBtnHeight  + iLineCount*10   + 10;
    
    viewStaut = [[UIView alloc] initWithFrame:CGRectMake(0, iViewTopY, iViewWidth, iViewHeight)];
    [scViewChild1 addSubview:viewStaut];
    //viewStaut.backgroundColor = [UIColor yellowColor];
    
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
        [viewStaut addSubview:btnTemp];
        btnTemp.iStyle = 2;
        btnTemp.iFontSize = 13;
        btnTemp.tag = i;
        [btnTemp setTitle:arryBtnTitle[i] forState:UIControlStateNormal];
        [btnTemp setNOSelected];
        btnTemp.delegateWithParamater = self;
        [btnTemp addTarget:self action:@selector(actionStauts:) forControlEvents:UIControlEventTouchUpInside];
    
        [arrySXBtn addObject:btnTemp];
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


#pragma mark  ---  action
-(void) actionRest
{
    [viewChild1 removeFromSuperview];
    
    [self layoutUI];
    
    
    [self setParam];
    
    
    [self setPopBlock];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CLOSE_SIDE_VIEW object:nil];
    
}

-(void) actionOK
{
    [self setParam];
    
    [self setPopBlock];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CLOSE_SIDE_VIEW object:nil];
}

-(void) setPopBlock
{
    if (_popBlock)
     {
        
        if (isAllSel)
         {
            _popBlock(@"全选");
            return;
         }
        else
         {
            NSString *strSelect = @"";
            int iAddCount = 0;
        
            BOOL isNotSel = FALSE;
            for (int i = 0; i < [arrySXBtn count]; i++)
             {
                UIButton *btnTemp = (UIButton*)arrySXBtn[i];
                if (btnTemp.selected)
                 {
                    NSString *strTemp = [NSString stringWithFormat:@"%@%@,",strSelect, btnTemp.titleLabel.text];
                    strSelect = strTemp;
                    iAddCount++;
                 }
                else
                 {
                    isNotSel = TRUE;
                 }
             }
            
            if (!isNotSel  ||
                strSelect.length <= 0)
             {
                _popBlock(@"全部");
                return;
             }
            
            if (iAddCount &&
                strSelect.length > 0)
             {
                strSelect = [strSelect substringToIndex:strSelect.length-1];
             }
            
            _popBlock(strSelect);
            
         }
     }
}

-(void) setParam
{
    NSMutableDictionary *dicParam =  [[NSMutableDictionary alloc] init];
    
    NSString *strParam = @"";
    int iAddCount = 0;
    NSMutableArray *arrySetBtn = [[NSMutableArray alloc] init];
    for (int i = 0; i < [arrySXBtn count]; i++)
     {
        UIButton *btnTemp = (UIButton*)arrySXBtn[i];
        if(btnTemp.selected)
         {
            //arrayIncomParm[i];
            NSString * strTemp = [NSString stringWithFormat:@"%@,", arryParamsStr[i]];
            strParam = [strParam stringByAppendingString:strTemp];
            iAddCount++;
            [arrySetBtn addObject:@(btnTemp.tag)];
         }
     }
    if (iAddCount &&
        strParam.length > 0)
     {
        strParam = [strParam substringToIndex:strParam.length-1];
        
        if(3 == _bussinessType)
         {
            dicParam[@"inStatus"] = strParam;
         }
        else
         {
            dicParam[@"inReceiveStatus"] = strParam;
         }
     }
    
    if (labelTimeBegin.text.length >4)
     {
        dicParam[@"startTime"] = labelTimeBegin.text;
        dicParam[@"endTime"] = labelTimeEnd.text;
     }
    
    if (textFind1.text.length > 0)
     {
        
        if (3 == _bussinessType)
         {
            dicParam[@"searchKey"] = textFind1.text;
         }
        dicParam[@"userName"] = textFind1.text;
        
     }
    
    

     if (1 == _bussinessType )
      {
         NSString *strInRobWay = [[NSString alloc] init];
         //抢单方式:0-手动抢单 1-自动抢单(多选用逗号隔开)
         if (btnAuto.selected)
          {
             strInRobWay = [strInRobWay stringByAppendingString:@"1,"];
          }
         if (btnManual.selected)
          {
             strInRobWay = [strInRobWay stringByAppendingString:@"0,"];
          }
         if (strInRobWay.length > 1)
          {
             strInRobWay = [strInRobWay substringToIndex:(strInRobWay.length-1)];
             dicParam[@"inRobWay"] = strInRobWay;
          }
         
         
         [CommonInfo setKey:K_FILTER_ELEMENT_QD withDicValue:dicParam];
         [CommonInfo setKey:K_FILTER_BTNARRY_QD withArrayValue:arrySetBtn];
      }
    else if (2 == _bussinessType )
     {
        [CommonInfo setKey:K_FILTER_ELEMENT_TG withDicValue:dicParam];
        [CommonInfo setKey:K_FILTER_BTNARRY_TG withArrayValue:arrySetBtn];
     }
    else if (3 == _bussinessType)
     {
        [CommonInfo setKey:K_FILTER_ELEMENT_DX withDicValue:dicParam];
        [CommonInfo setKey:K_FILTER_BTNARRY_DX withArrayValue:arrySetBtn];
     }
    
}

-(void) actionAllSel
{
    isAllSel = !isAllSel;
    
    if (isAllSel)
     {
        imgGou.image = [UIImage imageNamed:@"select_yes"];
     }
    else
     {
        imgGou.image = [UIImage imageNamed:@"select_no"];
     }
    
    [self stautsBtnAllSel:isAllSel];
    
}

-(void) stautsBtnAllSel:(BOOL) bSel
{
    if (bSel)
     {
        for (int i = 0; i < [arrySXBtn count];  i++ )
         {
            UIButton *btnTemp = (UIButton*)arrySXBtn[i];
            if (!btnTemp.selected)
             {
                // 触发系统的点击事件
                [btnTemp sendActionsForControlEvents:UIControlEventTouchUpInside];
             }
         }
     }
    else
     {
        for (int i = 0; i < [arrySXBtn count];  i++ )
         {
            UIButton *btnTemp = (UIButton*)arrySXBtn[i];
            if (btnTemp.selected)
             {
                // 触发系统的点击事件
                [btnTemp sendActionsForControlEvents:UIControlEventTouchUpInside];
             }
         }
     }
}

-(void) actionStauts:(UIButton*) sender
{
    if (sender.selected)
     {
        //[btn setNOSelected];
     }
    else
     {
        //[btn setIsSelected];
        isAllSel = NO;
        imgGou.image = [UIImage imageNamed:@"select_no"];
     }
}

-(void) actionSelTime
{
    
//    XHDatePickerView *datepicker = [[XHDatePickerView alloc] initWithCompleteBlock:^(NSDate *startDate,NSDate *endDate) {
//
//        NSDate *newdate = [[NSDate date] initWithTimeInterval:8 *60 * 60 sinceDate:startDate];
//        NSLog(@"\nstartDate： %@，endDate：%@",startDate,endDate);
//        NSLog(@"\n开始时间： %@，结束时间：%@",[newdate stringWithFormat:@"yyyy-MM-dd HH:mm"],endDate);
//        //[weakSelf setSMTime:startDate];
//
//    }];
//    datepicker.datePickerStyle = DateStyleShowYearMonthDayHourMinute;
//    datepicker.dateType = DateTypeStartDate;
//    [datepicker show];
//    return;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *now = [NSDate date];
    NSDate *before = [self getPriousorLaterDateFromDate:now withMonth:-1];
    
    
    //  在没有设置时， 时间默认值
    NSString *strEnd = [dateFormatter stringFromDate:now];
    NSString *strbefore = [dateFormatter stringFromDate:before];
    
    XHDatePickerView_1 *datepicker = [[XHDatePickerView_1 alloc] initWithCompleteBlock:^(NSDate *startDate,NSDate *endDate) {
        NSLog(@"\n开始时间： %@，结束时间：%@",startDate,endDate);
        
        if (startDate == nil &&
            endDate == nil)
         {
            labelTimeBegin.text = @"开始时间";
            labelTimeEnd.text = @"结束时间";
            labelTimeEnd.textColor = [ResourceManager lightGrayColor];
            labelTimeBegin.textColor = [ResourceManager lightGrayColor];
            return;
         }
        
        labelTimeEnd.text = [endDate stringWithFormat:@"yyyy-MM-dd"];    //结束时间
        labelTimeBegin.text = [startDate stringWithFormat:@"yyyy-MM-dd"];  //开始时间
        
        labelTimeEnd.textColor = [ResourceManager CellTitleColor];
        labelTimeBegin.textColor = [ResourceManager CellTitleColor];
        
        //[self reloadData];
    }];
    
    
    datepicker.beginTimeLabel.text = strbefore;
    NSDate *dateBefore = [dateFormatter dateFromString:strbefore];
    datepicker.startDate = dateBefore;
    [datepicker getNowDate:dateBefore animated:YES];
    
    datepicker.endTimeLabel.text = strEnd;
    NSDate *dateEnd = [dateFormatter dateFromString:strEnd];
    datepicker.endDate = dateEnd;
    
    datepicker.dateType = DateTypeStartDate;
    [datepicker show];
    
}

// 给一个时间，给一个数，正数是以后n个月，负数是前n个月；
-(NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(int)month

{
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setMonth:month];
    
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    
    
    return mDate;
    
}


@end
