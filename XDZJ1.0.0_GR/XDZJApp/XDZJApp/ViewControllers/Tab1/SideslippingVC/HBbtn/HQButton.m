//
//  HQButton.m
//  ButtonDelegate
//
//  Created by HEYANG on 15/11/20.
//  Copyright © 2015年 HEYANG. All rights reserved.
//

#import "HQButton.h"




@implementation HQButton

//在需要监听代理的时候，添加监听的功能，所以要重写代理的get方法，需要代理->get代理
-(void)setDelegate:(id<ButtonDelegate>)delegate
{
    [self addTarget:self action:@selector(func) forControlEvents:UIControlEventTouchUpInside];
    _delegate = delegate;
    
}
-(void)setDelegateWithParamater:(id<ButtonDelegateWithParameter>)delegateWithParamater{
    [self addTarget:self action:@selector(funcWithParameter:) forControlEvents:UIControlEventTouchUpInside];
    _delegateWithParamater = delegateWithParamater;
}

-(void)func
{
    
    if  (self.delegate)
     {
        [self.delegate delegateFunction];
     }
}
-(void)funcWithParameter:(id)parameter
{
    if (self.delegateWithParamater)
     {
        [self.delegateWithParamater delegateFunctionWithParameter:parameter];
     }
}


-(void) setNOSelected;
{
    [self setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    
    if (_iFontSize > 0 &&
        _iFontSize < 14)
     {
        self.titleLabel.font = [UIFont systemFontOfSize:_iFontSize];
     }
    
    self.layer.borderWidth = 1;
    self.layer.borderColor = [ResourceManager color_5].CGColor;
    self.cornerRadius = 3;
    
    if (_imgGou)
     {
        _imgGou.hidden = YES;
     }
    
    
}

-(void) setIsSelected
{
    [self setTitleColor:[ResourceManager mainColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    
    if (_iFontSize > 0 &&
        _iFontSize < 14)
     {
        self.titleLabel.font = [UIFont systemFontOfSize:_iFontSize];
     }
    
    self.layer.borderWidth = 1;
    self.layer.borderColor = [ResourceManager mainColor].CGColor;
    self.cornerRadius = 3;
    
    //iStyle  1 -- 勾在中间  ， 2 --- 勾在下面
    if (1 == _iStyle  ||
        2 == _iStyle)
     {
        int iWdith = self.width;
        int iHeight = self.height;
        if (!_imgGou)
         {
            _imgGou = [[UIImageView alloc] initWithFrame:CGRectMake(iWdith - 16, (iHeight-10)/2, 13, 10)];
            [self addSubview:_imgGou];
         }
        _imgGou.image = [UIImage imageNamed:@"Filter_gou1"];
        _imgGou.hidden = NO;
     }
    
    
//    if (2 == _iStyle )
//     {
//        int iWdith = self.width;
//        int iHeight = self.height;
//        int iImgWdith = iHeight/2;
//        if (!_imgGou)
//         {
//            _imgGou = [[UIImageView alloc] initWithFrame:CGRectMake(iWdith - iImgWdith, (iHeight-iImgWdith), iImgWdith, iImgWdith)];
//            [self addSubview:_imgGou];
//         }
//        _imgGou.image = [UIImage imageNamed:@"Filter_gou2"];
//        _imgGou.hidden = NO;
//     }
}
@end
