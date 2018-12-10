//
//  JXButton.m
//  JXButtonDemo
//
//  Created by pconline on 2016/11/28.
//  Copyright © 2016年 pconline. All rights reserved.
//

#import "JXButton.h"

@implementation JXButton

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

-(void)commonInit{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    _iSystle = 0;
    
}

// 设置标题大小
-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    /*
    CGFloat titleX = 0;
    CGFloat titleY = contentRect.size.height *0.75;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height - titleY - 2;
     */
    
    if (1 == _iSystle)
     {
        CGFloat titleX = 0;
        CGFloat titleY = contentRect.size.height *0.75;
        CGFloat titleW = contentRect.size.width;
        CGFloat titleH = contentRect.size.height - titleY;
        return CGRectMake(titleX, titleY, titleW, titleH);
     }
    if (2 == _iSystle)
     {
        CGFloat titleX = 0;
        CGFloat titleY = contentRect.size.height *0.40;
        CGFloat titleW = contentRect.size.width;
        CGFloat titleH = contentRect.size.height - titleY;
        return CGRectMake(titleX, titleY, titleW, titleH);
     }
    
    CGFloat titleX = 0;
    CGFloat titleY = contentRect.size.height *0.5;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height - titleY;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

// 设置图片大小
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    /*
    CGFloat imageW = CGRectGetWidth(contentRect);
    CGFloat imageH = contentRect.size.height * 0.6;
    return CGRectMake(0, 3, imageW, imageH);
     */
    
    if (1 == _iSystle)
     {
        CGFloat imageW = CGRectGetWidth(contentRect);
        CGFloat imageH = contentRect.size.height * 0.65;
        return CGRectMake(0, 3, imageW, imageH);
     }
    if (2 == _iSystle)
     {
        CGFloat imageW = CGRectGetWidth(contentRect);
        CGFloat imageH = contentRect.size.height * 0.50;
        return CGRectMake(0, 3, imageW, imageH);
     }
    
    CGFloat imageW = CGRectGetWidth(contentRect);
    CGFloat imageH = contentRect.size.height * 0.4;
    return CGRectMake(0, 5, imageW, imageH);
}

@end
