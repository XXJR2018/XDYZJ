//
//  TGButtonView.m
//  XXJR
//
//  Created by xxjr02 on 2017/12/7.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import "TGButtonView.h"

@interface TGButtonView()
{
    UIButton *btnTitle;
    NSString *strTitle;
    BOOL isBtnClick;
    UIButton *btnAdd;
    UIButton *btnSub;
    UILabel *labelUnit;
    int      iMoneyTemp;

    UIView *viewFG1;
    UIView *viewFG2;
}
@end

@implementation TGButtonView


//// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//    //self = [super  initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
//}

-(TGButtonView*)initWithPrice:(int) price  origin_Y:(CGFloat)origin_Y 
{
    strTitle = @"";
    self = [super initWithFrame:CGRectMake(SCREEN_WIDTH/2, origin_Y, SCREEN_WIDTH/2, 44)];
    //self.backgroundColor = [UIColor yellowColor];
    
    // 单位
    int iLeftX = SCREEN_WIDTH/2 - 40;
    labelUnit = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, 0, 40, CellHeight44)];
    [self addSubview:labelUnit];
    labelUnit.textColor = [ResourceManager color_1];
    labelUnit.font = [UIFont systemFontOfSize:13];
    labelUnit.text = @"元/单";
    
    // +按钮
    int iButton2Hegiht = 20;
    int iButton2Width = 40;
    iLeftX -= iButton2Hegiht +5;
    int iTopY = (CellHeight44-iButton2Hegiht)/2;
    btnAdd = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iButton2Hegiht, iButton2Hegiht)];
    [self addSubview:btnAdd];
    [btnAdd setTitle:@"+" forState:UIControlStateNormal];
    [btnAdd setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
    btnAdd.layer.borderColor= [ResourceManager lightGrayColor].CGColor;
    btnAdd.layer.borderWidth= 1.0f;
    [btnAdd addTarget:self action:@selector(actionAdd) forControlEvents:UIControlEventTouchUpInside];
    
    // 加价值
    iLeftX -= (iButton2Width);
    _textFiledMoney = [[UITextField alloc] initWithFrame:CGRectMake(iLeftX , iTopY, iButton2Width, iButton2Hegiht)];
    [self addSubview:_textFiledMoney];
    
    _textFiledMoney.textColor = [ResourceManager color_1];
    _textFiledMoney.font = [UIFont systemFontOfSize:13];
    //textFiledMoney.layer.borderColor= [ResourceManager lightGrayColor].CGColor;
    //textFiledMoney.layer.borderWidth= 1.0f;
    _textFiledMoney.keyboardType = UIKeyboardTypeNumberPad;
    // 缩进
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    leftView.backgroundColor = [UIColor whiteColor];
    _textFiledMoney.leftView = leftView;
    _textFiledMoney.leftViewMode = UITextFieldViewModeAlways;
    [_textFiledMoney addTarget:self action:@selector(textField1TextChange) forControlEvents:UIControlEventEditingChanged];
    _iSelPrice = price;
    if (_iSelPrice > 0)
     {
        _textFiledMoney.text = [NSString stringWithFormat:@"%d",price];
     }
    else
     {
        _iSelPrice = 1;
        _textFiledMoney.text = @"1";
     }
    
    // 分割线1 和分割线2
    viewFG1 = [[UIView alloc] initWithFrame:CGRectMake(iLeftX , iTopY, iButton2Width,1)];
    viewFG1.backgroundColor = [ResourceManager lightGrayColor];
    [self addSubview:viewFG1];
    
    viewFG2 = [[UIView alloc] initWithFrame:CGRectMake(iLeftX , iTopY+iButton2Hegiht-1, iButton2Width,1)];
    viewFG2.backgroundColor = [ResourceManager lightGrayColor];
    [self addSubview:viewFG2];
    
    
    // 减号按钮
    iLeftX -= (iButton2Hegiht);
    btnSub = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iButton2Hegiht, iButton2Hegiht)];
    [self addSubview:btnSub];
    [btnSub setTitle:@"-" forState:UIControlStateNormal];
    [btnSub setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
    btnSub.layer.borderColor= [ResourceManager lightGrayColor].CGColor;
    btnSub.layer.borderWidth= 1.0f;
    [btnSub addTarget:self action:@selector(actionSub) forControlEvents:UIControlEventTouchUpInside];
    
    return  self;
}

