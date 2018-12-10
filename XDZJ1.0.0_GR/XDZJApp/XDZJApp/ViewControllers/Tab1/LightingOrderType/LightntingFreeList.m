//
//  LightntingFreeList.m
//  XXJR
//
//  Created by xxjr02 on 2018/3/27.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import "LightntingFreeList.h"
#import "LightningNewCell.h"
#import "LightingPopMessage.h"
#import "QDDetailVC.h"
#import "SelectCityViewController.h"

#import "CDWAlertView.h"

#define  Tabel_Height       70
NSString *const LightningOrderCellID = @"LightningOrderCellID";

@interface LightntingFreeList ()
{
    DDGAFHTTPRequestOperation *_operation;
    
    
    UIView *shaixuanView;        // 筛选view
    UIView *viewTab;             // tab的view
    UIButton  *btSX[10]; // 筛选条件按钮
    UILabel *lableSX;    // 筛选条件title
    NSArray *titleSXArr;    //  筛选数组
    BOOL       bShowSX;  // 释放显示筛选条件
    
    UILabel *lableTabCity;    // 城市label
    UIImageView  *viewImage;    // 向上或向下的箭头
    UIImageView *imageViewTime;   // 时间的双箭头
    UIImageView *imageViewJG;   // 价格的双箭头
    UIImageView *imageViewED;   // 额度的双箭头
    BOOL      isTimeUP;          // 时间是否升序
    BOOL      isJGUP;          // 价格是否升序
    BOOL      isEDUP;          // 额度是否升序
    NSString       *strTimeOrder;      // 时间的排序  1 升序， 2 降序，   0 不排序
    NSString       *strJGOrder;        // 价格的排序  1 升序， 2 降序，   0 不排序
    NSString       *strEDOrder;        // 额度的排序  1 升序， 2 降序，   0 不排序
    
    UIView *bgView;       // 跑马灯的背景
    
    
    float _originY;  // table 的y轴起点
    
    
    // 积分时间
    BOOL _freeHour;
    int _score;
    int _robNum;
    
    
    // 可免费抢单
    BOOL _haveFreeRob;
    
    int _lightingButtonSelectedIndex;
    
    
    NSString *_isVip;        //是否是会员
    float _usableAmount; //可用余额
    BOOL  _canUseTicket;  // 能否用打折券
    
    UIView *_aleartView_1;
    UIView *_aleartView_2;
    UIView *_aleartView_3;
    UIView *_aleartView_CS;
    
    RCLabel *_rcLabel_1;
    RCLabel *_rcLabel_2;
    

    NSArray * arrCustTickets;  // 打折券的数组
    int   iTotalRecords;    // 可抢的免费单的数量
    RCLabel *rclFreeCount;
    
    int  lastweekPayFlag;  // 1 显示可抢单，  0 -显示 已抢单
    
}
@end

@implementation LightntingFreeList

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutUI];
    
    
    // 加入抢单成功时，通知函数
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GrabSuccess) name:GrabSuccessNotification object:nil];
    
    [self loadData];
    
}

-(void) GrabSuccess
{
    [self reloadData];
}

-(void) viewWillAppear:(BOOL)animated
{
    [MobClick beginLogPageView:@"免费客户"];
    
}


-(void) viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"免费客户"];
}

