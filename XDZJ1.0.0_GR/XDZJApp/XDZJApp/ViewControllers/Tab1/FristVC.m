//
//  FristVC.m
//  XXStatshipApp
//
//  Created by xxjr02 on 2018/6/8.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import "FristVC.h"
#import "AnimationButton.h"
#import "NSString + DesEncrypt.h"
#import "LightningNewCell.h"
#import "LightingGoodCell.h"
#import "LightingPopMessage.h"
#import "QDDetailVC.h"
#import "SelectCityViewController.h"
#import "JYJAnimateViewController.h"
#import "PopAndSelectView.h"
#import "LightntingFreeCtl.h"
#import "LightingLockVC.h"



#define  Tabel_Height       (NavHeight + 40+40)
NSString *const LightningLendCellID = @"LightningLend";

@interface FristVC ()
{
    DDGAFHTTPRequestOperation *_operation;
    
    
    CustomNavigationBarView *nav;
    UIView *shaixuanView;        // 筛选view
    UIView *viewTab;             // tab的view
    
    
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
    
    NSString  *curBorrowId;
    
    dispatch_source_t _timer1;  // 定时器1
}

@property (nonatomic, strong) UIViewController *popParent;

/** hasClick */
@property (nonatomic, assign) BOOL hasClick;

/** vc */
@property (nonatomic, strong) JYJAnimateViewController *vc;

@end



@implementation FristVC


-(void)addButtonView{
    
    self.tabBarController.tabBar.hidden = YES;
    
    [self.view addSubview:self.tabBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.hideBackButton = YES;
    nav = [self layoutNaviBarViewWithTitle:@"抢单市场"];
    
    // 加入中间的弹出选择页面 按钮
    int iViewXLLeftX = nav.titleLab.width/2 + 35;
    UIImageView *viewXL = [[UIImageView alloc] initWithFrame:CGRectMake(iViewXLLeftX, 15, 15, 7)];
    [nav.titleLab addSubview:viewXL];
    viewXL.image = [UIImage imageNamed:@"com_nav_xl"];
    
//    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionNavSel)];
//    nav.titleLab.userInteractionEnabled = YES;
//    [nav.titleLab addGestureRecognizer:labelTapGestureRecognizer];
    
    // 加入右边的 筛选按钮
    float fRightBtnTopY =  NavHeight - 40;
    if (IS_IPHONE_X_MORE)
     {
        fRightBtnTopY = NavHeight - 42;
     }
    
    UIButton *rightNavBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60.f,fRightBtnTopY,60.f, 35.0f)];
    [rightNavBtn setTitle:@"筛选" forState:UIControlStateNormal];
    [rightNavBtn setTitleColor:[ResourceManager mainColor] forState:UIControlStateNormal];
    [rightNavBtn addTarget:self action:@selector(actionFind) forControlEvents:UIControlEventTouchUpInside];
    rightNavBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [nav addSubview:rightNavBtn];
    
    
    [self layoutUI];
    
    // 筛选条件关闭通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:CLOSE_SIDE_VIEW object:nil];
    
    // 加入抢单成功时，通知函数
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GrabSuccess) name:GrabSuccessNotification object:nil];
    
    // 加入刷新列表，通知函数
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateList:) name:UpdataListNotification object:nil];
    
    
    [self loadData];
    
    [self getFindData1];
    [self getFindData2];
    [self getIncomeData];
    
    
    
}

-(void) GrabSuccess
{
    [self reloadData];
}

