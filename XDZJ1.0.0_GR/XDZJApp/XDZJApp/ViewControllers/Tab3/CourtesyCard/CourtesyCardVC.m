//
//  CourtesyCardVC.m
//  XXJR
//
//  Created by xxjr02 on 2017/10/30.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import "CourtesyCardVC.h"
#import "CourtesyCardList1.h"
#import "CourtesyCardList2.h"
#import "CourtesyCardList3.h"
#import "CourtesyCardList4.h"
#import "ExchangeVC.h"
#import "CCWebViewController.h"



@interface CourtesyCardVC ()
{
    
}


@property (nonatomic, strong)  UIButton *firstButton;
@property (nonatomic, strong)  UIButton *secondButton;
@property (nonatomic, strong)  UIButton *thridButton;
@property (nonatomic, strong)  UIButton *fourthButton;

@property (nonatomic ,strong) CourtesyCardList1  *firstVC;
@property (nonatomic ,strong) CourtesyCardList2 *secondVC; 
@property (nonatomic ,strong) CourtesyCardList3 *thridVC;
@property (nonatomic ,strong) CourtesyCardList4 *fourhVC;

@property (nonatomic ,strong) UIViewController *currentVC;

@end



@implementation CourtesyCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CustomNavigationBarView *nav = [self layoutWhiteNaviBarViewWithTitle:@"我的卡包"];
    
    float fRightBtnTopY =  NavHeight - 40;
    if (IS_IPHONE_X_MORE)
     {
        fRightBtnTopY = NavHeight - 42;
     }
    
    UIButton *rightNavBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 90.f,fRightBtnTopY,90.f, 35.0f)];
    [rightNavBtn setTitle:@" 使用说明" forState:UIControlStateNormal];
    [rightNavBtn setTitleColor:[ResourceManager navgationTitleColor] forState:UIControlStateNormal];
    [rightNavBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [rightNavBtn addTarget:self action:@selector(actionDH) forControlEvents:UIControlEventTouchUpInside];
    rightNavBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [nav addSubview:rightNavBtn];
    
    [rightNavBtn setImage:[UIImage imageNamed:@"card_sysm"] forState:UIControlStateNormal];
    
    [self layoutHead];
    
    [self initChildrenViewControllers];
}

-(void) actionDH
{
    //ExchangeVC *vc = [[ExchangeVC alloc] init];
    //[self.navigationController pushViewController:vc animated:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@xxapp/lend/coupon/explain2.html", [PDAPI WXSysRouteAPI]];
    [CCWebViewController showWithContro:self withUrlStr:url withTitle:@"使用说明"];
}

-(void )viewWillAppear:(BOOL)animated
{
    
    if (self.currentVC != self.firstVC) {
        _firstButton.selected = YES;
        _secondButton.selected = NO;
        _thridButton.selected = NO;
        _fourthButton.selected = NO;
        [self replaceController:self.currentVC newController:self.firstVC];
    }
    
    [self loadData];
    [_firstVC reloadData];
}

-(void) loadData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    
//     DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],@"xxcust/account/coupon/queryCouponCount"]
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],kDDGqueryTicketNum]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    
    
    operation.tag = 10210;
    [operation start];
}

/*
 * 请求成功 ，做数据处理
 **/
-(void)handleData:(DDGAFHTTPRequestOperation *)operation
{
    if (10210 == operation.tag )
     {
        NSDictionary *dicAttr = operation.jsonResult.attr;
        if ([dicAttr count] >0)
         {
//            返回参数：
//            'unActiveCount', 未激活的
//            'unUseCount', 未使用的
//            'usedCount',  已使用的
//            'invalidCount' 无效的
            NSString *strTemp = [NSString stringWithFormat:@"未使用(%d)", [dicAttr[@"unUsedStatus"] intValue]];
            [_firstButton setTitle:strTemp forState:UIControlStateNormal];
            
            strTemp = [NSString stringWithFormat:@"未激活(%d)", [dicAttr[@"unActiveCount"] intValue]];
            [_secondButton setTitle:strTemp forState:UIControlStateNormal];
            
            strTemp = [NSString stringWithFormat:@"已使用(%d)", [dicAttr[@"usedStatus"] intValue]];
            [_thridButton setTitle:strTemp forState:UIControlStateNormal];
            
            strTemp = [NSString stringWithFormat:@"已过期(%d)", [dicAttr[@"pastStatus"] intValue]];
            [_fourthButton setTitle:strTemp forState:UIControlStateNormal];

            
         }
    }
}

-(void) layoutHead
{
    int iBtnHeight = 40;
    _firstButton = [[UIButton alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH/3, iBtnHeight)];
    [_firstButton setTitle:@"未使用(0)" forState:UIControlStateNormal];
    _firstButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_firstButton setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
    [_firstButton setTitleColor:[ResourceManager mainColor] forState:UIControlStateSelected];
    _firstButton.backgroundColor = [UIColor whiteColor];
    [_firstButton addTarget:self action:@selector(firstVCClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_firstButton];
    
    // 分割线1
    UIView * viewX_1 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3-1, 5, 1, iBtnHeight - 2*5)];
    viewX_1.backgroundColor = [ResourceManager color_5];
    [_firstButton addSubview:viewX_1];
    
    
    
