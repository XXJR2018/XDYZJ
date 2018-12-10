//
//  ScotViewController.m
//  XXJR
//
//  Created by xxjr03 on 16/6/21.
//  Copyright © 2016年 Cary. All rights reserved.
//

#import "ScotViewController.h"
#import "ScotDetailsViewController.h"

@interface ScotViewController ()<UITextFieldDelegate>
{
    NSMutableArray * btnArr;
    UIButton * _housBtn;
    UIView * _oldView;
    UIView * _newView;
    UIButton * resultBtn;
    NSMutableArray * _oldBtnArr;
    UIButton * _oldBtn;
    UIView * _oldView_1;
    UIView * _oldView_2;
    UIView * _oldView_3;
    UITextField * _areaField;
    UITextField * _priceField;
    UITextField * _estateField;
    UITextField * _areaField_2;
    UITextField * _priceField_2;
    UITextField * _estateField_2;
    UITextField * _areaField_3;
    UITextField * _priceField_3;
    UITextField * _estateField_3;
    UITextField * _areaField_4;
    UITextField * _priceField_4;
    NSMutableArray * _sellerBtnArr_1;
    UIButton * _sellerBtn_1;
    NSMutableArray * _sellerBtnArr_2;
    UIButton * _sellerBtn_2;
    NSMutableArray * _sellerBtnArr_3;
    UIButton * _sellerBtn_3;
    NSMutableArray * _sellerBtnArr_4;
    UIButton * _sellerBtn_4;
    NSMutableArray * _sellerBtnArr_5;
    UIButton * _sellerBtn_5;
    NSMutableArray * _sellerBtnArr_6;
    UIButton * _sellerBtn_6;
    NSMutableArray * _sellerBtnArr_7;
    UIButton * _sellerBtn_7;
    NSMutableArray * _sellerBtnArr_8;
    UIButton * _sellerBtn_8;

    NSInteger scortNum_1;
    NSInteger scortNum_2;
    NSInteger scortNum_3;
    NSInteger scortNum_4;
    NSInteger scortNum_5;
    NSInteger scortNum_6;
    NSInteger scortNum_7;
    NSInteger scortNum_8;
    
}
@end

@implementation ScotViewController

