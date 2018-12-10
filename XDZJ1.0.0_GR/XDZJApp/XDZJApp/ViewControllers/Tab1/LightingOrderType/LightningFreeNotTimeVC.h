//
//  LightningFreeNotTimeVC.h
//  XXJR
//
//  Created by xxjr02 on 2018/3/27.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LightningFreeNotTimeVC : CommonViewController

@property (nonatomic, strong) NSString *strNetTime;
@property (nonatomic, assign) int  iTimePoint;
@property (nonatomic, assign) int  iCDHour;
@property (nonatomic, assign) int  iCDMinute;
@property (nonatomic, assign) int  iCdSecond;
@property (nonatomic, assign) int  iStatus;  // 状态位


-(void) setTimer;
-(void) setNextGrab:(int) iGrabCount;
-(void) setNextGrabTime:(int) iMonth   Day:(int) iDay   Hour:(int) iHour;


@end
