//
//  LightntingFreeCtl.m
//  XXJR
//
//  Created by xxjr02 on 2018/3/26.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import "LightntingFreeCtl.h"
#import "LightningFreeNotTimeVC.h"
#import "LightntingFreeList.h"
#import "SKAutoScrollLabel.h"

#import "VIPViewController.h"
#import "PopAndSelectView.h"
//#import "LightnigLendCtl.h"
//#import "LigthingGoodCtl.h"

@interface LightntingFreeCtl ()
{
    SKAutoScrollLabel *paoma;
    
    int  iNextMonth;
    int  iNextDay;
    int  iNextHour;
    
    int freeFlag;  // 1 倒计时， 2 可抢单  ， 3 等待状态  （4， 5，也是等待状态）
}

@property (nonatomic ,strong) LightningFreeNotTimeVC  *firstVC;
@property (nonatomic ,strong) LightntingFreeList *secondVC;
@property (nonatomic ,strong) UIViewController *currentVC;

@end

@implementation LightntingFreeCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CustomNavigationBarView *nav = [self layoutNaviBarViewWithTitle:@"免费抢单"];
    
    // 加入中间的弹出选择页面 按钮
    int iViewXLLeftX = nav.titleLab.width/2 + 35;
    UIImageView *viewXL = [[UIImageView alloc] initWithFrame:CGRectMake(iViewXLLeftX, 15, 15, 7)];
    [nav.titleLab addSubview:viewXL];
    viewXL.image = [UIImage imageNamed:@"com_nav_xl"];
    
//    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionNavSel)];
//    nav.titleLab.userInteractionEnabled = YES;
//    [nav.titleLab addGestureRecognizer:labelTapGestureRecognizer];
    
    [self getSystemTimeFromWeb];
    
    //[self layoutPLabelViewWithTitle];
    
    [self initPage];
    
    // 首页切换到别的页面的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchPage:) name:FreeGrabSwitchNotification object:nil];
    
    

}

-(void) viewWillAppear:(BOOL)animated
{
    [MobClick beginLogPageView:@"免费抢单——首页"];
    paoma.text = @"会员每天都可以参与免费抢单，非会员只有3次机会。";
}

-(void) viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"免费抢单——首页"];
}

-(void)layoutPLabelViewWithTitle
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, NavHeight, self.view.frame.size.width, 30)];
    bgView.backgroundColor = UIColorFromRGB(0xFDF9EC);
    bgView.clipsToBounds = YES;
    [self.view addSubview:bgView];
    

    
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
    paoma.backgroundColor = UIColorFromRGB(0xFDF9EC);
    paoma.font = [UIFont systemFontOfSize:13];
    paoma.textColor = UIColorFromRGB(0x774311);
    paoma.text = @"  会员每天都可以参与免费抢单，非会员只有3次机会。";
    
    


    
    UIButton *btnDH = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 70, 5, 60, 20)];
    [bgView addSubview:btnDH];
    [btnDH setTitle:@"成为会员" forState:UIControlStateNormal];
    [btnDH setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    btnDH.titleLabel.font = [UIFont systemFontOfSize:14];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"成为会员"];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [btnDH setAttributedTitle:str forState:UIControlStateNormal];
    [btnDH addTarget:self action:@selector(acionVip) forControlEvents:UIControlEventTouchUpInside];
    
    
    if ( [[[DDGAccountManager sharedManager].userInfo objectForKey:@"isVip"] intValue] == 1) {
        btnDH.hidden = YES;
    }
    
}

-(void) initPage
{
    _firstVC = [[LightningFreeNotTimeVC alloc] init];
    _firstVC.iCDHour = 24;
    _firstVC.iCDMinute = 0;
    _firstVC.iCdSecond = 0;
    [_firstVC.view setFrame:CGRectMake(0, NavHeight, self.view.frame.size.width, self.view.frame.size.height - NavHeight)];
    
    _secondVC = [[LightntingFreeList alloc] init];
    [_secondVC.view setFrame:CGRectMake(0, NavHeight, self.view.frame.size.width, self.view.frame.size.height - NavHeight)];
 
    
    //  默认,第一个视图(你会发现,全程就这一个用了addSubview)
    [self.view addSubview:self.firstVC.view];
    [self addChildViewController:_firstVC];
    self.currentVC = self.firstVC;
}


-(void)getSystemTimeFromWeb{
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",[PDAPI getBusiUrlString],KDDGgetSysTime];
    
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:url
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [self handleErrorData:operation];
                                                                                      
                                                                            
                                                                                    
                                                                                      
                                                                                     ;


                                                                                  }];
    operation.tag = 10210;
    
    [operation start];
}

-(void)getSystemTimeFromWeb2{
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",[PDAPI getBusiUrlString],KDDGgetSysTime];
    
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:url
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [self handleErrorData:operation];
                                                                                      
                                                                                      
                                                                                      
                                                                                      
                                                                                      ;
                                                                                      
                                                                                      
                                                                                  }];
    operation.tag = 10211;
    
    [operation start];
}




