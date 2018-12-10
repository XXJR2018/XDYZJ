//
//  HousViewController.m
//  XXJR
//
//  Created by xxjr03 on 16/6/16.
//  Copyright © 2016年 Cary. All rights reserved.
//

#import "HousViewController.h"
#import "HousDetailsViewController.h"

@interface HousViewController ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSMutableArray * btnArr;
    UIButton * _housBtn;
    UIView * _housView_1;
    UIView * _housView_2;
    UIView * _housView_3;
    UILabel * _limitLabel;
    UILabel * _rateLabel;
    UITextField * _MoneyField;
    UIButton * _resultBtn;
    UIPickerView * _limitPickView;
    UIPickerView * _ratePickView;
    UIView * _limitView;
    UIView * _rateView;
    NSArray * _limitPickArr;
    NSArray * _ratePickArr;
    UITextField * _MoneyFieldTWo;
    UITextField * _MoneyFieldThree;
    UITextField * _MoneyFieldFour;
    UILabel * _limitLabelTwo;
    UILabel * _limitLabelThree;
    UILabel * _rateLabelThree;
    UIButton * _momeyRateBtn;
    UIButton * _momeyRateBtn_2;
    NSMutableArray * _momeyRateArr;
    NSMutableArray * _momeyRateArr_2;
    CGFloat  _rataNum;
    UILabel * _TSLabel;
    
    UIView *_viewNotNet;  // 无网络时的页面（此时也必须要时审核页面）
}
@end

@implementation HousViewController

-(void)addButtonView{
    
    self.tabBarController.tabBar.hidden = YES;
    
    [self.view addSubview:self.tabBar];
}


- (void)viewWillAppear:(BOOL)animated
{
    barStyle = UIStatusBarStyleDefault;
    [[UIApplication sharedApplication] setStatusBarStyle:barStyle];
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"房贷计算器"];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"房贷计算器"];
}

#pragma mark --- 网络通讯
// 调用网络接口，获取是否正在审核中
-(void)getCheckVersion{
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    currentVersion = [currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"appID"] = MY_APP_ID;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[PDAPI getCheckVersionAPI]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                                                                      [self parseDic2:operation.jsonResult.attr];
                                                                                      
                                                                                      
                                                                                      
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      NSLog(@"error ==== %@",operation.jsonResult.message);
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                      
                                                                                      
                                                                                  }];
    [operation start];
}

// 判断是否审核中
-(void) parseDic2:(NSDictionary*) dic
{
    if (!dic)
     {
        return;
     }
    NSLog(@"dic : %@", dic);
    
    _viewNotNet.hidden = NO;
    
    // isTestByIos   1 表示审核中，   0  表示审核通过
    int     iisTestByIos  = [dic[@"isTestByIos"] boolValue];
    
    NSString *version = dic[@"upVersion"];
    version = [version stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    currentVersion = [currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    // 网络版本号 和 isTestByIos ，都匹配，才是审核中 (审核时，后台返回的版本号，要比自己的版本号小)
    if ([currentVersion floatValue] > [version floatValue] &&
        iisTestByIos == 1)
     {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"1" forKey:@"isAppReview"];
        
        _viewNotNet.hidden = YES;
        
     }
    else
     {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"0" forKey:@"isAppReview"];
        
        // 重新属性tabbar ,切换到正式界面
        [self.navigationController popToRootViewControllerAnimated:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@(100),@"index":@(1)}];
        
     }
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.hideBackButton = YES;
    [self layoutNaviBarViewWithTitle:@"房贷计算器"];
    self.view.backgroundColor = [ResourceManager viewBackgroundColor];
    //添加手势点击空白处隐藏键盘
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchViewKeyBoard)];
    gesture.numberOfTapsRequired  = 1;
    [self.view addGestureRecognizer:gesture];
    [self layoutUI];
}
//Return 键回收键盘
- (BOOL)textViewShouldReturn:(UITextField *)textView
{
    //  回收键盘,取消第一响应者
    [_MoneyField resignFirstResponder];
    [_MoneyFieldTWo resignFirstResponder];
    [_MoneyFieldThree resignFirstResponder];
    [_MoneyFieldFour resignFirstResponder];
    return YES;
}
//添加手势点击空白处隐藏键盘
-(void)TouchViewKeyBoard
{
    //隐藏选择器
    _limitView.hidden =YES;
    _rateView.hidden =YES;
    _resultBtn.hidden = NO;
    [self.view endEditing:YES];
}