-(void) layoutUI
{
    // 隐藏分割线
    self.tableView.separatorColor = [UIColor clearColor];
    
    int iTopY = 5;
    int iLeftX = 10;
    //UIColor *colorRed = UIColorFromRGB(0xff5e18);
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 150, 20)];
    [self.view addSubview:label1];
    label1.textColor = [ResourceManager color_1];
    label1.font = [UIFont systemFontOfSize:13];
    label1.text = @"每人限抢一单...";
    
    
    rclFreeCount = [[RCLabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-200, iTopY, 190, 30)];
    [self.view addSubview:rclFreeCount];
    rclFreeCount.textAlignment = RTTextAlignmentCenter;
    rclFreeCount.componentsAndPlainText = [RCLabel extractTextStyle:[NSString stringWithFormat:@"<font size = 14 color=#333333>全国剩余免费单数：</font><font size = 16 color=#ff5e18>%d </font><font size = 14 color=#333333>单</font>",iTotalRecords]];
    
    
    // 加入tab(排序)
    iTopY += rclFreeCount.height - 5;
    // tab标签控件
    viewTab = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY , SCREEN_WIDTH, 40)];
    viewTab.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewTab];
    

    
    
    int iTabWidth = SCREEN_WIDTH /3;
    
    iLeftX = 30;
    UILabel *lableTab1A = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, 5+5, 30, 20)];
    lableTab1A.textColor = [ResourceManager color_6];
    lableTab1A.text = @"时间";
    lableTab1A.font = [UIFont systemFontOfSize:14];
    [viewTab addSubview:lableTab1A];
    
    imageViewTime = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX+30, 5+8, 10, 12)];
    [imageViewTime setImage:[UIImage imageNamed:@"light_shuang_down"]];
    [viewTab addSubview:imageViewTime];
    strTimeOrder = @"2";        // 价格的排序  1 升序， 2 降序，   0 不排序
    
    UIButton *btTab1A = [[UIButton alloc] initWithFrame:CGRectMake(0, 5+0, SCREEN_WIDTH/3, 30)];
    [btTab1A addTarget:self action:@selector(actionTime) forControlEvents:UIControlEventTouchUpInside];
    [viewTab addSubview:btTab1A];
    isTimeUP = NO;
    
//    iLeftX += iTabWidth ;
//    UILabel *lableTab1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, 5+5, 30, 20)];
//    lableTab1.textColor = [ResourceManager color_6];
//    lableTab1.text = @"价格";
//    lableTab1.font = [UIFont systemFontOfSize:14];
//    [viewTab addSubview:lableTab1];
//
//    imageViewJG = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX+30, 5+8, 10, 12)];
//    [imageViewJG setImage:[UIImage imageNamed:@"light_shuang_unselect"]];
//    [viewTab addSubview:imageViewJG];
//    strJGOrder = @"0";        // 价格的排序  1 升序， 2 降序，   0 不排序
//
//
//    UIButton *btTab1 = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, 5+0, iTabWidth, 30)];
//    [btTab1 addTarget:self action:@selector(actionJG) forControlEvents:UIControlEventTouchUpInside];
//    [viewTab addSubview:btTab1];
//    isJGUP = NO;
    
    
    //iLeftX = SCREEN_WIDTH/3 + 30;
    iLeftX += iTabWidth ;
    UILabel *lableTab2 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, 5+5, 30, 20)];
    lableTab2.textColor = [ResourceManager color_6];
    lableTab2.text = @"额度";
    lableTab2.font = [UIFont systemFontOfSize:14];
    [viewTab addSubview:lableTab2];
    
    
    imageViewED = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX+30, 5+8, 10, 12)];
    [imageViewED setImage:[UIImage imageNamed:@"light_shuang_unselect"]];
    [viewTab addSubview:imageViewED];
    strEDOrder = @"0";        // 额度的排序  1 升序， 2 降序，   0 不排序
    
    UIButton *btTab2 = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, 5+0, iTabWidth, 30)];
    [btTab2 addTarget:self action:@selector(actionED) forControlEvents:UIControlEventTouchUpInside];
    [viewTab addSubview:btTab2];
    isEDUP = YES;
    
    NSString *strCity = [CommonInfo getKey:K_TS_City ];
    if([strCity isEqualToString:@""])
     {
        strCity = @"深圳市";
     }
    
    iLeftX = 2*SCREEN_WIDTH/3 + 30;
    lableTabCity = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, 5+5, 45, 20)];
    lableTabCity.textColor = [ResourceManager color_6];
    lableTabCity.textAlignment = NSTextAlignmentRight;
    lableTabCity.text = strCity;
    lableTabCity.font = [UIFont systemFontOfSize:14];
    [viewTab addSubview:lableTabCity];
    
    
    
    UIImageView  *imageViewCS = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX+45, 5+12, 10, 8)];
    [imageViewCS setImage:[UIImage imageNamed:@"light_jt_down"]];
    [viewTab addSubview:imageViewCS];
    
    UIButton *btTab3 = [[UIButton alloc] initWithFrame:CGRectMake(2*SCREEN_WIDTH/3, 5+0, SCREEN_WIDTH/3, 30)];
    //[btTab3 addTarget:self action:@selector(actionCS) forControlEvents:UIControlEventTouchUpInside];
    [viewTab addSubview:btTab3];
    
    // 分割线1
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0,39, SCREEN_WIDTH, 0.5)];
    line1.backgroundColor = [ResourceManager color_5];
    [viewTab addSubview:line1];

    
    
}


