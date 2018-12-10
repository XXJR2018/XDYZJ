//
//  WageViewController.m
//  XXJR
//
//  Created by xxjr03 on 16/6/21.
//  Copyright © 2016年 Cary. All rights reserved.
//

#import "WageViewController.h"
#import "ScotDetailsViewController.h"
@interface WageViewController ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    UITextField * _MoneyField;
    UILabel * _limitLabel;
    UIPickerView * _limitPickView;
    UIView * _limitView;
    NSArray * _limitPickArr;
    UIView * _customView;
    UITextField * _custField_1;
    UITextField * _custField_2;
    UITextField * _custField_3;
    UITextField * _custField_4;
    UITextField * _custField_5;
    UITextField * _custField_6;
    UITextField * _custField_7;
    UITextField * _custField_8;
    UITextField * _custField_9;
    UITextField * _custField_10;
    UITextField * _custField_11;
    UITextField * _custField_12;
    UITextField * _custField_13;
}
@end

@implementation WageViewController

-(void)addButtonView{
    
    self.tabBarController.tabBar.hidden = YES;
    
    [self.view addSubview:self.tabBar];
}

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
    self.hideBackButton = YES;
    [self layoutNaviBarViewWithTitle:@"工资计算器"];
    self.view.backgroundColor = [ResourceManager viewBackgroundColor];
    [self layoutUI];
    //添加手势点击空白处隐藏键盘
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchViewKeyBoard)];
    gesture.numberOfTapsRequired  = 1;
    [self.view addGestureRecognizer:gesture];
}
//添加手势点击空白处隐藏键盘
-(void)TouchViewKeyBoard
{    //隐藏选择器
    _limitView.hidden =YES;
    [self resumeView];
    [self.view endEditing:YES];
}
-(void)layoutUI{
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0.f, NavHeight + 20, SCREEN_WIDTH, 100)];
    [self.view addSubview:headView];
    headView.backgroundColor = [UIColor whiteColor];
    UIView * viewX = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0, SCREEN_WIDTH, 0.5)];
    [headView addSubview:viewX];
    viewX.backgroundColor = [ResourceManager color_5];
    NSArray * titleArr = @[@"工资金额",@"各项社会保障费"];
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
    UIColor * color = [ResourceManager mainColor];//UIColorFromRGB(0xfc7637);
    UIColor * color_2 = UIColorFromRGB(0x333333);
    _MoneyField = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 200.f, 0.f, 170.f, 50.f)];
    [headView addSubview:_MoneyField];
    _MoneyField.font = font;
    _MoneyField.textColor = color_2;
    _MoneyField.textAlignment = NSTextAlignmentRight;
    _MoneyField.placeholder = @"请输入金额";
    _MoneyField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 25.f, 0.f, 15, 50)];
    label.font = font;
    label.textColor = color_2;
    label.text = @"元";
    label.textAlignment = NSTextAlignmentRight;
    [headView addSubview:label];
    _limitLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 50, 90, 50)];
    [headView addSubview:_limitLabel];
    _limitLabel.font = font;
    _limitLabel.textColor = color;
    _limitLabel.textAlignment = NSTextAlignmentRight;
    _limitLabel.text = @"深圳市";
    UIButton * limitBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 150.f, 50, 150, 50)];
    [headView addSubview:limitBtn];
    [limitBtn addTarget:self action:@selector(limitBtn) forControlEvents:UIControlEventTouchUpInside];
    UIButton * resultBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(headView.frame) + 100, SCREEN_WIDTH - 30, 45.f)];
    [self.view addSubview:resultBtn];
    resultBtn.backgroundColor = color;//UIColorFromRGB(0xfc7637);
    resultBtn.cornerRadius = 5;
    [resultBtn setTitle:@"计算税后收入" forState:UIControlStateNormal];
    [resultBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    resultBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [resultBtn addTarget:self action:@selector(resultBtn) forControlEvents:UIControlEventTouchUpInside];
    [self limitPickViewUI];
}
-(void)limitPickViewUI{
    _limitView = [[UIView alloc]initWithFrame:CGRectMake(0.f, SCREEN_HEIGHT - (180.f + TabbarHeight), SCREEN_WIDTH,180.f)];
    [self.view addSubview:_limitView];
    _limitView.backgroundColor = [UIColor whiteColor];
    _limitPickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0.f, 30.f, SCREEN_WIDTH, 150.f)];
    _limitPickView.delegate = self;
    _limitPickView.dataSource = self;
    _limitPickView.backgroundColor = [UIColor whiteColor];
    [_limitView addSubview:_limitPickView];
    UIView * titleView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, 40.f)];
    [_limitView addSubview:titleView];
    titleView.backgroundColor = UIColorFromRGB(0xeaeaea);
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 -100.f, 0.f, 200.f, 40.f)];
    [_limitView addSubview:titleLabel];
    titleLabel.text = @"所在地区社会保障";
    titleLabel.font = [UIFont systemFontOfSize:14];
    //居中
    titleLabel.textAlignment = NSTextAlignmentCenter;
    UIButton * finishBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 60.f, 0.f, 60.f,40.f)];
    [titleView addSubview:finishBtn];
    [finishBtn addTarget:self action:@selector(finishBtn) forControlEvents:UIControlEventTouchUpInside];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    finishBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [finishBtn setTitleColor:UIColorFromRGB(0x2faaf7) forState:UIControlStateNormal];
    //隐藏选择器
    _limitView.hidden =YES;
    _limitPickArr = @[@"自定义",@"深圳市",@"上海市",@"北京市",@"广州市"];
    [_limitPickView selectRow:1 inComponent:0 animated:YES];
    [self customViewUI];
}
-(void)customViewUI{
    _customView = [[UIView alloc]initWithFrame:CGRectMake(0.f, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight)];
    [self.view addSubview:_customView];
    _customView.backgroundColor = [UIColor whiteColor];
    UIFont * font = [UIFont systemFontOfSize:13];
    UIColor * color_2 = UIColorFromRGB(0x808080);
    UIColor * color_1 = UIColorFromRGB(0x333333);
    UILabel * label_1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, (SCREEN_WIDTH - 40)/3, 43)];
    [_customView addSubview:label_1];
    label_1.backgroundColor = [UIColor whiteColor];
    label_1.font = font;
    label_1.textColor = color_1;
    label_1.text = @"项目列表";
    UILabel * label_2 = [[UILabel alloc]initWithFrame:CGRectMake(20 + (SCREEN_WIDTH - 40)/3, 10, (SCREEN_WIDTH - 40)/3, 43)];
    [_customView addSubview:label_2];
    label_2.backgroundColor = [UIColor whiteColor];
    label_2.font = font;
    label_2.textColor = color_1;
    label_2.textAlignment = NSTextAlignmentCenter;
    label_2.text = @"个人";
    UILabel * label_3 = [[UILabel alloc]initWithFrame:CGRectMake(20 + (SCREEN_WIDTH - 40)/3 * 2, 10, (SCREEN_WIDTH - 40)/3, 43)];
    [_customView addSubview:label_3];
    label_3.backgroundColor = [UIColor whiteColor];
    label_3.font = font;
    label_3.textColor = color_1;
    label_3.textAlignment = NSTextAlignmentCenter;
    label_3.text = @"单位";
    UIView * viewX = [[UIView alloc]initWithFrame:CGRectMake(0.f, 53, SCREEN_WIDTH, 0.5)];
    [_customView addSubview:viewX];
    viewX.backgroundColor = [ResourceManager color_5];
    NSArray * titleArr = @[@"养老(%)",@"医疗(%)",@"失业(%)",@"工伤(%)",@"生育(%)",@"公积金(%)",@"缴费基数封顶数"];
    for (int i = 0; i < titleArr.count; i++) {
        UIView * viewX = [[UIView alloc]initWithFrame:CGRectMake(0.f,54 + 44 * (i + 1) - 0.5, SCREEN_WIDTH, 0.5)];
        [_customView addSubview:viewX];
        viewX.backgroundColor = [ResourceManager color_5];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(20 , 54 + 44 * i, (SCREEN_WIDTH - 40)/3, 44 - 0.5)];
        [_customView addSubview:label];
        label.backgroundColor = [UIColor whiteColor];
        label.font = font;
        label.textColor = color_1;
        label.text = titleArr[i];
        if (i == titleArr.count - 1) {
            label.frame = CGRectMake(20 , 54 + 44 * i, 120, 43);
        }
    }
    
    _custField_1 = [[UITextField alloc]initWithFrame:CGRectMake(20 + (SCREEN_WIDTH - 40)/3, 54, (SCREEN_WIDTH - 40)/3, 44)];
    [_customView addSubview:_custField_1];
    _custField_1.font = font;
    _custField_1.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _custField_1.textColor = color_2;
    _custField_1.textAlignment = NSTextAlignmentCenter;
    _custField_1.text = @"0.08";
    _custField_2 = [[UITextField alloc]initWithFrame:CGRectMake(20 + 2 * (SCREEN_WIDTH - 40)/3, 54, (SCREEN_WIDTH - 40)/3, 44)];
    [_customView addSubview:_custField_2];
    _custField_2.font = font;
    _custField_2.textColor = color_2;
    _custField_2.textAlignment = NSTextAlignmentCenter;
    _custField_2.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _custField_2.text = @"0.20";
    _custField_3 = [[UITextField alloc]initWithFrame:CGRectMake(20 + (SCREEN_WIDTH - 40)/3, 54 + 44 * 1, (SCREEN_WIDTH - 40)/3, 44)];
    [_customView addSubview:_custField_3];
    _custField_3.font = font;
    _custField_3.textColor = color_2;
    _custField_3.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _custField_3.text = @"0.02";
    _custField_3.textAlignment = NSTextAlignmentCenter;
    _custField_4 = [[UITextField alloc]initWithFrame:CGRectMake(20 + 2 * (SCREEN_WIDTH - 40)/3, 54 + 44 * 1, (SCREEN_WIDTH - 40)/3, 44)];
    [_customView addSubview:_custField_4];
    _custField_4.font = font;
    _custField_4.textColor = color_2;
    _custField_4.textAlignment = NSTextAlignmentCenter;
    _custField_4.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _custField_4.text = @"0.10";
    _custField_5 = [[UITextField alloc]initWithFrame:CGRectMake(20 + (SCREEN_WIDTH - 40)/3, 54 + 44 * 2, (SCREEN_WIDTH - 40)/3, 44)];
    [_customView addSubview:_custField_5];
    _custField_5.font = font;
    _custField_5.textColor = color_2;
    _custField_5.textAlignment = NSTextAlignmentCenter;
    _custField_5.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _custField_5.text = @"0.01";
    _custField_6 = [[UITextField alloc]initWithFrame:CGRectMake(20 + 2 * (SCREEN_WIDTH - 40)/3, 54 + 44 * 2, (SCREEN_WIDTH - 40)/3, 44)];
    [_customView addSubview:_custField_6];
    _custField_6.font = font;
    _custField_6.textColor = color_2;
    _custField_6.textAlignment = NSTextAlignmentCenter;
    _custField_6.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _custField_6.text = @"0.01";
    _custField_7 = [[UITextField alloc]initWithFrame:CGRectMake(20 + (SCREEN_WIDTH - 40)/3, 54 + 44 * 3, (SCREEN_WIDTH - 40)/3, 44)];
    [_customView addSubview:_custField_7];
    _custField_7.font = font;
    _custField_7.textColor = color_2;
    _custField_7.textAlignment = NSTextAlignmentCenter;
    _custField_7.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _custField_7.text = @"0.00";
    _custField_8 = [[UITextField alloc]initWithFrame:CGRectMake(20 + 2 * (SCREEN_WIDTH - 40)/3, 54 + 44 * 3, (SCREEN_WIDTH - 40)/3, 44)];
    [_customView addSubview:_custField_8];
    _custField_8.font = font;
    _custField_8.textColor = color_2;
    _custField_8.textAlignment = NSTextAlignmentCenter;
    _custField_8.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _custField_8.text = @"0.00";
    _custField_9 = [[UITextField alloc]initWithFrame:CGRectMake(20 + (SCREEN_WIDTH - 40)/3, 54 + 44 * 4, (SCREEN_WIDTH - 40)/3, 44)];
    [_customView addSubview:_custField_9];
    _custField_9.font = font;
    _custField_9.textColor = color_2;
    _custField_9.textAlignment = NSTextAlignmentCenter;
    _custField_9.delegate = self;
    _custField_9.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _custField_9.text = @"0.00";
    _custField_10 = [[UITextField alloc]initWithFrame:CGRectMake(20 + 2 * (SCREEN_WIDTH - 40)/3, 54 + 44 * 4, (SCREEN_WIDTH - 40)/3, 44)];
    [_customView addSubview:_custField_10];
    _custField_10.font = font;
    _custField_10.textColor = color_2;
    _custField_10.textAlignment = NSTextAlignmentCenter;
    _custField_10.delegate = self;
    _custField_10.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _custField_10.text = @"0.00";
    _custField_11 = [[UITextField alloc]initWithFrame:CGRectMake(20 + (SCREEN_WIDTH - 40)/3, 54 + 44 * 5, (SCREEN_WIDTH - 40)/3, 44)];
    [_customView addSubview:_custField_11];
    _custField_11.font = font;
    _custField_11.textColor = color_2;
    _custField_11.textAlignment = NSTextAlignmentCenter;
    _custField_11.delegate = self;
    _custField_11.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _custField_11.text = @"0.07";
    _custField_12 = [[UITextField alloc]initWithFrame:CGRectMake(20 + 2 * (SCREEN_WIDTH - 40)/3, 54 + 44 * 5, (SCREEN_WIDTH - 40)/3, 44)];
    [_customView addSubview:_custField_12];
    _custField_12.font = font;
    _custField_12.textColor = color_2;
    _custField_12.textAlignment = NSTextAlignmentCenter;
    _custField_12.delegate = self;
    _custField_12.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _custField_12.text = @"0.07";
    _custField_13 = [[UITextField alloc]initWithFrame:CGRectMake (150, 54 + 44 * 6, (SCREEN_WIDTH - 40)/6 * 5 - 150, 44)];
    [_customView addSubview:_custField_13];
    _custField_13.font = font;
    _custField_13.textColor = color_2;
    _custField_13.textAlignment = NSTextAlignmentRight;
    _custField_13.delegate = self;
    _custField_13.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _custField_13.text = @"15000.00";
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(20 +(SCREEN_WIDTH - 40)/6 * 5 , 54 + 44 * 6, 20, 43)];
    [_customView addSubview:label];
    label.backgroundColor = [UIColor whiteColor];
    label.font = font;
    label.textColor = color_1;
    label.text = @"元";
    label.textAlignment = NSTextAlignmentRight;
    UIButton * backBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 54+ 44 * 7 + 40, SCREEN_WIDTH - 30, 45.f)];
    [_customView addSubview:backBtn];
    backBtn.backgroundColor = [ResourceManager mainColor];//UIColorFromRGB(0xfc7637);
    backBtn.cornerRadius = 5;
    [backBtn setTitle:@"保存" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [backBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    _customView.hidden = YES;
}
-(void)finishBtn
{   //隐藏选择器
    _limitView.hidden =YES;
    if ([_limitLabel.text isEqualToString:@"自定义"]) {
        _customView.hidden = NO;
    }
}
-(void)backBtn{
    [self resumeView];
    [self.view endEditing:YES];
    _customView.hidden = YES;
}
-(void)limitBtn{
    [self.view endEditing:YES];
    _limitView.hidden = NO;
}
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
-(void)resultBtn{
    [self.view endEditing:YES];
     _limitView.hidden = YES;
    CGFloat rataNum = 0.0;
    int maxNum = 0 ;
    if ([_limitLabel.text isEqualToString:@"深圳市"]) {
        rataNum = (0.08 + 0.02 + 0.00203 + 0 + 0 + 0.05);
        maxNum = 18162;
    }else if ([_limitLabel.text isEqualToString:@"上海市"]){
        rataNum = (0.08 + 0.02 + 0.005 + 0 + 0 + 0.07);
        maxNum = 16353;
    }else if ([_limitLabel.text isEqualToString:@"北京市"]){
        rataNum = (0.08 + 0.02 + 0.002 + 0 + 0 + 0.12);
        maxNum = 19389;
    }else if ([_limitLabel.text isEqualToString:@"广州市"]){
        rataNum = (0.08 + 0.02 + 0.005 + 0 + 0 + 0.05);
        maxNum = 17424;
    }else if ([_limitLabel.text isEqualToString:@"自定义"]){
        rataNum = ([_custField_1.text floatValue] + [_custField_3.text floatValue] + [_custField_5.text floatValue] +
                   [_custField_7.text floatValue] + [_custField_9.text floatValue] + [_custField_11.text floatValue]);
        maxNum = [_custField_13.text intValue];
    }
    //五险一金
    CGFloat num_1 = 0.0;
    num_1 = [_MoneyField.text intValue] * rataNum;
    //扣个税前工资
    CGFloat num_2 = [_MoneyField.text intValue] - num_1 - 3500;
    //个税
    CGFloat num_3 = 0.0;
    //税后工资
    CGFloat num_4 = 0.0;
    if (num_2 <= 0) {
        [MBProgressHUD showErrorWithStatus:@"基准工资过低" toView:self.view];
        return;
    }
    if (num_2 > 0 && num_2 <= 1500) {
        num_3 = num_2 * 0.03 - 0;
    }else if (num_2 > 1500 && num_2 <= 4500){
        num_3 = num_2 * 0.1 - 105;
    }else if (num_2 > 4500 && num_2 <= 9000){
        num_3 = num_2 * 0.2 - 555;
    }else if (num_2 >9000 && num_2 <= 35000){
        num_3 = num_2 * 0.25 - 1005;
    }else if (num_2 > 35000 && num_2 <= 55000){
        num_3 = num_2 * 0.30 - 2755;
    }else if (num_2 > 55000 && num_2 <= 80000){
        num_3 = num_2 * 0.35 - 5505;
    }else{
        num_3 = num_2 * 0.45 - 13505;
    }
    num_4 = [_MoneyField.text intValue] - num_1 - num_3;
     NSArray * resultArr = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%.2f元",[_MoneyField.text floatValue]],[NSString stringWithFormat:@"%.2f元",num_4],[NSString stringWithFormat:@"%.2f元",num_1],[NSString stringWithFormat:@"%.2f元",num_3],[NSString stringWithFormat:@"%d元",maxNum], nil];
    if(![self isPureInt:_MoneyField.text]){
        [MBProgressHUD showErrorWithStatus:@"输入金额有误" toView:self.view];
        return;
    }
    if (_MoneyField.text.length == 0){
        [MBProgressHUD showErrorWithStatus:@"信息不完整" toView:self.view];
        return;
    }else if (rataNum < 0 || rataNum > 1){
        [MBProgressHUD showErrorWithStatus:@"五险一金税率格式不正确" toView:self.view];
        return;
    }else{
        ScotDetailsViewController * sortDetails = [[ScotDetailsViewController alloc]init];
        sortDetails.moneyArr = resultArr;
        sortDetails.titleArr = @[@"税前收入",@"税后收入",@"五险一金",@"个人所得税",@"缴费基数封顶数"];
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
        return _limitPickArr.count;
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
    _limitLabel.text = [_limitPickArr objectAtIndex:row];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [_limitPickArr objectAtIndex:row];
}
//开始编辑时,键盘遮挡文本框，视图上移
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //上移30个单位，按实际情况设置
    CGRect rect=CGRectMake(0.0f,-210,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
    return YES;
}
//恢复原始视图位置
-(void)resumeView
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //如果当前View是父视图，则Y为20个像素高度，如果当前View为其他View的子视图，则动态调节Y的高度

    CGRect rect=CGRectMake(0.0f,0,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
}
//键盘落下事件
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self resumeView];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [self resumeView];
    [super viewDidDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
