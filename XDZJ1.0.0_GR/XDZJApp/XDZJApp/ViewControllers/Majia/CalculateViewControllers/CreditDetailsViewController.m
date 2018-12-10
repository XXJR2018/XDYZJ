//
//  CreditDetailsViewController.m
//  XXJR
//
//  Created by xxjr03 on 16/6/22.
//  Copyright © 2016年 Cary. All rights reserved.
//

#import "CreditDetailsViewController.h"

@interface CreditDetailsViewController ()

@end

@implementation CreditDetailsViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"计算结果"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"计算结果"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNaviBarViewWithTitle:@"计算结果"];
    self.view.backgroundColor = [ResourceManager viewBackgroundColor];
    [self layoutUI];
}
-(void)layoutUI{
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, NavHeight + 20, SCREEN_WIDTH, 44 * 6)];
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    UIView * viewX = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0, SCREEN_WIDTH, 0.5)];
    [headView addSubview:viewX];
    viewX.backgroundColor = [ResourceManager color_5];
    NSArray * titleArr = @[@"总利息",@"总计还款额",@"每期(月)还款额",@"每日利息",@"期数",@"金额"];
    for (NSInteger i = 0; i<titleArr.count; i++) {
        UIView * viewX = [[UIView alloc]initWithFrame:CGRectMake(0.f, 44 * (i + 1) - 0.5, SCREEN_WIDTH, 0.5)];
        [headView addSubview:viewX];
        viewX.backgroundColor = [ResourceManager color_5];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 44 * i, 130, 44)];
        [headView addSubview:label];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = UIColorFromRGB(0x333333);
        label.text = titleArr[i];
        UILabel * label_2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 150, 44 * i, 140, 44)];
        [headView addSubview:label_2];
        label_2.font = [UIFont systemFontOfSize:14];
        label_2.textColor = UIColorFromRGB(0xfc7637);
        label_2.textAlignment = NSTextAlignmentRight;
        label_2.text = self.DetailsArr[i];
    }
    UIButton * resultBtn = [[UIButton alloc]initWithFrame:CGRectMake(20.f, CGRectGetMaxY(headView.frame) + 50, SCREEN_WIDTH - 40, 50.f)];
    [self.view addSubview:resultBtn];
    resultBtn.backgroundColor = UIColorFromRGB(0xfc7637);
    resultBtn.cornerRadius = 5;
    [resultBtn setTitle:@"重新计算" forState:UIControlStateNormal];
    [resultBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    resultBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [resultBtn addTarget:self action:@selector(resultBtn) forControlEvents:UIControlEventTouchUpInside];
}
-(void)resultBtn{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end