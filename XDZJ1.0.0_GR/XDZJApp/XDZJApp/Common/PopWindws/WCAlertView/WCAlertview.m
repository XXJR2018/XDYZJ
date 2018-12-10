//
//  WCAlertview.m
//  WCAlertView
//
//  Created by huangwenchen on 15/2/17.
//  Copyright (c) 2015年 huangwenchen. All rights reserved.
//

#import "WCAlertview.h"

#define UIColorFromRGB11(rgbValue) \
[UIColor colorWithRed:((rgbValue >> 16) & 0xFF)/255.f \
green:((rgbValue >> 8) & 0xFF)/255.f \
blue:(rgbValue & 0xFF)/255.f \
alpha:1.0f]

static const CGFloat alertviewWidth = 300.0;
static const CGFloat titleHeight = 50.0;
static const CGFloat imageviewHeight = 120;
static const CGFloat buttonHeight = 35;
static const CGFloat buttonWidth = 95;
@interface WCAlertview()

@property (strong,nonatomic)UIDynamicAnimator * animator;
@property (strong,nonatomic)UIView * alertview;
@property (strong,nonatomic)UIView * backgroundview;
@property (strong,nonatomic)NSString * title;
@property (strong,nonatomic)NSString * message;
@property (strong,nonatomic)NSString * cancelButtonTitle;
@property (strong,nonatomic)NSString * okButtonTitle;
@property (strong,nonatomic)UIImage * image;
@property (strong,nonatomic)UIButton * buttonVesion;


@end

@implementation WCAlertview

#pragma mark - Gesture
-(void)click:(UITapGestureRecognizer *)sender{
    // 屏蔽掉点击任何区域，消失
//    CGPoint tapLocation = [sender locationInView:self.backgroundview];
//    CGRect alertFrame = self.alertview.frame;
//    if (!CGRectContainsPoint(alertFrame, tapLocation)) {
//        [self dismiss];
//    }
}

#pragma mark -  private function
-(UIButton *)createButtonWithFrame:(CGRect)frame Title:(NSString *)title
{
    UIButton * button = [[UIButton alloc] initWithFrame:frame];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.layer.cornerRadius = 35/2;
    button.backgroundColor = [UIColor orangeColor];
    //button.layer.borderWidth = 0.5;
    //button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [button setShowsTouchWhenHighlighted:YES];
    return button;
}

// 创建灰色按钮
-(UIButton *)createButtonWithFrame2:(CGRect)frame Title:(NSString *)title
{
    UIButton * button = [[UIButton alloc] initWithFrame:frame];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.layer.cornerRadius = 35/2;
    button.backgroundColor = UIColorFromRGB11(0xd3cdca);
    //button.layer.borderWidth = 0.5;
    //button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [button setShowsTouchWhenHighlighted:YES];
    return button;
}

-(void)clickButton:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(didClickButtonAtIndex:)]) {
        [self.delegate didClickButtonAtIndex:(button.tag -1)];
    }
    [self dismiss];
}
-(void)dismiss{
    [self.animator removeAllBehaviors];
    [UIView animateWithDuration:0.7 animations:^{
//        self.alpha = 0.0;
//        CGAffineTransform rotate = CGAffineTransformMakeRotation(0.9 * M_PI);
//        CGAffineTransform scale = CGAffineTransformMakeScale(0.1, 0.1);
//        self.alertview.transform = CGAffineTransformConcat(rotate, scale);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
         self.alertview = nil;
    }];
    
}
-(void)setUp{
    self.backgroundview = [[UIView alloc] initWithFrame:[[UIApplication sharedApplication] keyWindow].frame];
    self.backgroundview.backgroundColor = [UIColor blackColor];
    self.backgroundview.alpha = 0.4;
    [self addSubview:self.backgroundview];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
    [self.backgroundview addGestureRecognizer:tap];
    
    
    self.alertview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, alertviewWidth, 250)];
    self.alertview.layer.cornerRadius = 5;
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    self.alertview.center = CGPointMake(CGRectGetMidX(keywindow.frame), -CGRectGetMidY(keywindow.frame));
    self.alertview.backgroundColor = UIColorFromRGB11(0xfefcfb);//[UIColor whiteColor];
    self.alertview.clipsToBounds = YES;
    
    [self addSubview:self.alertview];

    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,alertviewWidth,titleHeight)];
    titleLabel.text = self.title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.alertview addSubview:titleLabel];
    
    UIImageView * imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, alertviewWidth,imageviewHeight)];
    //imageview.contentMode = UIViewContentModeScaleToFill;
    imageview.image = self.image;
//    imageview.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    imageview.layer.borderWidth = 0.5;
    [self.alertview addSubview:imageview];
    
    CGRect cancelButtonFrame = CGRectMake(0, titleHeight + imageviewHeight,alertviewWidth,buttonHeight);
    if (self.okButtonTitle.length != 0 && self.okButtonTitle !=nil) {
        cancelButtonFrame = CGRectMake(alertviewWidth / 2 ,titleHeight + imageviewHeight, alertviewWidth/2,buttonHeight);
        CGRect okButtonFrame = CGRectMake(0,titleHeight + imageviewHeight, alertviewWidth/2,buttonHeight);
        UIButton * okButton = [self createButtonWithFrame:okButtonFrame Title:self.okButtonTitle];
        okButton.tag = 2;
        [self.alertview addSubview:okButton];
        
    }
    UIButton * cancelButton = [self createButtonWithFrame:cancelButtonFrame Title:self.cancelButtonTitle];
    cancelButton.tag = 1;
    [self.alertview addSubview:cancelButton];
}



