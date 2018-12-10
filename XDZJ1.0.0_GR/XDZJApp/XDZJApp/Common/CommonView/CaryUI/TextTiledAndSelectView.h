//
//  TextTiledAndSelectView.h
//  XXJR
//
//  Created by xxjr02 on 2018/4/11.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseLineView.h"

//此控件可输入， 可选择， 可删除
@interface TextTiledAndSelectView : BaseLineView<UITextFieldDelegate>

//  初始化控件为 可以自定义宽度和高低
-(TextTiledAndSelectView*)initWithOrigin_X:(CGFloat) origin_X  origin_Y:(CGFloat)origin_Y   textWidth:(CGFloat) textWdith  textHeight:(CGFloat) textHeight  itemArray:(NSArray *)items  textValue:(NSString *)textValue;




@property (nonatomic,strong) Block_Int finishedBlock;

@property (nonatomic,strong) Block_Void beginBlock;


@property (nonatomic,strong) UITextField *textField;

@property (nonatomic,strong) UIImageView *rightImage;

@property (nonatomic,strong) NSArray *itemsArray;

@property (nonatomic,assign) int selectedIndex;

@end
