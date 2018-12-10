//
//  ThridVC.m
//  XXStatshipApp
//
//  Created by xxjr02 on 2018/6/8.
//  Copyright © 2018年 xxjr02. All rights reserved.
//

#import "ThridVC.h"
#import "MyInfoViewController.h"
#import "NewVipViewControllerCtl_2.h"
#import "BalanceRecordViewController.h"
#import "FeedbackViewController.h"
#import "CourtesyCardVC.h"
#import "SheZhiViewController.h"
#import "ApproveResultsViewController.h"
#import "ApproveViewController.h"
#import "WorkProveViewController.h"

@interface ThridVC ()
{
    
    
    UIScrollView * scView;
    UIImageView  *imgHead;
    UILabel *labelName;
    UILabel *labelMoney;
    
    NSDictionary * _dataDic;
    NSString* _usableAmount; // 余额
    NSInteger _vipGrade;     //是否是VIP
    NSString *_vipEndDate;   //到期时间
    
    NSDictionary *_workDic;
    NSDictionary *_cardDic;
    
    UIButton *btnSFRZ;
    UILabel *labelErr1;
    
    UIButton *btnGZRZ;
    UILabel *labelErr2;
    

    
}
@end

@implementation ThridVC

-(void)addButtonView{
    
    self.tabBarController.tabBar.hidden = YES;
    
    [self.view addSubview:self.tabBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TabbarHeight)];
    
    //    if(!TARGET_IPHONE_SIMULATOR &&
    //       IS_IPHONE_6_LATER)
    //     {
    //        _scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, SCREEN_HEIGHT - TabbarHeight+20)];
    //     }
    
    scView.backgroundColor= [UIColor whiteColor];
    //关闭翻页效果
    scView.pagingEnabled = NO;
    //隐藏滚动条
    scView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scView];
    
    [self adjustSCView];
    
    [self layoutUI];
}

-(void) adjustSCView
{
    if (@available(iOS 11.0, *)) {
        scView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        if (!IS_IPHONE_X_MORE)
         {
            scView.height += 20;
         }
        else
         {
            scView.height += 64;
         }
    }
    else
     {
        // NavHeight 高度变为44了，多了20
        scView.height += 20;
     }

}

-(void) viewWillAppear:(BOOL)animated
{
    barStyle = UIStatusBarStyleDefault;
    [[UIApplication sharedApplication] setStatusBarStyle:barStyle];
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
    [self adjustSCView];
    
    [self InfoURL];
    
    [self getAuthInfo];
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
    //return barStyle;
}