-(TGButtonView*)initWithTitle:(NSString *)title withPrice:(int) price origin_Y:(CGFloat)origin_Y
{
    self = [super initWithFrame:CGRectMake(0, origin_Y, SCREEN_WIDTH, 44)];
    //self.backgroundColor = [UIColor yellowColor];
    
    // 单位
    int iLeftX = SCREEN_WIDTH - 40;
    labelUnit = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, 0, 40, CellHeight44)];
    [self addSubview:labelUnit];
    labelUnit.textColor = [ResourceManager color_1];
    labelUnit.font = [UIFont systemFontOfSize:13];
    labelUnit.text = @"元/单";
    
    // +按钮
    int iButton2Hegiht = 20;
    int iButton2Width = 40;
    iLeftX -= iButton2Hegiht +5;
    int iTopY = (CellHeight44-iButton2Hegiht)/2;
    btnAdd = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iButton2Hegiht, iButton2Hegiht)];
    [self addSubview:btnAdd];
    [btnAdd setTitle:@"+" forState:UIControlStateNormal];
    [btnAdd setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
    btnAdd.layer.borderColor= [ResourceManager lightGrayColor].CGColor;
    btnAdd.layer.borderWidth= 1.0f;
    [btnAdd addTarget:self action:@selector(actionAdd) forControlEvents:UIControlEventTouchUpInside];
    
    // 加价值
    iLeftX -= (iButton2Width);
    _textFiledMoney = [[UITextField alloc] initWithFrame:CGRectMake(iLeftX , iTopY, iButton2Width, iButton2Hegiht)];
    [self addSubview:_textFiledMoney];
   
    _textFiledMoney.textColor = [ResourceManager color_1];
    _textFiledMoney.font = [UIFont systemFontOfSize:13];
    //textFiledMoney.layer.borderColor= [ResourceManager lightGrayColor].CGColor;
    //textFiledMoney.layer.borderWidth= 1.0f;
    _textFiledMoney.keyboardType = UIKeyboardTypeNumberPad;
    // 缩进
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    leftView.backgroundColor = [UIColor whiteColor];
    _textFiledMoney.leftView = leftView;
    _textFiledMoney.leftViewMode = UITextFieldViewModeAlways;
    [_textFiledMoney addTarget:self action:@selector(textField1TextChange) forControlEvents:UIControlEventEditingChanged];
    
    // 分割线1 和分割线2
    viewFG1 = [[UIView alloc] initWithFrame:CGRectMake(iLeftX , iTopY, iButton2Width,1)];
    viewFG1.backgroundColor = [ResourceManager lightGrayColor];
    [self addSubview:viewFG1];
    
    viewFG2 = [[UIView alloc] initWithFrame:CGRectMake(iLeftX , iTopY+iButton2Hegiht-1, iButton2Width,1)];
    viewFG2.backgroundColor = [ResourceManager lightGrayColor];
    [self addSubview:viewFG2];
    
    
    
    
    // 减号按钮
    iLeftX -= (iButton2Hegiht);
    btnSub = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iButton2Hegiht, iButton2Hegiht)];
    [self addSubview:btnSub];
    [btnSub setTitle:@"-" forState:UIControlStateNormal];
    [btnSub setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
    btnSub.layer.borderColor= [ResourceManager lightGrayColor].CGColor;
    btnSub.layer.borderWidth= 1.0f;
    [btnSub addTarget:self action:@selector(actionSub) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 加价项目
    iLeftX = 40;
    int iButtonHeigt = 25;
    // 根据文字长度，计算按钮宽度
    int iButtonWidth = [XXJRUtils getSizeWithString:title withFrame:CGRectMake(0, 0, 200, iButtonHeigt) withFontSize:13].width + 25;
    iTopY = (CellHeight44-iButtonHeigt)/2;
    btnTitle = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iButtonWidth, iButtonHeigt)];
    [self addSubview:btnTitle];
    strTitle = title;
    [btnTitle setTitle:title forState:UIControlStateNormal];
    btnTitle.titleLabel.font = [UIFont systemFontOfSize:13];
    btnTitle.cornerRadius = 10;//iButtonWidth /2;
    [btnTitle setTitleColor:UIColorFromRGB(0xfc6923) forState:UIControlStateNormal];
    btnTitle.layer.borderColor= [ResourceManager lightGrayColor].CGColor;
    btnTitle.layer.borderWidth= 1.0f;
    [btnTitle addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    
    _iSelPrice = price;
    iMoneyTemp = price;
    if (_iSelPrice > 0)
     {
        isBtnClick = YES;
        _textFiledMoney.text = [NSString stringWithFormat:@"%d",price];
        [self showBtn];
     }
    else
     {
        isBtnClick = NO;
        _textFiledMoney.text = @"";
        _iSelPrice = 0;
        [self hideBtn];
     }
    
    
    return self;
}