-(void) UpdateList:(NSNotification *)notification
{
    NSString *key = [(NSDictionary *)notification.object objectForKey:@"key"];
    
    if (key &&
        ([key isEqualToString:@"MyLock"] ||
         [key isEqualToString:@"OtherLock"]))
     {
        NSArray *arrTemp = [CommonInfo getKeyOfArray:K_LOCK_ROBLIST];
        if (!arrTemp ||
            [arrTemp count] ==  0)
         {
            NSArray *arr = @[@"11"];
            [CommonInfo setKey:K_LOCK_ROBLIST withArrayValue:arr];
         }

        
        if (self.dataArray &&
            _lightingButtonSelectedIndex  <  [self.dataArray count])
         {
            NSMutableDictionary *dicTemp = self.dataArray[_lightingButtonSelectedIndex];
            dicTemp[@"isLock"] = @(1);
            if ([key isEqualToString:@"MyLock"])
             {
                dicTemp[@"myLock"] = @(1);
             }
            self.dataArray[_lightingButtonSelectedIndex] = dicTemp;
            
            // 刷新某行cell
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:_lightingButtonSelectedIndex inSection:0];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
         }
        
        [self getLockList];
     }
    
    
    if (key &&
        ([key isEqualToString:@"UnLock"] ))
     {
        
        if (self.dataArray &&
            _lightingButtonSelectedIndex  <  [self.dataArray count])
         {
            
            NSString* UnBorrowId = [(NSDictionary *)notification.object objectForKey:@"UnBorrowId"];
            for (int i = 0; i < self.dataArray.count ; i++)
             {
                NSMutableDictionary *dicTemp = self.dataArray[i];
                NSString *borrowId = [NSString stringWithFormat:@"%@", dicTemp[@"borrowId"]];
                
                if ([borrowId isEqualToString:UnBorrowId])
                 {
                    dicTemp[@"isLock"] = @(0);
                    dicTemp[@"myLock"] = @(0);
                    self.dataArray[i] = dicTemp;
                    
                    // 刷新某行cell
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                 }
             }
            
//            NSMutableDictionary *dicTemp = self.dataArray[_lightingButtonSelectedIndex];
//            dicTemp[@"isLock"] = @(0);
//            dicTemp[@"myLock"] = @(0);
//            self.dataArray[_lightingButtonSelectedIndex] = dicTemp;
            
            
         }
        
        [self getLockList];
     }
}

-(void) viewWillAppear:(BOOL)animated
{
    barStyle = UIStatusBarStyleDefault;
    [[UIApplication sharedApplication] setStatusBarStyle:barStyle];
    
    [MobClick beginLogPageView:@"直借客户"];

    self.navigationController.navigationBar.hidden = YES;
    
    [self getCity];
    
    // 创建并启动定时器
    [self creatTime];
    
}


-(void) viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"直借客户"];
    
    if (_timer1)
     {
        // 关闭定时器
        dispatch_source_cancel(_timer1);
        _timer1 = nil;
     }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
    //return barStyle;
}

-(void) getCity
{
    NSString *strCity = [CommonInfo getKey:K_TS_City ];
    if([strCity isEqualToString:@""])
     {
        strCity = @"深圳市";
     }
    lableTabCity.text = strCity;
}

