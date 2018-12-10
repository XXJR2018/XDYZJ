//
//  DCPaymentView.m
//  DCPayAlertDemo
//
//  Created by dawnnnnn on 15/12/9.
//  Copyright © 2015年 dawnnnnn. All rights reserved.
//

#import "DCPaymentView.h"

#import "GLTextField.h"
#import "UIView+category.h"

#define TITLE_HEIGHT 46
#define PAYMENT_WIDTH [UIScreen mainScreen].bounds.size.width

#define ALERT_HEIGHT   [UIScreen mainScreen].bounds.size.height/2



//密码位数
static NSInteger const kDotsNumber = 6;
//假密码点点的宽和高  应该是等高等宽的正方形 方便设置为圆
static CGFloat const kDotWith_height = 10;

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height


@interface DCPaymentView ()<UITextFieldDelegate>
{
    NSMutableArray *pwdIndicatorArr;
}
@property (nonatomic, strong) UIView *paymentAlert, *inputView;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UILabel *titleLabel, *line, *detailLabel, *amountLabel;
@property (nonatomic, strong) UITextField *pwdTextField;


//密码输入文本框
@property (nonatomic,strong) GLTextField *passwordField;
//用来装密码圆点的数组
@property (nonatomic,strong) NSMutableArray *passwordDotsArray;
//默认密码
@property (nonatomic,strong,readonly) NSString *password;


@end

@implementation DCPaymentView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.3f];
        
        [self drawView];
    }
    return self;
}

- (void)drawView {
    if (!_paymentAlert) {
        //_paymentAlert = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-KEYBOARD_HEIGHT-KEY_VIEW_DISTANCE-ALERT_HEIGHT, [UIScreen mainScreen].bounds.size.width, ALERT_HEIGHT)];
        float  fPayAlertH = [UIScreen mainScreen].bounds.size.height/2;
        if (IS_IPHONE_5_OR_LESS)
         {
            fPayAlertH = [UIScreen mainScreen].bounds.size.height/2-80;
         }
        if (IS_IPHONE_6)
         {
            fPayAlertH = [UIScreen mainScreen].bounds.size.height/2-30;
         }

        _paymentAlert = [[UIView alloc]initWithFrame:CGRectMake(0, fPayAlertH, [UIScreen mainScreen].bounds.size.width, ALERT_HEIGHT)];
        //_paymentAlert.layer.cornerRadius = 5.f;
        //_paymentAlert.layer.masksToBounds = YES;
        _paymentAlert.backgroundColor = [UIColor colorWithWhite:1. alpha:.95];
        [self addSubview:_paymentAlert];
        
        
        // 加入个白底
        UIView *viewTitleBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PAYMENT_WIDTH, TITLE_HEIGHT)];
        viewTitleBack.backgroundColor = [UIColor whiteColor];
        [_paymentAlert addSubview:viewTitleBack];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, PAYMENT_WIDTH, TITLE_HEIGHT)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        [_paymentAlert addSubview:_titleLabel];
        
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setFrame:CGRectMake(0, 0, TITLE_HEIGHT, TITLE_HEIGHT)];
        [_closeBtn setTitle:@"╳" forState:UIControlStateNormal];
        [_closeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_paymentAlert addSubview:_closeBtn];
        
        
        // 加入密码框并将密码框定制化
        [_paymentAlert addSubview:self.passwordField];
        [self.passwordField becomeFirstResponder];
        [self addDotsViews];
        
        // 加入“忘记密码”按钮
        float  fButtonY = self.passwordField.frame.size.height + TITLE_HEIGHT + 10 + 5;
        UIButton  *btLJHK = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-110, fButtonY, 100, 20)];
        btLJHK.titleLabel.font = [UIFont systemFontOfSize: 14.0];
        [btLJHK setTitle:@"忘记密码？" forState:UIControlStateNormal];
        [btLJHK setTitleColor:[ResourceManager color_8] forState:UIControlStateNormal];
        btLJHK.titleLabel.textAlignment = NSTextAlignmentRight;
        //btLJHK.backgroundColor = [ResourceManager color_8];
        [btLJHK addTarget:self action:@selector(actionWJMM) forControlEvents:UIControlEventTouchUpInside];
        [_paymentAlert addSubview:btLJHK];
        

    }
    
    
}

#pragma mark ----- 忘记密码
-(void) actionWJMM
{
//    InputMoneyView *payAlert = [[InputMoneyView alloc]init];
//    payAlert.title = @"修改金额";
//    [payAlert show];
//    payAlert.completeHandle = ^(NSString *inputPwd) {
//        NSLog(@"金额是%@",inputPwd);
//    };
    if (_passWordBlock)
     {
        _passWordBlock();
     }
}


