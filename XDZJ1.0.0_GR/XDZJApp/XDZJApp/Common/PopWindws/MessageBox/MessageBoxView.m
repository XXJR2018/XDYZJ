//
//  MessageBoxView.m
//  XXJR
//
//  Created by xxjr02 on 2017/12/15.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import "MessageBoxView.h"



#import "UIImageView+WebCache.h"

#define UIColorFromRGB11(rgbValue) \
[UIColor colorWithRed:((rgbValue >> 16) & 0xFF)/255.f \
green:((rgbValue >> 8) & 0xFF)/255.f \
blue:(rgbValue & 0xFF)/255.f \
alpha:1.0f]

static const CGFloat alertviewWidth = 300.0;
static const CGError alertviewHeight = 220.0;
static const CGFloat titleHeight = 30.0;

static const CGFloat midviewHeight = 115;
static const CGFloat buttonHeight = 35;





@interface MessageBoxView()

@property (strong,nonatomic)UIDynamicAnimator * animator;
@property (strong,nonatomic)UIView * alertview;
@property (strong,nonatomic)UIView * backgroundview;
@property (strong,nonatomic)NSString * title;
@property (strong,nonatomic)NSString * message;
@property (strong,nonatomic)NSString * imgUrl;
@property (strong,nonatomic)NSString * strTime;

@property (strong,nonatomic)NSString * cancelButtonTitle;
@property (strong,nonatomic)NSString * okButtonTitle;
@property (strong,nonatomic)UIImage * image;
@property (strong,nonatomic)UIButton * buttonVesion;
@property (strong,nonatomic)UILabel *label1_text;
@property (strong,nonatomic)UIImageView * imageview;


@end


@implementation MessageBoxView

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
    [button addTarget:self action:@selector(clickOKButton:) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark ---- 确定按钮
-(void)clickOKButton:(UIButton *)button{
    
    [self dismiss];
    if ([self.delegate respondsToSelector:@selector(didClickButtonAtIndex:)]) {
        [self.delegate didClickButtonAtIndex:(1)];
    }
    
    
    //
}

-(void)clickButton:(UIButton *)button
{
    [self dismiss];
    if ([self.delegate respondsToSelector:@selector(didClickButtonAtIndex:)]) {
        [self.delegate didClickButtonAtIndex:(2)];
    }
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
    
    
    self.alertview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, alertviewWidth, alertviewHeight)];
    self.alertview.layer.cornerRadius = 5;
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    //self.alertview.center = CGPointMake(CGRectGetMidX(keywindow.frame), -CGRectGetMidY(keywindow.frame)-200);
    self.alertview.center = CGPointMake(CGRectGetMidX(keywindow.frame), -CGRectGetMidY(keywindow.frame));
    self.alertview.backgroundColor = [UIColor whiteColor];
    self.alertview.clipsToBounds = YES;
    
    [self addSubview:self.alertview];
    
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,alertviewWidth,titleHeight)];
    titleLabel.text = self.title;
    titleLabel.backgroundColor = [ResourceManager viewBackgroundColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [ResourceManager navgationTitleColor];
    [self.alertview addSubview:titleLabel];
    
    
    float  fLeftX = 70;
    float  fTopY =  titleHeight +20;


    fLeftX = 30;
    _label1_text = [[UILabel alloc] initWithFrame:CGRectMake(fLeftX, fTopY, alertviewWidth - 2*fLeftX, 50)];
    _label1_text.text = self.message;
    _label1_text.numberOfLines = 0;
    _label1_text.font = [UIFont systemFontOfSize:16];
    [self.alertview addSubview:_label1_text];
    
    
    
    
    
    if (self.message.length > 50)
     {
        [_label1_text sizeToFit];
     }
    
    int iTopY = CGRectGetMaxY(_label1_text.frame) +20;
    //CGRect cancelButtonFrame = CGRectMake(0, titleHeight + midviewHeight,alertviewWidth,buttonHeight);
    CGRect cancelButtonFrame = CGRectMake(0, iTopY,alertviewWidth,buttonHeight);
    
    if (self.okButtonTitle.length != 0 && self.okButtonTitle !=nil) {
        cancelButtonFrame = CGRectMake(alertviewWidth / 2 +10 ,iTopY, alertviewWidth/2-40,buttonHeight);
        CGRect okButtonFrame = CGRectMake(30,iTopY, alertviewWidth/2 -40 ,buttonHeight);
        UIButton * okButton = [self createButtonWithFrame2:okButtonFrame Title:self.okButtonTitle];
        okButton.tag = 2;
        [self.alertview addSubview:okButton];
        
    }
    UIButton * cancelButton = [self createButtonWithFrame:cancelButtonFrame Title:self.cancelButtonTitle];
    cancelButton.tag = 1;
    [self.alertview addSubview:cancelButton];
    
    iTopY +=buttonHeight + 15;
    CGRect  frameTemp =  self.alertview.frame;
    frameTemp.size.height = iTopY;
    self.alertview.frame = frameTemp;
    
}

-(void) actionSX
{
    [[SDImageCache sharedImageCache]  removeImageForKey:_imgUrl withCompletion:^{
        NSLog(@"清除 %@ 图片缓存成功", _imgUrl);
        
        NSDate *senddate = [NSDate date];
        _strTime = [NSString stringWithFormat:@"%ld_%@", (long)[senddate timeIntervalSince1970], [DDGSetting sharedSettings].UUID_MD5];// 当前时间戳
        _imgUrl = [NSString stringWithFormat:@"%@%@?page=%@", [PDAPI getBaseUrlString], @"xxcust/smsAction/imageCode",_strTime];
        
        [_imageview sd_setImageWithURL:[NSURL URLWithString:_imgUrl] placeholderImage:[UIImage imageNamed:@"tab4_ddsx"]];
        
    }];
    
}


#pragma mark -  API
- (void)show {
    
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:self];
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    
    
    CGPoint setCenter = self.center;
    //setCenter.y =150; // 修改弹出框的位置
    UISnapBehavior * sanp = [[UISnapBehavior alloc] initWithItem:self.alertview snapToPoint:setCenter];
    
    
    sanp.damping = 0.5;
    [self.animator addBehavior:sanp];
    
}


-(instancetype)initWithTitle:(NSString *) title
            Message:(NSString*)message
                CancelButton:(NSString *)cancelButton
                    OkButton:(NSString *)okButton{
    if (self = [super initWithFrame:[[UIApplication sharedApplication] keyWindow].frame]) {
        self.title = title;
        self.message = message;
        self.cancelButtonTitle = cancelButton;
        self.okButtonTitle = okButton;
        
        [self setUp];
    }
    return self;
}


@end
