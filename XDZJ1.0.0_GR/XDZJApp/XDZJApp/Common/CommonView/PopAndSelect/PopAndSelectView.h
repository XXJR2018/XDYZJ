//
//  PopAndSelectView.h
//  XXJR
//
//  Created by xxjr02 on 2018/4/13.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopAndSelectView : UIView

//  初始化控件为 可以自定义宽度和高度
//  origin_X  origin_Y 必须为相对屏幕坐标的位置
-(PopAndSelectView*)initWithOrigin_X:(CGFloat) origin_X  origin_Y:(CGFloat)origin_Y    itemArray:(NSArray *)items ;


//  origin_X  origin_Y 必须为相对屏幕坐标的位置
// textWdith  textHeight  为弹出选项的宽度和高度
-(PopAndSelectView*)initWithOrigin_X:(CGFloat) origin_X  origin_Y:(CGFloat)origin_Y   textWidth:(CGFloat) textWdith  textHeight:(CGFloat) textHeight  itemArray:(NSArray *)items  ;


-(void)showPickView;

-(void) remove;






@property (nonatomic,strong) NSArray *itemsArray;

@property (nonatomic,assign) int selectedIndex;

@property (nonatomic,strong) Block_Int finishedBlock;

@property (nonatomic,strong) Block_Void beginBlock;


@end
