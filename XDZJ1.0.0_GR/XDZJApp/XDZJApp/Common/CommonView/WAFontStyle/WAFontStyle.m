//
//  WAFontStyle.m
//  UIPickerViewDemo
//
//  Created by gamin on 15/4/29.
//  Copyright (c) 2015年 gamin. All rights reserved.
//

#import "WAFontStyle.h"

@interface WAFontStyle ()

@property (weak, nonatomic) IBOutlet UIPickerView *wFontPickerView;
@property (weak, nonatomic) IBOutlet UILabel *wFontLab;
@property (weak, nonatomic) IBOutlet UIView *wFontView;

@end

@implementation WAFontStyle


@synthesize nsNumXX;//下限金额
@synthesize nsDwXX;//下限单位
@synthesize nsDao;//到
@synthesize nsNumSX;//上限金额
@synthesize nsDwSX;//上限单位

- (void)viewDidLoad {
    [super viewDidLoad];
    [_wFontView.layer setCornerRadius:20];
    
    CGRect tmpFrame =  _wFontView.layer.frame;
    tmpFrame.size.width = [UIScreen mainScreen].bounds.size.width- 20;
    _wFontView.frame = tmpFrame;
    
    
    /*
     *数据准备
     */

    nsNumXX = [[NSMutableArray alloc] initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",nil];
    
    nsDwXX = [[NSMutableArray alloc] initWithObjects:@"万",@"十万",@"百万",nil];
    
    nsDao = [[NSMutableArray alloc] initWithObjects:@"至",nil];

    nsNumSX = [[NSMutableArray alloc] initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",nil];
    
    nsDwSX = [[NSMutableArray alloc] initWithObjects:@"万",@"十万",@"百万",nil];
    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//选择取消
- (IBAction)mCancelAction:(id)sender {
    [self.view removeFromSuperview];
}

//选择确定
- (IBAction)mSelectorAction:(id)sender {

    [self mCancelAction:nil];
}

#pragma mark UIPickerViewDataSource
//几列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 5;
}

//几行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(component == 0)
        return [nsNumXX count];
    else if(component == 1)
        return [nsDwXX count];
    else if(component == 2)
        return [nsDao count];
    else if(component == 3)
        return [nsNumSX count];
    else if(component == 4)
        return [nsDwSX count];
    return -1;
}

#pragma mark UIPickerViewDelegate
//component宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if(component == 0)
        return 50.0f;
    else if(component == 1)
        return 50.0f;
    else if(component == 2)
        return 50.0f;
    else if(component == 3)
        return 50.0f;
    else if(component == 4)
        return 50.0f;
    return 50.0f;
}
//row高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 50.0f;
}

//专门为定制UIPickerView用的一个函数，返回component列row行所在的定制的View，不自定义的话会有一个系统默认的格式
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    //得到Component对应的宽和高
    CGFloat width = [self pickerView:pickerView widthForComponent:component];
    CGFloat height = [self pickerView:pickerView rowHeightForComponent:component];
    //返回UIView
    UIView *returnView = [[UIView alloc] init];
    [returnView setFrame:CGRectMake(0, 0, width, height-10)];
    
    //添加UILabel到UIView上,传递数据
    UILabel *label = [[UILabel alloc] init];
    label.frame = returnView.frame;
    [label setTextColor:[UIColor blackColor] ];

    label.tag = 1000;
    [label setFont:[UIFont systemFontOfSize:20]];
    [returnView addSubview:label];
    
    //对Label附加数据
    if(component == 0)
        label.text = [nsNumXX objectAtIndex:row];//字体
    else if(component == 1)
        label.text = [nsDwXX objectAtIndex:row];//大小
    else if(component == 2)
        label.text = [nsDao objectAtIndex:row];//大小label.backgroundColor = [_wFontColor objectAtIndex:row];//颜色
    else if(component == 3)
        label.text = [nsNumSX objectAtIndex:row];//大小
    else if(component == 4)
        label.text = [nsDwSX objectAtIndex:row];//大小
    
    return returnView;
}
//关联UILabel 和 UIPickerView
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    
    NSLog(@"row :%ld  component : %ld", (long)row, (long)component);

    
}

@end
