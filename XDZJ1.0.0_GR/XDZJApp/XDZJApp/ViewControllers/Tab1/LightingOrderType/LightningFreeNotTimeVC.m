//
//  LightningFreeNotTimeVC.m
//  XXJR
//
//  Created by xxjr02 on 2018/3/27.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import "LightningFreeNotTimeVC.h"
//#import "PLabelView.h"
//#import "LightnigLendCtl.h"

@interface LightningFreeNotTimeVC ()
{
    NSTimer *timer;
    
    
    UIImageView *imgTop;

    UIView *viewHideTime;
    
    
    UILabel *labelHour1;
    UILabel *labelHour2;
    UILabel *labelMinute1;
    UILabel *labelMinute2;
    UILabel *labelSecond1;
    UILabel *labelSecond2;
    
    UIButton *btnQD;
    
    __block int iTimeout;
    dispatch_queue_t queue;   // 定时队列
    dispatch_source_t _timer;  //定时器
}
@end

@implementation LightningFreeNotTimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self layoutUI];
}

-(void) layoutUI
{
    
    int iTopY = 50;
    imgTop = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 200)/2 , iTopY, 200, 200)];
    [self.view addSubview:imgTop];
    imgTop.image = [UIImage imageNamed:@"Free_Center3"];

    [self setTimer];
    
    iTopY += imgTop.height + 20;
    [self layoutMidTitle:@"距离免费抢单开始还有" topY:iTopY];
}