//    _secondButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4, NavHeight, SCREEN_WIDTH/4, iBtnHeight)];
//    [_secondButton setTitle:@"未激活(0)" forState:UIControlStateNormal];
//    _secondButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    [_secondButton setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
//    [_secondButton setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
//    _secondButton.backgroundColor = [UIColor whiteColor];
//    [_secondButton addTarget:self action:@selector(secondVCClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_secondButton];
    
    
    
    // 分割线2
    UIView * viewX_2 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3-1, 5, 1, iBtnHeight - 2*5)];
    viewX_2.backgroundColor = [ResourceManager color_5];
    [_secondButton addSubview:viewX_2];
    
    
    _thridButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3, NavHeight, SCREEN_WIDTH/3, iBtnHeight)];
    [_thridButton setTitle:@"已使用(0)" forState:UIControlStateNormal];
    _thridButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_thridButton setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
    [_thridButton setTitleColor:[ResourceManager mainColor] forState:UIControlStateSelected];
    _thridButton.backgroundColor = [UIColor whiteColor];
    [_thridButton addTarget:self action:@selector(thridVCClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_thridButton];
    
    
    // 分割线3
    UIView * viewX_3 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3-1, 5, 1, iBtnHeight - 2*5)];
    viewX_3.backgroundColor = [ResourceManager color_5];
    [_thridButton addSubview:viewX_3];
    
    _fourthButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*2/3, NavHeight, SCREEN_WIDTH/3, iBtnHeight)];
    [_fourthButton setTitle:@"已过期(0)" forState:UIControlStateNormal];
    _fourthButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_fourthButton setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
    [_fourthButton setTitleColor:[ResourceManager mainColor] forState:UIControlStateSelected];
    _fourthButton.backgroundColor = [UIColor whiteColor];
    [_fourthButton addTarget:self action:@selector(fourthVCClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_fourthButton];
}


-(void)initChildrenViewControllers{
    
    if (self.firstVC == nil ||
        self.secondVC == nil ||
        self.thridVC == nil){
        
        int iHeadHeight = 101;
        // 对于iPhoneX 适配
        if (IS_IPHONE_X_MORE)
         {
            iHeadHeight += 30;
         }
        
        self.firstVC = [[CourtesyCardList1 alloc] init];
        [self.firstVC.view setFrame:CGRectMake(0, iHeadHeight, SCREEN_WIDTH, SCREEN_HEIGHT - iHeadHeight)];
        [self addChildViewController:_firstVC];// 必须加入此句，表示加入 ChildViewController
        
        self.secondVC = [[CourtesyCardList2 alloc] init];
        [self.secondVC.view setFrame:CGRectMake(0, iHeadHeight, self.view.frame.size.width, self.view.frame.size.height - iHeadHeight)];

        
        self.thridVC = [[CourtesyCardList3 alloc] init];
        [self.thridVC.view setFrame:CGRectMake(0, iHeadHeight, SCREEN_WIDTH, SCREEN_HEIGHT - iHeadHeight)];
        
        self.fourhVC = [[CourtesyCardList4 alloc] init];
        [self.fourhVC.view setFrame:CGRectMake(0, iHeadHeight, SCREEN_WIDTH, SCREEN_HEIGHT - iHeadHeight)];
        
        //  默认,第一个视图(你会发现,全程就这一个用了addSubview)
        [self.view addSubview:self.firstVC.view];
        self.currentVC = self.firstVC;
        
        _firstButton.selected = YES;
        _secondButton.selected = NO;
        _thridButton.selected = NO;
    }
}




- (IBAction)firstVCClick:(id)sender {
    if (_firstButton.selected) {
        return;
    }
    
    if (self.currentVC != self.firstVC) {
        _firstButton.selected = YES;
        _secondButton.selected = NO;
        _thridButton.selected = NO;
        _fourthButton.selected = NO;
        [self replaceController:self.currentVC newController:self.firstVC];
    }
}

- (IBAction)secondVCClick:(id)sender {
    if (_secondButton.selected) {
        return;
    }
    
    if (self.currentVC != self.secondVC) {
        _firstButton.selected = NO;
        _secondButton.selected = YES;
        _thridButton.selected = NO;
        _fourthButton.selected = NO;
        [self replaceController:self.currentVC newController:self.secondVC];
    }
}

- (IBAction)thridVCClick:(id)sender {
    if (_thridButton.selected) {
        return;
    }
    
    if (self.currentVC != self.thridVC) {
        _firstButton.selected = NO;
        _secondButton.selected = NO;
        _thridButton.selected = YES;
        _fourthButton.selected = NO;
        [self replaceController:self.currentVC newController:self.thridVC];
    }
    
}

- (IBAction)fourthVCClick:(id)sender {
    if (_fourthButton.selected) {
        return;
    }
    
    if (self.currentVC != self.fourhVC) {
        _firstButton.selected = NO;
        _secondButton.selected = NO;
        _thridButton.selected = NO;
        _fourthButton.selected = YES;
        [self replaceController:self.currentVC newController:self.fourhVC];
    }
    
}

//  切换各个标签内容
- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController
{
    /**
     *            着重介绍一下它
     *  transitionFromViewController:toViewController:duration:options:animations:completion:
     *  fromViewController      当前显示在父视图控制器中的子视图控制器
     *  toViewController        将要显示的姿势图控制器
     *  duration                动画时间(这个属性,old friend 了 O(∩_∩)O)
     *  options                 动画效果(渐变,从下往上等等,具体查看API)
     *  animations              转换过程中得动画
     *  completion              转换完成
     */
    
    @try{
        [self addChildViewController:newController];
        [self transitionFromViewController:oldController toViewController:newController duration:0.1 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
            
            if (finished) {
                [newController didMoveToParentViewController:self];
                [oldController willMoveToParentViewController:nil];
                [oldController removeFromParentViewController];
                self.currentVC = newController;
            }else{
                self.currentVC = oldController;
            }
        }];
    }
    @catch(NSException *exception) {
        NSLog(@"exception:%@", exception);
    }
    @finally {
        
    }
    

}


@end