-(void) layoutUI
{
    // 隐藏分割线
    self.tableView.separatorColor = [UIColor clearColor];
    
    
    
    int iTopY = NavHeight;
    UIButton *viewBG1 = [[UIButton alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 40)];
    [self.view addSubview:viewBG1];
    [viewBG1 addTarget:self action:@selector(actionFree) forControlEvents:UIControlEventTouchUpInside];
    
    iTopY += 10;
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, iTopY, 200, 20)];
    [self.view addSubview:labelTitle];
    labelTitle.textColor = [ResourceManager color_1];
    labelTitle.font = [UIFont systemFontOfSize:14];
    labelTitle.text = @"每天10点开抢，抢完为止";
    
    UILabel *labelTitle2 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100, iTopY, 75, 20)];
    [self.view addSubview:labelTitle2];
    labelTitle2.textColor = [ResourceManager color_1];
    labelTitle2.font = [UIFont systemFontOfSize:14];
    labelTitle2.textAlignment = NSTextAlignmentRight;
    labelTitle2.text = @"免费抢单";
    
    
    UIImageView *_rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 20, iTopY +(20 - 18)/2, 12, 18)];
    [self.view addSubview:_rightImage];
    _rightImage.image = [UIImage imageNamed:@"arrow-2"];
    
    // 加入tab(排序)
    iTopY = NavHeight+40;
    // tab标签控件
    viewTab = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY , SCREEN_WIDTH, 40)];
    viewTab.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewTab];
    
    
    int iTabWidth = SCREEN_WIDTH *2/3/3;
    
    int iLeftX = 30;
    UILabel *lableTab1A = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, 5+5, 30, 20)];
    lableTab1A.textColor = [ResourceManager color_1];
    lableTab1A.text = @"时间";
    lableTab1A.font = [UIFont systemFontOfSize:14];
    [viewTab addSubview:lableTab1A];
    
    imageViewTime = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX+35, 5+8, 10, 12)];
    [imageViewTime setImage:[UIImage imageNamed:@"light_shuang_down"]];
    [viewTab addSubview:imageViewTime];
    strTimeOrder = @"2";        // 价格的排序  1 升序， 2 降序，   0 不排序
    
    UIButton *btTab1A = [[UIButton alloc] initWithFrame:CGRectMake(0, 5+0, SCREEN_WIDTH/3, 30)];
    [btTab1A addTarget:self action:@selector(actionTime) forControlEvents:UIControlEventTouchUpInside];
    [viewTab addSubview:btTab1A];
    isTimeUP = NO;
    
    iLeftX += iTabWidth ;
    UILabel *lableTab1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, 5+5, 30, 20)];
    lableTab1.textColor = [ResourceManager color_1];
    lableTab1.text = @"价格";
    lableTab1.font = [UIFont systemFontOfSize:14];
    [viewTab addSubview:lableTab1];
    
    imageViewJG = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX+35, 5+8, 10, 12)];
    [imageViewJG setImage:[UIImage imageNamed:@"light_shuang_unselect"]];
    [viewTab addSubview:imageViewJG];
    strJGOrder = @"0";        // 价格的排序  1 升序， 2 降序，   0 不排序
    
    
    UIButton *btTab1 = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, 5+0, iTabWidth, 30)];
    [btTab1 addTarget:self action:@selector(actionJG) forControlEvents:UIControlEventTouchUpInside];
    [viewTab addSubview:btTab1];
    isJGUP = NO;
    
    
    //iLeftX = SCREEN_WIDTH/3 + 30;
    iLeftX += iTabWidth ;
    UILabel *lableTab2 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, 5+5, 30, 20)];
    lableTab2.textColor = [ResourceManager color_1];
    lableTab2.text = @"额度";
    lableTab2.font = [UIFont systemFontOfSize:14];
    [viewTab addSubview:lableTab2];
    
    
    imageViewED = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX+35, 5+8, 10, 12)];
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
    lableTabCity.textColor = [ResourceManager color_1];
    lableTabCity.textAlignment = NSTextAlignmentRight;
    lableTabCity.text = strCity;
    lableTabCity.font = [UIFont systemFontOfSize:14];
    [viewTab addSubview:lableTabCity];
    
    
    
    UIImageView  *imageViewCS = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX+50, 5+12, 10, 8)];
    [imageViewCS setImage:[UIImage imageNamed:@"light_jt_down"]];
    [viewTab addSubview:imageViewCS];
    
    UIButton *btTab3 = [[UIButton alloc] initWithFrame:CGRectMake(2*SCREEN_WIDTH/3, 5+0, SCREEN_WIDTH/3, 30)];
    [btTab3 addTarget:self action:@selector(actionCS) forControlEvents:UIControlEventTouchUpInside];
    [viewTab addSubview:btTab3];
    
    // 分割线1
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0,39, SCREEN_WIDTH, 0.5)];
    line1.backgroundColor = [ResourceManager color_5];
    [viewTab addSubview:line1];
    
}

