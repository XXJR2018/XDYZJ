//
//  PurchaseAbilityViewController.m
//  XXJR
//
//  Created by xxjr03 on 16/6/22.
//  Copyright © 2016年 Cary. All rights reserved.
//

#import "PurchaseAbilityViewController.h"
#import "ScotDetailsViewController.h"
@interface PurchaseAbilityViewController ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    UITextField * _arceField;
    UITextField * _MoneyField;
    UITextField * _MoneyField_2;
    UILabel * _limitLabel;
    UILabel * _rateLabel;
    UIPickerView * _limitPickView;
    UIPickerView * _ratePickView;
    UIView * _limitView;
    UIView * _rateView;
    NSArray * _limitPickArr;
    NSArray * _ratePickArr;
}
@end

@implementation PurchaseAbilityViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"购房能力计算器"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"购房能力计算器"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNaviBarViewWithTitle:@"购房能力计算器"];
    self.view.backgroundColor = [ResourceManager viewBackgroundColor];
    [self layoutUI];
    //添加手势点击空白处隐藏键盘
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchViewKeyBoard)];
    gesture.numberOfTapsRequired  = 1;
    [self.view addGestureRecognizer:gesture];
}
//添加手势点击空白处隐藏键盘
-(void)TouchViewKeyBoard
{
    //隐藏选择器
    _limitView.hidden =YES;
    _rateView.hidden =YES;
    [self.view endEditing:YES];
}
-(void)layoutUI{
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0.f, NavHeight + 20, SCREEN_WIDTH, 250)];
    [self.view addSubview:headView];
    headView.backgroundColor = [UIColor whiteColor];
    UIView * viewX = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0, SCREEN_WIDTH, 0.5)];
    [headView addSubview:viewX];
    viewX.backgroundColor = [ResourceManager color_5];
    NSArray * titleArr = @[@"建筑面积",@"首付资金",@"最高每月还款金额",@"期望还款年限",@"贷款类型"];
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
    _arceField = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 200.f, 0.f, 160.f, 50.f)];
    [headView addSubview:_arceField];
    _arceField.font = font;
    _arceField.textColor = color_2;
    _arceField.textAlignment = NSTextAlignmentRight;
    _arceField.placeholder = @"请输入建筑面积 ";
    _arceField.delegate = self;
    _arceField.keyboardType = UIKeyboardTypeNumberPad;
    UILabel * label_1 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 35, 0, 30, 50)];
    label_1.font = font;
    label_1.textColor = color_2;
    label_1.text = @"㎡";
    label_1.textAlignment = NSTextAlignmentRight;
    [headView addSubview:label_1];
    _MoneyField = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 200.f, 50.f, 160.f, 50.f)];
    [headView addSubview:_MoneyField];
    _MoneyField.font = font;
    _MoneyField.textColor = color_2;
    _MoneyField.textAlignment = NSTextAlignmentRight;
    _MoneyField.placeholder = @"请输入金额 ";
    _MoneyField.delegate = self;
    _MoneyField.keyboardType = UIKeyboardTypeNumberPad;
    UILabel * label_2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 35.f, 50.f, 30, 50)];
    label_2.font = font;
    label_2.textColor = color_2;
    label_2.text = @"万元";
    label_2.textAlignment = NSTextAlignmentRight;
    [headView addSubview:label_2];
    _MoneyField_2 = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 200.f, 100.f, 160.f, 50.f)];
    [headView addSubview:_MoneyField_2];
    _MoneyField_2.font = font;
    _MoneyField_2.textColor = color_2;
    _MoneyField_2.textAlignment = NSTextAlignmentRight;
    _MoneyField_2.placeholder = @"请输入金额 ";
    _MoneyField_2.delegate = self;
    _MoneyField_2.keyboardType = UIKeyboardTypeNumberPad;
    UILabel * label_3 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 35.f, 100.f, 30, 50)];
    label_3.font = font;
    label_3.textColor = color_2;
    label_3.text = @"元";
    label_3.textAlignment = NSTextAlignmentRight;
    [headView addSubview:label_3];
    _limitLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 150, 90, 50)];
    [headView addSubview:_limitLabel];
    _limitLabel.font = font;
    _limitLabel.textColor = color;
    _limitLabel.textAlignment = NSTextAlignmentRight;
    _limitLabel.text = @"10年(120期)";
    _rateLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 200, 90, 50)];
    [headView addSubview:_rateLabel];
    _rateLabel.font = font;
    _rateLabel.textColor = color;
    _rateLabel.textAlignment = NSTextAlignmentRight;
    _rateLabel.text = @"商业贷款";
    UIButton * limitBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 150.f, 150, 150, 50)];
    [headView addSubview:limitBtn];
    [limitBtn addTarget:self action:@selector(limitBtn) forControlEvents:UIControlEventTouchUpInside];
    UIButton * rateBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 150.f, 200, 150, 50)];
    [headView addSubview:rateBtn];
    [rateBtn addTarget:self action:@selector(rateBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * resultBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(headView.frame) + 50, SCREEN_WIDTH - 30, 45.f)];
    [self.view addSubview:resultBtn];
    resultBtn.backgroundColor = UIColorFromRGB(0xfc7637);
    resultBtn.cornerRadius = 5;
    [resultBtn setTitle:@"计算结果" forState:UIControlStateNormal];
    [resultBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    resultBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [resultBtn addTarget:self action:@selector(resultBtn) forControlEvents:UIControlEventTouchUpInside];
    [self limitPickViewUI];
    [self ratePickViewUI];
}
-(void)limitPickViewUI{
    _limitView = [[UIView alloc]initWithFrame:CGRectMake(0.f, SCREEN_HEIGHT - 180.f, SCREEN_WIDTH,180.f)];
    [self.view addSubview:_limitView];
    _limitView.backgroundColor = [UIColor whiteColor];
    _limitPickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0.f, 30.f, SCREEN_WIDTH, 150.f)];
    _limitPickView.delegate = self;
    _limitPickView.dataSource = self;
    _limitPickView.tag = 0;
    _limitPickView.backgroundColor = [UIColor whiteColor];
    [_limitView addSubview:_limitPickView];
    UIView * titleView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, 30.f)];
    [_limitView addSubview:titleView];
    titleView.backgroundColor = UIColorFromRGB(0xeaeaea);
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 -50.f, 0.f, 100.f, 30.f)];
    [_limitView addSubview:titleLabel];
    titleLabel.text = @"期望还款年限";
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
    _limitView.hidden =YES;
    _limitPickArr = @[@"1年(12期)",@"2年(24期)",@"3年(36期)",@"4年(48期)",@"5年(60期)",@"6年(72期)",@"7年(84期)",@"8年(96期)",@"9年(108期)",@"10年(120期)",
                      @"11年(132期)",@"12年(144期)",@"13年(156期)",@"14年(168期)",@"15年(180期)",@"16年(192期)",@"17年(204期)",@"18年(216期)",@"19年(228期)",@"20年(240期)",
                      @"21年(252期)",@"22年(264期)",@"23年(276期)",@"24年(288期)",@"25年(300期)",@"26年(312期)",@"27年(324期)",@"28年(336期)",@"29年(348期)",@"30年(360期)"];
    [_limitPickView selectRow:9 inComponent:0 animated:YES];
}
-(void)ratePickViewUI{
    _rateView = [[UIView alloc]initWithFrame:CGRectMake(0.f, SCREEN_HEIGHT - 180.f, SCREEN_WIDTH,180.f)];
    [self.view addSubview:_rateView];
    _rateView.backgroundColor = [UIColor whiteColor];
    _ratePickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0.f, 30.f, SCREEN_WIDTH, 150.f)];
    _ratePickView.delegate = self;
    _ratePickView.dataSource = self;
    _ratePickView.tag = 1;
    _ratePickView.backgroundColor = [UIColor whiteColor];
    [_rateView addSubview:_ratePickView];
    UIView * titleView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, 30.f)];
    [_rateView addSubview:titleView];
    titleView.backgroundColor = UIColorFromRGB(0xeaeaea);
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 -50.f, 0.f, 100.f, 30.f)];
    [_rateView addSubview:titleLabel];
    titleLabel.text = @"贷款类型";
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
    _rateView.hidden =YES;
    _ratePickArr = @[@"商业贷款",@"公积金贷款"];
    [_ratePickView selectRow:0 inComponent:0 animated:YES];
}
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
-(void)finishBtn
{
    //隐藏选择器
    _limitView.hidden =YES;
    _rateView.hidden =YES;
}
-(void)limitBtn{
    [self.view endEditing:YES];
    _limitView.hidden = NO;
    _rateView.hidden =YES;
}
-(void)rateBtn{
    [self.view endEditing:YES];
    _limitView.hidden = YES;
    _rateView.hidden =NO;
}
-(void)resultBtn{
    int count = 0;
    CGFloat rateNum = 0.0;
    for (NSString * limit in _limitPickArr) {
        count ++;
        if ([_limitLabel.text isEqualToString:limit]) {
            break;
        }
    }
    int limitNum = 12 * count;
    if ([_rateLabel.text isEqualToString:@"商业贷款"]) {
        if (count == 1) {
            rateNum = 0.0435/12;
        }else if (count >1 && count <=5){
            rateNum = 0.0475/12;
        }else{
            rateNum = 0.0490/12;
        }
    }else if ([_rateLabel.text isEqualToString:@"公积金贷款"]){
        if (count <= 5) {
            rateNum = 0.0275/12;
        }else if (count > 5){
            rateNum = 0.0375/12;
        }
    }
    CGFloat num_1 = ([_MoneyField_2.text intValue] * (pow(1 + rateNum, limitNum) - 1))/(rateNum * (pow(1 + rateNum, limitNum))) + [_MoneyField.text intValue] * 10000;
    CGFloat num_2 = [[NSString stringWithFormat:@"%.2f",num_1/[_arceField.text intValue]] floatValue];
    NSArray * resultArr = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%.2f万元",num_1/10000],[NSString stringWithFormat:@"%.2f元",num_2], nil];
    if(![self isPureInt:_arceField.text] || ![self isPureInt:_MoneyField.text] ||![self isPureInt:_MoneyField_2.text]){
        [MBProgressHUD showErrorWithStatus:@"输入金额有误" toView:self.view];
        return;
    }
    if (_arceField.text.length == 0) {
        [MBProgressHUD showErrorWithStatus:@"信息不完整" toView:self.view];
        return;
    }else if (_MoneyField.text.length == 0){
        [MBProgressHUD showErrorWithStatus:@"信息不完整" toView:self.view];
        return;
    }else if (_MoneyField_2.text.length == 0){
        [MBProgressHUD showErrorWithStatus:@"信息不完整" toView:self.view];
        return;
    }else{
        ScotDetailsViewController * sortDetails = [[ScotDetailsViewController alloc]init];
        sortDetails.moneyArr = resultArr;
        sortDetails.titleArr = @[@"您可购买的房屋总价",@"您可购买的房屋单价"];
        [self.navigationController pushViewController:sortDetails animated:YES];
    }
}
#pragma mark - Picker View Data source
//列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
//行
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView.tag == 0) {
        return _limitPickArr.count;
    }else {
        return _ratePickArr.count;
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
    if (pickerView.tag == 0) {
        _limitLabel.text = [_limitPickArr objectAtIndex:row];
        
    }else{
        _rateLabel.text = [_ratePickArr objectAtIndex:row];
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView.tag == 0) {
        return [_limitPickArr objectAtIndex:row];
    }else{
        return [_ratePickArr objectAtIndex:row];
    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
