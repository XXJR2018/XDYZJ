//
//  Calculate_CreditCardCtl.m
//  XXJR
//
//  Created by xxjr03 on 16/6/21.
//  Copyright © 2016年 Cary. All rights reserved.
//

#import "Calculate_CreditCardCtl.h"
#import "CreditDetailsViewController.h"

@interface Calculate_CreditCardCtl ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    UILabel * _limitLabel;
    UILabel * _bankLabel;
    UITextField * _MoneyField;
    NSArray * _bankArr;
    UIPickerView * _limitPickView;
    UIPickerView * _ratePickView;
    UIView * _limitView;
    UIView * _rateView;
    NSArray * _limitPickArr;
    NSArray * _ratePickArr;
}
@end

@implementation Calculate_CreditCardCtl
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"信用卡分期计算器"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"信用卡分期计算器"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNaviBarViewWithTitle:@"信用卡分期计算器"];
    self.view.backgroundColor = [ResourceManager viewBackgroundColor];
    //添加手势点击空白处隐藏键盘
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchViewKeyBoard)];
    gesture.numberOfTapsRequired  = 1;
    [self.view addGestureRecognizer:gesture];
    [self layoutUI];
}
//Return 键回收键盘
- (BOOL)textViewShouldReturn:(UITextField *)textView
{
    //  回收键盘,取消第一响应者
    [_MoneyField resignFirstResponder];
    return YES;
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
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0.f, NavHeight + 20, SCREEN_WIDTH, 150)];
    [self.view addSubview:headView];
    headView.backgroundColor = [UIColor whiteColor];
    UIView * viewX = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0, SCREEN_WIDTH, 0.5)];
    [headView addSubview:viewX];
    viewX.backgroundColor = [ResourceManager color_5];
    NSArray * titleArr = @[@"银行",@"期数",@"金额"];
    for (int i = 0; i < 3; i++) {
        UIView * viewX = [[UIView alloc]initWithFrame:CGRectMake(0.f, 50 * (i + 1) - 0.5, SCREEN_WIDTH, 0.5)];
        [headView addSubview:viewX];
        viewX.backgroundColor = [ResourceManager color_5];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 50 * i, 100, 50)];
        [headView addSubview:label];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = UIColorFromRGB(0x333333);
        label.text = titleArr[i];
    }
    UIFont * font = [UIFont systemFontOfSize:13];
    UIColor * color = UIColorFromRGB(0xfc7637);
    _bankLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 0, 90, 50)];
    [headView addSubview:_bankLabel];
    _bankLabel.font = font;
    _bankLabel.textColor = [ResourceManager color_6];
    _bankLabel.textAlignment = NSTextAlignmentRight;
    _bankLabel.text = @"请选择银行";
    _limitLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 50, 90, 50)];
    [headView addSubview:_limitLabel];
    _limitLabel.font = font;
    _limitLabel.textColor = [ResourceManager color_6];
    _limitLabel.textAlignment = NSTextAlignmentRight;
    _limitLabel.text = @"请选择期数";
    UIButton * limitBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 150.f, 50, 150, 50)];
    [headView addSubview:limitBtn];
    [limitBtn addTarget:self action:@selector(limitBtn) forControlEvents:UIControlEventTouchUpInside];
    UIButton * bankBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 150.f, 0, 150, 50)];
    [headView addSubview:bankBtn];
     [bankBtn addTarget:self action:@selector(bankBtn) forControlEvents:UIControlEventTouchUpInside];
    _MoneyField = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 200.f, 100.f, 170.f, 50.f)];
    [headView addSubview:_MoneyField];
    _MoneyField.font = font;
    _MoneyField.textColor = color;
    _MoneyField.textAlignment = NSTextAlignmentRight;
    _MoneyField.placeholder = @"请输入金额 ";
    _MoneyField.delegate = self;