#pragma mark ---  布局UI
-(void) layoutUI
{
    int iTopY = 0;
    int iLeftX = 0;
    
    UIColor  *color1 = UIColorFromRGB(0x999999);
    UIColor  *color2 = UIColorFromRGB(0x333333);
    
    UIFont *font1 = [UIFont systemFontOfSize:14];
    
    if (iOS11Less)
     {
        iTopY -= 20;
     }
    
    int iTopHeight = 110 * ScaleSize;
    
    if (IS_IPHONE_Plus ||
        IS_IPHONE_X_MORE)
     {
        iTopHeight = 150 * ScaleSize;
     }
    
    UIImageView  *viewTop = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH, 110 * ScaleSize)];
    [scView addSubview:viewTop];
    viewTop.image = [UIImage imageNamed:@"my_bg"];
    
    
    iTopY +=  30 * ScaleSize;
    if (IS_IPHONE_Plus ||
        IS_IPHONE_X_MORE)
     {
        iTopY += 20 * ScaleSize;
     }
    int iImgWdith = 80 * ScaleSize;
    imgHead = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - iImgWdith)/2, iTopY, iImgWdith, iImgWdith)];
    [scView addSubview:imgHead];
    imgHead.image = [UIImage imageNamed:@"my_head"];
    imgHead.backgroundColor = [UIColor whiteColor];
    imgHead.layer.cornerRadius = iImgWdith/2;
    imgHead.layer.masksToBounds = YES;
    
    //添加手势
    imgHead.userInteractionEnabled = YES;
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionInfo)];
    gesture.numberOfTapsRequired  = 1;
    [imgHead addGestureRecognizer:gesture];
    
    iTopY += iImgWdith + 10;
    labelName = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 20)];
    [scView addSubview:labelName];
    labelName.font = [UIFont systemFontOfSize:15];
    labelName.textColor = color1;
    labelName.textAlignment = NSTextAlignmentCenter;
    labelName.text = @"经理";
    
    iLeftX = 10;
    iTopY += labelName.height + 10;
    UILabel *labelZHYE = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 150, 20)];
    [scView addSubview:labelZHYE];
    labelZHYE.textColor = color2;
    labelZHYE.font = font1;
    labelZHYE.text = @"账号余额(元)";
    
    iTopY += labelZHYE.height + 10;
    labelMoney = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 200, 25)];
    [scView addSubview:labelMoney];
    labelMoney.textColor = color2;
    labelMoney.font = [UIFont systemFontOfSize:25];
    NSString *strMoney = @"";
    strMoney = [CommonInfo formatString:strMoney];
    labelMoney.text = strMoney; //@"1218.00";
    
    
    UIButton *btnCZ = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 110, iTopY, 100, 25)];
    [scView addSubview:btnCZ];
    [btnCZ setTitle:@"立即充值" forState:UIControlStateNormal];
    [btnCZ setTitleColor:color2 forState:UIControlStateNormal];
    btnCZ.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnCZ addTarget:self action:@selector(actionChongZhi) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *_rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(100 - 20, (25 - 18)/2, 13, 18)];
    [btnCZ addSubview:_rightImage];
    _rightImage.image = [UIImage imageNamed:@"arrow-2"];
    
    iTopY +=labelMoney.height + 15;
    UIView *viewFG1 = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 1)];
    [scView addSubview:viewFG1];
    viewFG1.backgroundColor = [ResourceManager color_5];
    
    
    
    
    // 身份认证
    iTopY += 15;
    UIImageView *imgSFRZ = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 40, 40)];
    [scView addSubview:imgSFRZ];
    imgSFRZ.image = [UIImage imageNamed:@"my_sfrz"];
    
    iLeftX += imgSFRZ.width + 10;
    int iLabelWidth = SCREEN_WIDTH/2 - iLeftX ;
    UILabel *labelSFRZ = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iLabelWidth, 20)];
    //labelSFRZ.backgroundColor = [UIColor yellowColor];
    [scView addSubview:labelSFRZ];
    labelSFRZ.textColor = color2;
    labelSFRZ.font = font1;
    labelSFRZ.text = @"身份认证";
    
    labelErr1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY + 25, iLabelWidth, 20)];
    [scView addSubview:labelErr1];
    labelErr1.textColor = color1;
    labelErr1.font = font1;
    labelErr1.text = @"未认证";
    
    btnSFRZ = [[UIButton alloc] initWithFrame:CGRectMake(0, iTopY-15, SCREEN_WIDTH/2, 70)];
    [scView addSubview:btnSFRZ];
    [btnSFRZ addTarget:self action:@selector(actionSFRZ) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIView *viewFG2 = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, iTopY, 1, 45)];
    [scView addSubview:viewFG2];
    viewFG2.backgroundColor = [ResourceManager color_5];
    
    // 工作认证
    iLeftX = SCREEN_WIDTH/2 + 15;
    UIImageView *imgGZRZ = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 40, 40)];
    [scView addSubview:imgGZRZ];
    imgGZRZ.image = [UIImage imageNamed:@"my_gzrz"];
    
    iLeftX += imgGZRZ.width + 10;
    UILabel *labelGZRZ = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iLabelWidth, 20)];
    [scView addSubview:labelGZRZ];
    labelGZRZ.textColor = color2;
    labelGZRZ.font = font1;
    labelGZRZ.text = @"工作认证";
    
    labelErr2 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY + 25, iLabelWidth, 20)];
    [scView addSubview:labelErr2];
    labelErr2.textColor = color1;
    labelErr2.font = font1;
    labelErr2.text = @"未认证";
    
    btnGZRZ = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, iTopY-15, SCREEN_WIDTH/2, 70)];
    [scView addSubview:btnGZRZ];
    [btnGZRZ addTarget:self action:@selector(actionGZRZ) forControlEvents:UIControlEventTouchUpInside];
    
    iTopY  += 55;