// 设置tableViewFrame 的高度和宽度
- (CGRect)tableViewFrame{
    int _originY = Tabel_Height;
    return CGRectMake(0, _originY, SCREEN_WIDTH, self.view.height-_originY);
}


#pragma mark === UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count ?: 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.dataArray || self.dataArray.count <= 0)
     {
        return SCREEN_HEIGHT;
     }
    
    return 140.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.dataArray || self.dataArray.count <= 0)
     {
        return [self noDataCell:tableView];
     }
    
    LightningNewCell *cell = nil;
    
    if (!cell) {
        cell = [[LightningNewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LightningOrderCellID];
    }
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;//UITableViewCellSelectionStyleNone;
    cell.haveFreeRob = YES;
    cell.dataDicionary = self.dataArray[indexPath.row];
//    if (lastweekPayFlag == 0)
//     {
//        cell.isNotKQD = YES;
//     }
    cell.lightedBlock = ^{
        [self lightingOrderButtonClickForCellAtIndex:(int)indexPath.row];
    };
    
    return cell;

}


-(UITableViewCell *)noDataCell:(UITableView *)tableView{
    static NSString * cellID = @"noDataCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
     {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
     }
    
    [self noDataView:cell.contentView];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(void)noDataView:(UIView *)view{
    [view removeAllSubviews];
    UIView  *viewBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 280.f)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 120.f)/2, 50.f, 120.f, 120.f)];
    imageView.image = [UIImage imageNamed:@"tab2_nodd"];
    [viewBackground addSubview:imageView];
    
    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 50+120+20, SCREEN_WIDTH, 30)];
    lable1.text = @"手慢，该城市的免费单与您飘过～";
    

    lable1.textAlignment =  NSTextAlignmentCenter;
    lable1.font = [UIFont systemFontOfSize:14];
    lable1.backgroundColor = [UIColor clearColor];
    lable1.textColor = [ResourceManager color_6];
    [viewBackground addSubview:lable1];
    
    
    UIButton *btnQD =  [[UIButton alloc] initWithFrame:CGRectMake(60, 50+120+70, SCREEN_WIDTH - 120, 50)];
    [viewBackground addSubview:btnQD];
    btnQD.backgroundColor = [ResourceManager mainColor];
    [btnQD setTitle:@"去抢单市场" forState:UIControlStateNormal];
    btnQD.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [btnQD addTarget:self action:@selector(actionQD) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:viewBackground];
    
    
    //  重设置高度, 隐藏“全国剩余xxx”
    viewTab.top =   0;
}

-(void) actionQD
{
    NSLog(@"去抢直接单");
    [self.navigationController popViewControllerAnimated:NO];
//    LightnigLendCtl *vc = [[LightnigLendCtl alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark === UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
//    if (lastweekPayFlag == 0)
//     {
//        [self popMessage];
//        return;
//     }
    
    if (!self.dataArray || self.dataArray.count <= 0)
     {
        return ;
     }
    
    NSDictionary *dataDic = self.dataArray[indexPath.row];
    
    
    _selectedIndexPath = indexPath;
    _lightingButtonSelectedIndex = (int)indexPath.row;
    
    
    QDDetailVC *ctl = [[QDDetailVC alloc] init];
    ctl.applyID = [dataDic objectForKey:@"borrowId"];
    ctl.borrowId = [dataDic objectForKey:@"borrowId"];
    ctl.score = _score;
    ctl.freeHour = YES;
    ctl.haveFreeRob = YES;
    ctl.robNum = _robNum;
    ctl.usableAmount = _usableAmount;
    ctl.lightDic = dataDic;
    ctl.canUseTicket = _canUseTicket;
    ctl.arrCustTickets = arrCustTickets;
    int status = [[dataDic objectForKey:@"status"] intValue];
    if (1 == status)
     {
        ctl.isNotQD = TRUE;
     }
    [self.navigationController pushViewController:ctl animated:YES];
}