#pragma mark ---  布局UI
-(void)layoutUI{
    
    
    btnArr = [[NSMutableArray alloc]init];
    NSArray * titleArr = @[@"商业贷款",@"公积金贷款",@"组合贷款"];
    for (int i = 0; i < 3; i++) {
        _housBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3 * i, NavHeight + 10, SCREEN_WIDTH/3, 40)];
        [self.view addSubview:_housBtn];
        _housBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btnArr addObject:_housBtn];
        _housBtn.tag = i;
        [_housBtn setTitleColor:[ResourceManager color_6] forState:UIControlStateNormal];
        //[_housBtn setTitleColor:UIColorFromRGB(0xfc7637) forState:UIControlStateSelected];
        [_housBtn setTitleColor:[ResourceManager mainColor] forState:UIControlStateSelected];
        [_housBtn setTitle:titleArr[i] forState:UIControlStateNormal];
        [_housBtn addTarget:self action:@selector(housBtn:) forControlEvents:UIControlEventTouchUpInside];
        ((UIButton *)btnArr[0]).selected = YES;
    }
    UIView * viewX_1 = [[UIView alloc]initWithFrame:CGRectMake(0.f, NavHeight + 50 - 0.5, SCREEN_WIDTH, 0.5)];
    [self.view addSubview:viewX_1];
    viewX_1.backgroundColor = [ResourceManager color_5];
    UIView * viewX_2 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3, NavHeight + 20, 0.5, 20)];
    [self.view addSubview:viewX_2];
    viewX_2.backgroundColor = [ResourceManager color_5];
    UIView * viewX_3 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3 * 2, NavHeight + 20, 0.5, 20)];
    [self.view addSubview:viewX_3];
    viewX_3.backgroundColor = [ResourceManager color_5];
    [self housViewUI];
    
    
    if ([PDAPI isTestUser] &&
        ![XXJRUtils isNetworkReachable])
     {
        _viewNotNet = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.view addSubview:_viewNotNet];
        [self layoutViewNotNet];
     }
}

-(void) layoutViewNotNet
{
    _viewNotNet.backgroundColor = [ResourceManager viewBackgroundColor];
    
    UIImageView *imgNotNet = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 70)/2, SCREEN_HEIGHT*1/5, 100, 60)];
    [_viewNotNet addSubview:imgNotNet];
    imgNotNet.image = [UIImage imageNamed:@"com_not_net"];
    
    
    int iTopY = imgNotNet.top + imgNotNet.height + 15;
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 20)];
    [_viewNotNet addSubview:label1];
    label1.font = [UIFont systemFontOfSize:18];
    label1.textColor = [ResourceManager color_1];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = @"网络请求失败";
    
    iTopY += label1.height + 10;
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 15)];
    [_viewNotNet addSubview:label2];
    label2.font = [UIFont systemFontOfSize:14];
    label2.textColor = [ResourceManager lightGrayColor];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.text = @"请重新设置网络后，重新加载";
    
    iTopY += label2.height + 10;
    UIButton *btnSetNet = [[UIButton alloc] initWithFrame:CGRectMake( (SCREEN_WIDTH-100)/2, iTopY, 100, 30)];
    [_viewNotNet addSubview:btnSetNet];
    btnSetNet.layer.borderWidth = 1;
    btnSetNet.layer.borderColor = [ResourceManager lightGrayColor].CGColor;
    [btnSetNet setTitle:@"设置网络" forState:UIControlStateNormal];
    [btnSetNet setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
    btnSetNet.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnSetNet addTarget:self action:@selector(actionSetNet) forControlEvents:UIControlEventTouchUpInside];
    
    iTopY += btnSetNet.height + 10;
    UIButton *btnReLoad = [[UIButton alloc] initWithFrame:CGRectMake( (SCREEN_WIDTH-100)/2, iTopY, 100, 30)];
    [_viewNotNet addSubview:btnReLoad];
    btnReLoad.layer.borderWidth = 1;
    btnReLoad.layer.borderColor = [ResourceManager lightGrayColor].CGColor;
    [btnReLoad setTitle:@"重新加载" forState:UIControlStateNormal];
    [btnReLoad setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
    btnReLoad.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnReLoad addTarget:self action:@selector(actionReLoad) forControlEvents:UIControlEventTouchUpInside];
    
}


-(void) actionSetNet
{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }
    
}
-(void) actionReLoad
{
    if ([XXJRUtils isNetworkReachable])
     {
        // 发通知到tabbar, 刷新tab
        [self getCheckVersion];
        
     }
    else
     {
        [MBProgressHUD showErrorWithStatus:@"请先设置网络" toView:self.view];
     }
}


