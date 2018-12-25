//
//  SecondVC.m
//  XXStatshipApp
//
//  Created by xxjr02 on 2018/6/8.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import "SecondVC.h"
#import "BussinessQDKHCell.h"
#import "SIEditAlertView.h"
#import "JYJAnimateViewController.h"
#import "SKAutoScrollLabel.h"
#import "QDKHPresonVC.h"


#define  Tabel_Height   30

@interface SecondVC ()
{
    SKAutoScrollLabel *paoma;
    UILabel *labelStauts;
    
    int _handleButtonSelectedIndex;         // 正在处理的项目的索引
    NSNumber *_status;
    NSString *_desc;
    NSString *_amount;
    NSString *_period;
    
}

/** hasClick */
@property (nonatomic, assign) BOOL hasClick;

/** vc */
@property (nonatomic, strong) JYJAnimateViewController *vc;


@end

@implementation SecondVC

-(void)addButtonView{
    
    self.tabBarController.tabBar.hidden = YES;
    
    [self.view addSubview:self.tabBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hideBackButton = YES;
    CustomNavigationBarView *nav = [self layoutNaviBarViewWithTitle:@"全部客户"];
    
    [self layoutUI];
    
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
    

    
    
    [self loadData];
    
    [self getLabelConfgData];
    
    
    // 筛选条件关闭通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(colseSideView) name:CLOSE_SIDE_VIEW object:nil];
    
    // 加入抢单成功时，通知函数
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GrabSuccess) name:GrabSuccessNotification object:nil];
    
}

-(void) GrabSuccess
{
    [self  reloadData];
    
}

-(void) colseSideView
{
    _iFindStyle = 3;
    [self reloadData];
}

-(void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
    
    barStyle = UIStatusBarStyleDefault;
    [[UIApplication sharedApplication] setStatusBarStyle:barStyle];
    
    paoma.text = @"若用户未接听，建议您尝试多次拨打以提高联系率。查看退单规则>>";
    
    if (2 == _iFindStyle )
     {
        paoma.text = @"若用户未接听，建议您尝试多次拨打以提高联系率。";
     }
    
    [MobClick beginLogPageView:@"抢单客户"];
}



-(void) viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"抢单客户"];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
    //return barStyle;
}


// 设置tableViewFrame 的高度和宽度
- (CGRect)tableViewFrame{
    int _originY = NavHeight  + 30 + 40;
    return CGRectMake(0, _originY, SCREEN_WIDTH, self.view.height-_originY);
}

-(void) layoutUI
{
    // 隐藏分割线
    self.tableView.separatorColor = [UIColor clearColor];
    
    [self layoutPLabelViewWithTitle];
    
}


