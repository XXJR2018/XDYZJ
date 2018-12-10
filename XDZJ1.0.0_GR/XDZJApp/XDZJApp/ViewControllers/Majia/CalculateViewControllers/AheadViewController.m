//
//  AheadViewController.m
//  XXJR
//
//  Created by xxjr03 on 16/6/22.
//  Copyright © 2016年 Cary. All rights reserved.
//

#import "AheadViewController.h"
#import "ScotDetailsViewController.h"

@interface AheadViewController ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    UITextField * _MoneyField;
    UILabel * _AheadLabel_1;
    UILabel * _AheadLabel_2;
    UILabel * _AheadLabel_3;
    UILabel * _AheadLabel_4;
    UIPickerView * _AheadPickView_1;
    UIPickerView * _AheadPickView_2;
    UIPickerView * _AheadPickView_3;
    UIPickerView * _AheadPickView_4;
    UIView * _AheadView_1;
    UIView * _AheadView_2;
    UIView * _AheadView_3;
    UIView * _AheadView_4;
    NSArray * _AheadPickArr_1;
    NSArray * _AheadPickArr_2;
    NSArray * _AheadPickArr_3_1;
    NSArray * _AheadPickArr_3_2;
    NSArray * _AheadPickArr_4_1;
    NSArray * _AheadPickArr_4_2;
    NSString * _aheadStr_1;
    NSString * _aheadStr_2;
    NSString * _aheadStr_4;
    NSString * _aheadStr_5;
}


@end

