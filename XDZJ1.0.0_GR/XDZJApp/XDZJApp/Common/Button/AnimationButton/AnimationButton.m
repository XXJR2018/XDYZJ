//
//  AnimationButton.m
//  BabyPigAnimation
//
//  Created by xxjr02 on 2018/6/7.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

#import "AnimationButton.h"

@implementation AnimationButton

-(void)setDelegateWithParamater:(id<ButtonDelegateWithParameter>)delegateWithParamater{
    
    
    [self addTarget:self action:@selector(funcWithParameter:) forControlEvents:UIControlEventTouchUpInside];
    _delegateWithParamater = delegateWithParamater;
}

-(void)funcWithParameter:(id)parameter
{
    if (self.delegateWithParamater)
     {
        
        [self setEndAnimation];
        
        [self.delegateWithParamater delegateFunctionWithParameter:parameter];
     }
}

// 设置开始的动画的跳动距离
-(void) setSatrtAnimationHegit:(float) fHegint
{
    int iWidth = self.frame.size.width;
    int iLeftX = self.frame.origin.x;
    float iTopY = self.frame.origin.y;
    
    int iRandTime = rand()%3;
    iRandTime += 3;
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    NSValue *value_0 = [NSValue valueWithCGPoint:CGPointMake(iLeftX + iWidth/2, iTopY)];
    NSValue *value_1 = [NSValue valueWithCGPoint:CGPointMake(iLeftX + iWidth/2, iTopY + fHegint/3)];
    NSValue *value_2 = [NSValue valueWithCGPoint:CGPointMake(iLeftX + iWidth/2, iTopY+ fHegint*2/3)];
    NSValue *value_3 = [NSValue valueWithCGPoint:CGPointMake(iLeftX + iWidth/2, iTopY + fHegint)];
    NSValue *value_4 = [NSValue valueWithCGPoint:CGPointMake(iLeftX + iWidth/2, iTopY+ fHegint*2/3)];
    NSValue *value_5 = [NSValue valueWithCGPoint:CGPointMake(iLeftX + iWidth/2, iTopY + fHegint/3)];
    NSValue *value_6 = [NSValue valueWithCGPoint:CGPointMake(iLeftX + iWidth/2, iTopY)];
    animation.values = [NSArray arrayWithObjects:value_0,value_1,value_2,value_3,value_4,value_5,value_6, nil];
    animation.duration = iRandTime;//3.0f;
    animation.repeatCount = MAXFLOAT;
    [self.layer addAnimation:animation forKey:@"keyFrameAnimation"];
    
}

// 设置结束的动画
-(void) setEndAnimation
{
    if (_isNotEndAnimation)
     {
        return;
     }
    
    int iLeftX = self.frame.origin.x;
    int iTopY = self.frame.origin.y;
    int iWidth = self.frame.size.width;
    int iHeight = self.frame.size.height;
    

    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];

    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(iLeftX + iWidth/2, iTopY)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(iLeftX + iWidth/2, -iHeight )];
    animation.duration = 1;//1.0f;
    animation.fillMode = kCAFillModeForwards;

    [self.layer addAnimation:animation forKey:@"positionAnimation"];
    
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.8];
    
    self.userInteractionEnabled = NO;
}

-(void) delayMethod
{
    [self removeFromSuperview];
}



-(void) setText:(NSString*) text
{
    int iWidth = self.frame.size.width;
    //int iHeight = self.frame.size.height;
    int iLeftX = (iWidth - 40)/2;
    int iTopY = 0;
    
    UIImageView *imgHead = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 40, 40)];
    [self addSubview:imgHead];
    imgHead.image = [UIImage imageNamed:@"taber1_bubble"];
    
    iTopY += imgHead.frame.size.height;
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, iWidth, 20)];
    [self addSubview:labelTitle];
    labelTitle.text = text;
    labelTitle.font = [UIFont systemFontOfSize:11];
    labelTitle.textAlignment = NSTextAlignmentCenter;
    labelTitle.textColor = UIColorFromRGB(0x11fdfd);
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