-(void)addButtonView{
    
    self.tabBarController.tabBar.hidden = YES;
    
    [self.view addSubview:self.tabBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"税费计算器"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"税费计算器"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.hideBackButton = YES;
    [self layoutNaviBarViewWithTitle:@"税费计算器"];
    self.view.backgroundColor = [ResourceManager viewBackgroundColor];
    //添加手势点击空白处隐藏键盘
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchViewKeyBoard)];
    gesture.numberOfTapsRequired  = 1;
    [self.view addGestureRecognizer:gesture];
    [self layoutUI];
}
//添加手势点击空白处隐藏键盘
-(void)TouchViewKeyBoard
{
    [self.view endEditing:YES];
}
-(void)layoutUI{
    btnArr = [[NSMutableArray alloc]init];
    NSArray * titleArr = @[@"二手房",@"新房"];
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
    _oldView = [[UIView alloc]initWithFrame:CGRectMake(0.f, NavHeight + 50.f, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight - 100)];
    [self.view addSubview:_oldView];
    _oldView.backgroundColor = [ResourceManager viewBackgroundColor];
    _newView = [[UIView alloc]initWithFrame:CGRectMake(0.f, NavHeight + 50.f, SCREEN_WIDTH, 50 * 3)];
    [self.view addSubview:_newView];
    _newView.backgroundColor = [UIColor whiteColor];
    _oldView.hidden = NO;
    _newView.hidden = YES;
    resultBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.f, SCREEN_HEIGHT - (50 + TabbarHeight+40), SCREEN_WIDTH, 50.f)];
    [self.view addSubview:resultBtn];
    resultBtn.backgroundColor = [ResourceManager mainColor];
    [resultBtn setTitle:@"计算结果" forState:UIControlStateNormal];
    [resultBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    resultBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [resultBtn addTarget:self action:@selector(resultBtn) forControlEvents:UIControlEventTouchUpInside];
    [self oldViewUI];
    [self newViewUI];
}
-(void)oldViewUI{
    _oldBtnArr = [[NSMutableArray alloc]init];
    NSArray * oldTitleArr = @[@"普通住宅",@"非普通住宅",@"经济适用房"];
    for (int i = 0; i < 3; i++) {
        _oldBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3 * i, 5, SCREEN_WIDTH/3, 45)];
        [_oldView addSubview:_oldBtn];
        _oldBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_oldBtnArr addObject:_oldBtn];
        _oldBtn.backgroundColor = [UIColor whiteColor];
        _oldBtn.tag = (i + 1) * 10;
        [_oldBtn setTitleColor:[ResourceManager color_6] forState:UIControlStateNormal];
        [_oldBtn setTitleColor:[ResourceManager mainColor] forState:UIControlStateSelected];
        [_oldBtn setTitle:oldTitleArr[i] forState:UIControlStateNormal];
        [_oldBtn addTarget:self action:@selector(oldBtn:) forControlEvents:UIControlEventTouchUpInside];
        ((UIButton *)_oldBtnArr[0]).selected = YES;
    }
    UIView * viewX_1 = [[UIView alloc]initWithFrame:CGRectMake(0.f, 50 - 0.5, SCREEN_WIDTH, 0.5)];
    [_oldView addSubview:viewX_1];
    viewX_1.backgroundColor = [ResourceManager color_5];
    UIView * viewX_2 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3, 15, 0.5, 20)];
    [_oldView addSubview:viewX_2];
    viewX_2.backgroundColor = [ResourceManager color_5];
    UIView * viewX_3 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3 * 2, 15, 0.5, 20)];
    [_oldView addSubview:viewX_3];
    viewX_3.backgroundColor = [ResourceManager color_5];
    _oldView_1 = [[UIView alloc]initWithFrame:CGRectMake(0.f, 50.f, SCREEN_WIDTH, 300.f)];
    [_oldView addSubview:_oldView_1];
    _oldView_1.backgroundColor = [UIColor whiteColor];
    _oldView_2 = [[UIView alloc]initWithFrame:CGRectMake(0.f, 50.f, SCREEN_WIDTH, 250.f)];
    [_oldView addSubview:_oldView_2];
    _oldView_2.backgroundColor = [UIColor whiteColor];
    _oldView_3 = [[UIView alloc]initWithFrame:CGRectMake(0.f, 50.f, SCREEN_WIDTH, 280.f)];
    [_oldView addSubview:_oldView_3];
    _oldView_3.backgroundColor = [UIColor whiteColor];
    _oldView_1.hidden = NO;
    _oldView_2.hidden = YES;
    _oldView_3.hidden = YES;
    [self _oldViewUI_1];
    [self _oldViewUI_2];
    [self _oldViewUI_3];
}
-(void)_oldViewUI_1{
    
    NSArray * titleArr = @[@"房屋建筑面积",@"房屋总价",@"房产证原价",@"买方家庭首次购房",@"卖方家庭唯一住房",@"房产证年限"];
    for (NSInteger i = 0; i< titleArr.count; i++) {
        UIView * viewX = [[UIView alloc]initWithFrame:CGRectMake(0.f, 50 * (i + 1) - 0.5, SCREEN_WIDTH, 0.5)];
        [_oldView_1 addSubview:viewX];
        viewX.backgroundColor = [ResourceManager color_5];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 50 * i, 120, 50)];
        [_oldView_1 addSubview:label];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = UIColorFromRGB(0x333333);
        label.text = titleArr[i];
    }
    UIFont * font = [UIFont systemFontOfSize:13];
    UIColor * color = UIColorFromRGB(0x808080);
    _areaField = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 160, 0, 130, 50)];
    [_oldView_1 addSubview:_areaField];
    _areaField.textAlignment = NSTextAlignmentRight;
    _areaField.placeholder = @"请输入建筑面积";
    _areaField.font = font;
    _areaField.textColor = color;
    _areaField.delegate = self;
    _areaField.keyboardType = UIKeyboardTypeNumberPad;
    _priceField = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 160, 50, 130, 50)];
    [_oldView_1 addSubview:_priceField];
    _priceField.textAlignment = NSTextAlignmentRight;
    _priceField.placeholder = @"请输入房产总价";
    _priceField.font = font;
    _priceField.textColor = color;
    _priceField.delegate = self;
    _priceField.keyboardType = UIKeyboardTypeNumberPad;
    _estateField = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 160, 100, 130, 50)];
    [_oldView_1 addSubview:_estateField];
    _estateField.textAlignment = NSTextAlignmentRight;
    _estateField.placeholder = @"请输入房产证原价";
    _estateField.font = font;
    _estateField.textColor = color;
    _estateField.delegate = self;
    _estateField.keyboardType = UIKeyboardTypeNumberPad;
    UILabel * label_1 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 25.f, 0.f, 20, 50)];
    label_1.font = font;
    label_1.textColor = UIColorFromRGB(0x333333);
    label_1.text = @"㎡";
    [_oldView_1 addSubview:label_1];
    UILabel * label_2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 25.f, 50.f, 20, 50)];
    label_2.font = font;
    label_2.textColor = UIColorFromRGB(0x333333);
    label_2.text = @"万";
    [_oldView_1 addSubview:label_2];
    UILabel * label_3 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 25.f, 100.f, 20, 50)];
    label_3.font = font;
    label_3.textColor = UIColorFromRGB(0x333333);
    label_3.text = @"万";
    [_oldView_1 addSubview:label_3];
    NSArray * sellerTitleArr = @[@"是",@"否"];
    _sellerBtnArr_1 = [[NSMutableArray alloc]init];
    for (int i= 0; i<2; i++) {
        UILabel * SLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 50 * (2 - i) + 20, 150, 20,50)];
        [_oldView_1 addSubview:SLabel];
        SLabel.font = font;
        SLabel.textColor = color;
        SLabel.text = sellerTitleArr[i];
        _sellerBtn_1 = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 50 * (2 - i) - 5, 150 + 50/2 - 25/2, 25.f, 25.f)];
        [_oldView_1 addSubview:_sellerBtn_1];
        [_sellerBtnArr_1 addObject:_sellerBtn_1];
        _sellerBtn_1.tag = i+1;
        [_sellerBtn_1 setImage:[UIImage imageNamed:@"select_no"] forState:UIControlStateNormal];
        [_sellerBtn_1 setImage:[UIImage imageNamed:@"select_yes"] forState:UIControlStateSelected];
        [_sellerBtn_1 addTarget:self action:@selector(touch_1:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            
            scortNum_1 = i+1;
        }
    }
    ((UIButton *)_sellerBtnArr_1[0]).selected  = YES;
    
    
    _sellerBtnArr_2 = [[NSMutableArray alloc]init];
    for (int i= 0; i<2; i++) {
        UILabel * SLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 50 * (2 - i) + 20, 200, 20,50)];
        [_oldView_1 addSubview:SLabel];
        SLabel.font = font;
        SLabel.textColor = color;
        SLabel.text = sellerTitleArr[i];
        _sellerBtn_2 = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 50 * (2 - i) - 5, 200 + 50/2 - 25/2, 25.f, 25.f)];
        [_oldView_1 addSubview:_sellerBtn_2];
        [_sellerBtnArr_2 addObject:_sellerBtn_2];
        _sellerBtn_2.tag = i + 1;
        [_sellerBtn_2 setImage:[UIImage imageNamed:@"select_no"] forState:UIControlStateNormal];
        [_sellerBtn_2 setImage:[UIImage imageNamed:@"select_yes"] forState:UIControlStateSelected];
        [_sellerBtn_2 addTarget:self action:@selector(touch_2:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            
            scortNum_2 = i+1;
        }
    }
    ((UIButton *)_sellerBtnArr_2[0]).selected  = YES;
    
    NSArray * sTitleArr = @[@"<2年",@"2-5年",@"5年以上"];
    _sellerBtnArr_3 = [[NSMutableArray alloc]init];
    for (int i= 0; i<sTitleArr.count; i++) {
        UILabel * SLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 210.f + 25.f + 60 * i, 250, 60.f,50.f)];
        [_oldView_1 addSubview:SLabel];
        SLabel.font = font;
        SLabel.textColor = color;
        SLabel.text = sTitleArr[i];
        _sellerBtn_3 = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 210.f + 60 * i,250 + 50/2 - 25/2, 25.f, 25.f)];
        [_oldView_1 addSubview:_sellerBtn_3];
        [_sellerBtnArr_3 addObject:_sellerBtn_3];
        _sellerBtn_3.tag = i + 1;
        [_sellerBtn_3 setImage:[UIImage imageNamed:@"select_no"] forState:UIControlStateNormal];
        [_sellerBtn_3 setImage:[UIImage imageNamed:@"select_yes"] forState:UIControlStateSelected];
        [_sellerBtn_3 addTarget:self action:@selector(touch_3:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
           
            scortNum_3 = i+1;
        }
    }
    ((UIButton *)_sellerBtnArr_3[0]).selected = YES;
}

