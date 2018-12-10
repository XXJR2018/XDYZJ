//
//  JYJAnimateViewController.m
//  JYJSlideMenuController
//
//  Created by JYJ on 2017/6/16.
//  Copyright © 2017年 baobeikeji. All rights reserved.
//

#import "JYJAnimateViewController.h"
#import "FilterOrderVC.h"
#import "FilerBussinessVC.h"


static CGFloat const animationTime = 0.2;

@interface JYJAnimateViewController ()
/** bgView */
@property (nonatomic, weak) UIView *bgView;
/** leftVc */
@property (nonatomic, weak) UIViewController *leftVc;
/** hasShow */
@property (nonatomic, assign) BOOL hasShow;
@end

@implementation JYJAnimateViewController



- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)showAnimation {
    self.view.userInteractionEnabled = NO;
    // 根据当前x，计算隐藏时间
    CGFloat time = fabs(self.leftVc.view.frame.origin.x / self.leftVc.view.frame.size.width) * animationTime;
    [UIView animateWithDuration:time animations:^{
        
        // 左侧界面
        //self.leftVc.view.frame = CGRectMake(0, 0, self.leftVc.view.frame.size.width, [UIScreen mainScreen].bounds.size.height);
        
        
        // 右侧界面
        self.leftVc.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - self.leftVc.view.frame.size.width, 0, self.leftVc.view.frame.size.width, [UIScreen mainScreen].bounds.size.height);
        
        self.bgView.alpha = 0.5;
    } completion:^(BOOL finished) {
        self.view.userInteractionEnabled = YES;
    }];
}

- (void)closeAnimation {
    self.view.userInteractionEnabled = NO;
    // 根据当前x，计算隐藏时间
    CGFloat time = (1 - fabs(self.leftVc.view.frame.origin.x / self.leftVc.view.frame.size.width)) * animationTime;
    [UIView animateWithDuration:time animations:^{
        
        // 左侧view 消失
        //self.leftVc.view.frame = CGRectMake(-self.leftVc.view.frame.size.width, 0, self.leftVc.view.frame.size.width, [UIScreen mainScreen].bounds.size.height);
        
        // 右侧view 消失
        self.leftVc.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width +  self.leftVc.view.frame.size.width, 0, self.leftVc.view.frame.size.width, [UIScreen mainScreen].bounds.size.height);
        
        self.bgView.alpha = 0.0;
    } completion:^(BOOL finished) {
        // 隐藏个人中心
        [self removeFromParentViewController];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    // 半透明的view
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.frame = [UIScreen mainScreen].bounds;
    bgView.alpha = 0;
    [self.view addSubview:bgView];
    self.bgView = bgView;
    
    
    // 筛选条件关闭通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeSideBar) name:CLOSE_SIDE_VIEW object:nil];
    
    
    // 添加两个手势
    UITapGestureRecognizer *tapGestureRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSideBar)];
    [bgView addGestureRecognizer:tapGestureRec];
   
    // 屏蔽掉脱拽手势
//    UIPanGestureRecognizer *panGestureRec = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveViewWithGesture:)];
//    [self.view addGestureRecognizer:panGestureRec];
    
    if (1 == _pageType)
     {
        // 添加控制器
        FilterOrderVC *leftVc = [[FilterOrderVC alloc] init];
        leftVc.borrowType = _borrowType;
        //UIViewController *leftVc = [[UIViewController alloc] init];
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width - 50;
        if ([UIScreen mainScreen].bounds.size.width > 375) {
            width -= 50;
        } else if ([UIScreen mainScreen].bounds.size.width > 320) {
            width = width - 25;
        }
        
        // 左侧view
        //leftVc.view.frame = CGRectMake(-width, 0, width, [UIScreen mainScreen].bounds.size.height);
        
        // 右侧view
        leftVc.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width + width, 0, width, [UIScreen mainScreen].bounds.size.height);
        
        [self.view addSubview:leftVc.view];
        [self addChildViewController:leftVc];
        self.leftVc = leftVc;
     }
    else if (2 == _pageType)
     {
        // 添加控制器
        FilerBussinessVC *leftVc = [[FilerBussinessVC alloc] init];
        leftVc.bussinessType = _bussinessType;
        //UIViewController *leftVc = [[UIViewController alloc] init];
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width - 50;
        if ([UIScreen mainScreen].bounds.size.width > 375) {
            width -= 50;
        } else if ([UIScreen mainScreen].bounds.size.width > 320) {
            width = width - 25;
        }
        
        // 左侧view
        //leftVc.view.frame = CGRectMake(-width, 0, width, [UIScreen mainScreen].bounds.size.height);
        
        // 右侧view
        leftVc.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width + width, 0, width, [UIScreen mainScreen].bounds.size.height);
        
        [self.view addSubview:leftVc.view];
        [self addChildViewController:leftVc];
        self.leftVc = leftVc;
        
        leftVc.popBlock = ^(id obj) {
            
            if (_popBlock)
             {
                _popBlock(obj);
             }
        };
     }

    
    
    // 展示
    [self showAnimation];

}

/**
 * 点击手势
 */
- (void)closeSideBar {
    [self closeAnimation];
}

/**
 * 拖拽手势
 */
- (void)moveViewWithGesture:(UIPanGestureRecognizer *)panGes {
    // 下面是计算
    // 结束位置
    static CGFloat lastX;
    // 改变多少
    static CGFloat durationX;
    CGPoint touchPoint = [panGes locationInView:[[UIApplication sharedApplication] keyWindow]];
    // 手势开始
    if (panGes.state == UIGestureRecognizerStateBegan) {
        lastX = touchPoint.x;
    }
    // 手势改变
    if (panGes.state == UIGestureRecognizerStateChanged) {
        CGFloat currentX = touchPoint.x;
        // 改变的距离
        durationX = currentX - lastX;
        lastX = currentX;
        // 左边控制器的frame
        CGFloat leftVcX = durationX + self.leftVc.view.frame.origin.x;
        // 如果控制器的x小于宽度直接返回
        if (leftVcX <= -self.leftVc.view.frame.size.width) {
            leftVcX = -self.leftVc.view.frame.size.width;
        }
        // 如果控制器的x大于0直接返回
        if (leftVcX >= 0) {
            leftVcX = 0;
        }
        // 计算bgView的透明度
        self.bgView.alpha = (1 + leftVcX / self.leftVc.view.frame.size.width) * 0.5;
        // 设置左边控制器的frame
        [self.leftVc.view setFrame:CGRectMake(leftVcX, 0, self.leftVc.view.frame.size.width, self.leftVc.view.frame.size.height)];
        //        NSLog(@"%f", self.leftVc.view.frame.origin.x);
    }
    // 手势结束
    if (panGes.state == UIGestureRecognizerStateEnded) {
        // 结束为止超时屏幕一半
        if (self.leftVc.view.frame.origin.x > - self.leftVc.view.frame.size.width + [UIScreen mainScreen].bounds.size.width / 2) {
            [self showAnimation];
        } else {
            [self closeAnimation];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