// 设置tableViewFrame 的高度和宽度
- (CGRect)tableViewFrame{
    int _originY = Tabel_Height;
    return CGRectMake(0, _originY, SCREEN_WIDTH, self.view.height-_originY - TabbarHeight - 5 );
}

#pragma mark ---  定时器
-(void) creatTime
{
    static long long  llTimeCount = 0;
    
    if (_timer1)
     {
        // 关闭定时器
        dispatch_source_cancel(_timer1);
        _timer1 = nil;
     }
    
    //设置时间间隔
    NSTimeInterval period = 3*60.0;
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    _timer1 = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer1, DISPATCH_TIME_NOW, period * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    
    // block 会立马执行一遍，后面隔一定时间间隔再执行一次
    dispatch_source_set_event_handler(_timer1, ^{
        // 定时器事件回调
        llTimeCount++;
        NSLog(@"定时器%lld次运行" ,llTimeCount);
        [self getLockList];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 在主线程中实现需要的功能 （UI操作）
            
        });
        
    });
    
    dispatch_resume(_timer1);
    
    
    
    
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
    
    NSDictionary *dic = self.dataArray[indexPath.row];
    BOOL  isLock = [dic[@"isLock"] boolValue];
    if (isLock)
     {
        return 140 + 15;
     }
    
    return 140.0;
}




-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.dataArray || self.dataArray.count <= 0)
     {
        return [self noDataCell:tableView];
     }
    
    LightingGoodCell *cell = nil;
    
    if (!cell) {
        cell = [[LightingGoodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LightningLendCellID];
    }
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;//UITableViewCellSelectionStyleNone;
    cell.dataDicionary = self.dataArray[indexPath.row];
    cell.lightedBlock = ^{
        [self lightingOrderButtonClickForCellAtIndex:(int)indexPath.row];
    };
    
    return cell;
    
}

#pragma mark === UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!self.dataArray || self.dataArray.count <= 0)
     {
        return ;
     }
    
    NSDictionary *dataDic = self.dataArray[indexPath.row];
    
    if ([[dataDic objectForKey:@"status"] intValue])
     {
        // 已抢单， 不能看详情
        [MBProgressHUD showErrorWithStatus:@"手慢了，此单已经被抢。" toView:self.view];
        return;
     }
    
    _selectedIndexPath = indexPath;
    _lightingButtonSelectedIndex = (int)indexPath.row;
    
    
    QDDetailVC *ctl = [[QDDetailVC alloc] init];
    ctl.applyID = [dataDic objectForKey:@"borrowId"];
    ctl.borrowId = [dataDic objectForKey:@"borrowId"];
    ctl.score = _score;
    ctl.freeHour = NO;
    ctl.haveFreeRob = NO;
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
    
    NSString *url = [NSString stringWithFormat:@"%@%@",[PDAPI getBusiUrlString],KDDGqueryBorrowList];
    
    
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
    
    [self getLockList];
}

-(void) setParams:(NSMutableDictionary *) paramsValue
{
    //paramsValue[@"price"] = @"2";    // 1 升序 2降序 ， 0 部排序
    //NSString       *strJGOrder;        // 价格的排序  1 升序， 2 降序，   0 不排序
    //NSString       *strEDOrder;        // 额度的排序  1 升序， 2 降序，   0 不排序
    paramsValue[@"loanAmountType"] = strEDOrder;
    paramsValue[@"price"] = strJGOrder;
    paramsValue[@"applyTime"] = strTimeOrder;
    
    NSString *strQueryType = [CommonInfo getKey:K_ZHIJIE_QueryType];
    if (strQueryType.length > 0)
     {
        paramsValue[@"queryType"] = strQueryType;
        
        // 如果是自定义
        if ([strQueryType isEqualToString:@"1"] )
         {
            NSDictionary *dicSX = [CommonInfo getKeyOfDic:K_ZHIJIE_FILTER];
            [paramsValue addEntriesFromDictionary:dicSX];
         }
     }
    else
     {
        paramsValue[@"queryType"] = @"1";
        NSDictionary *dicSX = [CommonInfo getKeyOfDic:K_ZHIJIE_FILTER];
        if (dicSX)
         {
            [paramsValue addEntriesFromDictionary:dicSX];
         }
     }
    
    
    
    
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

-(void) getLock:(NSDictionary*) dicData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    curBorrowId = [NSString stringWithFormat:@"%@",dicData[@"borrowId"]];
    
    params[@"borrowId"] = curBorrowId;

    NSString *url = [NSString stringWithFormat:@"%@%@",[PDAPI getBusiUrlString],kDDGRobLock];
    
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:url
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                      
                                                                                  }];
    operation.tag = 10213;
    
    [operation start];
}