-(void)_oldViewUI_2{
    NSArray * titleArr = @[@"房屋建筑面积",@"房屋总价",@"房产证原价",@"卖方家庭唯一住房",@"房产证年限"];
    for (NSInteger i = 0; i< titleArr.count; i++) {
        UIView * viewX = [[UIView alloc]initWithFrame:CGRectMake(0.f, 50 * (i + 1) - 0.5, SCREEN_WIDTH, 0.5)];
        [_oldView_2 addSubview:viewX];
        viewX.backgroundColor = [ResourceManager color_5];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 50 * i, 120, 50)];
        [_oldView_2 addSubview:label];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = UIColorFromRGB(0x333333);
        label.text = titleArr[i];
    }
    UIFont * font = [UIFont systemFontOfSize:13];
    UIColor * color = UIColorFromRGB(0x808080);
    _areaField_2 = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 160, 0, 130, 50)];
    [_oldView_2 addSubview:_areaField_2];
    _areaField_2.textAlignment = NSTextAlignmentRight;
    _areaField_2.placeholder = @"请输入建筑面积";
    _areaField_2.font = font;
    _areaField_2.textColor = color;
    _areaField_2.delegate = self;
    _areaField_2.keyboardType = UIKeyboardTypeNumberPad;
    _priceField_2 = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 160, 50, 130, 50)];
    [_oldView_2 addSubview:_priceField_2];
    _priceField_2.textAlignment = NSTextAlignmentRight;
    _priceField_2.placeholder = @"请输入房屋总价";
    _priceField_2.font = font;
    _priceField_2.textColor = color;
    _priceField_2.delegate = self;
    _priceField_2.keyboardType = UIKeyboardTypeNumberPad;
    _estateField_2 = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 160, 100, 130, 50)];
    [_oldView_2 addSubview:_estateField_2];
    _estateField_2.textAlignment = NSTextAlignmentRight;
    _estateField_2.placeholder = @"请输入房产证原价";
    _estateField_2.font = font;
    _estateField_2.textColor = color;
    _estateField_2.delegate = self;
    _estateField_2.keyboardType = UIKeyboardTypeNumberPad;
    UILabel * label_1 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 25.f, 0.f, 20, 50)];
    label_1.font = font;
    label_1.textColor = UIColorFromRGB(0x333333);
    label_1.text = @"㎡";
    [_oldView_2 addSubview:label_1];
    UILabel * label_2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 25.f, 50.f, 20, 50)];
    label_2.font = font;
    label_2.textColor = UIColorFromRGB(0x333333);
    label_2.text = @"万";
    [_oldView_2 addSubview:label_2];
    UILabel * label_3 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 25.f, 100.f, 20, 50)];
    label_3.font = font;
    label_3.textColor = UIColorFromRGB(0x333333);
    label_3.text = @"万";
    [_oldView_2 addSubview:label_3];
    NSArray * sellerTitleArr = @[@"是",@"否"];
    _sellerBtnArr_4 = [[NSMutableArray alloc]init];
    for (int i= 0; i<2; i++) {
        UILabel * SLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 50 * (2 - i) + 20, 150, 20,50)];
        [_oldView_2 addSubview:SLabel];
        SLabel.font = font;
        SLabel.textColor = color;
        SLabel.text = sellerTitleArr[i];
        _sellerBtn_4 = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 50 * (2 - i) - 5, 150 + 50/2 - 25/2, 25.f, 25.f)];
        [_oldView_2 addSubview:_sellerBtn_4];
        [_sellerBtnArr_4 addObject:_sellerBtn_4];
        _sellerBtn_4.tag = i + 1;
        [_sellerBtn_4 setImage:[UIImage imageNamed:@"select_no"] forState:UIControlStateNormal];
        [_sellerBtn_4 setImage:[UIImage imageNamed:@"select_yes"] forState:UIControlStateSelected];
        [_sellerBtn_4 addTarget:self action:@selector(touch_4:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
           
            scortNum_4 = i+1;
        }
    }
    ((UIButton *)_sellerBtnArr_4[0]).selected = YES;
    
    NSArray * sTitleArr = @[@"<2年",@"2-5年",@"5年以上"];
    _sellerBtnArr_5 = [[NSMutableArray alloc]init];
    for (int i= 0; i<sTitleArr.count; i++) {
        UILabel * SLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 210.f + 25.f + 60 * i, 200, 60.f,50.f)];
        [_oldView_2 addSubview:SLabel];
        SLabel.font = font;
        SLabel.textColor = color;
        SLabel.text = sTitleArr[i];
        _sellerBtn_5 = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 210.f + 60 * i,200 + 50/2 - 25/2, 25.f, 25.f)];
        [_oldView_2 addSubview:_sellerBtn_5];
        [_sellerBtnArr_5 addObject:_sellerBtn_5];
        _sellerBtn_5.tag = i + 1;
        [_sellerBtn_5 setImage:[UIImage imageNamed:@"select_no"] forState:UIControlStateNormal];
        [_sellerBtn_5 setImage:[UIImage imageNamed:@"select_yes"] forState:UIControlStateSelected];
        [_sellerBtn_5 addTarget:self action:@selector(touch_5:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
        
            scortNum_5 = i+1;
        }
    }
    ((UIButton *)_sellerBtnArr_5[0]).selected = YES;
}
-(void)_oldViewUI_3{
    NSArray * titleArr = @[@"房屋建筑面积",@"房屋总价",@"房产证原价",@"买方家庭首次购房",@"卖方家庭唯一住房"];
    for (NSInteger i = 0; i< titleArr.count; i++) {
        UIView * viewX = [[UIView alloc]initWithFrame:CGRectMake(0.f, 50 * (i + 1) - 0.5, SCREEN_WIDTH, 0.5)];
        [_oldView_3 addSubview:viewX];
        viewX.backgroundColor = [ResourceManager color_5];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 50 * i, 120, 50)];
        [_oldView_3 addSubview:label];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = UIColorFromRGB(0x333333);
        label.text = titleArr[i];
    }
    UIFont * font = [UIFont systemFontOfSize:13];
    UIColor * color = UIColorFromRGB(0x808080);
    _areaField_3 = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 160, 0, 130, 50)];
    [_oldView_3 addSubview:_areaField_3];
    _areaField_3.textAlignment = NSTextAlignmentRight;
    _areaField_3.placeholder = @"请输入建筑面积";
    _areaField_3.font = font;
    _areaField_3.textColor = color;
    _areaField_3.delegate = self;
    _areaField_3.keyboardType = UIKeyboardTypeNumberPad;
    _priceField_3 = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 160, 50, 130, 50)];
    [_oldView_3 addSubview:_priceField_3];
    _priceField_3.textAlignment = NSTextAlignmentRight;
    _priceField_3.placeholder = @"请输入房产总价";
    _priceField_3.font = font;
    _priceField_3.textColor = color;
    _priceField_3.delegate = self;
    _priceField_3.keyboardType = UIKeyboardTypeNumberPad;
    _estateField_3 = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 160, 100, 130, 50)];
    [_oldView_3 addSubview:_estateField_3];
    _estateField_3.textAlignment = NSTextAlignmentRight;
    _estateField_3.placeholder = @"请输入房产证原价";
    _estateField_3.font = font;
    _estateField_3.textColor = color;
    _estateField_3.delegate = self;
    _estateField_3.keyboardType = UIKeyboardTypeNumberPad;
    UILabel * label_1 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 25.f, 0.f, 20, 50)];
    label_1.font = font;
    label_1.textColor = UIColorFromRGB(0x333333);
    label_1.text = @"㎡";
    [_oldView_3 addSubview:label_1];
    UILabel * label_2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 25.f, 50.f, 20, 50)];
    label_2.font = font;
    label_2.textColor = UIColorFromRGB(0x333333);
    label_2.text = @"万";
    [_oldView_3 addSubview:label_2];
    UILabel * label_3 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 25.f, 100.f, 20, 50)];
    label_3.font = font;
    label_3.textColor = UIColorFromRGB(0x333333);
    label_3.text = @"万";
    [_oldView_3 addSubview:label_3];
    NSArray * sellerTitleArr = @[@"是",@"否"];
    _sellerBtnArr_6 = [[NSMutableArray alloc]init];
    for (int i= 0; i<2; i++) {
        UILabel * SLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 50 * (2 - i) + 20, 150, 20,50)];
        [_oldView_3 addSubview:SLabel];
        SLabel.font = font;
        SLabel.textColor = color;
        SLabel.text = sellerTitleArr[i];
        _sellerBtn_6 = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 50 * (2 - i) - 5, 150 + 50/2 - 25/2, 25.f, 25.f)];
        [_oldView_3 addSubview:_sellerBtn_6];
        [_sellerBtnArr_6 addObject:_sellerBtn_6];
        _sellerBtn_6.tag = i + 1;
        [_sellerBtn_6 setImage:[UIImage imageNamed:@"select_no"] forState:UIControlStateNormal];
        [_sellerBtn_6 setImage:[UIImage imageNamed:@"select_yes"] forState:UIControlStateSelected];
        [_sellerBtn_6 addTarget:self action:@selector(touch_6:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            
            scortNum_6 = i+1;
        }
    }
    ((UIButton *)_sellerBtnArr_6[0]).selected = YES;
    
    _sellerBtnArr_7 = [[NSMutableArray alloc]init];
    for (int i= 0; i<2; i++) {
        UILabel * SLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 50 * (2 - i) + 20, 200, 20,50)];
        [_oldView_3 addSubview:SLabel];
        SLabel.font = font;
        SLabel.textColor = color;
        SLabel.text = sellerTitleArr[i];
        _sellerBtn_7 = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 50 * (2 - i) - 5, 200 + 50/2 - 25/2, 25.f, 25.f)];
        [_oldView_3 addSubview:_sellerBtn_7];
        [_sellerBtnArr_7 addObject:_sellerBtn_7];
        _sellerBtn_7.tag = i + 1;
        [_sellerBtn_7 setImage:[UIImage imageNamed:@"select_no"] forState:UIControlStateNormal];
        [_sellerBtn_7 setImage:[UIImage imageNamed:@"select_yes"] forState:UIControlStateSelected];
        [_sellerBtn_7 addTarget:self action:@selector(touch_7:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            
            scortNum_7 = i+1;
        }
    }
    ((UIButton *)_sellerBtnArr_7[0]).selected = YES;
    
    UILabel * SLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 255, SCREEN_WIDTH - 20,20.f)];
    [_oldView_3 addSubview:SLabel];
    SLabel.font = font;
    SLabel.textColor = color;
    SLabel.text = @"经济适用房必须满5年才可以上市交易";
   
}
-(void)newViewUI{
    NSArray * titleArr = @[@"房屋建筑面积",@"房屋总价",@"买房家庭首次购房"];
    for (NSInteger i = 0; i< titleArr.count; i++) {
        UIView * viewX = [[UIView alloc]initWithFrame:CGRectMake(0.f, 50 * (i + 1) - 0.5, SCREEN_WIDTH, 0.5)];
        [_newView addSubview:viewX];
        viewX.backgroundColor = [ResourceManager color_5];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 50 * i, 120, 50)];
        [_newView addSubview:label];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = UIColorFromRGB(0x333333);
        label.text = titleArr[i];
    }
    UIFont * font = [UIFont systemFontOfSize:13];
    UIColor * color = UIColorFromRGB(0x808080);
    _areaField_4 = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 160, 0, 130, 50)];
    [_newView addSubview:_areaField_4];
    _areaField_4.textAlignment = NSTextAlignmentRight;
    _areaField_4.placeholder = @"请输入建筑面积";
    _areaField_4.font = font;
    _areaField_4.textColor = color;
    _areaField_4.delegate = self;
    _areaField_4.keyboardType = UIKeyboardTypeNumberPad;
    _priceField_4 = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 160, 50, 130, 50)];
    [_newView addSubview:_priceField_4];
    _priceField_4.textAlignment = NSTextAlignmentRight;
    _priceField_4.placeholder = @"请输入房产总价";
    _priceField_4.font = font;
    _priceField_4.textColor = color;
    _priceField_4.delegate = self;
    _priceField_4.keyboardType = UIKeyboardTypeNumberPad;
    UILabel * label_1 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 25.f, 0.f, 20, 50)];
    label_1.font = font;
    label_1.textColor = UIColorFromRGB(0x333333);
    label_1.text = @"㎡";
    [_newView addSubview:label_1];
    UILabel * label_2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 25.f, 50.f, 20, 50)];
    label_2.font = font;
    label_2.textColor = UIColorFromRGB(0x333333);
    label_2.text = @"万";
    [_newView addSubview:label_2];
    NSArray * sellerTitleArr = @[@"是",@"否"];
    _sellerBtnArr_8 = [[NSMutableArray alloc]init];
    for (int i= 0; i<2; i++) {
        UILabel * SLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 50 * (2 - i) + 20, 100, 20,50)];
        [_newView addSubview:SLabel];
        SLabel.font = font;
        SLabel.textColor = color;
        SLabel.text = sellerTitleArr[i];
        _sellerBtn_8 = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 50 * (2 - i) - 5, 100 + 50/2 - 25/2, 25.f, 25.f)];
        [_newView addSubview:_sellerBtn_8];
        [_sellerBtnArr_8 addObject:_sellerBtn_8];
        _sellerBtn_8.tag = i + 1;
        [_sellerBtn_8 setImage:[UIImage imageNamed:@"select_no"] forState:UIControlStateNormal];
        [_sellerBtn_8 setImage:[UIImage imageNamed:@"select_yes"] forState:UIControlStateSelected];
        [_sellerBtn_8 addTarget:self action:@selector(touch_8:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
           
            scortNum_8 = i+1;
        }
    }
    ((UIButton *)_sellerBtnArr_8[0]).selected = YES;
}
-(void)touch_1:(UIButton *)sender{
    [self.view endEditing:YES];
    ((UIButton *)_sellerBtnArr_1[0]).selected = NO;
    if (sender != _sellerBtn_1){
        _sellerBtn_1.selected = NO;
        _sellerBtn_1 = sender;
    }
    _sellerBtn_1.selected = YES;
    scortNum_1 = sender.tag;
}
-(void)touch_2:(UIButton *)sender{
    [self.view endEditing:YES];
    ((UIButton *)_sellerBtnArr_2[0]).selected = NO;
    if (sender != _sellerBtn_2){
        _sellerBtn_2.selected = NO;
        _sellerBtn_2 = sender;
    }
    _sellerBtn_2.selected = YES;
    scortNum_2 = sender.tag;
}
-(void)touch_3:(UIButton *)sender{
    [self.view endEditing:YES];
    ((UIButton *)_sellerBtnArr_3[0]).selected = NO;
    if (sender != _sellerBtn_3){
        _sellerBtn_3.selected = NO;
        _sellerBtn_3 = sender;
    }
    _sellerBtn_3.selected = YES;
    scortNum_3 = sender.tag;
}
-(void)touch_4:(UIButton *)sender{
    [self.view endEditing:YES];
    ((UIButton *)_sellerBtnArr_4[0]).selected = NO;
    if (sender != _sellerBtn_4){
        _sellerBtn_4.selected = NO;
        _sellerBtn_4 = sender;
    }
    _sellerBtn_4.selected = YES;
    scortNum_4 = sender.tag;
}
-(void)touch_5:(UIButton *)sender{
    [self.view endEditing:YES];
    ((UIButton *)_sellerBtnArr_5[0]).selected = NO;
    if (sender != _sellerBtn_5){
        _sellerBtn_5.selected = NO;
        _sellerBtn_5 = sender;
    }
    _sellerBtn_5.selected = YES;
    scortNum_5 = sender.tag;
}
-(void)touch_6:(UIButton *)sender{
    [self.view endEditing:YES];
    ((UIButton *)_sellerBtnArr_6[0]).selected = NO;
    if (sender != _sellerBtn_6){
        _sellerBtn_6.selected = NO;
        _sellerBtn_6 = sender;
    }
    _sellerBtn_6.selected = YES;
    scortNum_6 = sender.tag;
}
-(void)touch_7:(UIButton *)sender{
    [self.view endEditing:YES];
    ((UIButton *)_sellerBtnArr_7[0]).selected = NO;
    if (sender != _sellerBtn_7){
        _sellerBtn_7.selected = NO;
        _sellerBtn_7 = sender;
    }
    _sellerBtn_7.selected = YES;
    scortNum_7 = sender.tag;
}
-(void)touch_8:(UIButton *)sender{
    [self.view endEditing:YES];
    ((UIButton *)_sellerBtnArr_8[0]).selected = NO;
    if (sender != _sellerBtn_8){
        _sellerBtn_8.selected = NO;
        _sellerBtn_8 = sender;
    }
    _sellerBtn_8.selected = YES;
    scortNum_8 = sender.tag;
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
        _oldView.hidden = NO;
        _newView.hidden = YES;
       
    }if(sender.tag == 1){
        _oldView.hidden = YES;
        _newView.hidden = NO;
    }
}
-(void)oldBtn:(UIButton *)sender{
    //点击其他button之后这里设置为非选中状态，否则会出现2个同色的选中状态
    ((UIButton *)_oldBtnArr[0]).selected = NO;
    if (sender != _oldBtn){
        _oldBtn.selected = NO;
        _oldBtn = sender;
    }
    _oldBtn.selected = YES;
    if(sender.tag == 10){
        _oldView_1.hidden = NO;
        _oldView_2.hidden = YES;
        _oldView_3.hidden = YES;
    }if(sender.tag == 20){
        _oldView_2.hidden = NO;
        _oldView_1.hidden = YES;
        _oldView_3.hidden = YES;
    }if(sender.tag == 30){
        _oldView_3.hidden = NO;
        _oldView_2.hidden = YES;
        _oldView_1.hidden = YES;
    }
}
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
//计算结果
-(void)resultBtn{
    if (!_oldView.hidden) {
        //普通住宅
        if (!_oldView_1.hidden) {
            CGFloat areaNum = [_areaField.text floatValue];
            CGFloat priceNum = [_priceField.text floatValue] * 10000;
            CGFloat estateNum = [_estateField.text floatValue] * 10000;
            CGFloat resultNum_1 = 0.0;
            CGFloat resultNum_2 = 0.0;
            CGFloat resultNum_3 = 0.0;
            CGFloat resultNum_4 = 0.0;
            //契税
            if (scortNum_1 == 1) {
                if (areaNum <= 90) {
                    resultNum_1 = [[NSString stringWithFormat:@"%.2f", priceNum * 0.01] floatValue];
                }else{
                    resultNum_1 = [[NSString stringWithFormat:@"%.2f", priceNum * 0.015] floatValue];
                }
            }else if (scortNum_1 == 2){
                resultNum_1 = [[NSString stringWithFormat:@"%.2f", priceNum * 0.03] floatValue];
            }
            //增值税
            if (scortNum_3 == 1) {
                resultNum_2 = [[NSString stringWithFormat:@"%.2f", priceNum/(1+0.05)*0.050] floatValue];
            }else if (scortNum_3 == 2 || scortNum_3 == 3){
                resultNum_2 = [[NSString stringWithFormat:@"%.2f", 0.00] floatValue];
            }
            //个税
            if (priceNum < estateNum) {
                resultNum_3 = [[NSString stringWithFormat:@"%.2f", 0.00] floatValue];
            }else if (scortNum_3 == 1 || scortNum_3 == 2){
                resultNum_3 = [[NSString stringWithFormat:@"%.2f", (priceNum - estateNum) * 0.2] floatValue];
            }else if (scortNum_3 == 3){
                if (scortNum_2 == 1) {
                   resultNum_3 = [[NSString stringWithFormat:@"%.2f", 0.00] floatValue];
                }else if (scortNum_2 == 2){
                    resultNum_3 = [[NSString stringWithFormat:@"%.2f", (priceNum - estateNum) * 0.2] floatValue];
                }
            }
            //总计
            resultNum_4 = [[NSString stringWithFormat:@"%.2f", resultNum_1 + resultNum_2 + resultNum_3 + 5.0] floatValue];
            NSArray * resultArr = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%.2f元",resultNum_1],[NSString stringWithFormat:@"%.2f元",resultNum_2],[NSString stringWithFormat:@"%.2f元",resultNum_3],@"5元",[NSString stringWithFormat:@"%.2f元",resultNum_4], nil];
            if(![self isPureInt:_areaField.text]|| ![self isPureInt:_priceField.text] || ![self isPureInt:_estateField.text]){
                [MBProgressHUD showErrorWithStatus:@"输入金额有误" toView:self.view];
                return;
            }
            if([_priceField.text intValue] < [_estateField.text intValue]){
                [MBProgressHUD showErrorWithStatus:@"房屋总价不能小于房产证原价" toView:self.view];
                return;
            }
            if (_areaField.text.length == 0) {
                [MBProgressHUD showErrorWithStatus:@"信息不完整" toView:self.view];
                return;
            }else if (_priceField.text.length == 0){
                [MBProgressHUD showErrorWithStatus:@"信息不完整" toView:self.view];
                return;
            }else if (_estateField.text.length == 0){
                [MBProgressHUD showErrorWithStatus:@"信息不完整" toView:self.view];
                return;
            }else if (scortNum_1 == 0){
                [MBProgressHUD showErrorWithStatus:@"信息不完整" toView:self.view];
                return;
            }else if (scortNum_2 == 0){
                [MBProgressHUD showErrorWithStatus:@"信息不完整" toView:self.view];
                return;
            }else if (scortNum_3 == 0){
                [MBProgressHUD showErrorWithStatus:@"信息不完整" toView:self.view];
                return;
            }else{
                ScotDetailsViewController * sortDetails = [[ScotDetailsViewController alloc]init];
                sortDetails.moneyArr = resultArr;
                sortDetails.titleArr = @[@"契税",@"增值税",@"个人所得税",@"印花税",@"合计"];
                [self.navigationController pushViewController:sortDetails animated:YES];
            }
            //非普通住宅
        }else if (!_oldView_2.hidden){
            CGFloat priceNum = [_priceField_2.text floatValue] * 10000;
            CGFloat estateNum = [_estateField_2.text floatValue] * 10000;
            CGFloat resultNum_1 = 0.0;
            CGFloat resultNum_2 = 0.0;
            CGFloat resultNum_3 = 0.0;
            CGFloat resultNum_4 = 0.0;
            //契税
            resultNum_1 = [[NSString stringWithFormat:@"%.2f", priceNum * 0.015] floatValue];
            //增值税
            if (scortNum_5 == 1) {
                resultNum_2 = [[NSString stringWithFormat:@"%.2f", (priceNum/(1 + 0.05)) * 0.05] floatValue];
            }else if (scortNum_5 == 2 || scortNum_5 == 3){
                resultNum_2 = [[NSString stringWithFormat:@"%.2f", (priceNum - estateNum)/(1 + 0.05) * 0.05] floatValue];
            }
            //个税
            if (priceNum < estateNum) {
                resultNum_3 = [[NSString stringWithFormat:@"%.2f", 0.00] floatValue];
            }else if (scortNum_5 == 1 || scortNum_5 == 2){
                resultNum_3 = [[NSString stringWithFormat:@"%.2f", (priceNum - estateNum) * 0.2] floatValue];
            }else if (scortNum_5 == 3){
                if (scortNum_4 == 1) {
                    resultNum_3 = [[NSString stringWithFormat:@"%.2f", 0.00] floatValue];
                }else if (scortNum_4 == 2){
                    resultNum_3 = [[NSString stringWithFormat:@"%.2f", (priceNum - estateNum) * 0.2] floatValue];
                }
            }
            //总计
            resultNum_4 = resultNum_1 + resultNum_2 + resultNum_3 + 5;
            NSArray * resultArr = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%.2f元",resultNum_1],[NSString stringWithFormat:@"%.2f元",resultNum_2],[NSString stringWithFormat:@"%.2f元",resultNum_3],@"5元",[NSString stringWithFormat:@"%.2f元",resultNum_4], nil];
            if(![self isPureInt:_areaField_2.text]|| ![self isPureInt:_priceField_2.text] || ![self isPureInt:_estateField_2.text]){
                [MBProgressHUD showErrorWithStatus:@"输入金额有误" toView:self.view];
                return;
            }
            if([_priceField_2.text intValue] < [_estateField_2.text intValue]){
                [MBProgressHUD showErrorWithStatus:@"房屋总价不能小于房产证原价" toView:self.view];
                return;
            }
            if (_areaField_2.text.length == 0) {
                [MBProgressHUD showErrorWithStatus:@"信息不完整" toView:self.view];
                return;
            }else if (_priceField_2.text.length == 0){
                [MBProgressHUD showErrorWithStatus:@"信息不完整" toView:self.view];
                return;
            }else if (_estateField_2.text.length == 0){
                [MBProgressHUD showErrorWithStatus:@"信息不完整" toView:self.view];
                return;
            }else if (scortNum_4 == 0){
                [MBProgressHUD showErrorWithStatus:@"信息不完整" toView:self.view];
                return;
            }else if (scortNum_5 == 0){
                [MBProgressHUD showErrorWithStatus:@"信息不完整" toView:self.view];
                return;
            }else{
                ScotDetailsViewController * sortDetails = [[ScotDetailsViewController alloc]init];
                sortDetails.moneyArr = resultArr;
                sortDetails.titleArr = @[@"契税",@"增值税",@"个人所得税",@"印花税",@"合计"];
                [self.navigationController pushViewController:sortDetails animated:YES];
            }
            //经济适用房
        }else if (!_oldView_3.hidden){
            CGFloat priceNum = [_priceField_3.text floatValue] * 10000;
            CGFloat estateNum = [_estateField_3.text floatValue] * 10000;
            CGFloat resultNum_1 = 0.0;
            CGFloat resultNum_2 = 0.0;
            CGFloat resultNum_3 = 0.0;
            CGFloat resultNum_4 = 0.0;
            //契税
            if (scortNum_6 == 1) {
                resultNum_1 = [[NSString stringWithFormat:@"%.2f", priceNum * 0.015] floatValue];
            }else if (scortNum_6 == 2){
                resultNum_1 = [[NSString stringWithFormat:@"%.2f", priceNum * 0.03] floatValue];
            }
            //个税
            if (priceNum < estateNum) {
                resultNum_2 = [[NSString stringWithFormat:@"%.2f", 0.00] floatValue];
            }else if (scortNum_7 == 1){
                resultNum_2 = [[NSString stringWithFormat:@"%.2f", 0.00] floatValue];
            }else if (scortNum_7 == 2){
                resultNum_2 = [[NSString stringWithFormat:@"%.2f", (priceNum - estateNum) * 0.2] floatValue];
            }
            //综合地税
             resultNum_3 = [[NSString stringWithFormat:@"%.2f", priceNum * 0.1] floatValue];
            //总计
            resultNum_4 = resultNum_1 + resultNum_2 + resultNum_3 + 5;
            NSArray * resultArr = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%.2f元",resultNum_1],[NSString stringWithFormat:@"%.2f元",resultNum_2],[NSString stringWithFormat:@"%.2f元",resultNum_3],@"5元",[NSString stringWithFormat:@"%.2f元",resultNum_4], nil];
            if(![self isPureInt:_areaField_3.text]|| ![self isPureInt:_priceField_3.text] || ![self isPureInt:_estateField_3.text]){
                [MBProgressHUD showErrorWithStatus:@"输入金额有误" toView:self.view];
                return;
            }
            if([_priceField_3.text intValue] < [_estateField_3.text intValue]){
                [MBProgressHUD showErrorWithStatus:@"房屋总价不能小于房产证原价" toView:self.view];
                return;
            }
            if (_areaField_3.text.length == 0) {
                [MBProgressHUD showErrorWithStatus:@"信息不完整" toView:self.view];
                return;
            }else if (_priceField_3.text.length == 0){
                [MBProgressHUD showErrorWithStatus:@"信息不完整" toView:self.view];
                return;
            }else if (_estateField_3.text.length == 0){
                [MBProgressHUD showErrorWithStatus:@"信息不完整" toView:self.view];
                return;
            }else if (scortNum_6 == 0){
                [MBProgressHUD showErrorWithStatus:@"信息不完整" toView:self.view];
                return;
            }else if (scortNum_7 == 0){
                [MBProgressHUD showErrorWithStatus:@"信息不完整" toView:self.view];
                return;
            }else{
                ScotDetailsViewController * sortDetails = [[ScotDetailsViewController alloc]init];
                sortDetails.moneyArr = resultArr;
                sortDetails.titleArr = @[@"契税",@"增值税",@"综合地价税",@"印花税",@"合计"];
                [self.navigationController pushViewController:sortDetails animated:YES];
            }
        }
        //新房
    }else if (!_newView.hidden){
        CGFloat priceNum = [_priceField_4.text floatValue] * 10000;
        CGFloat resultNum_1 = 0.0;
        CGFloat resultNum_2 = 0.0;
        CGFloat resultNum_3 = 0.0;
        //契税
        if (scortNum_8 == 1) {
            resultNum_1 = [[NSString stringWithFormat:@"%.2f", priceNum * 0.015] floatValue];
        }else if (scortNum_8 == 2){
            resultNum_1 = [[NSString stringWithFormat:@"%.2f", priceNum * 0.03] floatValue];
        }
        //维修费
        resultNum_2 = [[NSString stringWithFormat:@"%.2f", priceNum * 0.02] floatValue];
       //总计
        resultNum_3 =resultNum_1 + resultNum_2 + 200 + 100;
        NSArray * resultArr = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%.2f元",resultNum_1],[NSString stringWithFormat:@"%.2f元",resultNum_2],@"200元",@"100元",[NSString stringWithFormat:@"%.2f元",resultNum_3], nil];
        if(![self isPureInt:_areaField_4.text]|| ![self isPureInt:_priceField_4.text] ){
            [MBProgressHUD showErrorWithStatus:@"输入金额有误" toView:self.view];
            return;
        }
        if (_areaField_4.text.length == 0) {
            [MBProgressHUD showErrorWithStatus:@"信息不完整" toView:self.view];
            return;
        }else if (_priceField_4.text.length == 0){
            [MBProgressHUD showErrorWithStatus:@"信息不完整" toView:self.view];
            return;
        }else if (scortNum_8 == 0){
            [MBProgressHUD showErrorWithStatus:@"信息不完整" toView:self.view];
            return;
        }else{
            ScotDetailsViewController * sortDetails = [[ScotDetailsViewController alloc]init];
            sortDetails.moneyArr = resultArr;
            sortDetails.titleArr = @[@"契税",@"房屋维修基金",@"交易手续费",@"权属登记费",@"合计"];
            [self.navigationController pushViewController:sortDetails animated:YES];
        }
    }
    
 
    
    
    
    
}












- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