-(void)housViewUI{
    _housView_1 = [[UIView alloc]initWithFrame:CGRectMake(0.f, NavHeight + 50.f, SCREEN_WIDTH, 200.f)];
    [self.view addSubview:_housView_1];
    _housView_1.backgroundColor = [UIColor whiteColor];
    _housView_2 = [[UIView alloc]initWithFrame:CGRectMake(0.f, NavHeight + 50.f, SCREEN_WIDTH, 150.f)];
    [self.view addSubview:_housView_2];
    _housView_2.backgroundColor = [UIColor whiteColor];
    _housView_3 = [[UIView alloc]initWithFrame:CGRectMake(0.f, NavHeight + 50.f, SCREEN_WIDTH, 250.f)];
    [self.view addSubview:_housView_3];
    _housView_3.backgroundColor = [UIColor whiteColor];
    _housView_1.hidden = NO;
    _housView_2.hidden = YES;
    _housView_3.hidden = YES;
    _resultBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.f, SCREEN_HEIGHT - (50 + TabbarHeight + 40), SCREEN_WIDTH, 50.f)];
    [self.view addSubview:_resultBtn];
    _resultBtn.backgroundColor = [ResourceManager mainColor];
    [_resultBtn setTitle:@"计算结果" forState:UIControlStateNormal];
    [_resultBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _resultBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_resultBtn addTarget:self action:@selector(resultBtn) forControlEvents:UIControlEventTouchUpInside];
    [self limitPickViewUI];
    [self ratePickViewUI];
    [self housView_1];
    [self housView_2];
    [self housView_3];
    _TSLabel = [[UILabel alloc]init];
    _TSLabel.font = [UIFont systemFontOfSize:11];
    _TSLabel.textColor = UIColorFromRGB(0x808080);
    [self.view addSubview:_TSLabel];
    _TSLabel.text = @"2018年08月21日最新商贷利率4.9%，公积金利率3.25%";
    _TSLabel.frame = CGRectMake(10, CGRectGetMaxY(_housView_1.frame), SCREEN_WIDTH - 15, 30);
    _TSLabel.numberOfLines = 2;
}
-(void)housView_1{
    NSArray * titleArr = @[@"商贷金额",@"贷款期限",@"商贷利率",@"计算方式"];
    for (int i = 0; i < 4; i++) {
        UIView * viewX = [[UIView alloc]initWithFrame:CGRectMake(0.f, 50 * (i + 1) - 0.5, SCREEN_WIDTH, 0.5)];
        [_housView_1 addSubview:viewX];
        viewX.backgroundColor = [ResourceManager color_5];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 50 * i, 100, 50)];
        [_housView_1 addSubview:label];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = UIColorFromRGB(0x333333);
        label.text = titleArr[i];
    }
    UIFont * font = [UIFont systemFontOfSize:13];
    UIColor * color =  UIColorFromRGB(0x808080);
    _MoneyField = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 200.f, 0.f, 170.f, 50.f)];
    [_housView_1 addSubview:_MoneyField];
    _MoneyField.font = font;
    _MoneyField.textColor = color;
    _MoneyField.textAlignment = NSTextAlignmentRight;
    _MoneyField.placeholder = @"请输入金额 ";
    _MoneyField.delegate = self;
    _MoneyField.keyboardType = UIKeyboardTypeNumberPad;
    UILabel * label_1 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 25.f, 0.f, 20, 50)];
    label_1.font = font;
    label_1.textColor = color;
    label_1.text = @"万";
    [_housView_1 addSubview:label_1];
    _limitLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 50, 90, 50)];
    [_housView_1 addSubview:_limitLabel];
    _limitLabel.font = font;
    _limitLabel.textColor = color;
    _limitLabel.textAlignment = NSTextAlignmentRight;
    _limitLabel.text = @"5年";
    _rateLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 100, 90, 50)];
    [_housView_1 addSubview:_rateLabel];
    _rateLabel.font = font;
    _rateLabel.textColor = color;
    _rateLabel.textAlignment = NSTextAlignmentRight;
    _rateLabel.text = @"基本利率";
    UILabel * label_2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 200, 150, 190, 50)];
    [_housView_1 addSubview:label_2];
    label_2.font = font;
    label_2.textColor = UIColorFromRGB(0x333333);
    label_2.textAlignment = NSTextAlignmentRight;
    label_2.text = @"按贷款额度计算";
    UIButton * limitBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 150.f, 50, 150, 50)];
    [_housView_1 addSubview:limitBtn];
    [limitBtn addTarget:self action:@selector(limitBtn) forControlEvents:UIControlEventTouchUpInside];
    UIButton * rateBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 150.f, 100, 150, 50)];
    [_housView_1 addSubview:rateBtn];
    [rateBtn addTarget:self action:@selector(rateBtn) forControlEvents:UIControlEventTouchUpInside];
   
}
-(void)housView_2{
    NSArray * titleArr = @[@"公积金金额",@"贷款期限",@"公积金利率"];
    for (int i = 0; i < 3; i++) {
        UIView * viewX = [[UIView alloc]initWithFrame:CGRectMake(0.f, 50 * (i + 1) - 0.5, SCREEN_WIDTH, 0.5)];
        [_housView_2 addSubview:viewX];
        viewX.backgroundColor = [ResourceManager color_5];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 50 * i, 100, 50)];
        [_housView_2 addSubview:label];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = UIColorFromRGB(0x333333);
        label.text = titleArr[i];
    }
        UIFont * font = [UIFont systemFontOfSize:13];
        UIColor * color = UIColorFromRGB(0x808080);
        _MoneyFieldTWo = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 200.f, 0.f, 170.f, 50.f)];
        [_housView_2 addSubview:_MoneyFieldTWo];
        _MoneyFieldTWo.font = font;
        _MoneyFieldTWo.textColor = color;
        _MoneyFieldTWo.textAlignment = NSTextAlignmentRight;
        _MoneyFieldTWo.placeholder = @"请输入金额 ";
        _MoneyFieldTWo.delegate = self;
        _MoneyFieldTWo.keyboardType = UIKeyboardTypeNumberPad;
        UILabel * label_1 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 25.f, 0.f, 20, 50)];
        label_1.font = font;
        label_1.textColor = color;
        label_1.text = @"万";
        [_housView_2 addSubview:label_1];
        _limitLabelTwo = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 50, 90, 50)];
        [_housView_2 addSubview:_limitLabelTwo];
        _limitLabelTwo.font = font;
        _limitLabelTwo.textColor = color;
        _limitLabelTwo.textAlignment = NSTextAlignmentRight;
        _limitLabelTwo.text = @"5年";
        UIButton * limitBtnTwo = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 150.f, 50, 150, 50)];
        [_housView_2 addSubview:limitBtnTwo];
        [limitBtnTwo addTarget:self action:@selector(limitBtnTwo) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray * titleArr_2 = @[@"标准:3.25%",@"1.1倍:3.58%"];
    _momeyRateArr = [[NSMutableArray alloc]init];
    for (int i= 0; i<2; i++) {
        UILabel * SLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 100 * (2 - i) + 20, 100, 75,50)];
        [_housView_2 addSubview:SLabel];
        SLabel.font = font;
        SLabel.textColor = color;
        SLabel.text = titleArr_2[i];
        _momeyRateBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 100 * (2 - i) - 5, 100 + 50/2 - 25/2, 25.f, 25.f)];
        [_housView_2 addSubview:_momeyRateBtn];
        [_momeyRateArr addObject:_momeyRateBtn];
        _momeyRateBtn.tag = (i + 1);
        [_momeyRateBtn setImage:[UIImage imageNamed:@"select_no"] forState:UIControlStateNormal];
        [_momeyRateBtn setImage:[UIImage imageNamed:@"select_yes"] forState:UIControlStateSelected];
        [_momeyRateBtn addTarget:self action:@selector(touch:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            _rataNum = 0.0325;
        }
    }
    ((UIButton *)_momeyRateArr[0]).selected = YES;
}
-(void)housView_3{
    NSArray * titleArr = @[@"公积金金额",@"商贷金额",@"贷款期限",@"公积金利率",@"商贷利率"];
    for (int i = 0; i < 5; i++) {
        UIView * viewX = [[UIView alloc]initWithFrame:CGRectMake(0.f, 50 * (i + 1) - 0.5, SCREEN_WIDTH, 0.5)];
        [_housView_3 addSubview:viewX];
        viewX.backgroundColor = [ResourceManager color_5];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 50 * i, 100, 50)];
        [_housView_3 addSubview:label];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = UIColorFromRGB(0x333333);
        label.text = titleArr[i];
    }
    UIFont * font = [UIFont systemFontOfSize:13];
    UIColor * color = UIColorFromRGB(0x808080);
    _MoneyFieldThree = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 200.f, 0.f, 170.f, 50.f)];
    [_housView_3 addSubview:_MoneyFieldThree];
    _MoneyFieldThree.font = font;
    _MoneyFieldThree.textColor = color;
    _MoneyFieldThree.textAlignment = NSTextAlignmentRight;
    _MoneyFieldThree.placeholder = @"请输入金额 ";
    _MoneyFieldThree.delegate = self;
    _MoneyFieldThree.keyboardType = UIKeyboardTypeNumberPad;
    _MoneyFieldFour = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 200.f, 50.f, 170.f, 50.f)];
    [_housView_3 addSubview:_MoneyFieldFour];
    _MoneyFieldFour.font = font;
    _MoneyFieldFour.textColor = color;
    _MoneyFieldFour.textAlignment = NSTextAlignmentRight;
    _MoneyFieldFour.placeholder = @"请输入金额 ";
    _MoneyFieldFour.delegate = self;
    _MoneyFieldFour.keyboardType = UIKeyboardTypeNumberPad;
    UILabel * label_1 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 25.f, 0.f, 20, 50)];
    label_1.font = font;
    label_1.textColor = color;
    label_1.text = @"万";
    [_housView_3 addSubview:label_1];
    UILabel * label_2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 25.f, 50.f, 20, 50)];
    label_2.font = font;
    label_2.textColor = color;
    label_2.text = @"万";
    [_housView_3 addSubview:label_2];
    _limitLabelThree = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 100, 90, 50)];
    [_housView_3 addSubview:_limitLabelThree];
    _limitLabelThree.font = font;
    _limitLabelThree.textColor = color;
    _limitLabelThree.textAlignment = NSTextAlignmentRight;
    _limitLabelThree.text = @"5年";
    _rateLabelThree = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 200, 90, 50)];
    [_housView_3 addSubview:_rateLabelThree];
    _rateLabelThree.font = font;
    _rateLabelThree.textColor = color;
    _rateLabelThree.textAlignment = NSTextAlignmentRight;
    _rateLabelThree.text = @"基本利率";
    UIButton * limitBtnThree = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 150.f, 100, 150, 50)];
    [_housView_3 addSubview:limitBtnThree];
    [limitBtnThree addTarget:self action:@selector(limitBtnThree) forControlEvents:UIControlEventTouchUpInside];
    UIButton * rateBtnThree = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 150.f, 200, 150, 50)];
    [_housView_3 addSubview:rateBtnThree];
    [rateBtnThree addTarget:self action:@selector(rateBtnThree) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray * titleArr_2 = @[@"标准:3.25%",@"1.1倍:3.58%"];
    _momeyRateArr_2 = [[NSMutableArray alloc]init];
    for (int i= 0; i<2; i++) {
        UILabel * SLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 100 * (2 - i) + 20, 150, 75,50)];
        [_housView_3 addSubview:SLabel];
        SLabel.font = font;
        SLabel.textColor = color;
        SLabel.text = titleArr_2[i];
        _momeyRateBtn_2 = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 100 * (2 - i) - 5, 150 + 50/2 - 25/2, 25.f, 25.f)];
        [_housView_3 addSubview:_momeyRateBtn_2];
        [_momeyRateArr_2 addObject:_momeyRateBtn_2];
        _momeyRateBtn_2.tag = 10 * (i + 1);
        [_momeyRateBtn_2 setImage:[UIImage imageNamed:@"select_no"] forState:UIControlStateNormal];
        [_momeyRateBtn_2 setImage:[UIImage imageNamed:@"select_yes"] forState:UIControlStateSelected];
        [_momeyRateBtn_2 addTarget:self action:@selector(touch_2:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
           
            _rataNum = 0.0325;
        }
    }
    ((UIButton *)_momeyRateArr_2[0]).selected = YES;
}
-(void)touch:(UIButton *)sender{
    ((UIButton *)_momeyRateArr[0]).selected = NO;
    if (sender != _momeyRateBtn){
        _momeyRateBtn.selected = NO;
        _momeyRateBtn = sender;
    }
    _momeyRateBtn.selected = YES;
    if (sender.tag == 1) {
        _rataNum = 0.0325;
    }if (sender.tag == 2) {
        _rataNum = 0.0358;
    }
}
-(void)touch_2:(UIButton *)sender{
    ((UIButton *)_momeyRateArr_2[0]).selected = NO;
    if (sender != _momeyRateBtn_2){
        _momeyRateBtn_2.selected = NO;
        _momeyRateBtn_2 = sender;
    }
    _momeyRateBtn_2.selected = YES;
    if (sender.tag == 10) {
        _rataNum = 0.0325;
    }if (sender.tag == 20) {
        _rataNum = 0.0358;
    }
}
-(void)limitPickViewUI{
    _limitView = [[UIView alloc]initWithFrame:CGRectMake(0.f, SCREEN_HEIGHT - (180 + 70), SCREEN_WIDTH,180.f)];
    [self.view addSubview:_limitView];
    _limitView.backgroundColor = [UIColor whiteColor];
    _limitPickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0.f, 30.f, SCREEN_WIDTH, 150.f)];
    _limitPickView.delegate = self;
    _limitPickView.dataSource = self;
    _limitPickView.tag = 0;
    _limitPickView.backgroundColor = [UIColor whiteColor];
    [_limitView addSubview:_limitPickView];
    UIView * titleView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, 30.f)];
    [_limitView addSubview:titleView];
    titleView.backgroundColor = UIColorFromRGB(0xeaeaea);
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 -50.f, 0.f, 100.f, 30.f)];
    [_limitView addSubview:titleLabel];
    titleLabel.text = @"贷款期限";
    titleLabel.font = [UIFont systemFontOfSize:14];
    //居中
    titleLabel.textAlignment = NSTextAlignmentCenter;
    UIButton * finishBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 60.f, 0.f, 60.f, 30.f)];
    [titleView addSubview:finishBtn];
    [finishBtn addTarget:self action:@selector(finishBtn) forControlEvents:UIControlEventTouchUpInside];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    finishBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [finishBtn setTitleColor:UIColorFromRGB(0x2faaf7) forState:UIControlStateNormal];
    //隐藏选择器
    _limitView.hidden =YES;
    _limitPickArr = @[@"1年",@"2年",@"3年",@"4年",@"5年",@"10年",@"20年",@"25年",@"30年"];
    [_limitPickView selectRow:4 inComponent:0 animated:YES];
}
-(void)ratePickViewUI{
    _rateView = [[UIView alloc]initWithFrame:CGRectMake(0.f, SCREEN_HEIGHT - 250.f, SCREEN_WIDTH,180.f)];
    [self.view addSubview:_rateView];
    _rateView.backgroundColor = [UIColor whiteColor];
    _ratePickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0.f, 30.f, SCREEN_WIDTH, 150.f)];
    _ratePickView.delegate = self;
    _ratePickView.dataSource = self;
    _ratePickView.tag = 1;
    _ratePickView.backgroundColor = [UIColor whiteColor];
    [_rateView addSubview:_ratePickView];
    UIView * titleView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, 30.f)];
    [_rateView addSubview:titleView];
    titleView.backgroundColor = UIColorFromRGB(0xeaeaea);
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 -50.f, 0.f, 100.f, 30.f)];
    [_rateView addSubview:titleLabel];
    titleLabel.text = @"商贷利率";
    titleLabel.font = [UIFont systemFontOfSize:14];
    //居中
    titleLabel.textAlignment = NSTextAlignmentCenter;
    UIButton * finishBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 60.f, 0.f, 60.f, 30.f)];
    [titleView addSubview:finishBtn];
    [finishBtn addTarget:self action:@selector(finishBtn) forControlEvents:UIControlEventTouchUpInside];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    finishBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [finishBtn setTitleColor:UIColorFromRGB(0x2faaf7) forState:UIControlStateNormal];
    //隐藏选择器
    _rateView.hidden =YES;
    _ratePickArr = @[@"85折",@"9折",@"95折",@"基本利率",@"1.1倍",@"1.2倍",@"1.3倍",@"1.4倍",@"1.5倍"];
    [_ratePickView selectRow:3 inComponent:0 animated:YES];
}
-(void)limitBtn{
    [self.view endEditing:YES];
    _limitView.hidden = NO;
    _resultBtn.hidden = YES;
    _rateView.hidden =YES;
}
-(void)limitBtnTwo{
    [self.view endEditing:YES];
    _limitView.hidden = NO;
    _resultBtn.hidden = YES;
    _rateView.hidden =YES;
}
-(void)rateBtn{
    [self.view endEditing:YES];
    _limitView.hidden = YES;
    _resultBtn.hidden = YES;
    _rateView.hidden =NO;
}
-(void)limitBtnThree{
    [self.view endEditing:YES];
    _limitView.hidden = NO;
    _resultBtn.hidden = YES;
    _rateView.hidden =YES;
}
-(void)rateBtnThree{
    [self.view endEditing:YES];
    _limitView.hidden = YES;
    _resultBtn.hidden = YES;
    _rateView.hidden =NO;
}
-(void)finishBtn{
    _limitView.hidden =YES;
    _resultBtn.hidden = NO;
    _rateView.hidden =YES;
}
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

