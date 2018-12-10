//
//  HousDetailsViewController.m
//  XXJR
//
//  Created by xxjr03 on 16/6/21.
//  Copyright © 2016年 Cary. All rights reserved.
//

#import "HousDetailsViewController.h"

@interface HousDetailsViewController ()
{
    NSMutableArray * btnArr;
    UIButton * _housBtn;
    UIView * _housView_1;
    UIView * _housView_2;
    UIButton * resultBtn;
}
@end

@implementation HousDetailsViewController
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
    btnArr = [[NSMutableArray alloc]init];
    NSArray * titleArr = @[@"等额本息",@"等额本金"];
    for (int i = 0; i < 2; i++) {
        _housBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 * i, NavHeight + 10, SCREEN_WIDTH/2, 40)];
        [self.view addSubview:_housBtn];
        _housBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btnArr addObject:_housBtn];
        _housBtn.tag = i;
        _housBtn.backgroundColor = [UIColor whiteColor];
        [_housBtn setTitleColor:[ResourceManager color_6] forState:UIControlStateNormal];
        [_housBtn setTitleColor:[ResourceManager mainColor] forState:UIControlStateSelected];
        [_housBtn setTitle:titleArr[i] forState:UIControlStateNormal];
        [_housBtn addTarget:self action:@selector(housBtn:) forControlEvents:UIControlEventTouchUpInside];
        ((UIButton *)btnArr[0]).selected = YES;
    }
    UIView * viewX_1 = [[UIView alloc]initWithFrame:CGRectMake(0.f, NavHeight + 50 - 0.5, SCREEN_WIDTH, 0.5)];
    [self.view addSubview:viewX_1];
    viewX_1.backgroundColor = [ResourceManager color_5];
    UIView * viewX_2 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, NavHeight + 20, 0.5, 20)];
    [self.view addSubview:viewX_2];
    viewX_2.backgroundColor = [ResourceManager color_5];
    _housView_1 = [[UIView alloc]initWithFrame:CGRectMake(0.f, NavHeight + 50.f, SCREEN_WIDTH, 44 * 5)];
    [self.view addSubview:_housView_1];
    _housView_1.backgroundColor = [UIColor whiteColor];
    _housView_2 = [[UIView alloc]initWithFrame:CGRectMake(0.f, NavHeight + 50.f, SCREEN_WIDTH, 44 * 6)];
    [self.view addSubview:_housView_2];
    _housView_2.backgroundColor = [UIColor whiteColor];
    _housView_1.hidden = NO;
    _housView_2.hidden = YES;
    resultBtn = [[UIButton alloc]initWithFrame:CGRectMake(20.f, CGRectGetMaxY(_housView_1.frame) + 50, SCREEN_WIDTH - 40, 50.f)];
    [self.view addSubview:resultBtn];
    resultBtn.backgroundColor = [ResourceManager mainColor];
    [resultBtn setTitle:@"重新计算" forState:UIControlStateNormal];
    [resultBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    resultBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    resultBtn.cornerRadius = 5;
    [resultBtn addTarget:self action:@selector(resultBtn) forControlEvents:UIControlEventTouchUpInside];
    [self housViewUI_1];
    [self housViewUI_2];
}
-(void)housViewUI_1{
    NSArray * titleArr = @[@"月供",@"总利息",@"本息合计",@"贷款金额",@"贷款期限"];
    for (NSInteger i = 0; i<self.arr_1.count; i++) {
        UIView * viewX = [[UIView alloc]initWithFrame:CGRectMake(0.f, 44 * (i + 1) - 0.5, SCREEN_WIDTH, 0.5)];
        [_housView_1 addSubview:viewX];
        viewX.backgroundColor = [ResourceManager color_5];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 44 * i, 100, 44)];
        [_housView_1 addSubview:label];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = UIColorFromRGB(0x333333);
        label.text = titleArr[i];
        UILabel * label_2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 150, 44 * i, 140, 44)];
        [_housView_1 addSubview:label_2];
        label_2.font = [UIFont systemFontOfSize:14];
        label_2.textColor = [ResourceManager mainColor];
        label_2.textAlignment = NSTextAlignmentRight;
        label_2.text = self.arr_1[i];
    }
}
-(void)housViewUI_2{
    NSArray * titleArr = @[@"首次月供",@"每月递减",@"总利息",@"本息合计",@"贷款金额",@"贷款期限"];
    for (NSInteger i = 0; i< self.arr_2.count; i++) {
        UIView * viewX = [[UIView alloc]initWithFrame:CGRectMake(0.f, 44 * (i + 1) - 0.5, SCREEN_WIDTH, 0.5)];
        [_housView_2 addSubview:viewX];
        viewX.backgroundColor = [ResourceManager color_5];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 44 * i, 100, 44)];
        [_housView_2 addSubview:label];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = UIColorFromRGB(0x333333);
        label.text = titleArr[i];
        UILabel * label_2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 150, 44 * i, 140, 44)];
        [_housView_2 addSubview:label_2];
        label_2.font = [UIFont systemFontOfSize:14];
        label_2.textColor = [ResourceManager mainColor];
        label_2.textAlignment = NSTextAlignmentRight;
        label_2.text = self.arr_2[i];
    }
}
-(void)housBtn:(UIButton *)sender{
    //点击其他button之后这里设置为非选中状态，否则会出现2个同色的选中状态
    ((UIButton *)btnArr[0]).selected = NO;
    if (sender != _housBtn){
        _housBtn.selected = NO;
        _housBtn = sender;
    }
    _housBtn.selected = YES;
    if(sender.tag == 0){
        _housView_1.hidden = NO;
        _housView_2.hidden = YES;
        resultBtn.frame = CGRectMake(20.f, CGRectGetMaxY(_housView_1.frame) + 50, SCREEN_WIDTH - 40, 50.f);
    }if(sender.tag == 1){
        _housView_1.hidden = YES;
        _housView_2.hidden = NO;
        resultBtn.frame = CGRectMake(20.f, CGRectGetMaxY(_housView_2.frame) + 50, SCREEN_WIDTH - 40, 50.f);
    }
}
//计算结果
-(void)resultBtn{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