//    UIView *viewFG3 = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 1)];
//    [scView addSubview:viewFG3];
//    viewFG3.backgroundColor = [ResourceManager color_5];
    
    [self layoutTail:iTopY];
    
}

-(void) layoutTail:(int) iCurTopY
{
    int iTopY = iCurTopY;
    
    UIView  *viewTail = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 500)];
    [scView addSubview:viewTail];
    viewTail.backgroundColor = [ResourceManager viewBackgroundColor];
    
    NSArray * imageArr = @[@"my_grxx",@"my_wdye",@"my_wdkb",@"my_yjfk",@"my_set"];
    NSArray * titleArr = @[@"个人信息",@"我的余额",@"我的卡包",@"意见反馈",@"设置"];
    
    iTopY += 15;
    
    for (int i = 0; i < [imageArr count]; i++)
     {
        UIButton *viewTemp = [[UIButton alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 50)];
        [scView addSubview:viewTemp];
        viewTemp.backgroundColor = [UIColor whiteColor];
        viewTemp.tag = i;
        [viewTemp addTarget:self action:@selector(actionBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *imgTemp = [[UIImageView alloc] initWithFrame:CGRectMake(15, iTopY + 15, 20, 20)];
        [scView addSubview:imgTemp];
        imgTemp.image = [UIImage imageNamed:imageArr[i]];
        
        UILabel *labelTemp = [[UILabel alloc] initWithFrame:CGRectMake(15 + 20 + 10, iTopY+15, 150, 20)];
        [scView addSubview:labelTemp];
        labelTemp.font = [UIFont systemFontOfSize:15];
        labelTemp.textColor = UIColorFromRGB(0x333333);
        labelTemp.text = titleArr[i];
        
        UIImageView *rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 20, iTopY +(50 - 18)/2, 13, 18)];
        [scView addSubview:rightImage];
        rightImage.image = [UIImage imageNamed:@"arrow-2"];
        
        if (i <= 2)
         {
            UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(45, iTopY + 49, SCREEN_WIDTH, 1)];
            [scView addSubview:viewFG];
            viewFG.backgroundColor = [ResourceManager color_5];
         }
        
        iTopY += viewTemp.height;
        
        if (i == 3)
         {
            iTopY += 15;
         }
     }
    iTopY += 50;
    
    scView.contentSize = CGSizeMake(0, iTopY);
}


#pragma mark ---  action
-(void) actionBtn:(UIButton*) sender
{
    int iTag =  (int)sender.tag;
    
    if (iTag < 4)
     {
        if (![[DDGAccountManager sharedManager] isLoggedIn])
         {
            [DDGUserInfoEngine engine].parentViewController = self;
            [[DDGUserInfoEngine engine] finishUserInfoWithFinish:nil];
            return;
         }
     }
    
    switch (iTag) {
        case 0:
            {
               // 个人信息
               [self actionInfo];
            }
            break;
        case 1:
            {
               // 我的余额
               BalanceRecordViewController *ctl = [[BalanceRecordViewController alloc] init];
               [self.navigationController pushViewController:ctl animated:YES];
            }
            break;
        case 2:
            {
                // 我的卡包
               CourtesyCardVC *ctl = [[CourtesyCardVC alloc] init];
               [self.navigationController pushViewController:ctl animated:YES];
            }
            break;
        case 3:
            {
               // 意见反馈
               FeedbackViewController *ctl = [[FeedbackViewController alloc] init];
               [self.navigationController pushViewController:ctl animated:YES];
            }
            break;
        case 4:
            {
               // 设置
               SheZhiViewController *ctl = [[SheZhiViewController alloc] init];
               [self.navigationController pushViewController:ctl animated:YES];
            }
            break;
            
        default:
            break;
    }
}