-(void)layoutPLabelViewWithTitle
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, NavHeight, self.view.frame.size.width, 30)];
    bgView.backgroundColor = [ResourceManager viewBackgroundColor];
    bgView.clipsToBounds = YES;
    [self.view addSubview:bgView];
    
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside)];
    bgView.userInteractionEnabled = YES;
    [bgView addGestureRecognizer:labelTapGestureRecognizer];
    
    
    UIImage *image = [UIImage imageNamed:@"icon_ broadcast"];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 15, 15)];
    imgView.image = image;
    [bgView addSubview:imgView];
    
    
    int iPaoWidth = self.view.frame.size.width - 30 - 80;
    if ( [[[DDGAccountManager sharedManager].userInfo objectForKey:@"isVip"] intValue] == 1) {
        iPaoWidth = self.view.frame.size.width - 30 - 5;
    }
    
    paoma = [[SKAutoScrollLabel alloc] initWithFrame:CGRectMake(30, 5, iPaoWidth, 20)];
    [bgView addSubview:paoma];
    //paoma.backgroundColor = UIColorFromRGB(0xFDF9EC);
    paoma.font = [UIFont systemFontOfSize:13];
    paoma.textColor = UIColorFromRGB(0xd1a53a);
    paoma.text = @"若用户未接听，建议您尝试多次拨打以提高联系率。查看退单规则>>";
    paoma.direction = SK_AUTOSCROLL_DIRECTION_LEFT;
    

    paoma.userInteractionEnabled = NO;
    
    
    
    
    UIView *bgView2 = [[UIView alloc] initWithFrame:CGRectMake(0, NavHeight+30, SCREEN_WIDTH, 30)];
    [self.view addSubview:bgView2];
    bgView2.backgroundColor = [UIColor whiteColor];
    
    UILabel *lableTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 60, 20)];
    [bgView2 addSubview:lableTitle];
    lableTitle.textColor = [ResourceManager blackGrayColor];
    lableTitle.font = [UIFont  systemFontOfSize:14];
    lableTitle.text = @"订单状态";
    
    labelStauts = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, SCREEN_WIDTH-130, 20)];
    [bgView2 addSubview:labelStauts];
    labelStauts.textColor = [ResourceManager mainColor];//UIColorFromRGB(0xff5e18);
    labelStauts.font = [UIFont  systemFontOfSize:14];
    labelStauts.textAlignment = NSTextAlignmentRight;
    labelStauts.text = @"全部";
    
    if (2 == _iFindStyle )
     {
        labelStauts.text = @"新订单";
     }
    
    UIImageView *_rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 20, (30 - 11)/2, 7, 11)];
    [bgView2 addSubview:_rightImage];
    _rightImage.image = [UIImage imageNamed:@"arrow_right"];
    
    
    UITapGestureRecognizer *labelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionFind)];
    bgView2.userInteractionEnabled = YES;
    [bgView2 addGestureRecognizer:labelTap];
    
    
}





-(void)endEditView
{
    [self.view endEditing:YES];
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
    
    NSDictionary * _dataDicionary = self.dataArray[indexPath.row];
    int ireceiveStatus  = [[_dataDicionary objectForKey:@"receiveStatus"] intValue];
    
    if (1 == ireceiveStatus)
     {
        //_statusLabel.text = @"新订单";
        return 170 +60;
        
     }
    else if (2 == ireceiveStatus)
     {
        //_statusLabel.text = @"成功放款";
        return  250; //170 + 25*2  + 10 - 20;
        
        
     }
    else if (3 == ireceiveStatus ||
             4 == ireceiveStatus)
     {
        //_statusLabel.text = @"无效客户";
        return  240; //170 + 25  + 10;
        
     }
    else if (5 == ireceiveStatus)
     {
        
        int iserviceStatus = [_dataDicionary[@"serviceStatus"] intValue];
        if (1 == iserviceStatus||
            2 == iserviceStatus)
         {
            //@"退款成功";
            //@"退款失败";
            return  240;//170 + 25*2 + 10 + 40;
         }
        
        //_statusLabel.text = @"退款审核中";
        return  240 ;//170 + 25  + 10 + 40;
        
     }
    else if (7 == ireceiveStatus||
             8 == ireceiveStatus||
             9 == ireceiveStatus ||
             10 == ireceiveStatus)
     {
        //_statusLabel.text = @"跟进中";
        return 170 + 25  + 10 + 60;
        
     }
    
    return 170.0 +60;
}




-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.dataArray || self.dataArray.count <= 0)
     {
        return [self noDataCell:tableView];
     }
    
    NSString* CellID = @"QDKHCell";
    
    BussinessQDKHCell *cell = nil;
    
    NSDictionary *dic = self.dataArray[indexPath.row];
    
    if (!cell) {
        cell = [[BussinessQDKHCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
    }
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;//UITableViewCellSelectionStyleNone;
    cell.dataDicionary = dic;
    cell.handleBlock = ^{
        
        [self lightingOrderButtonClickForCellAtIndex:(int)indexPath.row];
    };
    
    
    
    cell.callBlock = ^{
        NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:+86%@",[dic objectForKey:@"telephone"]]];
        UIWebView*callWebview =[[UIWebView alloc] init];
        
        [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
        
        //记得添加到view上
        [self.view addSubview:callWebview];
        
        
        
    };
    
    cell.delBlock = ^{
        // 删除操作
        [self deleteAction:dic];
    };
    
    return cell;
    
}

-(void)noDataView:(UIView *)view{
    [view removeAllSubviews];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 120.f)/2, 50.f, 120.f, 90.f)];
    imageView.image = [UIImage imageNamed:@"tab2_nodd"];
    [view addSubview:imageView];
    
    
    UILabel *imglabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 160, SCREEN_WIDTH, 15)];
    imglabel2.font = [UIFont systemFontOfSize:14];
    imglabel2.textAlignment = NSTextAlignmentCenter;
    imglabel2.textColor = [ResourceManager lightGrayColor];
    imglabel2.text =@"您最近没有抢单哦～";
    [view addSubview:imglabel2];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, 205, 200, 50)];
    [view addSubview:btn];
    [btn setTitle:@"去抢单" forState:UIControlStateNormal];
    [btn setTitleColor:[ResourceManager mainColor] forState:UIControlStateNormal];
    btn.cornerRadius = 5;
    btn.layer.borderColor = [ResourceManager mainColor].CGColor;
    btn.layer.borderWidth = 1;
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];

}

