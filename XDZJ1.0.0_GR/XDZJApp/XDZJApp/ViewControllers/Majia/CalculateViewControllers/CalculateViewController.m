//
//  CalculateViewController.m
//  XXJR
//
//  Created by xxjr03 on 16/6/16.
//  Copyright © 2016年 Cary. All rights reserved.
//

#import "CalculateViewController.h"
#import "HousViewController.h"
#import "ScotViewController.h"
#import "WageViewController.h"
#import "Calculate_CreditCardCtl.h"
#import "PurchaseAbilityViewController.h"
#import "AheadViewController.h"

@interface CalculateViewController ()

@end

@implementation CalculateViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"贷款计算器"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"贷款计算器"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNaviBarViewWithTitle:@"贷款计算器"];
    [self layoutUI];
    self.view.backgroundColor = [ResourceManager viewBackgroundColor];
}

-(void)layoutUI{
    UIView * lsitView = [[UIView alloc]initWithFrame:CGRectMake(0.f, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight)];
    [self.view addSubview:lsitView];
    lsitView.backgroundColor = [UIColor whiteColor];
    NSArray * titleArr = @[@"房贷计算器",@"税费计算器",@"工资计算器",@"信用卡分期计算",@"购房能力评估",@"提前还款计算器"];
    NSArray * ImgArr = @[@"Calculate-1",@"Calculate-2",@"Calculate-3",@"Calculate-4",@"Calculate-5",@"Calculate-6"];
    for (int i = 0; i < titleArr.count; i++) {
        UIView * viewX = [[UIView alloc]initWithFrame:CGRectMake(45.f,60 * (i + 1) - .3f, lsitView.bounds.size.width - 45.f, .3f)];
        [lsitView addSubview:viewX];
        if (i == titleArr.count - 1) {
            viewX.frame = CGRectMake(0.f,60 * (i + 1) - 0.3, lsitView.bounds.size.width , 0.3);
        }
        viewX.backgroundColor = [ResourceManager color_5];
        UIImageView *listImgView=[[UIImageView alloc]initWithFrame:CGRectMake(lsitView.bounds.size.width - 20.f, 60 * i + 60/2 - 12/2, 7.5, 12)];
        listImgView.image=[UIImage imageNamed:@"jiantou"];
        [lsitView addSubview:listImgView];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(50, 60 * i + 5, 200.f, 60)];
        [lsitView addSubview:label];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = UIColorFromRGB(0x333333);
        
        label.text = titleArr[i];
        UIImageView *ImgView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 60 * i + 60/2 - 37/2, 37, 37)];
        ImgView.image=[UIImage imageNamed:ImgArr[i]];
        [lsitView addSubview:ImgView];
        UIButton * calculateBtn =[[UIButton alloc]initWithFrame:CGRectMake(50.f, 60 * i, SCREEN_WIDTH - 50.f, 60.f)];
        [lsitView addSubview:calculateBtn];
        calculateBtn.tag = i;
        [calculateBtn addTarget:self action:@selector(touch:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)touch:(UIButton *)sender{
    NSInteger num = sender.tag;
    switch (num) {
        case 0:{
            //房贷计算器
            HousViewController * hous = [[HousViewController alloc]init];
            [self.navigationController pushViewController:hous animated:YES];
        }break;
        case 1:{
            //税费计算器
            ScotViewController * Scot = [[ScotViewController alloc]init];
            [self.navigationController pushViewController:Scot animated:YES];
        }break;
        case 2:{
            //工资计算器
            WageViewController * Wage = [[WageViewController alloc]init];
            [self.navigationController pushViewController:Wage animated:YES];
        }break;
        case 3:{
            //信用卡分期计算
            Calculate_CreditCardCtl * creditCard = [[Calculate_CreditCardCtl alloc]init];
            [self.navigationController pushViewController:creditCard animated:YES];
        }break;
        case 4:{
            //购房能力评估
            PurchaseAbilityViewController * PurchaseAbility = [[PurchaseAbilityViewController alloc]init];
            [self.navigationController pushViewController:PurchaseAbility animated:YES];
        }break;
        case 5:{
            //提前还款计算器
            AheadViewController * Ahead = [[AheadViewController alloc]init];
            [self.navigationController pushViewController:Ahead animated:YES];
        }break;
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