@implementation AheadViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"提前还款计算器"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"提前还款计算器"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNaviBarViewWithTitle:@"提前还款计算器"];
    self.view.backgroundColor = [ResourceManager viewBackgroundColor];
    [self layoutUI];
    //添加手势点击空白处隐藏键盘
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchViewKeyBoard)];
    gesture.numberOfTapsRequired  = 1;
    [self.view addGestureRecognizer:gesture];
}
//添加手势点击空白处隐藏键盘
-(void)TouchViewKeyBoard
{     //隐藏选择器
     _AheadView_1.hidden =YES;
     _AheadView_2.hidden =YES;
     _AheadView_3.hidden =YES;
     _AheadView_4.hidden =YES;
    [self.view endEditing:YES];
}
-(void)layoutUI{
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0.f, NavHeight + 20, SCREEN_WIDTH, 250)];
    [self.view addSubview:headView];
    headView.backgroundColor = [UIColor whiteColor];
    UIView * viewX = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0, SCREEN_WIDTH, 0.5)];
    [headView addSubview:viewX];
    viewX.backgroundColor = [ResourceManager color_5];
    NSArray * titleArr = @[@"原贷款金额",@"原贷款期限",@"原贷款利率",@"第一次还款时间",@"预计提前还款时间"];
    for (int i = 0; i < titleArr.count; i++) {
        UIView * viewX = [[UIView alloc]initWithFrame:CGRectMake(0.f, 50 * (i + 1) - 0.5, SCREEN_WIDTH, 0.5)];
        [headView addSubview:viewX];
        viewX.backgroundColor = [ResourceManager color_5];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 50 * i, 130, 50)];
        [headView addSubview:label];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = UIColorFromRGB(0x333333);
        label.text = titleArr[i];
    }
    UIFont * font = [UIFont systemFontOfSize:13];
    UIColor * color = UIColorFromRGB(0xfc7637);
    UIColor * color_2 = UIColorFromRGB(0x333333);
    _MoneyField = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 200.f, 0.f, 160.f, 50.f)];
    [headView addSubview:_MoneyField];
    _MoneyField.font = font;
    _MoneyField.textColor = color_2;
    _MoneyField.textAlignment = NSTextAlignmentRight;
    _MoneyField.placeholder = @"请输入金额 ";
    _MoneyField.delegate = self;
    _MoneyField.keyboardType = UIKeyboardTypeNumberPad;
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 35.f, 0, 30, 50)];
    label.font = font;
    label.textColor = UIColorFromRGB(0x333333);
    label.text = @"万元";
    label.textAlignment = NSTextAlignmentRight;
    [headView addSubview:label];
    _AheadLabel_1 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 50, 90, 50)];
    [headView addSubview:_AheadLabel_1];
    _AheadLabel_1.font = font;
    _AheadLabel_1.textColor = color;
    _AheadLabel_1.textAlignment = NSTextAlignmentRight;
    _AheadLabel_1.text = @"10年(120期)";
    _AheadLabel_2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 190, 100, 180, 50)];
    [headView addSubview:_AheadLabel_2];
    _AheadLabel_2.font = font;
    _AheadLabel_2.textColor = color;
    _AheadLabel_2.textAlignment = NSTextAlignmentRight;
    _AheadLabel_2.text = @"2015/10/24 利率:0.049";
    _AheadLabel_3 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 190, 150, 180, 50)];
    [headView addSubview:_AheadLabel_3];
    _AheadLabel_3.font = font;
    _AheadLabel_3.textColor = color;
    _AheadLabel_3.textAlignment = NSTextAlignmentRight;
    _AheadLabel_3.text = @"2015/10";
    _AheadLabel_4 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 190, 200, 180, 50)];
    [headView addSubview:_AheadLabel_4];
    _AheadLabel_4.font = font;
    _AheadLabel_4.textColor = color;
    _AheadLabel_4.textAlignment = NSTextAlignmentRight;
    _AheadLabel_4.text = @"2016/10";
    UIButton * AheadBtn_1 = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 150.f, 50, 150, 50)];
    [headView addSubview:AheadBtn_1];
    [AheadBtn_1 addTarget:self action:@selector(aheadBtn_1) forControlEvents:UIControlEventTouchUpInside];
    UIButton * AheadBtn_2 = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 150.f, 100, 150, 50)];
    [headView addSubview:AheadBtn_2];
    [AheadBtn_2 addTarget:self action:@selector(aheadBtn_2) forControlEvents:UIControlEventTouchUpInside];
    UIButton * AheadBtn_3 = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 150.f, 150, 150, 50)];
    [headView addSubview:AheadBtn_3];
    [AheadBtn_3 addTarget:self action:@selector(aheadBtn_3) forControlEvents:UIControlEventTouchUpInside];
    UIButton * AheadBtn_4 = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 150.f, 200, 150, 50)];
    [headView addSubview:AheadBtn_4];
    [AheadBtn_4 addTarget:self action:@selector(aheadBtn_4) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * resultBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(headView.frame) + 30, SCREEN_WIDTH - 30, 45.f)];
    [self.view addSubview:resultBtn];
    resultBtn.backgroundColor = UIColorFromRGB(0xfc7637);
    resultBtn.cornerRadius = 5;
    [resultBtn setTitle:@"计算结果" forState:UIControlStateNormal];
    [resultBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    resultBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [resultBtn addTarget:self action:@selector(resultBtn) forControlEvents:UIControlEventTouchUpInside];
    [self AheadPickUI_1];
    [self AheadPickUI_2];
    [self AheadPickUI_3];
    [self AheadPickUI_4];
}
-(void)AheadPickUI_1{
    _AheadView_1 = [[UIView alloc]initWithFrame:CGRectMake(0.f, SCREEN_HEIGHT - 180.f, SCREEN_WIDTH,180.f)];
    [self.view addSubview:_AheadView_1];
    _AheadView_1.backgroundColor = [UIColor whiteColor];
    _AheadPickView_1 = [[UIPickerView alloc]initWithFrame:CGRectMake(0.f, 30.f, SCREEN_WIDTH, 150.f)];
    _AheadPickView_1.delegate = self;
    _AheadPickView_1.dataSource = self;
    _AheadPickView_1.tag = 1;
    _AheadPickView_1.backgroundColor = [UIColor whiteColor];
    [_AheadView_1 addSubview:_AheadPickView_1];
    UIView * titleView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, 30.f)];
    [_AheadView_1 addSubview:titleView];
    titleView.backgroundColor = UIColorFromRGB(0xeaeaea);
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 -50.f, 0.f, 100.f, 30.f)];
    [_AheadView_1 addSubview:titleLabel];
    titleLabel.text = @"贷款期限";
    titleLabel.font = [UIFont systemFontOfSize:14];
    //居中
    titleLabel.textAlignment = NSTextAlignmentCenter;
    UIButton * finishBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 60.f, 0.f, 60.f, 30.f)];
    [titleView addSubview:finishBtn];
    [finishBtn addTarget:self action:@selector(finishBtn) forControlEvents:UIControlEventTouchUpInside];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    finishBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [finishBtn setTitleColor:UIColorFromRGB(0x2faaf7) forState:UIControlStateNormal];
    //隐藏选择器
    _AheadView_1.hidden =YES;
    _AheadPickArr_1 = @[@"1年(12期)",@"2年(24期)",@"3年(36期)",@"4年(48期)",@"5年(60期)",@"6年(72期)",@"7年(84期)",@"8年(96期)",@"9年(108期)",@"10年(120期)",
                      @"11年(132期)",@"12年(144期)",@"13年(156期)",@"14年(168期)",@"15年(180期)",@"16年(192期)",@"17年(204期)",@"18年(216期)",@"19年(228期)",@"20年(240期)",
                      @"21年(252期)",@"22年(264期)",@"23年(276期)",@"24年(288期)",@"25年(300期)",@"26年(312期)",@"27年(324期)",@"28年(336期)",@"29年(348期)",@"30年(360期)"];
    [_AheadPickView_1 selectRow:9 inComponent:0 animated:YES];
}
-(void)AheadPickUI_2{
    _AheadView_2 = [[UIView alloc]initWithFrame:CGRectMake(0.f, SCREEN_HEIGHT - 180.f, SCREEN_WIDTH,180.f)];
    [self.view addSubview:_AheadView_2];
    _AheadView_2.backgroundColor = [UIColor whiteColor];
    _AheadPickView_2 = [[UIPickerView alloc]initWithFrame:CGRectMake(0.f, 30.f, SCREEN_WIDTH, 150.f)];
    _AheadPickView_2.delegate = self;
    _AheadPickView_2.dataSource = self;
    _AheadPickView_2.tag = 2;
    _AheadPickView_2.backgroundColor = [UIColor whiteColor];
    [_AheadView_2 addSubview:_AheadPickView_2];
    UIView * titleView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, 30.f)];
    [_AheadView_2 addSubview:titleView];
    titleView.backgroundColor = UIColorFromRGB(0xeaeaea);
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 -50.f, 0.f, 100.f, 30.f)];
    [_AheadView_2 addSubview:titleLabel];
    titleLabel.text = @"贷款期限";
    titleLabel.font = [UIFont systemFontOfSize:14];
    //居中
    titleLabel.textAlignment = NSTextAlignmentCenter;
    UIButton * finishBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 60.f, 0.f, 60.f, 30.f)];
    [titleView addSubview:finishBtn];
    [finishBtn addTarget:self action:@selector(finishBtn) forControlEvents:UIControlEventTouchUpInside];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    finishBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [finishBtn setTitleColor:UIColorFromRGB(0x2faaf7) forState:UIControlStateNormal];
    //隐藏选择器
    _AheadView_2.hidden =YES;
    _AheadPickArr_2 = @[@"2015/10/24 利率:0.049",@"2015/8/26 利率:0.0515",@"2015/6/28 利率:0.054",@"2015/5/11 利率:0.0565",@"2015/3/11 利率:0.0774",
                        @"2014/11/22 利率:0.0615",@"2012/7/6 利率:0.0655",@"2012/6/8 利率:0.068",@"2011/7/7 利率:0.0705",@"2011/4/6 利率:0.068",
                        @"2011/2/9 利率:0.066",@"2010/12/26 利率:0.064",@"2010/10/20 利率:0.0614",@"2008/12/23 利率:0.0594",@"2008/11/27 利率:0.0612",
                        @"2008/10/30 利率:0.072",@"2008/10/9 利率:0.0747",@"2008/9/16 利率:0.0774",@"2007/12/21 利率:0.0783",@"2007/9/15 利率:0.0783",
                        @"2007/8/22 利率:0.0756",@"2007/7/21 利率:0.0738",@"2007/5/19 利率:0.0720",@"2006/8/19 利率:0.0684",@"2006/4/28 利率:0.0639",
                        @"2004/10/29 利率:0.0612",@"2002/2/21 利率:0.0576",@"1999/6/10 利率:0.0621",@"1998/12/7 利率:0.0756",@"1998/7/1 利率:0.0801",
                        @"1998/3/25 利率:0.1035",@"1997/10/23 利率:0.1053",@"1996/8/23 利率:0.1242",@"1996/5/1 利率:0.1512"];
    [_AheadPickView_2 selectRow:0 inComponent:0 animated:YES];
}
-(void)AheadPickUI_3{
    _AheadView_3 = [[UIView alloc]initWithFrame:CGRectMake(0.f, SCREEN_HEIGHT - 180.f, SCREEN_WIDTH,180.f)];
    [self.view addSubview:_AheadView_3];
    _AheadView_3.backgroundColor = [UIColor whiteColor];
    _AheadPickView_3 = [[UIPickerView alloc]initWithFrame:CGRectMake(0.f, 30.f, SCREEN_WIDTH, 150.f)];
    _AheadPickView_3.delegate = self;
    _AheadPickView_3.dataSource = self;
    _AheadPickView_3.tag = 3;
    _AheadPickView_3.backgroundColor = [UIColor whiteColor];
    [_AheadView_3 addSubview:_AheadPickView_3];
    UIView * titleView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, 30.f)];
    [_AheadView_3 addSubview:titleView];
    titleView.backgroundColor = UIColorFromRGB(0xeaeaea);
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 -50.f, 0.f, 100.f, 30.f)];
    [_AheadView_3 addSubview:titleLabel];
    titleLabel.text = @"贷款期限";
    titleLabel.font = [UIFont systemFontOfSize:14];
    //居中
    titleLabel.textAlignment = NSTextAlignmentCenter;
    UIButton * finishBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 60.f, 0.f, 60.f, 30.f)];
    [titleView addSubview:finishBtn];
    [finishBtn addTarget:self action:@selector(finishBtn) forControlEvents:UIControlEventTouchUpInside];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    finishBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [finishBtn setTitleColor:UIColorFromRGB(0x2faaf7) forState:UIControlStateNormal];
    //隐藏选择器
    _AheadView_3.hidden =YES;
    _AheadPickArr_3_1 = @[@"1995",@"1996",@"1997",@"1998",@"1999",@"2000",@"2001",@"2002",@"2003",@"2004",@"2005",
                          @"2006",@"2007",@"2008",@"2009",@"2010",@"2011",@"2012",@"2013",@"2014",@"2015",@"2016",@"2017"];
    _AheadPickArr_3_2 = @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12"];
    [_AheadPickView_3 selectRow:20 inComponent:0 animated:YES];
    [_AheadPickView_3 selectRow:9 inComponent:1 animated:YES];
    _aheadStr_1 = _AheadPickArr_3_1[20];
    _aheadStr_2 = _AheadPickArr_3_2[9];
}
-(void)AheadPickUI_4{
    _AheadView_4 = [[UIView alloc]initWithFrame:CGRectMake(0.f, SCREEN_HEIGHT - 180.f, SCREEN_WIDTH,180.f)];
    [self.view addSubview:_AheadView_4];
    _AheadView_4.backgroundColor = [UIColor whiteColor];
    _AheadPickView_4 = [[UIPickerView alloc]initWithFrame:CGRectMake(0.f, 30.f, SCREEN_WIDTH, 150.f)];
    _AheadPickView_4.delegate = self;
    _AheadPickView_4.dataSource = self;
    _AheadPickView_4.tag = 4;
    _AheadPickView_4.backgroundColor = [UIColor whiteColor];
    [_AheadView_4 addSubview:_AheadPickView_4];
    UIView * titleView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, 30.f)];
    [_AheadView_4 addSubview:titleView];
    titleView.backgroundColor = UIColorFromRGB(0xeaeaea);
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 -50.f, 0.f, 100.f, 30.f)];
    [_AheadView_4 addSubview:titleLabel];
    titleLabel.text = @"贷款期限";
    titleLabel.font = [UIFont systemFontOfSize:14];
    //居中
    titleLabel.textAlignment = NSTextAlignmentCenter;
    UIButton * finishBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 60.f, 0.f, 60.f, 30.f)];
    [titleView addSubview:finishBtn];
    [finishBtn addTarget:self action:@selector(finishBtn) forControlEvents:UIControlEventTouchUpInside];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    finishBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [finishBtn setTitleColor:UIColorFromRGB(0x2faaf7) forState:UIControlStateNormal];
    //隐藏选择器
    _AheadView_4.hidden =YES;
    _AheadPickArr_4_1 = @[@"2013",@"2014",@"2015",@"2016",@"2017",@"2018",@"2019"];
    _AheadPickArr_4_2 = @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12"];
    [_AheadPickView_4 selectRow:3 inComponent:0 animated:YES];
    [_AheadPickView_4 selectRow:9 inComponent:1 animated:YES];
    _aheadStr_4 = _AheadPickArr_4_1[3];
    _aheadStr_5 = _AheadPickArr_4_2[9];
}
-(void)finishBtn
{   //隐藏选择器
    _AheadView_1.hidden =YES;
    _AheadView_2.hidden =YES;
    _AheadView_3.hidden =YES;
    _AheadView_4.hidden =YES;
}
-(void)aheadBtn_1{
    [self.view endEditing:YES];
    _AheadView_1.hidden =NO;
    _AheadView_2.hidden =YES;
    _AheadView_3.hidden =YES;
    _AheadView_4.hidden =YES;
}
-(void)aheadBtn_2{
    [self.view endEditing:YES];
    _AheadView_1.hidden =YES;
    _AheadView_2.hidden =NO;
    _AheadView_3.hidden =YES;
    _AheadView_4.hidden =YES;
}
-(void)aheadBtn_3{
    [self.view endEditing:YES];
    _AheadView_1.hidden =YES;
    _AheadView_2.hidden =YES;
    _AheadView_3.hidden =NO;
    _AheadView_4.hidden =YES;
}
-(void)aheadBtn_4{
    [self.view endEditing:YES];
    _AheadView_1.hidden =YES;
    _AheadView_2.hidden =YES;
    _AheadView_3.hidden =YES;
    _AheadView_4.hidden =NO;
}
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

