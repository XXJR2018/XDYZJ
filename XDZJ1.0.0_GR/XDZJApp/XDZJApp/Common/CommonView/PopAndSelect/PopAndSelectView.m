//
//  PopAndSelectView.m
//  XXJR
//
//  Created by xxjr02 on 2018/4/13.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import "PopAndSelectView.h"

@implementation PopAndSelectView
{
    UIView *_backGroundView;   // 全尺寸的透明背景
    
    UIView *_itemView;
    
    float _titleWidth;
    float _titleHeight;
    
    float pop_X;
    float pop_Y;
}

-(PopAndSelectView*)initWithOrigin_X:(CGFloat) origin_X  origin_Y:(CGFloat)origin_Y    itemArray:(NSArray *)items
{
    self = [super initWithFrame:CGRectMake(origin_X, origin_Y,SCREEN_WIDTH , 100)];
    
    pop_X = origin_X;
    pop_Y = origin_Y;
    
    _titleWidth = SCREEN_WIDTH;
    _titleHeight = 36;
    
    _itemsArray = items;
    
    
    
    return  self;
}

//  origin_X  origin_Y 必须为相对屏幕坐标的位置
// textWdith  textHeight  为弹出选项的宽度和高度
-(PopAndSelectView*)initWithOrigin_X:(CGFloat) origin_X  origin_Y:(CGFloat)origin_Y   textWidth:(CGFloat) textWdith  textHeight:(CGFloat) textHeight  itemArray:(NSArray *)items
{
    self = [super initWithFrame:CGRectMake(origin_X, origin_Y, textWdith, textHeight)];
    
    pop_X = origin_X;
    pop_Y = origin_Y;
    
    _titleWidth = textWdith;
    _titleHeight = textHeight;
    
    _itemsArray = items;
    
    return  self;
}

-(UIView *)itemsView{
    

    //UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(pop_X, pop_Y, SCREEN_WIDTH, 36.0 * _itemsArray.count +2)];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(pop_X, pop_Y, _titleWidth, _titleHeight * _itemsArray.count +2)];
    
    //123123
    bgView.backgroundColor =  [UIColor whiteColor ];//UIColorFromRGBA(0xffffff, 0.9);
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bgView.width, 1)];
    line.backgroundColor = [ResourceManager color_5];
    [bgView addSubview:line];
    
    for (int i = 0; i < _itemsArray.count; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 300, _titleHeight)];
        //button.center = CGPointMake(bgView.width/2, 60.0 + 36.0 * i);
        button.center = CGPointMake(bgView.width/2, 18.0 + _titleHeight * i);
        button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [button setTitle:_itemsArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[ResourceManager color_6] forState:UIControlStateNormal];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.tag = i + 100;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:button];
        
        
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, (i+1)*_titleHeight -1, bgView.width, 1)];
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

}


-(void) showPickView
{
    if (_beginBlock) {
        _beginBlock();
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    _backGroundView = [[UIView alloc] initWithFrame:window.bounds];
    //_backGroundView.backgroundColor = [UIColor grayColor];
    [window addSubview:_backGroundView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remove)];
    [_backGroundView addGestureRecognizer:tap];
    
    _itemView = [self itemsView];
    [_backGroundView addSubview:_itemView];
    
    
    // 当前textField 的屏幕坐标
    //CGRect rect=[self.textField convertRect: self.textField.bounds toView:window];
    //CGFloat fItemViewTopY = rect.origin.y + rect.size.height + 15;
    
    
    [UIView animateWithDuration:0.2f animations:^{
        //        _backGroundView.alpha = 0.4f;
        float viewHeight = _itemView.height;
        //_itemView.frame = CGRectMake(0, window.frame.size.height - viewHeight, window.frame.size.width, viewHeight);
        _itemView.frame = CGRectMake(pop_X, pop_Y, _titleWidth, viewHeight);
    } completion:^(BOOL finished) {}];
    
    
}


#pragma mark  ---   action
-(void) buttonClick:(UIButton*) button
{
    _selectedIndex = (int)(button.tag - 100);
    [button setTitleColor:[ResourceManager orangeColor] forState:UIControlStateNormal];
    

    
    if (_finishedBlock) {
        _finishedBlock(_selectedIndex);
    }
    [self remove];
}


@end