-(void) actionInfo
{
    if ([[DDGAccountManager sharedManager] isLoggedIn]) {
        MyInfoViewController *Info = [[MyInfoViewController alloc] init];
        [self.navigationController pushViewController:Info animated:YES];
    }else {
        [DDGUserInfoEngine engine].parentViewController = self;
        [[DDGUserInfoEngine engine] finishUserInfoWithFinish:nil];
    }
}

//充值
-(void)actionChongZhi{
    
    if ([[DDGAccountManager sharedManager] isLoggedIn]) {
        
        NewVipViewControllerCtl_2 *ctl = [[NewVipViewControllerCtl_2 alloc]init];
        ctl.usableAmount = _usableAmount;
        ctl.vipGrade = _vipGrade;
        ctl.vipEndDate = _vipEndDate;
        [self.navigationController pushViewController:ctl animated:YES];
        
    }else {
        [DDGUserInfoEngine engine].parentViewController = self;
        [[DDGUserInfoEngine engine] finishUserInfoWithFinish:nil];
        return;
    }
}

-(void) actionSFRZ
{
    if ([[_cardDic objectForKey:@"status"] intValue] == 1) {
        [MBProgressHUD showOnlyText:@"身份认证已成功" toView:self.view];
        return;
    }
    
    int approveStatus =  [[_cardDic objectForKey:@"status"] intValue];
    if (approveStatus == 0 ||
        approveStatus == 1 ||
        approveStatus == 2) {
        ApproveResultsViewController *ctl = [[ApproveResultsViewController alloc]init];
        [self.navigationController pushViewController: ctl animated:YES];
    }else{
        ApproveViewController *ctl = [[ApproveViewController alloc]init];
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

-(void) actionGZRZ
{
    if ([[_workDic objectForKey:@"status"] intValue] == 1) {
        [MBProgressHUD showOnlyText:@"工作认证已成功" toView:self.view];
        return;
    }
    
    WorkProveViewController *ctl = [[WorkProveViewController alloc]init];
    ctl.proveBlock = ^{
        [self getAuthInfo];
    };
    if ([_workDic objectForKey:@"status"]) {
        ctl.type = [[_workDic objectForKey:@"status"]intValue];
    }
    ctl.workDic = _workDic;
    [self.navigationController pushViewController:ctl animated:YES];
}



#pragma mark ---  网络请求
//获取用户信息
-(void)InfoURL
{
    if (![[DDGAccountManager sharedManager] isLoggedIn])
     {
        return;
     }
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[PDAPI getUserBaseInfoAPI]
                                                                               parameters:@{kUUID:[DDGSetting sharedSettings].UUID_MD5} HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    operation.tag = 1000;
    [operation start];
}

-(void)getAuthInfo{
    
    if (![[DDGAccountManager sharedManager] isLoggedIn])
     {
        return;
     }

    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@",[PDAPI getQueryProfessionListAPI]]
                                                                               parameters:nil HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    operation.tag = 1001;
    [operation start];
}

-(void)handleData:(DDGAFHTTPRequestOperation *)operation
{
    if (1000 == operation.tag)
     {
        NSDictionary * dic = operation.jsonResult.attr;
        if (dic)
         {
            NSString *areaVersion = dic[@"areaVersion"];  // 城市信息的网络版本号
            [CommonInfo setKey:K_CITY_NETVESION  withValue:areaVersion];
            
            
         }
        
        NSArray *rows=operation.jsonResult.rows;
        
        if (rows.count > 0) {
            NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithDictionary:rows[0]];
            _dataDic = dic;
            //避免NULL字段
            for (NSString *key in dic.allKeys) {
                if ([[dic objectForKey:key] isEqual:[NSNull null]]) {
                    [dic setValue:@"" forKey:key];
                }
            }
            
            NSString *strCityName =  dic[@"cityName"];
            if (strCityName)
             {
                [CommonInfo setKey:K_PR_City withValue:strCityName];
             }
            
            [[DDGAccountManager sharedManager] setUserInfo:dic];
            //头像
            NSString * _imageUrl = [NSString stringWithFormat:@"%@",[dic objectForKey:@"headImgUrl"]];
            [imgHead sd_setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage:[UIImage imageNamed:@"my_head"]];
            
            
            if ([NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"realName"]].length > 0) {
                NSString *name = [NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"realName"]];
                labelName.text = [NSString stringWithFormat:@"%@经理",[name substringToIndex:1]];
            }
            else if ([NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"userName"]].length > 0) {
                NSString *name = [NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"userName"]];
                labelName.text = name;
            }
            
            if ([_dataDic objectForKey:@"usableAmount"] && [NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"usableAmount"]].length > 0) {
                _usableAmount = [NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"usableAmount"]];
                NSString *strAomunt = [CommonInfo formatString:_usableAmount];
                labelMoney.text = [NSString stringWithFormat:@"%@",strAomunt];
            }
            
            if ([_dataDic objectForKey:@"vipGrade"] && [NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"vipGrade"]].length > 0) {
                _vipGrade = [[_dataDic objectForKey:@"vipGrade"] intValue];
                
                if (_vipGrade == 1 && [_dataDic objectForKey:@"vipEndDate"] && [NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"vipEndDate"]].length > 0) {
                    _vipEndDate = [NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"vipEndDate"]];
                    //_vipTimeLabel.text = [NSString stringWithFormat:@"%@到期",[_dataDic objectForKey:@"vipEndDate"]];
                }
            }
        }
     }
    else if (1001 == operation.tag)
     {
        _workDic = [[NSDictionary alloc]initWithDictionary:[operation.jsonResult.attr objectForKey:@"cardInfo"]];
        _cardDic = [[NSDictionary alloc]initWithDictionary:[operation.jsonResult.attr objectForKey:@"identifyInfo"]];

        
        if ([_cardDic objectForKey:@"status"]) {
            //labelErr1.textColor = [ResourceManager color_6];
            if ([[_cardDic objectForKey:@"status"] intValue] == -1) {
                labelErr1.text = @"未认证";
            }else if ([[_cardDic objectForKey:@"status"] intValue] == 0) {
                labelErr1.text = @"认证待审核";
            }else if ([[_cardDic objectForKey:@"status"] intValue] == 1) {
                //labelErr1.textColor = UIColorFromRGB(0x00AC61);
                labelErr1.text = @"认证成功";
            }else if ([[_cardDic objectForKey:@"status"] intValue] == 2) {
                //labelErr1.textColor = UIColorFromRGB(0xED0000);
                labelErr1.text = @"认证失败";
            }
        }
        if ([_workDic objectForKey:@"status"]) {
            //labelErr2.textColor = [ResourceManager color_6];
            if ([[_workDic objectForKey:@"status"] intValue] == -1) {
                labelErr2.text = @"未认证";
            }else if ([[_workDic objectForKey:@"status"] intValue] == 0) {
                labelErr2.text = @"认证待审核";
            }else if ([[_workDic objectForKey:@"status"] intValue] == 1) {
                //labelErr2.textColor = UIColorFromRGB(0x00AC61);
                labelErr2.text = @"认证成功";
            }else if ([[_workDic objectForKey:@"status"] intValue] == 2) {
                //labelErr2.textColor = UIColorFromRGB(0xED0000);
                labelErr2.text = @"认证失败";
            }
        }
     }

}
@end