//    _MoneyField.text = @"5000";
    _MoneyField.keyboardType = UIKeyboardTypeNumberPad;
    UILabel * label_1 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 25.f, 100.f, 20, 50)];
    label_1.font = font;
    label_1.textColor = color;
    label_1.text = @"元";
    [headView addSubview:label_1];
   
    UIButton * resultBtn = [[UIButton alloc]initWithFrame:CGRectMake(15.f, CGRectGetMaxY(headView.frame) + 50, SCREEN_WIDTH - 30, 45.f)];
    [self.view addSubview:resultBtn];
    resultBtn.cornerRadius = 5;
    resultBtn.backgroundColor = UIColorFromRGB(0xfc7637);
    [resultBtn setTitle:@"计算结果" forState:UIControlStateNormal];
    [resultBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    resultBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [resultBtn addTarget:self action:@selector(resultBtn) forControlEvents:UIControlEventTouchUpInside];
    _bankArr = @[@[@"0.0195", @"0.036",  @"0.054",  @"0.072",  @"0.117",  @"0.15"],  //中国银行
                 @[@"0.0165", @"0.036",  @"0.054",  @"0.072",  @"0.117",  @"0.156"], //工商银行
                 @[@"0.021",  @"0.036",  @"0.054",  @"0.072",  @"0.108",  @"0.144"], //建设银行
                 @[@"0.018",  @"0.036",  @"0.054",  @"0.072",  @"0.129",  @"0.144"], //农业银行
                 @[@"0.018",  @"0.036",  @"0.054",  @"0.072",  @"0.108",  @"0.144"], //邮政银行
                 @[@"0.0265", @"0.0465", @"0.0645", @"0.0885" ,@"0.135",  @"0.18"],  //光大银行
                 @[@"0.0195", @"0.039",  @"0.0684", @"0.078",  @"0.1260", @"0.1728"],//广发银行
                 @[@"0.0246", @"0.042",  @"0.0603", @"0.0804", @"0.1209", @"0.168"], //民生银行
                 @[@"0.0201", @"0.0402", @"0.0603", @"0.0804", @"0.1206", @"0.1608"],//华夏银行
                 @[@"0.0216", @"0.0396", @"0.0594", @"0.0732", @"0.1206", @"0.1584"],//中信银行
                 @[@"0.0270", @"0.0468", @"0.0684", @"0.0888", @"0.1368", @"0.1824"],//浦发银行
                 @[@"0.0240", @"0.039",  @"0.0684", @"0.078",  @"0.1170", @"0.1560"],//兴业银行
                 @[@"0.0255", @"0.048",  @"0.0684", @"0.09",   @"0.135",  @"0.1728"],//平安银行
                 @[@"0.0216", @"0.0432", @"0.0684", @"0.0864", @"0.1296", @"0.1728"],//交通银行
                 @[@"0.027",  @"0.045",  @"0.0792", @"0.0864", @"0.1224", @"0.1632"],//招商银行
                 @[@"0.0216", @"0.0432", @"0.0684", @"0.0864", @"0.1296", @"0.1728"]];//花旗银行
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
    titleLabel.text = @"选择银行";
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
    _limitPickArr = @[@"中国银行",@"工商银行",@"建设银行",@"农业银行",@"邮政银行",@"光大银行",@"广发银行",@"民生银行",@"华夏银行",@"中信银行",@"浦发银行",@"兴业银行",@"平安银行",@"交通银行",@"招商银行",@"花旗银行"];
//    [_limitPickView selectRow:0 inComponent:0 animated:YES];
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
    _rateView.hidden =YES;
    _ratePickArr = @[@"3个月",@"6个月",@"9个月",@"12个月",@"18个月",@"24个月"];
//    [_ratePickView selectRow:1 inComponent:0 animated:YES];
}
-(void)finishBtn
{
    //隐藏选择器
    _limitView.hidden =YES;
    _rateView.hidden =YES;
}
-(void)bankBtn{
    [self.view endEditing:YES];
    _limitView.hidden = NO;
    _rateView.hidden =YES;
}
-(void)limitBtn{
    [self.view endEditing:YES];
    _limitView.hidden = YES;
    _rateView.hidden =NO;
}
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
-(void)resultBtn{
    
    if (_bankLabel.text.length == 0 || [_bankLabel.text isEqualToString:@"请选择银行"]) {
        [MBProgressHUD showErrorWithStatus:@"请选择银行" toView:self.view];
        return;
    }if (_limitLabel.text.length == 0 || [_limitLabel.text isEqualToString:@"请选择期限"]) {
        [MBProgressHUD showErrorWithStatus:@"请选择期数" toView:self.view];
        return;
    }if (_MoneyField.text.length == 0) {
        [MBProgressHUD showErrorWithStatus:@"请填写金额" toView:self.view];
        return;
    }
    
    CGFloat rateNum = 0.0;
    int limitNum = 0;
    int count = 0;
    NSArray * limitArr = @[@"3",@"6",@"9",@"12",@"18",@"24"];
    NSArray * rateArr;
    for (NSString * bank in _limitPickArr) {
        if ([_bankLabel.text isEqualToString:bank]) {
            rateArr = _bankArr[count];
            int num = 0;
            for (NSString * limit in _ratePickArr) {
                if ([_limitLabel.text isEqualToString:limit]) {
                    rateNum = [rateArr[num] floatValue];
                    limitNum = [limitArr[num] intValue];
                }
                num ++;
            }
        }
        count ++;
    }
    
    CGFloat num_1 =[[NSString stringWithFormat:@"%.2f",[_MoneyField.text intValue] * rateNum] floatValue];
    CGFloat num_2 =[[NSString stringWithFormat:@"%.2f",[_MoneyField.text intValue] + num_1] floatValue];
    CGFloat num_3 =[[NSString stringWithFormat:@"%.2f",num_2/limitNum] floatValue];
    CGFloat num_4 =[[NSString stringWithFormat:@"%.2f",num_1/limitNum/30] floatValue];
      NSArray * resultArr = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%.2f元",num_1],[NSString stringWithFormat:@"%.2f元",num_2],[NSString stringWithFormat:@"%.2f元",num_3],[NSString stringWithFormat:@"%.2f元",num_4],[NSString stringWithFormat:@"%d个月",limitNum],[NSString stringWithFormat:@"%@元",_MoneyField.text], nil];
    if(![self isPureInt:_MoneyField.text]){
        [MBProgressHUD showErrorWithStatus:@"输入金额有误" toView:self.view];
        return;
    }
    if (_MoneyField.text.length == 0) {
        [MBProgressHUD showErrorWithStatus:@"信息不完整" toView:self.view];
        return;
    }else{
        CreditDetailsViewController * CreditDetails = [[CreditDetailsViewController alloc]init];
        CreditDetails.DetailsArr = resultArr;
        [self.navigationController pushViewController:CreditDetails animated:YES];
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
        _bankLabel.text = [_limitPickArr objectAtIndex:row];
         _bankLabel.textColor = UIColorFromRGB(0xfc7637);
       
    }else{
        _limitLabel.text = [_ratePickArr objectAtIndex:row];
        _limitLabel.textColor = UIColorFromRGB(0xfc7637);
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