-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    if (operation.tag == 10210) {
        
        NSDictionary *dicAttr = operation.jsonResult.attr;
        NSLog(@"dicAttr: %@" ,dicAttr);
        

        
        freeFlag = [dicAttr[@"freeFlag"] intValue];  // 1 倒计时， 2 可抢单  ， 3 等待状态  （4， 5，也是等待状态）
        _firstVC.iCDHour =  24;
        _firstVC.iCDMinute = 0;
        _firstVC.iCdSecond = 0;
        
        iNextMonth = [dicAttr[@"month"] intValue];
        iNextDay = [dicAttr[@"day"] intValue];
        iNextHour = [dicAttr[@"freeRobTime"] intValue];
        
        //freeFlag = 2;
        
        if (freeFlag == 1)
         {
            _firstVC.iCDHour =  0;//[dicAttr[@"hour"] intValue];
            _firstVC.iCDMinute = 60- [dicAttr[@"minute"] intValue];
            _firstVC.iCdSecond = 60 - [dicAttr[@"second"] intValue];
            [_firstVC setTimer];
         }else if (freeFlag == 2){
             if ([dicAttr[@"freeNumber"] intValue] == 0) {
                 [_firstVC setNextGrab:0];
                 [_firstVC setNextGrabTime:iNextMonth Day:iNextDay Hour:iNextHour];
                 [self replaceController:self.currentVC newController:_firstVC];
                 return;
             }
             [self replaceController:self.currentVC newController:_secondVC];
         } else if (freeFlag == 3 ||
                    freeFlag == 4 ||
                    freeFlag == 5){
             [_firstVC setNextGrab:100];
             [_firstVC setNextGrabTime:iNextMonth Day:iNextDay Hour:iNextHour];
             [self replaceController:self.currentVC newController:_firstVC];
         }
        
    }
    
    if (operation.tag == 10211) {
        
        NSDictionary *dicAttr = operation.jsonResult.attr;
        NSLog(@"dicAttr: %@" ,dicAttr);
        
        
        iNextMonth = [dicAttr[@"month"] intValue];
        iNextDay = [dicAttr[@"day"] intValue];
        iNextHour = [dicAttr[@"freeRobTime"] intValue];
        
        [_firstVC setNextGrabTime:iNextMonth Day:iNextDay Hour:iNextHour];
    }
}




#pragma mark notification
-(void)switchPage:(NSNotification *)notification
{
    NSLog(@"user info is %@",notification.object);
    
    int status = [[(NSDictionary *)notification.object objectForKey:@"status"] intValue];
    int iListCount = [[(NSDictionary *)notification.object objectForKey:@"listCount"] intValue];
    
    if (status == 1 &&
        iListCount > 0)
     {


        [self replaceController:self.currentVC newController:self.secondVC];
        
     }
    if (status ==1 &&
        iListCount == 0 &&
        freeFlag == 2)
     {

        // 在抢单时间内，但单数为0
        [self.firstVC setNextGrab:0];
        [_firstVC setNextGrabTime:iNextMonth Day:iNextDay Hour:iNextHour];
        [self replaceController:self.currentVC newController:self.firstVC];
        
        [self getSystemTimeFromWeb2];
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
    if (self.currentVC == newController)
     {
        return;
     }
    
    [self addChildViewController:newController];
    [self transitionFromViewController:oldController toViewController:newController duration:0.01 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        
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

#pragma  mark ----- action
-(void)clickNavButton:(UIButton *)button{
    if (self.popParent)
     {
        [self.navigationController popToViewController:self.popParent animated:YES];
        return;
     }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) actionNavSel
{
    NSArray *arry = @[@"优质客户", @"直借客户"];
    PopAndSelectView *pop = [[PopAndSelectView alloc] initWithOrigin_X:0 origin_Y:NavHeight-10 itemArray:arry];
    pop.selectedIndex = -100;
    [self.view addSubview:pop];
    [pop showPickView];
    
    pop.finishedBlock = ^(int index) {
        NSLog(@"finishedBlock:%d" , index);
//        if (0 == index)
//         {
//
//            LigthingGoodCtl *vc = [[LigthingGoodCtl alloc] init];
//            vc.popParent = self.popParent;
//            [self.navigationController pushViewController:vc animated:YES];
//         }
//        else if (1 == index)
//         {
//            LightnigLendCtl *vc = [[LightnigLendCtl alloc] init];
//            vc.popParent = self.popParent;
//            [self.navigationController pushViewController:vc animated:YES];
//         }
    };
    
    return;
}

-(void) acionVip
{
    NSDictionary *dic = [DDGAccountManager sharedManager].userInfo;
    VIPViewController *ctl = [[VIPViewController alloc]init];
    ctl.vipGrade = [[dic objectForKey:@"vipGrade"] integerValue];
    ctl.usableAmount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"usableAmount"]];
    ctl.vipEndDate = [NSString stringWithFormat:@"%@",[dic objectForKey:@"vipEndDate"]];
    ctl.name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"realName"]];
    ctl.imageUrl = [NSString stringWithFormat:@"%@",[dic objectForKey:@"userImage"]];
    [self.navigationController pushViewController:ctl animated:YES];
}


@end