-(void)resultBtn{
    [self.view endEditing:YES];
    _AheadView_1.hidden =YES;
    _AheadView_2.hidden =YES;
    _AheadView_3.hidden =YES;
    _AheadView_4.hidden =YES;
    int num_1 = 0;//原贷款期限
    CGFloat num_2 = 0.0;//利率
    int count_1 = 0;
    NSArray * rateArr = @[@"0.049",@"0.0515",@"0.054",@"0.0565",@"0.0774",@"0.0615",@"0.0655",@"0.068",@"0.0705",@"0.068",@"0.066",@"0.064",
                          @"0.0614",@"0.0594",@"0.0612",@"0.072",@"0.0747",@"0.0774",@"0.0783",@"0.0783",@"0.0756",@"0.0738",@"0.0720",
                          @"0.0684",@"0.0639",@"0.0612",@"0.0576",@"0.0621",@"0.0756",@"0.0801",@"0.1035",@"0.1053",@"0.1242",@"0.1512"];
    for (NSString * str in _AheadPickArr_2) {
        if ([_AheadLabel_2.text isEqualToString:str]) {
            num_2 = [rateArr[count_1] floatValue]/12;
        }
        count_1 ++;
    }
    NSArray * limitArr = @[@"12",@"24",@"36",@"48",@"60",@"72",@"84",@"96",@"108",@"120",
                           @"132",@"144",@"156",@"168",@"180",@"192",@"204",@"216",@"228",@"240",
                           @"252",@"264",@"276",@"288",@"300",@"312",@"324",@"336",@"348",@"360"];
    int count_2 = 0;
    for (NSString * str in _AheadPickArr_1) {
        if ([_AheadLabel_1.text isEqualToString:str]) {
            num_1 = [limitArr[count_2] intValue];
        }
        count_2 ++;
    }
    //已还贷期数
    int num_3 = ([_aheadStr_4 intValue] * 12 + [_aheadStr_5 intValue]) - ([_aheadStr_1 intValue] * 12 + [_aheadStr_2 intValue]);
    //原月还款额
    CGFloat num_4 = ([_MoneyField.text intValue] * 10000) * (num_2 * (pow((1 + num_2), num_1)))/(pow(1 + num_2, num_1) - 1);
    //原最后还款期
    NSString * limitStr ;
    if ([_aheadStr_2 intValue] - 1 == 0) {
        limitStr = [NSString stringWithFormat:@"%d年12月",[_aheadStr_1 intValue] + (num_1/12 - 1)];
    }else{
        limitStr = [NSString stringWithFormat:@"%d年%d月",[_aheadStr_1 intValue] + num_1/12 ,[_aheadStr_2 intValue] - 1];
    }
    //已还款总额
    NSString * totalStr = [NSString stringWithFormat:@"%.2f元",num_3 * num_4];
    CGFloat yhlxs = 0.0;
    CGFloat yhbjs = 0.0;
    for (int i = 0; i < num_3; i++) {
        yhlxs = yhlxs + ([_MoneyField.text intValue] * 10000 - yhbjs) * num_2;
        yhbjs = yhbjs + num_4 - ([_MoneyField.text intValue] * 10000 - yhbjs) * num_2;
    }
    //该月一次还款额
    CGFloat gyychke = ([_MoneyField.text intValue] * 10000 - yhbjs) * (1 + num_2);
    //节省利息支出
    CGFloat jslxzc = num_4 * num_1 - num_3 * num_4 - gyychke;
    NSArray * resultArr = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%.2f元",num_4],totalStr,[NSString stringWithFormat:@"%.2f元",gyychke],[NSString stringWithFormat:@"%.2f元",jslxzc],limitStr,[NSString stringWithFormat:@"%@年%@月",_aheadStr_4,_aheadStr_5], nil];
    if(![self isPureInt:_MoneyField.text]){
        [MBProgressHUD showErrorWithStatus:@"输入金额有误" toView:self.view];
        return;
    }
     if (_MoneyField.text.length == 0){
        [MBProgressHUD showErrorWithStatus:@"信息不完整" toView:self.view];
        return;
     }else if ([_aheadStr_1 intValue] > [_aheadStr_4 intValue]){
         [MBProgressHUD showErrorWithStatus:@"第一次还款时间需在预计还款之前" toView:self.view];
         return;
     }else if ([_aheadStr_1 intValue] == [_aheadStr_4 intValue]){
         if ([_aheadStr_2 intValue] > [_aheadStr_5 intValue]) {
             [MBProgressHUD showErrorWithStatus:@"第一次还款时间需在预计还款之前" toView:self.view];
             return;
         }
     }else{
        ScotDetailsViewController * sortDetails = [[ScotDetailsViewController alloc]init];
        sortDetails.moneyArr = resultArr;
        sortDetails.titleArr = @[@"原月还款额",@"已还款总额",@"该月一次还款额",@"节省利息支出",@"原最后还款期限",@"新的还款期"];
        [self.navigationController pushViewController:sortDetails animated:YES];
    }
}