-(void)setUp2{
    self.backgroundview = [[UIView alloc] initWithFrame:[[UIApplication sharedApplication] keyWindow].frame];
    self.backgroundview.backgroundColor = [UIColor blackColor];
    self.backgroundview.alpha = 0.4;
    [self addSubview:self.backgroundview];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
    [self.backgroundview addGestureRecognizer:tap];
    
    int iTopY = 0;
    self.alertview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, alertviewWidth, 250)];
    self.alertview.layer.cornerRadius = 8;
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    self.alertview.center = CGPointMake(CGRectGetMidX(keywindow.frame), -CGRectGetMidY(keywindow.frame));
    self.alertview.backgroundColor = UIColorFromRGB11(0xfefcfb);
    self.alertview.clipsToBounds = YES;
    
    [self addSubview:self.alertview];
    
    
    
    

    
    UIImageView * imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, alertviewWidth,imageviewHeight)];
    imageview.image = self.image;
    [self.alertview addSubview:imageview];
    
    
    self.buttonVesion = [[UIButton alloc] initWithFrame:CGRectMake(195,60, 50,20)];
    self.buttonVesion.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.buttonVesion setTitle:_strVerion forState:UIControlStateNormal];
    self.buttonVesion.titleLabel.font = [UIFont systemFontOfSize:15];
    self.buttonVesion.titleLabel.textColor = [UIColor whiteColor];
    self.buttonVesion.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.buttonVesion.layer.cornerRadius = 8;
    self.buttonVesion.backgroundColor = [UIColor orangeColor];
    [self.alertview addSubview:self.buttonVesion];

    
    iTopY += imageviewHeight + 10;
    UILabel * titleMesage = [[UILabel alloc] initWithFrame:CGRectMake(40,iTopY,alertviewWidth-80,titleHeight)];
    titleMesage.text = self.message;
    titleMesage.numberOfLines = 0;
    titleMesage.font = [UIFont systemFontOfSize:14];
    titleMesage.textColor = UIColorFromRGB(0x333333);
    titleMesage.textAlignment = NSTextAlignmentLeft;
    [titleMesage sizeToFit]; // 高度自适应
    [self.alertview addSubview:titleMesage];
    
    iTopY += titleMesage.frame.size.height + 20;
    CGRect cancelButtonFrame = CGRectMake((alertviewWidth- buttonWidth)/2, iTopY,buttonWidth,buttonHeight);
    if (self.okButtonTitle.length != 0 && self.okButtonTitle !=nil) {
        int iJianJu = (alertviewWidth- 2*buttonWidth)/3;
        CGRect okButtonFrame = CGRectMake(iJianJu,iTopY, buttonWidth,buttonHeight);
        UIButton * okButton = [self createButtonWithFrame2:okButtonFrame Title:self.okButtonTitle];
        okButton.tag = 2;
        [self.alertview addSubview:okButton];
        
        int iLeftX = iJianJu + buttonWidth + iJianJu;
        cancelButtonFrame = CGRectMake(iLeftX ,iTopY, buttonWidth,buttonHeight);
        
    }
    UIButton * cancelButton = [self createButtonWithFrame:cancelButtonFrame Title:self.cancelButtonTitle];
    cancelButton.tag = 1;
    [self.alertview addSubview:cancelButton];
    iTopY +=buttonHeight + 15;
    
    
    CGRect  frameTemp =  self.alertview.frame;
    frameTemp.size.height = iTopY;
    self.alertview.frame = frameTemp;
}


#pragma mark -  API
- (void)show {
    
    [self.buttonVesion setTitle:_strVerion forState:UIControlStateNormal];
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:self];
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    UISnapBehavior * sanp = [[UISnapBehavior alloc] initWithItem:self.alertview snapToPoint:self.center];
    sanp.damping = 0.5;
    [self.animator addBehavior:sanp];
    
}

-(instancetype)initWithTitle:(NSString *) title
                       Image:(UIImage *)image
                CancelButton:(NSString *)cancelButton
                    OkButton:(NSString *)okButton{
    if (self = [super initWithFrame:[[UIApplication sharedApplication] keyWindow].frame]) {
        self.title = title;
        self.image = image;
        self.cancelButtonTitle = cancelButton;
        self.okButtonTitle = okButton;
        
        [self setUp];
    }
    return self;
}


-(instancetype)initWithTitle:(NSString *) title
                     Message:(NSString*)message
                       Image:(UIImage *)image
                CancelButton:(NSString *)cancelButton
                    OkButton:(NSString *)okButton
{
    if (self = [super initWithFrame:[[UIApplication sharedApplication] keyWindow].frame])
     {
        self.title = title;
        self.image = image;
        self.message = message;
        self.cancelButtonTitle = cancelButton;
        self.okButtonTitle = okButton;
        
        [self setUp2];
    }
    return self;
}
@end