//计算结果
-(void)resultBtn{
    //商业贷款
    if (!_housView_1.hidden) {
       //等额本息
        NSInteger  moneyNum = [_MoneyField.text intValue] * 10000;
        NSInteger  limitNum = [[_limitLabel.text substringToIndex:[_limitLabel.text length] - 1]integerValue] * 12;
        NSArray * rataArr = @[@"0.85",@"0.9",@"0.95",@"1",@"1.1",@"1.2",@"1.3",@"1.4",@"1.5"];
        NSInteger count = 0;
       for (NSString * str in _ratePickArr) {
           if ([_rateLabel.text isEqualToString:str]) {
               break;
            }
           count ++;
       }
        CGFloat num_1 = [[NSString stringWithFormat:@"%.2f", ((moneyNum * ([rataArr[count] floatValue]/12 * 0.049) * (pow((1 + ([rataArr[count] floatValue]/12 * 0.049)), limitNum )))/(pow((1 + ([rataArr[count] floatValue]/12 * 0.049)), limitNum) - 1))] floatValue];
        CGFloat num_2 = [[NSString stringWithFormat:@"%.2f", (limitNum * moneyNum * ([rataArr[count] floatValue]/12 * 0.049) * pow((1 + ([rataArr[count] floatValue]/12 * 0.049)), limitNum) - pow((1 + ([rataArr[count] floatValue]/12 * 0.049)), limitNum))/(pow((1 + ([rataArr[count] floatValue]/12 * 0.049)), limitNum) - 1)]floatValue] - moneyNum;
        CGFloat num_3 = [[NSString stringWithFormat:@"%.2f", moneyNum + num_2]floatValue];
        NSArray * arr_1 =[NSArray arrayWithObjects:[NSString stringWithFormat:@"%.2f元",num_1],[NSString stringWithFormat:@"%.2f元",num_2],[NSString stringWithFormat:@"%.2f元",num_3],[NSString stringWithFormat:@"%@万",_MoneyField.text],[NSString stringWithFormat:@"%@",_limitLabel.text],nil];
        //等额本金
        CGFloat firstInterest = 0.0;
        for (int i = 0; i< limitNum; i++) {
            if (i == 0) {
               firstInterest = moneyNum * ([rataArr[count] floatValue]/12 * 0.049);
            }
        }
        CGFloat gradeNum_1 = moneyNum/limitNum + firstInterest;//首月还款
        CGFloat gradeNum_2 = moneyNum/limitNum * ([rataArr[count] floatValue]/12 * 0.049);//每月递减
        CGFloat gradeNum_3 = (limitNum + 1) * moneyNum * ([rataArr[count] floatValue]/12 * 0.049)/2;//总利息
        CGFloat gradeNum_4 = gradeNum_3 + moneyNum;//本息总和
        NSArray * arr_2 = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%.2f元",gradeNum_1],[NSString stringWithFormat:@"%.2f元",gradeNum_2],[NSString stringWithFormat:@"%.2f元",gradeNum_3],[NSString stringWithFormat:@"%.2f元",gradeNum_4],[NSString stringWithFormat:@"%@万",_MoneyField.text],[NSString stringWithFormat:@"%@",_limitLabel.text], nil];
        if(![self isPureInt:_MoneyField.text]){
            [MBProgressHUD showErrorWithStatus:@"输入金额有误" toView:self.view];
            return;
        }
        if (_MoneyField.text.length > 0) {
            HousDetailsViewController * details =[[HousDetailsViewController alloc]init];
            details.arr_1 = arr_1;
            details.arr_2 = arr_2;
            [self.navigationController pushViewController:details animated:YES];
        }
        
    }else if (!_housView_2.hidden){
        //公积金
        //等额本息
        NSInteger  moneyNum = [_MoneyFieldTWo.text intValue] * 10000;
        NSInteger  limitNum = [[_limitLabel.text substringToIndex:[_limitLabel.text length] - 1]integerValue] * 12;
        CGFloat  rataNum = [[NSString stringWithFormat:@"%.6f",_rataNum/12]floatValue];
        CGFloat num_1 = [[NSString stringWithFormat:@"%.2f", ((moneyNum * rataNum * (pow((1 + rataNum), limitNum )))/(pow((1 + rataNum), limitNum) - 1))] floatValue];
        CGFloat num_2 = [[NSString stringWithFormat:@"%.2f", (limitNum * moneyNum * rataNum * pow((1 + rataNum), limitNum) - pow((1 + rataNum), limitNum))/(pow((1 + rataNum), limitNum) - 1)]floatValue] - moneyNum;
        CGFloat num_3 = [[NSString stringWithFormat:@"%.2f", moneyNum + num_2]floatValue];
        NSArray * arr_1 =[NSArray arrayWithObjects:[NSString stringWithFormat:@"%.2f元",num_1],[NSString stringWithFormat:@"%.2f元",num_2],[NSString stringWithFormat:@"%.2f元",num_3],[NSString stringWithFormat:@"%@万",_MoneyFieldTWo.text],[NSString stringWithFormat:@"%@",_limitLabel.text],nil];
        //等额本金
        CGFloat firstInterest = 0.0;
        for (int i = 0; i< limitNum; i++) {
            if (i == 0) {
                firstInterest = moneyNum * rataNum;
            }
        }
        CGFloat gradeNum_1 = moneyNum/limitNum + firstInterest;//首月还款
        CGFloat gradeNum_2 = moneyNum/limitNum * rataNum;//每月递减
        CGFloat gradeNum_3 = (limitNum + 1) * moneyNum * rataNum/2;//总利息
        CGFloat gradeNum_4 = gradeNum_3 + moneyNum;//本息总和
        NSArray * arr_2 = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%.2f元",gradeNum_1],[NSString stringWithFormat:@"%.2f元",gradeNum_2],[NSString stringWithFormat:@"%.2f元",gradeNum_3],[NSString stringWithFormat:@"%.2f元",gradeNum_4],[NSString stringWithFormat:@"%@万",_MoneyFieldTWo.text],[NSString stringWithFormat:@"%@",_limitLabel.text], nil];
        if(![self isPureInt:_MoneyFieldTWo.text]){
            [MBProgressHUD showErrorWithStatus:@"输入金额有误" toView:self.view];
            return;
        }
        if (_MoneyFieldTWo.text.length > 0) {
            HousDetailsViewController * details =[[HousDetailsViewController alloc]init];
            details.arr_1 = arr_1;
            details.arr_2 = arr_2;
            [self.navigationController pushViewController:details animated:YES];
        }
    
    }else if (!_housView_3.hidden){

        //组合贷款
        //公积金
        //等额本息
        NSInteger  moneyNum = [_MoneyFieldThree.text intValue] * 10000;
        NSInteger  limitNum = [[_limitLabel.text substringToIndex:[_limitLabel.text length] - 1]integerValue] * 12;
        CGFloat  rataNum = [[NSString stringWithFormat:@"%.6f",_rataNum/12]floatValue];
        CGFloat num_1 = [[NSString stringWithFormat:@"%.2f", ((moneyNum * rataNum * (pow((1 + rataNum), limitNum )))/(pow((1 + rataNum), limitNum) - 1))] floatValue];
        CGFloat num_2 = [[NSString stringWithFormat:@"%.2f", (limitNum * moneyNum * rataNum * pow((1 + rataNum), limitNum) - pow((1 + rataNum), limitNum))/(pow((1 + rataNum), limitNum) - 1)]floatValue] - moneyNum;
        CGFloat num_3 = [[NSString stringWithFormat:@"%.2f", moneyNum + num_2]floatValue];
        //等额本金
        CGFloat firstInterest = 0.0;
        for (int i = 0; i< limitNum; i++) {
            if (i == 0) {
                firstInterest = moneyNum * rataNum;
            }
        }
        CGFloat gradeNum_1 = moneyNum/limitNum + firstInterest;//首月还款
        CGFloat gradeNum_2 = moneyNum/limitNum * rataNum;//每月递减
        CGFloat gradeNum_3 = (limitNum + 1) * moneyNum * rataNum/2;//总利息
        CGFloat gradeNum_4 = gradeNum_3 + moneyNum;//本息总和
        //商贷
            //等额本息
            NSInteger  LMoneyNum = [_MoneyFieldFour.text intValue] * 10000;
            NSInteger  LLimitNum = [[_limitLabel.text substringToIndex:[_limitLabel.text length] - 1]integerValue] * 12;
            NSArray * LRataArr = @[@"0.85",@"0.9",@"0.95",@"1",@"1.1",@"1.2",@"1.3",@"1.4",@"1.5"];
            NSInteger LCount = 0;
            for (NSString * str in _ratePickArr) {
                if ([_rateLabel.text isEqualToString:str]) {
                    break;
                }
                LCount ++;
            }
            CGFloat  LRataNum = [[NSString stringWithFormat:@"%.6f",[LRataArr[LCount] floatValue]/12 * 0.049]floatValue];
            CGFloat num_4 = [[NSString stringWithFormat:@"%.2f", ((LMoneyNum * LRataNum * (pow((1 + LRataNum), LLimitNum )))/(pow((1 + LRataNum), LLimitNum) - 1))] floatValue];
            CGFloat num_5 = [[NSString stringWithFormat:@"%.2f", (LLimitNum * LMoneyNum * LRataNum * pow((1 + LRataNum), LLimitNum) - pow((1 + LRataNum), LLimitNum))/(pow((1 + LRataNum), LLimitNum) - 1)]floatValue] - LMoneyNum;
            CGFloat num_6 = [[NSString stringWithFormat:@"%.2f", LMoneyNum + num_5]floatValue];
            //等额本金
            CGFloat LFirstInterest = 0.0;
            for (int i = 0; i< LLimitNum; i++) {
                if (i == 0) {
                    LFirstInterest = LMoneyNum * LRataNum;
                }
            }
            CGFloat gradeNum_5 = LMoneyNum/LLimitNum + LFirstInterest;//首月还款
            CGFloat gradeNum_6 = LMoneyNum/LLimitNum * LRataNum;//每月递减
            CGFloat gradeNum_7 = (LLimitNum + 1) * LMoneyNum * LRataNum/2;//总利息
            CGFloat gradeNum_8 = gradeNum_7 + LMoneyNum;//本息总和
        NSArray * arr_1 =[NSArray arrayWithObjects:[NSString stringWithFormat:@"%.2f元",num_1 + num_4],[NSString stringWithFormat:@"%.2f元",num_2 + num_5],[NSString stringWithFormat:@"%.2f元",num_3 + num_6],[NSString stringWithFormat:@"%ld万",(long)(moneyNum + LMoneyNum)/10000],[NSString stringWithFormat:@"%@",_limitLabel.text],nil];
            NSArray * arr_2 = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%.2f元",gradeNum_1 + gradeNum_5],[NSString stringWithFormat:@"%.2f元",gradeNum_2 + gradeNum_6],[NSString stringWithFormat:@"%.2f元",gradeNum_3 + gradeNum_7],[NSString stringWithFormat:@"%.2f元",gradeNum_4 + gradeNum_8],[NSString stringWithFormat:@"%ld万",(long)(moneyNum + LMoneyNum)/10000],[NSString stringWithFormat:@"%@",_limitLabel.text], nil];
        if(![self isPureInt:_MoneyFieldThree.text]){
            [MBProgressHUD showErrorWithStatus:@"输入金额有误" toView:self.view];
            return;
        }
        if(![self isPureInt:_MoneyFieldFour.text]){
            [MBProgressHUD showErrorWithStatus:@"输入金额有误" toView:self.view];
            return;
        }
        if (_MoneyFieldThree.text.length > 0 && _MoneyFieldFour.text.length > 0) {
            HousDetailsViewController * details =[[HousDetailsViewController alloc]init];
            details.arr_1 = arr_1;
            details.arr_2 = arr_2;
            [self.navigationController pushViewController:details animated:YES];
        }
    }
}
-(void)housBtn:(UIButton *)sender{
     //点击其他button之后这里设置为非选中状态，否则会出现2个同色的选中状态
    ((UIButton *)btnArr[0]).selected = NO;
    if (sender != _housBtn){
        _housBtn.selected = NO;
        _housBtn = sender;
    }
    _housBtn.selected = YES;
    if(sender.tag == 0){
        _housView_1.hidden = NO;
        _housView_2.hidden = YES;
        _housView_3.hidden = YES;
        _TSLabel.frame = CGRectMake(10, CGRectGetMaxY(_housView_1.frame), SCREEN_WIDTH - 20, 20);
        
    }if(sender.tag == 1){
        _housView_2.hidden = NO;
        _housView_1.hidden = YES;
        _housView_3.hidden = YES;
        _TSLabel.frame = CGRectMake(10, CGRectGetMaxY(_housView_2.frame), SCREEN_WIDTH - 20, 20);
        
    }if(sender.tag == 2){
        _housView_3.hidden = NO;
        _housView_2.hidden = YES;
        _housView_1.hidden = YES;
        _TSLabel.frame = CGRectMake(10, CGRectGetMaxY(_housView_3.frame), SCREEN_WIDTH - 20, 20);
    }
}
#pragma mark - Picker View Data source
//列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
//行
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView.tag == 0) {
        return _limitPickArr.count;
    }else {
        return _ratePickArr.count;
    }
}
//返回row高度
-(CGFloat) pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.f;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.font = [UIFont systemFontOfSize:15];
    }
    pickerLabel.textAlignment = NSTextAlignmentCenter;
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}
#pragma mark- Picker View Delegate
//选中行触发事件
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView.tag == 0) {
        _limitLabel.text = [_limitPickArr objectAtIndex:row];
        _limitLabelTwo.text = [_limitPickArr objectAtIndex:row];
        _limitLabelThree.text = [_limitPickArr objectAtIndex:row];
    }else{
        _rateLabel.text = [_ratePickArr objectAtIndex:row];
        _rateLabelThree.text = [_ratePickArr objectAtIndex:row];
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView.tag == 0) {
        return [_limitPickArr objectAtIndex:row];
    }else{
        return [_ratePickArr objectAtIndex:row];
    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