-(void) getLockList
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *strCity = [CommonInfo getKey:K_TS_City];
    if([strCity isEqualToString:@""])
     {
        strCity = @"深圳市";
     }
    params[@"cityName"] = strCity;
    
    NSString *url = [NSString stringWithFormat:@"%@%@",[PDAPI getBusiUrlString],kDDGqueryBorrowLock];
    
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:url
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      NSArray *arr = operation.jsonResult.rows;
                                                                                      if (arr)
                                                                                       {
                                                                                          [CommonInfo setKey:K_LOCK_ROBLIST withArrayValue:arr];
                                                                                       }
                                                                                      
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      

                                                                                      
                                                                                  }];

    
    [operation start];
}

#pragma mark ---  网络请求
- (void) getFindData1
{
    if (![[DDGAccountManager sharedManager] isLoggedIn]) {
        return;
    }
    
    NSDictionary *dicGood = [CommonInfo getKeyOfDic:K_GOOD_FIlTER];
    //    if (dicGood)
    //     {
    //        return;
    //     }
    
    NSString *url = [NSString stringWithFormat:@"%@%@",[PDAPI getBusiUrlString],KDDGqueryCustCondition];
    
    NSMutableDictionary *paperm = [[NSMutableDictionary alloc] init];
    paperm[@"borrowType"] = @(1);
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:url
                                                                               parameters:paperm HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      
                                                                                      NSDictionary *dic = operation.jsonResult.attr;
                                                                                      
                                                                                      NSDictionary *notNullDic = dic[@"condInfo"];
                                                                                      
                                                                                      [CommonInfo setKey:K_GOOD_FIlTER withDicValue:notNullDic];
                                                                                      
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      //[MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                                      //[self handleErrorData:operation];
                                                                                  }];
    
    
    [operation start];
    
}

- (void) getFindData2
{
    if (![[DDGAccountManager sharedManager] isLoggedIn])
     {
        return;
     }
    
    NSDictionary *dicZDY = [CommonInfo getKeyOfDic:K_ZHIJIE_FILTER];
    //    if (dicZDY)
    //     {
    //        return;
    //     }
    
    NSString *url = [NSString stringWithFormat:@"%@%@",[PDAPI getBusiUrlString],KDDGqueryCustCondition];
    
    NSMutableDictionary *paperm = [[NSMutableDictionary alloc] init];
    paperm[@"borrowType"] = @(2);
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:url
                                                                               parameters:paperm HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      
                                                                                      NSDictionary *dic = operation.jsonResult.attr;
                                                                                      
                                                                                      NSDictionary *notNullDic = dic[@"condInfo"];
                                                                                      
                                                                                      [CommonInfo setKey:K_ZHIJIE_FILTER withDicValue:notNullDic];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      //[MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                                      //[self handleErrorData:operation];
                                                                                  }];
    
    
    [operation start];
    
}