-(void)setPrice:(int) price
{
    if(price >=1 &&
       price <= 100 &&
       _textFiledMoney)
     {
        if (strTitle.length > 0)
         {
            isBtnClick = YES;
            [self showBtn];
         }
        
        _textFiledMoney.text = [NSString stringWithFormat:@"%d", price];
     }
        
}

-(void) hideBtn
{
    btnSub.hidden = YES;
    btnAdd.hidden = YES;
    _textFiledMoney.hidden = YES;
    labelUnit.hidden = YES;
    viewFG1.hidden = YES;
    viewFG2.hidden = YES;
    
    [btnTitle setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
    btnTitle.layer.borderColor= [ResourceManager lightGrayColor].CGColor;
}

-(void) showBtn
{
    btnSub.hidden = NO;
    btnAdd.hidden = NO;
    _textFiledMoney.hidden = NO;
    labelUnit.hidden = NO;
    viewFG1.hidden = NO;
    viewFG2.hidden = NO;
    
    if (_iSelPrice <= 0)
     {
        _iSelPrice = 1;
        _textFiledMoney.text = [NSString stringWithFormat:@"%d",_iSelPrice];
     }

    
    [btnTitle setTitleColor:UIColorFromRGB(0xfc6923) forState:UIControlStateNormal];
    btnTitle.layer.borderColor= UIColorFromRGB(0xfc6923).CGColor;
}

-(void) buttonClick
{
    isBtnClick = !isBtnClick;
    if (isBtnClick)
     {
        _iSelPrice = iMoneyTemp;
        _textFiledMoney.text = [NSString stringWithFormat:@"%d",_iSelPrice];
        [self showBtn];
        
        if (_selecltBlock)
         {
            _selecltBlock(_iSelPrice);
         }
     }
    else
     {
        _iSelPrice = 0;
        [self hideBtn];
        
        if (_selecltBlock)
         {
            _selecltBlock(_iSelPrice);
         }
     }
}

-(void) actionAdd
{
    int iValue = [_textFiledMoney.text intValue];
    if (iValue < 100)
     {
        iValue++;
        _iSelPrice = iValue;
        iMoneyTemp = _iSelPrice;
        _textFiledMoney.text = [NSString stringWithFormat:@"%d", iValue];
        
        if (_selecltBlock)
         {
            _selecltBlock(iValue);
         }
     }
}

-(void) actionSub
{
    int iValue = [_textFiledMoney.text intValue];
    if (iValue > 1)
     {
        iValue--;
        _iSelPrice = iValue;
        iMoneyTemp = _iSelPrice;
        _textFiledMoney.text = [NSString stringWithFormat:@"%d", iValue];
        
        if (_selecltBlock)
         {
            _selecltBlock(iValue);
         }
     }
}

-(void) textField1TextChange
{
    int iValue = [_textFiledMoney.text intValue];
    if (iValue >100 )
     {
        _textFiledMoney.text = @"1";
        
        if (_selecltBlock)
         {
            _selecltBlock(iValue);
         }
     }
    
}

@end
