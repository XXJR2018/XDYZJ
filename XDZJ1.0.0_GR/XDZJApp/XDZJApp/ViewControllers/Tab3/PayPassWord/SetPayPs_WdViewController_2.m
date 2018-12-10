//
//  SetPayPs_WdViewController_2.m
//  XXJR
//
//  Created by xxjr03 on 2017/8/24.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import "SetPayPs_WdViewController_2.h"

#import "GLTextField.h"
#import "UIView+category.h"

//密码输入框宽高
#define kPassWordFieldHeight       (SCREEN_WIDTH - 40 * ScaleSize)/6
//static NSInteger const kPassWordFieldHeight = (SCREEN_WIDTH - 40 * ScaleSize)/6;
//密码位数
static NSInteger const kDotsNumber = 6;
//假密码点点的宽和高  应该是等高等宽的正方形 方便设置为圆
static CGFloat const kDotWith_height = 10;

@interface SetPayPs_WdViewController_2 ()<UITextFieldDelegate>
{
    NSInteger _psWdType;
    NSString *_oldPsWd;
    NSString *_newPsWd_1;
    NSString *_newPsWd_2;
}

//密码输入文本框
@property (nonatomic,strong) UILabel *promptLabel;
//密码输入文本框
@property (nonatomic,strong) GLTextField *passwordField;
//用来装密码圆点的数组
@property (nonatomic,strong) NSMutableArray *passwordDotsArray;

@end

@implementation SetPayPs_WdViewController_2

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNaviBarViewWithTitle:@"修改支付密码"];
    self.view.backgroundColor = [ResourceManager viewBackgroundColor];
    
    [self.view addSubview:self.promptLabel];
    self.promptLabel.text = @"请输入原密码，以验证身份";
    [self.view addSubview:self.passwordField];
    [self.passwordField becomeFirstResponder];
    
    _psWdType = 1;
    [self addDotsViews];
}

//验证
-(void)payPassWordUrl_1
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *parame = [[NSMutableDictionary alloc]init];
    parame[@"tradePwd"] = _oldPsWd;
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],@"xxcust/account/info/checkTradePwd"]
                                                                               parameters:parame HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      _psWdType = 2;
                                                                                      [self cleanPassword];
                                                                                      self.promptLabel.text = @"请设置新的支付密码，用于支付验证";
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                      [self cleanPassword];
                                                                                  }];
    [operation start];
}

//修改.
-(void)payPassWordUrl_2
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *parame = [[NSMutableDictionary alloc]init];
    parame[@"tradePwd"] = _newPsWd_1;
    parame[@"confirmTradePwd"] = _newPsWd_2;
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],@"xxcust/account/info/changeTradePwd"]
                                                                               parameters:parame HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      [MBProgressHUD showSuccessWithStatus:@"支付密码修改成功" toView:self.view];
                                                                                      [self performBlock:^{
                                                                                          [self.navigationController popToRootViewControllerAnimated:YES];
                                                                                      } afterDelay:1.5];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    [operation start];
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
        //调函数
        NSLog(@"passWord=====%@",_passwordField.text);
        if (_psWdType == 1) {
            _oldPsWd = self.passwordField.text;
            if (_oldPsWd.length == 6) {
                [self payPassWordUrl_1];
            }else{
                [MBProgressHUD showErrorWithStatus:@"支付密码错误，请重新输入" toView:self.view];
                [self cleanPassword];
            }
        }else if (_psWdType == 2) {
            _psWdType = 3;
            _newPsWd_1 = self.passwordField.text;
            [self cleanPassword];
            self.promptLabel.text = @"请再次填写确认";
        }else if (_psWdType == 3) {
            _newPsWd_2 = self.passwordField.text;
            if ([_newPsWd_1 isEqualToString:_newPsWd_2] && _newPsWd_1.length == 6 && _newPsWd_2.length == 6) {
                [self performBlock:^{
                    [self payPassWordUrl_2];
                } afterDelay:0.5];
            }else{
                [MBProgressHUD showErrorWithStatus:@"两次输入密码不一致，请重新输入" toView:self.view];
                [self cleanPassword];
            }
        }
    }
}


#pragma mark == 懒加载
- (GLTextField *)passwordField
{
    if (nil == _passwordField)
    {
        _passwordField = [[GLTextField alloc] initWithFrame:CGRectMake(20 * ScaleSize, CGRectGetMaxY(_promptLabel.frame) + 20, kPassWordFieldHeight * 6, kPassWordFieldHeight)];
        _passwordField.delegate = (id)self;
        _passwordField.backgroundColor = [UIColor whiteColor];
        //将密码的文字颜色和光标颜色设置为透明色
        //之前是设置的白色 这里有个问题 如果密码太长的话 文字和光标的位置如果到了第一个黑色的密码点的时候 就看出来了
        _passwordField.textColor = [UIColor clearColor];
        _passwordField.tintColor = [UIColor clearColor];
        [_passwordField setBorderColor:UIColorFromRGB(0xdddddd) width:1];
        _passwordField.keyboardType = UIKeyboardTypeNumberPad;
        _passwordField.secureTextEntry = YES;
        [_passwordField addTarget:self action:@selector(passwordFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _passwordField;
}

- (UILabel *)promptLabel
{
    
    if (nil == _promptLabel)
    {
        _promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 140 * ScaleSize, SCREEN_WIDTH, 20)];
        _promptLabel.font = [UIFont systemFontOfSize:15];
        _promptLabel.textColor = UIColorFromRGB(0x666666);
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.numberOfLines = 0;
    }
    return _promptLabel;
}

- (NSMutableArray *)passwordDotsArray
{
    if (nil == _passwordDotsArray)
    {
        _passwordDotsArray = [[NSMutableArray alloc] initWithCapacity:kDotsNumber];
    }
    return _passwordDotsArray;
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
