//
//  LightingLockVC.m
//  XDZJApp
//
//  Created by xxjr02 on 2018/8/9.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import "LightingLockVC.h"
#import "QDDetailVC.h"
#import "LightingPopMessage.h"

@interface LightingLockVC ()
{
    NSString *curBorrowId;
}
@end

@implementation LightingLockVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutNaviBarViewWithTitle:@"锁单状态"];
    
    [self layoutUI];
    
    //[self getLockList];
}

#pragma mark --- 布局UI
-(void)layoutUI
{
    int iTopY = NavHeight + 15;
    int iLeftX = (SCREEN_WIDTH - 90)/2;
    UIImageView *imgLock = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 90, 90)];
    [self.view addSubview:imgLock];
    imgLock.image = [UIImage imageNamed:@"light_suo"];
    
    iTopY += imgLock.height + 10;
    UILabel *labelTitle1 = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 20)];
    [self.view addSubview:labelTitle1];
    labelTitle1.font = [UIFont systemFontOfSize:14];
    labelTitle1.textColor = [ResourceManager color_1];
    labelTitle1.textAlignment = NSTextAlignmentCenter;
    labelTitle1.text = @"该贷款客户已被你锁定";
    
    iTopY += labelTitle1.height + 10;
    UIButton *btnCKZL = [[UIButton alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 15)];
    [self.view addSubview:btnCKZL];
    [btnCKZL setTitle:@"查看该客户贷款资料>" forState:UIControlStateNormal];
    [btnCKZL setTitleColor:[ResourceManager mainColor]  forState:UIControlStateNormal];
    btnCKZL.titleLabel.font = [UIFont systemFontOfSize:13];
    [btnCKZL addTarget:self action:@selector(actionCKXQ) forControlEvents:UIControlEventTouchUpInside];
    
    iTopY += btnCKZL.height + 10;
    UILabel *labelTitle2 = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 15)];
    [self.view addSubview:labelTitle2];
    labelTitle2.font = [UIFont systemFontOfSize:12];
    labelTitle2.textColor = UIColorFromRGB(0x666666);
    labelTitle2.textAlignment = NSTextAlignmentCenter;
    labelTitle2.text = @"请于5分钟能完成付款，超过时间该笔订单自动";
    
    iTopY += labelTitle2.height;
    UILabel *labelTitle3 = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 15)];
    [self.view addSubview:labelTitle3];
    labelTitle3.font = [UIFont systemFontOfSize:12];
    labelTitle3.textColor = UIColorFromRGB(0x666666);
    labelTitle3.textAlignment = NSTextAlignmentCenter;
    labelTitle3.text = @"解锁，你可能失去一笔好单。";
    
    iTopY += labelTitle3.height+30;
    UILabel *labelTitle4 = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 15)];
    [self.view addSubview:labelTitle4];
    labelTitle4.font = [UIFont systemFontOfSize:12];
    labelTitle4.textColor = [ResourceManager color_1];
    labelTitle4.textAlignment = NSTextAlignmentCenter;
    labelTitle4.text = @"锁单时间为5分钟";
    
    int iBtnLeft = 50;
    int iBtnWdith = SCREEN_WIDTH - 2*iBtnLeft;
    iTopY += labelTitle4.height + 10;
    UIButton *btnQD = [[UIButton alloc] initWithFrame:CGRectMake(iBtnLeft, iTopY, iBtnWdith, 40)];
    [self.view addSubview:btnQD];
    [btnQD setTitle:@"抢单" forState:UIControlStateNormal];
    [btnQD setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
    btnQD.titleLabel.font = [UIFont systemFontOfSize:14];
    btnQD.backgroundColor = [ResourceManager mainColor];
    btnQD.cornerRadius = 3;
    [btnQD addTarget:self action:@selector(actionQD) forControlEvents:UIControlEventTouchUpInside];
    
    int iPrice = [_dataDic[@"price"]  intValue] / 100;
    if (iPrice > 0 &&
        ![PDAPI isTestUser])
     {
        NSString *strPrice = [NSString stringWithFormat:@"%d元抢单", iPrice];
        [btnQD setTitle:strPrice forState:UIControlStateNormal];
     }

    
    
    iTopY += btnQD.height + 10;
    UIButton *btnJS = [[UIButton alloc] initWithFrame:CGRectMake(iBtnLeft, iTopY, iBtnWdith, 40)];
    [self.view addSubview:btnJS];
    [btnJS setTitle:@"解锁" forState:UIControlStateNormal];
    [btnJS setTitleColor:UIColorFromRGB(0x666666)  forState:UIControlStateNormal];
    btnJS.titleLabel.font = [UIFont systemFontOfSize:14];
    //btnJS.backgroundColor = [ResourceManager mainColor];
    btnJS.cornerRadius = 3;
    btnJS.layer.borderWidth = 1;
    btnJS.layer.borderColor = UIColorFromRGB(0x666666).CGColor;
    [btnJS addTarget:self action:@selector(actionUnLock) forControlEvents:UIControlEventTouchUpInside];
    
    
}

#pragma mark --- action
-(void) actionCKXQ
{
    QDDetailVC *ctl = [[QDDetailVC alloc] init];
    ctl.applyID = [_dataDic objectForKey:@"borrowId"];
    ctl.borrowId = [_dataDic objectForKey:@"borrowId"];
    ctl.score = _score;
    ctl.freeHour = NO;
    ctl.haveFreeRob = NO;
    ctl.robNum = _robNum;
    ctl.usableAmount = _usableAmount;
    ctl.lightDic = _dataDic;
    ctl.canUseTicket = _canUseTicket;
    ctl.arrCustTickets = _arrCustTickets;
    int status = [[_dataDic objectForKey:@"status"] intValue];
    if (1 == status)
     {
        ctl.isNotQD = TRUE;
     }
    [self.navigationController pushViewController:ctl animated:YES];
}


-(void) actionQD
{
    // 抢单扣款功能
    LightingPopMessage * alert = [[LightingPopMessage alloc] initWithDic:_dataDic
                                                               arraryDZQ:_arrCustTickets
                                                            usebleAmount:_usableAmount
                                                                  canUse:_canUseTicket];
    alert.parentVC = self;
    [alert show];
}

-(void) actionUnLock
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    curBorrowId = [NSString stringWithFormat:@"%@",_dataDic[@"borrowId"]];
    
    params[@"borrowId"] = curBorrowId;
    
    NSString *url = [NSString stringWithFormat:@"%@%@",[PDAPI getBusiUrlString],kDDGRobUnlock];
    
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:url
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
        
                                                                                      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                                                                          // 因为有bug（解锁不能太快），所以要延迟1.5s执行
                                                                                          [self.navigationController popViewControllerAnimated:YES];
                                                                                          
                                                                                          // 发送刷新抢单列表的通知
                                                                                          [[NSNotificationCenter defaultCenter] postNotificationName:UpdataListNotification object:@{@"key":@"UnLock",@"UnBorrowId":curBorrowId}];
                                                                                         
                                                                                      });
                                                                                      
                                                                                      
                                                                                      
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                      
                                                                                  }];
    operation.tag = 10213;
    
    [operation start];
}

#pragma mark --- 网络通讯
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



@end