#pragma mark --- 网络请求
-(void)loadData{
    
    if (_operation) {
        [_operation cancel];
        _operation = nil;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[kPage] = @(self.pageIndex);
    params[@"everyPage"] = @(10);
    NSString *strCity = [CommonInfo getKey:K_TS_City ];
    if([strCity isEqualToString:@""])
     {
        strCity = @"深圳市";
     }
    params[@"cityName"] = strCity;
    [self setParams:params];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",[PDAPI getBusiUrlString],KDDGqueryFreeRobList];
    
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:url
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    operation.tag = 10210;
    
    _operation = operation;
    [_operation start];
}

-(void) setParams:(NSMutableDictionary *) paramsValue
{
    //paramsValue[@"price"] = @"2";    // 1 升序 2降序 ， 0 部排序
    //NSString       *strJGOrder;        // 价格的排序  1 升序， 2 降序，   0 不排序
    //NSString       *strEDOrder;        // 额度的排序  1 升序， 2 降序，   0 不排序
    paramsValue[@"loanAmountType"] = strEDOrder;
    paramsValue[@"price"] = strJGOrder;
    paramsValue[@"applyTime"] = strTimeOrder;
    
//    //titleSXArr = @[@"有房产", @"有车产",@"有社保",@"有公积金",@"上班族",@"企业主",@"有微粒贷",@"代发工资"];
//    NSArray  * paramsStrArr = @[@"houseType", @"carType",@"socialType",@"fundType",@"inWorkType1",@"inWorkType2",@"haveWeiLi",@"isPayroll",@"zimaScore", @"insurType"];
//    NSString *keyName;
//    for (int i = 0; i < 10;  i++ )
//     {
//        keyName = paramsStrArr[i];
//        if (btSX[i].selected)
//         {
//            paramsValue[keyName] = @"1";
//         }
//
//     }
    
}


-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if (operation.tag == 10210) {
        
        
        NSDictionary *dicPage = operation.jsonResult.attr;
        
        iTotalRecords = [dicPage[@"freeNumber"] intValue];
        
        if(iTotalRecords == 0)
         {
            // 通知函数，尽量放到主函数来执行
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.1];
            
            return;
         }
        
        NSDictionary *dicAttr = operation.jsonResult.attr;
        if ([dicAttr count] > 0)
         {
            
            _score = [[operation.jsonResult.attr objectForKey:@"totalScore"] intValue];
            _robNum = [[operation.jsonResult.attr objectForKey:@"daiPowRobNum"] intValue];
            _haveFreeRob = YES;
            lastweekPayFlag = [[operation.jsonResult.attr objectForKey:@"lastweekPayFlag"] intValue];
            
            
            //可用余额
            _usableAmount = [[operation.jsonResult.attr objectForKey:@"usableAmount"] floatValue];
            
            arrCustTickets  = dicAttr[@"custTickets"];
            
            _canUseTicket = [dicAttr[@"canUseTicket"] boolValue];
            
            rclFreeCount.componentsAndPlainText = [RCLabel extractTextStyle:[NSString stringWithFormat:@"<font size = 14 color=#333333>全国剩余免费单数：</font><font size = 16 color=#ff5e18>%d </font><font size = 14 color=#333333>单</font>",iTotalRecords]];
         }
        
        
        
        if (operation.jsonResult.rows && operation.jsonResult.rows.count > 0) {
            
            //  重设置高度,显示“全国剩余xxx”
            viewTab.top =   30;
            [self reloadTableViewWithArray:operation.jsonResult.rows];
        }else{
            self.pageIndex --;
            if (self.pageIndex > 0)
             {
               
                [MBProgressHUD showErrorWithStatus:@"没有更多数据了" toView:self.view];
             }
            else
             {
                 [self reloadTableViewWithArray:nil];
             }
            [self endRefresh];
        }
        
    }else if (operation.tag == 10211){
        _isRobSuccess = YES;
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        [self.navigationController popToRootViewControllerAnimated:NO];
        
        // 发送抢单成功的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:GrabSuccessNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@(2),@"index":@(0)}];
    }else if (operation.tag == 10212){
        _isRobSuccess = YES;
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        [self.navigationController popToRootViewControllerAnimated:NO];
        
        // 发送抢单成功的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:GrabSuccessNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@(2),@"index":@(0)}];
    }
}