- (void) getIncomeData
{
    if (![[DDGAccountManager sharedManager] isLoggedIn])
     {
        return;
     }
    
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",[PDAPI getBusiUrlString],KDDGgetIncomeOfJournal];
    
    NSMutableDictionary *paperm = [[NSMutableDictionary alloc] init];
    
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:url
                                                                               parameters:paperm HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      //[self handleData:operation];
                                                                                      NSDictionary *dic = operation.jsonResult.attr;
                                                                                      
                                                                                      NSLog(@"dic:%@",dic);
                                                                                      
                                                                                      [CommonInfo setKey:K_FILTER_ELEMENT withDicValue:dic];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      //[MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                                      //[self handleErrorData:operation];
                                                                                  }];
    
    
    [operation start];
    
}

-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if (operation.tag == 10210) {
        
        
        NSDictionary *dicPage = operation.jsonResult.page;
        
        NSDictionary *dicAttr = operation.jsonResult.attr;
        if ([dicAttr count] > 0)
         {
            _score = [[operation.jsonResult.attr objectForKey:@"totalScore"] intValue];
            _robNum = [[operation.jsonResult.attr objectForKey:@"daiPowRobNum"] intValue];
            _haveFreeRob = YES;
            
            //可用余额
            _usableAmount = [[operation.jsonResult.attr objectForKey:@"usableAmount"] floatValue];
            
            arrCustTickets  = dicAttr[@"custTickets"];
            
            _canUseTicket = [dicAttr[@"canUseTicket"] boolValue];
            
         }
        
        
        
        if (operation.jsonResult.rows && operation.jsonResult.rows.count > 0) {
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
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        [self.navigationController popToRootViewControllerAnimated:NO];
        
        // 发送抢单成功的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:GrabSuccessNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@(3),@"index":@(0)}];
    }else if (operation.tag == 10212){
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        [self.navigationController popToRootViewControllerAnimated:NO];
        
        // 发送抢单成功的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:GrabSuccessNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@(3),@"index":@(0)}];
    }else if (operation.tag == 10213)
     {
        NSDictionary *dic = operation.jsonResult.attr;
        NSString *borrorId = [NSString stringWithFormat:@"%@", dic[@"borrowId"]];
        NSDictionary *dicData = dic[@"borrowInfo"];
        int status = [dic[@"status"] intValue];
        
        if (1 == status)
         {
            // 发送刷新列表的通知
            [[NSNotificationCenter defaultCenter] postNotificationName:UpdataListNotification object:@{@"key":@"MyLock"}];
            
            NSDictionary *dataDic = self.dataArray[_lightingButtonSelectedIndex];
            
            LightingLockVC *VC = [[LightingLockVC alloc] init];
            VC.dataDic = dataDic;
            VC.arrCustTickets = arrCustTickets;
            VC.usableAmount = _usableAmount;
            VC.canUseTicket = _canUseTicket;
            VC.score = _score;
            VC.robNum = _robNum;
            [self.navigationController pushViewController:VC animated:YES];
            return;
         }
        
        if(3 == status)
         {
            [MBProgressHUD showErrorWithStatus:@"此单已经被其他用户锁单，请等待5分钟" toView:self.view];
            
            // 发送刷新列表的通知
            [[NSNotificationCenter defaultCenter] postNotificationName:UpdataListNotification object:@{@"key":@"OtherLock"}];
            
            return;
         }
        
        // 如果锁定的本单
        if ([curBorrowId isEqualToString:borrorId])
         {
            LightingLockVC *VC = [[LightingLockVC alloc] init];
            VC.dataDic = dicData;
            VC.arrCustTickets = arrCustTickets;
            VC.usableAmount = _usableAmount;
            VC.canUseTicket = _canUseTicket;
            VC.score = _score;
            VC.robNum = _robNum;
            [self.navigationController pushViewController:VC animated:YES];
         }
        else
         {
            [self popQDMessage1:dicData];
         }
     }

}