#pragma mark === UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!self.dataArray || self.dataArray.count <= 0)
     {
        return ;
     }
    
    
    
    NSDictionary *dataDic = self.dataArray[indexPath.row];
    
    //    QDKHHomeVC *ctl = [[QDKHHomeVC alloc] init];
    //    ctl.applyID = [dataDic objectForKey:@"borrowId"];
    //    ctl.borrowId = [dataDic objectForKey:@"borrowId"];
    //    ctl.receiveId = [dataDic objectForKey:@"receiveId"];
    //    ctl.tel = [dataDic objectForKey:@"telephone"];
    //    ctl.lightDic = dataDic;
    //    [self.navigationController pushViewController:ctl animated:YES];
    
    
    QDKHPresonVC *ctl = [[QDKHPresonVC alloc] init];
    ctl.applyID = [dataDic objectForKey:@"borrowId"];
    ctl.borrowId = [dataDic objectForKey:@"borrowId"];
    //ctl.receiveId = [dataDic objectForKey:@"receiveId"];
    ctl.tel = [dataDic objectForKey:@"telephone"];
    ctl.lightDic = dataDic;
    [self.navigationController pushViewController:ctl animated:YES];
}



#pragma mark --- 网络请求
-(void)loadData{
    
    if (![[DDGAccountManager sharedManager] isLoggedIn])
     {
        return;
     }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[kPage] = @(self.pageIndex);
    params[@"everyPage"] = @(10);
    
    [self setParams:params];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",[PDAPI getBusiUrlString],KDDGnewRobList];
    
    
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
    
    [operation start];
}

-(void) getLabelConfgData
{
    //[MBProgressHUD showHUDAddedTo:self.view animated:NO];
    if (![[DDGAccountManager sharedManager] isLoggedIn])
     {
        return;
     }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],KDDGgetLabelCfgInfo];
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:url
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      
                                                                                      NSDictionary *dic = operation.jsonResult.attr[@"sysLabel"];
                                                                                      
                                                                                      
                                                                                      NSArray *arrLableKey = dic[@"sysLabelKey"];
                                                                                      if (arrLableKey)
                                                                                       {
                                                                                          [CommonInfo setKey:K_LABEL_KEY_ELEMENT withArrayValue:arrLableKey];
                                                                                       }
                                                                                      
                                                                                      NSArray *arrLableValue = dic[@"sysLabelVal"];
                                                                                      if (arrLableValue)
                                                                                       {
                                                                                          [CommonInfo setKey:K_LABEL_VALUE_ELEMENT withArrayValue:arrLableValue];
                                                                                       }
                                                                                      
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      
                                                                                  }];
    operation.tag = 102;
    [operation start];
}