-(void) delayMethod
{
    [[NSNotificationCenter defaultCenter] postNotificationName:FreeGrabSwitchNotification object:@{@"status":@(1),@"listCount":@(0)}];
}
#pragma mark ---   action
// 点击抢单按钮
- (void)lightingOrderButtonClickForCellAtIndex:(int)index {
    
//    if (lastweekPayFlag == 0)
//     {
//        [self popMessage];
//        return;
//     }
    _lightingButtonSelectedIndex = index;
    
    bool  cityEqual = [CommonInfo isCityEqual];
    if (!cityEqual)
     {
        [self _aleartViewUI_CS];
        return;
     }
    
    [self realQD:index];
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
    [self realQD:_lightingButtonSelectedIndex];
}

-(void) btn_CS2
{
    _aleartView_1.hidden = YES;
    _aleartView_2.hidden = YES;
    _aleartView_3.hidden = YES;
    _aleartView_CS.hidden = YES;
}

-(void) actionTime
{
    isTimeUP = !isTimeUP;
    if (isTimeUP)
     {
        [imageViewTime setImage:[UIImage imageNamed:@"light_shuang_up"]];
        strTimeOrder = @"1";        // 时间的排序  1 升序， 2 降序，   0 不排序
     }
    else
     {
        [imageViewTime setImage:[UIImage imageNamed:@"light_shuang_down"]];
        strTimeOrder = @"2";        // 时间的排序  1 升序， 2 降序，   0 不排序
     }
    
    [imageViewED setImage:[UIImage imageNamed:@"light_shuang_unselect"]];
    strEDOrder = @"0";        // 额度的排序  1 升序， 2 降序，   0 不排序
    
    [imageViewJG setImage:[UIImage imageNamed:@"light_shuang_unselect"]];
    strJGOrder = @"0";
    
    
    if (_haveAppeared)
     {
        [self reloadData];
     }
    
}


-(void) actionJG
{
    isJGUP = !isJGUP;
    if (isJGUP)
     {
        [imageViewJG setImage:[UIImage imageNamed:@"light_shuang_up"]];
        strJGOrder = @"1";        // 价格的排序  1 升序， 2 降序，   0 不排序
     }
    else
     {
        [imageViewJG setImage:[UIImage imageNamed:@"light_shuang_down"]];
        strJGOrder = @"2";        // 价格的排序  1 升序， 2 降序，   0 不排序
     }
    
    [imageViewED setImage:[UIImage imageNamed:@"light_shuang_unselect"]];
    strEDOrder = @"0";        // 额度的排序  1 升序， 2 降序，   0 不排序
    
    [imageViewTime setImage:[UIImage imageNamed:@"light_shuang_unselect"]];
    strTimeOrder = @"0";
    
    
    if (_haveAppeared)
     {
        [self reloadData];
     }
    
}