#pragma mark - Picker View Data source
//列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (pickerView.tag == 1 || pickerView.tag == 2) {
        return 1;
    }else{
        return 2;
    }
}
//行
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView.tag == 1 ) {
        return _AheadPickArr_1.count;
    }else if (pickerView.tag == 2){
        return _AheadPickArr_2.count;
    }else if (pickerView.tag == 3){
        if (component == 0) {
            return _AheadPickArr_3_1.count;
        }else{
            return _AheadPickArr_3_2.count;
        }
    }else{
        if (component == 0) {
            return _AheadPickArr_4_1.count;
        }else{
            return _AheadPickArr_4_2.count;
        }
    }
}
//返回row高度
-(CGFloat) pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.f;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.font = [UIFont systemFontOfSize:15];
    }
    pickerLabel.textAlignment = NSTextAlignmentCenter;
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}
#pragma mark- Picker View Delegate
//选中行触发事件
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView.tag == 1) {
        _AheadLabel_1.text = [_AheadPickArr_1 objectAtIndex:row];
    }else if(pickerView.tag == 2){
        _AheadLabel_2.text = [_AheadPickArr_2 objectAtIndex:row];
    }else if(pickerView.tag == 3){
        if (component == 0) {
            _aheadStr_1 = [_AheadPickArr_3_1 objectAtIndex:row];
        }else if (component == 1){
            _aheadStr_2 = [_AheadPickArr_3_2 objectAtIndex:row];
        }
        _AheadLabel_3.text = [NSString stringWithFormat:@"%@/%@",_aheadStr_1,_aheadStr_2];
    }else if(pickerView.tag == 4){
        if (component == 0) {
            _aheadStr_4 = [_AheadPickArr_4_1 objectAtIndex:row];
        }else if (component == 1){
            _aheadStr_5 = [_AheadPickArr_4_2 objectAtIndex:row];
        }
        _AheadLabel_4.text = [NSString stringWithFormat:@"%@/%@",_aheadStr_4,_aheadStr_5];
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView.tag == 1) {
        return [_AheadPickArr_1 objectAtIndex:row];
    }else if(pickerView.tag == 2){
        return [_AheadPickArr_2 objectAtIndex:row];
    }else if(pickerView.tag == 3){
        if (component == 0) {
            return [_AheadPickArr_3_1 objectAtIndex:row];
        }else {
            return [_AheadPickArr_3_2 objectAtIndex:row];
        }
    }else{
        if (component == 0) {
            return [_AheadPickArr_4_1 objectAtIndex:row];
        }else {
            return [_AheadPickArr_4_2 objectAtIndex:row];
        }
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