-(void) setParams:(NSMutableDictionary *) paramsValue
{
    // 1 - 查询所有订单，  2 - 查询新订单， 3 - 查询筛选条件
    if (1 == _iFindStyle )
     {
        return;
     }
    else if (2 == _iFindStyle)
     {
        paramsValue[@"inReceiveStatus"] = @"1";
        return;
     }
    
    paoma.text = @"若用户未接听，建议您尝试多次拨打以提高联系率。查看退单规则>>";
    NSDictionary *dicSX = [CommonInfo getKeyOfDic:K_FILTER_ELEMENT_QD];
    if (dicSX &&
        [dicSX count] > 0)
     {
        [paramsValue addEntriesFromDictionary:dicSX];
        NSString *strinReceiveStatus = dicSX[@"inReceiveStatus"];
        if ([strinReceiveStatus containsString:@","] &&
            [strinReceiveStatus containsString:@"5"])
         {
            paoma.text = @"若用户未接听，建议您尝试多次拨打以提高联系率。查看退单规则>>";
         }
        else if ([strinReceiveStatus isEqualToString:@"5"])
         {
            paoma.text = @"查看退单规则>>";
         }
        else
         {
            paoma.text = @"若用户未接听，建议您尝试多次拨打以提高联系率。";
         }
     }
    
    
}

-(void)deleteAction:(NSDictionary*) dicDel{
    //_isReloadShow = YES;
    //删除提示
    SIAlertView * alertView = [[SIAlertView alloc]initWithTitle:@"提示" andMessage:@"确定要删除吗?"];
    
    [alertView addButtonWithTitle:@"取消" type:SIAlertViewButtonTypeDefault handler:nil];
    [alertView addButtonWithTitle:@"确定" type:SIAlertViewButtonTypeCancel handler:^(SIAlertView *alertView){
        
        
        [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        params[@"borrowId"] = dicDel[@"borrowId"];
        params[@"receiveId"] = dicDel[@"receiveId"];
        params[@"receiveStatus"] = dicDel[@"receiveStatus"];
        
        
        DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],@"busi/account/dai/rob/deleteRob"]
                                                                                   parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                      success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                          
                                                                                          [MBProgressHUD showSuccessWithStatus:@"删除成功" toView:self.view];
                                                                                          [self reloadData];
                                                                                          
                                                                                          
                                                                                      }
                                                                                      failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                          
                                                                                          [self handleErrorData:operation];
                                                                                      }];
        [operation start];
        
    }];
    alertView.cornerRadius = 5;
    alertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
    alertView.transitionStyle = SIAlertViewTransitionStyleSlideFromTop;
    
    [alertView show];
}



-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if (operation.tag == 10210) {
        
        NSDictionary *dicAttr = operation.jsonResult.attr;
        if ([dicAttr count] > 0)
         {
            
            //            //可用余额
            //            _usableAmount = [[operation.jsonResult.attr objectForKey:@"usableAmount"] floatValue];
            
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
    }else if (operation.tag == 10200){
        
        // 处理成功，更新
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        
        [self reloadData];
    }
}


-(void)handleLightingOrder:(NSNumber *)status descreption:(NSString *)desc loanAmount:(NSString *)amount loanPeriod:(NSString *)period{
    NSDictionary *dic = nil;
    
    
    dic = self.dataArray[_handleButtonSelectedIndex];
    
    
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





#pragma mark ---  action
-(void) btnClick
{
    [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@(1),@"index":@(10)}];
}

-(void) labelTouchUpInside
{
    NSString *url = [NSString stringWithFormat:@"%@xxapp/protocol/lendHomeRob",[PDAPI WXSysRouteAPI]];
    [CCWebViewController showWithContro:self withUrlStr:url withTitle:@"抢单协议"];
}

-(void) lightingOrderButtonClickForCellAtIndex:(int)index
{
    [self showAlertView_Step1:index];
}

-(void)showAlertView_Step1:(int)index{
    
    _handleButtonSelectedIndex = index;
    
    NSDictionary *dic = self.dataArray[_handleButtonSelectedIndex];
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
    NSDictionary *dic = self.dataArray[_handleButtonSelectedIndex];
    
    
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
    vc.pageType = 2;
    vc.bussinessType = 1;
    self.vc = vc;
    vc.view.backgroundColor = [UIColor clearColor];
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    
    vc.popBlock = ^(id obj) {
        NSString *strRet = (NSString*)obj;
        //NSLog(@"strRet:%@", strRet);
        labelStauts.text = strRet;
    };
}




@end