-(void) actionED
{
    isEDUP = !isEDUP;
    if (isEDUP)
     {
        [imageViewED setImage:[UIImage imageNamed:@"light_shuang_up"]];
        strEDOrder = @"1";        // 额度的排序  1 升序， 2 降序，   0 不排序
     }
    else
     {
        [imageViewED setImage:[UIImage imageNamed:@"light_shuang_down"]];
        strEDOrder = @"2";        // 额度的排序  1 升序， 2 降序，   0 不排序
     }
    
    [imageViewJG setImage:[UIImage imageNamed:@"light_shuang_unselect"]];
    strJGOrder = @"0";        // 价格的排序  1 升序， 2 降序，   0 不排序
    
    [imageViewTime setImage:[UIImage imageNamed:@"light_shuang_unselect"]];
    strTimeOrder = @"0";
    
    if (_haveAppeared)
     {
        [self reloadData];
     }
    
}



-(void) actionCS
{
    // 城市
    SelectCityViewController *ctl = [[SelectCityViewController alloc] init];
    ctl.rootVC = self.parentViewController;  // 必须用父类的 vc
    ctl.block = ^(id city){
        
        NSString *strCity = [(NSDictionary *)city objectForKey:@"areaName"];
        if([strCity isEqualToString:@""])
         {
            strCity = @"深圳市";
         }
        [CommonInfo setKey:K_TS_City withValue:strCity];
        lableTabCity.text = strCity;
        [self reloadData];
        
    };
    [self.navigationController pushViewController:ctl animated:YES];
}

#pragma mark --- 抢单的点击响应函数
-(void) realQD:(int)index
{
    
    if (![CommonInfo isGZRZannSMRZ:self])
     {
        return;
     }
    

    
    NSDictionary *dataDic = self.dataArray[index];
    _lightingButtonSelectedIndex = index;
    
    int robType = [[dataDic objectForKey:@"robType"] intValue];  // 单的类型  1 可参与免费抢单  2 只能积分   3 只能支付
    
    
    if((_haveFreeRob && robType == 1))  {
        
        // 直接抢单，免费抢单
        [self lightingOrderForCellAtIndex:index];

//        SIAlertView * alertView = [[SIAlertView alloc]initWithTitle:@"抢单提示" andMessage:@"该单是免费单，是否抢单"];
//
//        [alertView addButtonWithTitle:@"再看看" type:SIAlertViewButtonTypeDefault handler:nil];
//        [alertView addButtonWithTitle:@"免费抢单" type:SIAlertViewButtonTypeCancel handler:^(SIAlertView *alertView){
//            // 直接抢单，免费抢单
//            [self lightingOrderForCellAtIndex:index];
//        }];
//        alertView.cornerRadius = 5;
//        alertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
//        alertView.transitionStyle = SIAlertViewTransitionStyleSlideFromTop;
//        [alertView show];

    }else{


        // 抢单扣款功能
        LightingPopMessage * alert = [[LightingPopMessage alloc] initWithDic:dataDic
                                                                   arraryDZQ:arrCustTickets
                                                                usebleAmount:_usableAmount
                                                                      canUse:_canUseTicket];
        alert.parentVC = self;
        [alert show];

        return;

    }
    
}

// 抢单请求
-(void)lightingOrderForCellAtIndex:(int)index{
    NSDictionary *dataDic = self.dataArray[index];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    
    NSString *api =[NSString stringWithFormat:@"%@mjb/account/dai/rob/robFree",[PDAPI getBaseUrlString]];

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

-(void) popMessage
{
    CDWAlertView *alertView = [[CDWAlertView alloc] init];
    alertView.shouldDismissOnTapOutside = NO;
    //[alertView addTitle:@"提示"];
    // 降低高度
    [alertView subAlertCurHeight:10];
    
    
    [alertView addSubTitle:[NSString stringWithFormat:@"<font size = 15 color=#676767>该笔单已被抢，是否要跳去直借抢单?</font>"]];
    
    
    [alertView addAlertCurHeight:10];
    
    [alertView addButton:@"确定" red:YES actionBlock:^{
        
//        LightnigLendCtl *vc = [[LightnigLendCtl alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [alertView addCanelButton:@"取消" actionBlock:^{
        
    }];
    [alertView showAlertView:self.parentViewController duration:0.0];
    return;
}


@end