-(void) layoutMidTitle:(NSString*)strTitle  topY:(int)iTopY
{

    UIView *viewFuGai = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 200)];
    [self.view addSubview:viewFuGai];
    viewFuGai.backgroundColor = [ResourceManager viewBackgroundColor];
    
    int iWidth = (int)[XXJRUtils getSizeWithString:strTitle withFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20) withFontSize:15].width +5;
    
    int iLabelLeftX = (SCREEN_WIDTH - iWidth) / 2;
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(iLabelLeftX, iTopY, iWidth, 20)];
    [self.view addSubview:labelTitle];
    labelTitle.textColor = [ResourceManager color_1];
    labelTitle.font = [UIFont systemFontOfSize:15];
    labelTitle.text = strTitle;
    
    UIView *viewFGLeft = [[UIView alloc] initWithFrame:CGRectMake(20, iTopY + 7.5, iLabelLeftX - 40, 1)];
    [self.view addSubview:viewFGLeft];
    viewFGLeft.backgroundColor = [ResourceManager color_5];
    
    
    UIView *viewFGRight = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-iLabelLeftX + 20, iTopY + 7.5, iLabelLeftX - 40, 1)];
    [self.view addSubview:viewFGRight];
    viewFGRight.backgroundColor = [ResourceManager color_5];
    
    int iCurTopY = iTopY+ labelTitle.height +15;
    int iCurLeftX = iLabelLeftX - 30;
    int iBlackWidth = 22.5;
    int iBlackHeight = 35;
    labelHour1 = [[UILabel alloc] initWithFrame:CGRectMake(iCurLeftX, iCurTopY, iBlackWidth, iBlackHeight)];
    [self.view addSubview:labelHour1];
    labelHour1.backgroundColor = [UIColor blackColor];
    labelHour1.layer.cornerRadius = 3;
    labelHour1.layer.masksToBounds = YES;
    labelHour1.text = @"0";
    labelHour1.textAlignment = NSTextAlignmentCenter;
    labelHour1.textColor = [UIColor whiteColor];
    labelHour1.font = [UIFont systemFontOfSize:22];
    
    iCurLeftX += iBlackWidth +2;
    labelHour2 = [[UILabel alloc] initWithFrame:CGRectMake(iCurLeftX, iCurTopY, iBlackWidth, iBlackHeight)];
    [self.view addSubview:labelHour2];
    labelHour2.backgroundColor = [UIColor blackColor];
    labelHour2.layer.cornerRadius = 3;
    labelHour2.layer.masksToBounds = YES;
    labelHour2.text = @"0";
    labelHour2.textAlignment = NSTextAlignmentCenter;
    labelHour2.textColor = [UIColor whiteColor];
    labelHour2.font = [UIFont systemFontOfSize:22];
    
    iCurLeftX += iBlackWidth +5;
    UILabel *labelHour = [[UILabel alloc] initWithFrame:CGRectMake(iCurLeftX, iCurTopY + iBlackHeight  - 20, 15, 20)];
    [self.view addSubview:labelHour];
    labelHour.text = @"时";
    labelHour.textAlignment = NSTextAlignmentCenter;
    labelHour.textColor = [UIColor blackColor];
    labelHour.font = [UIFont systemFontOfSize:15];
    
    iCurLeftX += 20;
    labelMinute1 = [[UILabel alloc] initWithFrame:CGRectMake(iCurLeftX, iCurTopY, iBlackWidth, iBlackHeight)];
    [self.view addSubview:labelMinute1];
    labelMinute1.backgroundColor = [UIColor blackColor];
    labelMinute1.layer.cornerRadius = 3;
    labelMinute1.layer.masksToBounds = YES;
    labelMinute1.text = @"0";
    labelMinute1.textAlignment = NSTextAlignmentCenter;
    labelMinute1.textColor = [UIColor whiteColor];
    labelMinute1.font = [UIFont systemFontOfSize:22];
    
    iCurLeftX += iBlackWidth +2;
    labelMinute2 = [[UILabel alloc] initWithFrame:CGRectMake(iCurLeftX, iCurTopY, iBlackWidth, iBlackHeight)];
    [self.view addSubview:labelMinute2];
    labelMinute2.backgroundColor = [UIColor blackColor];
    labelMinute2.layer.cornerRadius = 3;
    labelMinute2.layer.masksToBounds = YES;
    labelMinute2.text = @"0";
    labelMinute2.textAlignment = NSTextAlignmentCenter;
    labelMinute2.textColor = [UIColor whiteColor];
    labelMinute2.font = [UIFont systemFontOfSize:22];
    
    iCurLeftX += iBlackWidth +5;
    UILabel *labelMinute = [[UILabel alloc] initWithFrame:CGRectMake(iCurLeftX, iCurTopY + iBlackHeight  - 20, 15, 20)];
    [self.view addSubview:labelMinute];
    labelMinute.text = @"分";
    labelMinute.textAlignment = NSTextAlignmentCenter;
    labelMinute.textColor = [UIColor blackColor];
    labelMinute.font = [UIFont systemFontOfSize:15];
    
    
    iCurLeftX += 20;
    labelSecond1 = [[UILabel alloc] initWithFrame:CGRectMake(iCurLeftX, iCurTopY, iBlackWidth, iBlackHeight)];
    [self.view addSubview:labelSecond1];
    labelSecond1.backgroundColor = [UIColor blackColor];
    labelSecond1.layer.cornerRadius = 3;
    labelSecond1.layer.masksToBounds = YES;
    labelSecond1.text = @"0";
    labelSecond1.textAlignment = NSTextAlignmentCenter;
    labelSecond1.textColor = [UIColor whiteColor];
    labelSecond1.font = [UIFont systemFontOfSize:22];
    
    iCurLeftX += iBlackWidth +2;
    labelSecond2 = [[UILabel alloc] initWithFrame:CGRectMake(iCurLeftX, iCurTopY, iBlackWidth, iBlackHeight)];
    [self.view addSubview:labelSecond2];
    labelSecond2.backgroundColor = [UIColor blackColor];
    labelSecond2.layer.cornerRadius = 3;
    labelSecond2.layer.masksToBounds = YES;
    labelSecond2.text = @"0";
    labelSecond2.textAlignment = NSTextAlignmentCenter;
    labelSecond2.textColor = [UIColor whiteColor];
    labelSecond2.font = [UIFont systemFontOfSize:22];
    
    iCurLeftX += iBlackWidth +5;
    UILabel *labelSecond = [[UILabel alloc] initWithFrame:CGRectMake(iCurLeftX, iCurTopY + iBlackHeight  - 20, 15, 20)];
    [self.view addSubview:labelSecond];
    labelSecond.text = @"秒";
    labelSecond.textAlignment = NSTextAlignmentCenter;
    labelSecond.textColor = [UIColor blackColor];
    labelSecond.font = [UIFont systemFontOfSize:15];
    
    viewHideTime = [[UIView alloc] initWithFrame:CGRectMake(0, iCurTopY, SCREEN_WIDTH, 50)];
    [self.view addSubview:viewHideTime];
    viewHideTime.backgroundColor = [ResourceManager viewBackgroundColor];
    viewHideTime.hidden = YES;
    
    iCurTopY = viewHideTime.top + viewHideTime.height + 10;
    btnQD = [[UIButton alloc] initWithFrame:CGRectMake(50, iCurTopY, SCREEN_WIDTH - 100, 45)];
    [self.view addSubview:btnQD];
    btnQD.backgroundColor = [ResourceManager mainColor];
    btnQD.cornerRadius = 5;
    [btnQD setTitle:@"去抢单市场" forState:UIControlStateNormal];
    [btnQD setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnQD.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnQD addTarget:self action:@selector(actionQD) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)setUIforTime
{
    [self setHour];
    [self setMuinute];
    [self setSecond];
}

