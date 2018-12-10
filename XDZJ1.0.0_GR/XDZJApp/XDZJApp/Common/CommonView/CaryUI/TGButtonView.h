//
//  TGButtonView.h
//  XXJR
//
//  Created by xxjr02 on 2017/12/7.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseLineView.h"


//@interface TGButtonView :  UIView
@interface TGButtonView :  BaseLineView

@property (nonatomic,assign) int iSelPrice;

@property (nonatomic,strong) UITextField  *textFiledMoney;

@property (nonatomic,strong) Block_Int selecltBlock;

//  初始化控件为 半屏幕宽度
-(TGButtonView*)initWithPrice:(int) price  origin_Y:(CGFloat)origin_Y;

//  初始化控件为 全屏幕宽度
-(TGButtonView*)initWithTitle:(NSString *)title withPrice:(int) price  origin_Y:(CGFloat)origin_Y;

// 设置价格
-(void)setPrice:(int) price;






@end
