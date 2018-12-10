//
//  VipHytqVC.m
//  XXJR
//
//  Created by xxjr02 on 2018/2/22.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import "VipHytqVC.h"

@interface VipHytqVC ()

@end

@implementation VipHytqVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutWhiteNaviBarViewWithTitle:@"VIP会员特权"];
    
    [self layoutUI_2];
}


//会员特权
-(void)layoutUI_2{
    
    UIColor *color_1 = UIColorFromRGB(0xC69548);
    UIColor *color_2 = [ResourceManager color_6];
    UIFont *font_1 = [UIFont systemFontOfSize:13];
    UIView *freedomViwe = [[UIView alloc]initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, 57.5 * SCREEN_WIDTH/320 + 440 )];
    [self.view addSubview:freedomViwe];
    freedomViwe.backgroundColor = [UIColor whiteColor];
    
    UIImageView *freedomImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 57.5 * SCREEN_WIDTH/320)];
    [freedomViwe addSubview:freedomImg];
    freedomImg.image = [UIImage imageNamed:@"VIP_hycz"];
    
    NSArray *imgArr = @[@"VIP-2",@"VIP-3",@"VIP_zidong", @"VIP-5",@"VIP-6",@"VIP-7"];
    NSArray *titleArr_1 = @[@"免费抢单",@"特价抢单",@"自动抢单", @"申请退款",@"房价评估",@"APP抽奖"];
    NSArray *titleArr_2 = @[@"会员每天都可参与免费抢单（普通用户只有3次机会）",
                            @"会员设有“会员特价”专区，均有机会抢到10元的特价单。",
                            @"系统根据您当前设置的抢单价格区间和抢单笔数，每天自动抢单（贴心为您省去找单、抢单的时间）",
                            @"会员抢到的普通单和优质客户单可申请退款，每月送一次退款机会（当月没使用，累计到下月）",
                            @"会员每天有3次机会免费评估房价（普通用户每天1次）",
                            @"会员每天3次免费抽奖机会（普通用户每天1次）"];
    for (int i = 0; i < [imgArr count]; i++) {
        UIButton *freedomBtn_1 = [[UIButton alloc]initWithFrame:CGRectMake(10, 57.5 * SCREEN_WIDTH/320 + 10 + 60 * i, 78, 25)];
        [freedomViwe addSubview:freedomBtn_1];
        [freedomBtn_1 setTitle:titleArr_1[i] forState:UIControlStateNormal];
        [freedomBtn_1 setImage:[UIImage imageNamed:imgArr[i]] forState:UIControlStateNormal];
        [freedomBtn_1 setTitleEdgeInsets:UIEdgeInsetsMake(0, 3, 0, 0)];
        [freedomBtn_1 setTitleColor:color_1 forState:UIControlStateNormal];
        freedomBtn_1.titleLabel.font = font_1;
        UILabel *label_1 = [[UILabel alloc]initWithFrame:CGRectMake(30, 57.5 * SCREEN_WIDTH/320 + 35 + 60 * i, SCREEN_WIDTH - 40, 35)];
        [freedomViwe addSubview:label_1];
        label_1.numberOfLines = 2;
        label_1.textColor = color_2;
        label_1.font = font_1;
        label_1.text = titleArr_2[i];
    }
}


@end