-(void) setHour
{
    int iHour =  iTimeout /3600;
    [self setLabelTens:labelHour1 LabelOnes:labelHour2 withNumber:iHour];
}

-(void) setMuinute
{
    int iMinute =  iTimeout %3600;
    iMinute = iMinute /60;
    [self setLabelTens:labelMinute1 LabelOnes:labelMinute2 withNumber:iMinute];
}

-(void) setSecond
{
    int iSecond =  iTimeout %60;
    [self setLabelTens:labelSecond1 LabelOnes:labelSecond2 withNumber:iSecond];
}


-(void) setLabelTens:(UILabel*) labelTens  LabelOnes:(UILabel*) labelOnes  withNumber:(int) iNumber
{
    if (iNumber > 0)
     {
        int iTens = iNumber/10;
        int iOnes = iNumber%10;
        labelTens.text = [NSString stringWithFormat:@"%d", iTens];
        labelOnes.text = [NSString stringWithFormat:@"%d", iOnes];
        
     }
    else
     {
        labelTens.text = @"0";
        labelOnes.text = @"0";
     }
}


-(void) setTimer
{

    if (_timer)
     {
        dispatch_source_cancel(_timer);
     }
    
    btnQD.hidden = YES;
    
    iTimeout = _iCDHour*3600 +  _iCDMinute*60 + _iCdSecond; //倒计时时间 // 59
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        iTimeout--;
        


        
        if(iTimeout<0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            _timer = nil;

            dispatch_async(dispatch_get_main_queue(), ^{
                // 此函数，一定要放回主线程执行
                [[NSNotificationCenter defaultCenter] postNotificationName:FreeGrabSwitchNotification object:@{@"status":@(1),@"listCount":@(100)}];
            });
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //设置界面 根据自己需求设置
            [self setUIforTime];
        });
    });
    dispatch_resume(_timer);
    
}


-(void) setNextGrab:(int) iGrabCount
{
    if (_timer)
     {
        dispatch_source_cancel(_timer);
     }
    
    btnQD.hidden = NO;
    
    if (iGrabCount == 100)
     {
        imgTop.image = [UIImage imageNamed:@"Free_Center1"];
        
        int iTopY = CGRectGetMaxY(imgTop.frame)  + 20;
        [self layoutMidTitle:@"下一轮免费抢单开始时间" topY:iTopY];
        viewHideTime.hidden = NO;
     }
    else
     {
        imgTop.image = [UIImage imageNamed:@"Free_Center2"];
        int iTopY = CGRectGetMaxY(imgTop.frame)  + 20;
        [self layoutMidTitle:@"下一轮免费抢单开始时间" topY:iTopY];
        viewHideTime.hidden = NO;
        
     }
}

-(void) setNextGrabTime:(int) iMonth   Day:(int) iDay   Hour:(int) iHour
{
    btnQD.hidden = NO;
    
    viewHideTime.hidden = NO;
    UILabel *labelTime = [[UILabel  alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    [viewHideTime addSubview:labelTime];
    labelTime.textColor = [UIColor orangeColor];
    labelTime.font = [UIFont systemFontOfSize:18];
    labelTime.textAlignment = NSTextAlignmentCenter;
    labelTime.text = [NSString stringWithFormat:@"%d月%d日%d时",iMonth,iDay, iHour];
}

#pragma  mark ----- action
-(void) acionVip
{

}

-(void) actionQD
{
    [self.navigationController popViewControllerAnimated:NO];
    //LightnigLendCtl *vc = [[LightnigLendCtl alloc] init];
    //[self.navigationController pushViewController:vc animated:YES];
}



@end