#pragma mark == private method
- (void)addDotsViews
{
    //密码输入框的宽度
    CGFloat passwordFieldWidth = CGRectGetWidth(self.passwordField.frame);
    //六等分 每等分的宽度
    CGFloat password_width = passwordFieldWidth / kDotsNumber;
    //密码输入框的高度
    CGFloat password_height = CGRectGetHeight(self.passwordField.frame);
    
    for (int i = 0; i < kDotsNumber; i ++)
     {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(i * password_width, 0, 1, password_height)];
        line.backgroundColor = UIColorFromRGB(0xdddddd);
        [self.passwordField addSubview:line];
        
        //假密码点的x坐标
        CGFloat dotViewX = (i + 1)*password_width - password_width / 2.0 - kDotWith_height / 2.0;
        CGFloat dotViewY = (password_height - kDotWith_height) / 2.0;
        UIView *dotView = [[UIView alloc] initWithFrame:CGRectMake(dotViewX, dotViewY, kDotWith_height, kDotWith_height)];
        dotView.backgroundColor = UIColorFromRGB(0x222222);
        dotView.layer.cornerRadius = kDotWith_height/2;
        dotView.hidden = YES;
        [self.passwordField addSubview:dotView];
        [self.passwordDotsArray addObject:dotView];
     }
}


- (void)cleanPassword
{
    _passwordField.text = @"";
    
    [self setDotsViewHidden];
}

//将所有的假密码点设置为隐藏状态
- (void)setDotsViewHidden
{
    for (UIView *view in _passwordDotsArray)
     {
        [view setHidden:YES];
     }
}



- (void)show {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    _paymentAlert.transform = CGAffineTransformMakeScale(1.21f, 1.21f);
    _paymentAlert.alpha = 0;

    
    [UIView animateWithDuration:.7f delay:0.f usingSpringWithDamping:.7f initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [_pwdTextField becomeFirstResponder];
        _paymentAlert.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        _paymentAlert.alpha = 1.0;
    } completion:nil];
}

- (void)dismiss {
    [self removeFromSuperview];
}




#pragma mark == UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //删除键
    if (string.length == 0)
     {
        return YES;
     }
    
    if (_passwordField.text.length >= kDotsNumber)
     {
        return NO;
     }
    
    return YES;
}

#pragma mark - 
- (void)setTitle:(NSString *)title {
    if (_title != title) {
        _title = title;
        _titleLabel.text = _title;
    }
}

#pragma mark == event response
- (void)passwordFieldDidChange:(UITextField *)field
{
    [self setDotsViewHidden];
    
    for (int i = 0; i < _passwordField.text.length; i ++)
     {
        if (_passwordDotsArray.count > i )
         {
            UIView *dotView = _passwordDotsArray[i];
            [dotView setHidden:NO];
         }
     }
    
    
    if (_passwordField.text.length == 6)
     {
        NSString *password = _passwordField.text;
        
//        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
//        
//        //  转圈等待加入
//        [MBProgressHUD showHUDAddedTo:keyWindow animated:NO];
//        
//        // 转圈等待消失
//        [MBProgressHUD hideHUDForView:keyWindow animated:NO];
        

        
       
        if (_completeHandle) {
                _completeHandle(password);
        }
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:.3f];
        NSLog(@"complete");
        
     }
}


#pragma mark == 懒加载
- (GLTextField *)passwordField
{
    if (nil == _passwordField)
     {
        _passwordField = [[GLTextField alloc] initWithFrame:CGRectMake((kScreenWidth - 44 * 6)/2.0, TITLE_HEIGHT + 10, 44 * 6, 44)];
        _passwordField.delegate = (id)self;
        _passwordField.backgroundColor = [UIColor whiteColor];
        //将密码的文字颜色和光标颜色设置为透明色
        //之前是设置的白色 这里有个问题 如果密码太长的话 文字和光标的位置如果到了第一个黑色的密码点的时候 就看出来了
        _passwordField.textColor = [UIColor clearColor];
        _passwordField.tintColor = [UIColor clearColor];
        [_passwordField setBorderColor:UIColorFromRGB(0xdddddd) width:1];
        _passwordField.keyboardType = UIKeyboardTypeNumberPad;
        //_passwordField.keyboardType = UIKeyboardTypeDecimalPad;
        _passwordField.secureTextEntry = YES;
        [_passwordField addTarget:self action:@selector(passwordFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
     }
    return _passwordField;
}

- (NSMutableArray *)passwordDotsArray
{
    if (nil == _passwordDotsArray)
     {
        _passwordDotsArray = [[NSMutableArray alloc] initWithCapacity:kDotsNumber];
     }
    return _passwordDotsArray;
}



@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
