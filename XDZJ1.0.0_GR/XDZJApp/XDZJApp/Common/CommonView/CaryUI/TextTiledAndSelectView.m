//
//  TextTiledAndSelectView.m
//  XXJR
//
//  Created by xxjr02 on 2018/4/11.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import "TextTiledAndSelectView.h"

@implementation TextTiledAndSelectView
{
    UIButton *buttonDel;
    
    UIView *_backGroundView;   // 全尺寸的黑色半透明背景
    
    UIView *_itemView;
    
    float _titleWidth;
}

//  初始化控件为 半屏幕宽度
-(TextTiledAndSelectView*)initWithOrigin_X:(CGFloat) origin_X  origin_Y:(CGFloat)origin_Y   textWidth:(CGFloat) textWdith
                          textHeight:(CGFloat) textHeight  itemArray:(NSArray *)items  textValue:(NSString *)textValue
{
    self.border = TRUE;
    self = [super initWithFrame:CGRectMake(origin_X, origin_Y, textWdith, textHeight)];
    
    _itemsArray = items;
    
    float textFieldHeight = 24.0;
    float textFieldWidth = textWdith-80;
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(10, (self.height - textFieldHeight)/2, textFieldWidth, textFieldHeight)];
    //self.textField.placeholder = placeHolder;
    self.textField.text = textValue;
    self.textField.textAlignment = NSTextAlignmentLeft;
    self.textField.font = [UIFont systemFontOfSize:14];
    self.textField.delegate = self;
    //self.textField.backgroundColor = [UIColor yellowColor];
    [self addSubview:self.textField];
    
    
    [self layoutImagePicker:YES];  // 右侧按钮向下
    [self layoutButton];
    [self layoutButtonDel];
    
    
    return self;
}


-(void)layoutImagePicker:(BOOL)picker{
    _rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - 23, (self.height - 6)/2, 11, 6)];
    if (picker) {
        _rightImage.image = [UIImage imageNamed:@"arrow_down"];
    }else{
        _rightImage.image = [UIImage imageNamed:@"arrow_right"];
        _rightImage.frame = CGRectMake(self.width - 20, (self.height - 11)/2, 7, 11);
    }
    [self addSubview:_rightImage];
}

-(void)layoutButton{
    //UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(_holderLabel.frame), 0, 160, self.height)];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.width-30 , 0, 30, self.height)];
    //button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(showPickView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

-(void)layoutButtonDel{
    //UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(_holderLabel.frame), 0, 160, self.height)];
    
    int iBtnLeftX = [XXJRUtils  getSizeWithString:_textField.text withFrame:CGRectMake(0, 0, self.width, self.height) withFontSize:14].width + 20;
    //if (iBtnLeftX > _textField.width)
     {
        iBtnLeftX = _textField.width +10;
     }
    if (!buttonDel)
     {
        buttonDel = [[UIButton alloc] initWithFrame:CGRectMake(iBtnLeftX, 0, 30, self.height)];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (self.height-20)/2, 20, 20)];
        [buttonDel addSubview:imgView];
        imgView.image = [UIImage imageNamed:@"com_delete"];
     }
    else
     {
        buttonDel.frame = CGRectMake(iBtnLeftX, 0, 30, self.height);
     }
    
    //buttonDel.backgroundColor = [UIColor blueColor];
    [buttonDel addTarget:self action:@selector(actionDel) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:buttonDel];
    
    
    if (_textField.text.length <= 0)
     {
        buttonDel.hidden = YES;
     }
    else
     {
        buttonDel.hidden = NO;
     }
}

-(UIView *)itemsView{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    CGRect rect=[self.textField convertRect: self.textField.bounds toView:window];
    CGFloat fItemViewTopY = rect.origin.y + rect.size.height + 15;
    
    //UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 36.0 * _itemsArray.count +2)];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, fItemViewTopY, SCREEN_WIDTH, 36.0 * _itemsArray.count +2)];
    
    //123123
    bgView.backgroundColor =  [UIColor whiteColor ];//UIColorFromRGBA(0xffffff, 0.9);
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bgView.width, 1)];
    line.backgroundColor = [ResourceManager color_5];
    [bgView addSubview:line];
    
    for (int i = 0; i < _itemsArray.count; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 300, 36)];
        //button.center = CGPointMake(bgView.width/2, 60.0 + 36.0 * i);
        button.center = CGPointMake(bgView.width/2, 18.0 + 36.0 * i);
        button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [button setTitle:_itemsArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[ResourceManager color_6] forState:UIControlStateNormal];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.tag = i + 100;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:button];
        

        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, (i+1)*36 -1, bgView.width, 1)];
        line.backgroundColor = [ResourceManager color_5];
        [bgView addSubview:line];

        
        if (i == _selectedIndex) {
            [button setTitleColor:[ResourceManager orangeColor] forState:UIControlStateNormal];
        }
        
    }
    
    return bgView;
}

-(void)remove{
    
    [_backGroundView removeFromSuperview];
//    [UIView animateWithDuration:0.4f animations:^{
//        _itemView.transform = CGAffineTransformMakeTranslation(0, SCREEN_HEIGHT);
//        //        _backGroundView.alpha = 0.f;
//    } completion:^(BOOL finished) {
//        [_backGroundView removeFromSuperview];
//    }];
}

#pragma mark  ---   action
-(void) showPickView
{
    NSLog(@"showPickView");
    
    if (_beginBlock) {
        _beginBlock();
    }
    

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    _backGroundView = [[UIView alloc] initWithFrame:window.bounds];
    //    _backGroundView.backgroundColor = [UIColor grayColor];
    [window addSubview:_backGroundView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remove)];
    [_backGroundView addGestureRecognizer:tap];
    
    _itemView = [self itemsView];
    [_backGroundView addSubview:_itemView];
    
    
    // 当前textField 的屏幕坐标
    CGRect rect=[self.textField convertRect: self.textField.bounds toView:window];
    CGFloat fItemViewTopY = rect.origin.y + rect.size.height + 15;
    
    
    [UIView animateWithDuration:0.2f animations:^{
        //        _backGroundView.alpha = 0.4f;
        float viewHeight = _itemView.height;
        //_itemView.frame = CGRectMake(0, window.frame.size.height - viewHeight, window.frame.size.width, viewHeight);
        _itemView.frame = CGRectMake(0, fItemViewTopY, window.frame.size.width, viewHeight);
    } completion:^(BOOL finished) {}];
}


-(void) buttonClick:(UIButton*) button
{
    _selectedIndex = (int)(button.tag - 100);
    [button setTitleColor:[ResourceManager orangeColor] forState:UIControlStateNormal];
    
    _textField.textColor = [ResourceManager color_7];
    _textField.text = _itemsArray[_selectedIndex];
    [self layoutButtonDel];
    
//    //重新设置字体颜色
//    if (_colorStyle) {
//        //        _colorStyle = NO;
//        _holderLabel.textColor = UIColorFromRGB(0x268ccf);
//    }
    
    if (_finishedBlock) {
        _finishedBlock(_selectedIndex);
    }
    [self remove];
}

-(void) actionDel
{
    _textField.text = @"";
    buttonDel.hidden = YES;
}



#pragma mark  ---  UITextFieldDelegate

- ( BOOL )textField:( UITextField  *)textField shouldChangeCharactersInRange:(NSRange )range replacementString:( NSString  *)string
{
    NSLog(@"replacementString");
    [self layoutButtonDel];
    return YES;
    
}


@end
