//
//  ExchangeVC.m
//  XXJR
//
//  Created by xxjr02 on 2017/11/6.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import "ExchangeVC.h"

@interface ExchangeVC ()
{
    UITextField *_label1_text;
}
@end

@implementation ExchangeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self layoutNaviBarViewWithTitle:@"优惠码"];
    
    [self layoutUI];
}

-(void) layoutUI
{
    float fTopY = NavHeight+10;
    float fLeftX = 30;
    
    UIView *viewHeadBack = [[UIView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, 60)];
    viewHeadBack.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewHeadBack];
    
    _label1_text = [[UITextField alloc] initWithFrame:CGRectMake(fLeftX, fTopY, SCREEN_WIDTH - 2*fLeftX, 40)];
    _label1_text.placeholder = @"  请输入兑换码";
    _label1_text.font = [UIFont systemFontOfSize:14];
    
    
    //设置边框的颜色
    _label1_text.layer.borderColor = [ResourceManager lightGrayColor].CGColor;
    //设置边框的粗细
    _label1_text.layer.borderWidth = 1;
    [self.view addSubview:_label1_text];
    
    
    fTopY +=60;
    
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(fLeftX, fTopY, SCREEN_WIDTH - 2*fLeftX, 40)];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button setTitle:@"兑换" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.layer.cornerRadius = 35/2;
    button.backgroundColor = [UIColor orangeColor];
    //button.layer.borderWidth = 0.5;
    //button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [button addTarget:self action:@selector(clickOKButton) forControlEvents:UIControlEventTouchUpInside];
    [button setShowsTouchWhenHighlighted:YES];
    [self.view addSubview:button];
}

-(void) clickOKButton
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //[MBProgressHUD hideHUDForView:self.view animated:YES];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"inviteCode"] = _label1_text.text;
    
    
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],@"xxcust/account/coupon/sendCoupon"]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      [self.navigationController popViewControllerAnimated:NO];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    
    
    operation.tag = 10210;
    [operation start];
    
    //account/coupon/sendCoupon
}
@end