#pragma mark ---    action
-(void) actionFree
{
    LightntingFreeCtl *VC = [[LightntingFreeCtl alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)clickNavButton:(UIButton *)button{
    if (self.popParent)
     {
        [self.navigationController popToViewController:self.popParent animated:YES];
        return;
     }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) actionFind
{
    
    
    // 防止重复点击
    if (self.hasClick) return;
    self.hasClick = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hasClick = NO;
    });
    
    // 展示筛选条件
    JYJAnimateViewController *vc = [[JYJAnimateViewController alloc] init];
    vc.pageType = 1;
    vc.borrowType = 2;
    self.vc = vc;
    vc.view.backgroundColor = [UIColor clearColor];
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
}

- (void) actionNavSel
{
    NSArray *arry = @[@"免费抢单", @"优质客户"];
    PopAndSelectView *pop = [[PopAndSelectView alloc] initWithOrigin_X:0 origin_Y:NavHeight-10 itemArray:arry];
    pop.selectedIndex = -100;
    [self.view addSubview:pop];
    [pop showPickView];
    
    pop.finishedBlock = ^(int index) {
        NSLog(@"finishedBlock:%d" , index);
        //        if (0 == index)
        //         {
        //
        //            LightntingFreeCtl *vc = [[LightntingFreeCtl alloc] init];
        //            vc.popParent = self.popParent;
        //            [self.navigationController pushViewController:vc animated:YES];
        //         }
        //        else if (1 == index)
        //         {
        //            LigthingGoodCtl *vc = [[LigthingGoodCtl alloc] init];
        //            vc.popParent = self.popParent;
        //            [self.navigationController pushViewController:vc animated:YES];
        //         }
    };
    
    return;
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
    ctl.rootVC = self;  // 必须用父类的 vc
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

// 点击抢单按钮
- (void)lightingOrderButtonClickForCellAtIndex:(int)index {
    
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


-(void) popQDMessage1:(NSDictionary*) dicData
{
    CDWAlertView *alertView = [[CDWAlertView alloc] init];
    alertView.shouldDismissOnTapOutside = NO;
    //[alertView addTitle:@"提示"];
    // 降低高度
    [alertView subAlertCurHeight:10];
    
    
    [alertView addSubTitle:[NSString stringWithFormat:@"<font size = 15 color=#676767>您还有一笔订单在锁定状态，取消锁定才能抢下一笔订单哦～</font>"]];
    
    
    [alertView addAlertCurHeight:10];
    
    [alertView addButton:@"去解锁" red:YES actionBlock:^{
        
        //  锁单页面
        LightingLockVC *VC = [[LightingLockVC alloc] init];
        VC.dataDic = dicData;
        VC.arrCustTickets = arrCustTickets;
        VC.usableAmount = _usableAmount;
        VC.canUseTicket = _canUseTicket;
        VC.score = _score;
        VC.robNum = _robNum;
        [self.navigationController pushViewController:VC animated:YES];

    }];
    
    [alertView addCanelButton:@"暂不" actionBlock:^{
        
    }];
    [alertView showAlertView:self.parentViewController duration:0.0];
    return;
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
    
    [self getLock:dataDic];
    
    
    
//    //  锁单页面
//    LightingLockVC *VC = [[LightingLockVC alloc] init];
//    VC.dataDic = dataDic;
//    VC.arrCustTickets = arrCustTickets;
//    VC.usableAmount = _usableAmount;
//    VC.canUseTicket = _canUseTicket;
//    VC.score = _score;
//    VC.robNum = _robNum;
//    [self.navigationController pushViewController:VC animated:YES];
    
//    // 抢单扣款功能
//    LightingPopMessage * alert = [[LightingPopMessage alloc] initWithDic:dataDic
//                                                               arraryDZQ:arrCustTickets
//                                                            usebleAmount:_usableAmount
//                                                                  canUse:_canUseTicket];
//    alert.parentVC = self;
//    [alert show];
    
    
    
    
}


@end
