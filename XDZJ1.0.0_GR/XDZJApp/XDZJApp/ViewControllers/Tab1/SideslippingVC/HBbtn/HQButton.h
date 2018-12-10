//
//  HQButton.h
//  ButtonDelegate
//
//  Created by HEYANG on 15/11/20.
//  Copyright © 2015年 HEYANG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonDelegate.h"
#import "ButtonDelegateWithParameter.h"

@interface HQButton : UIButton

/** 代理 */
@property (nonatomic,weak)id<ButtonDelegate> delegate;

/** 含参数代理 */
@property (nonatomic,weak)id<ButtonDelegateWithParameter> delegateWithParamater;

@property (nonatomic,assign) int iStyle;  // 1 -- 勾在中间  ， 2 --- 勾在下面

@property (nonatomic,assign) int iFontSize;  // 字体大小

@property (nonatomic,strong) UIImageView  *imgGou;  // 1 -- 勾在中间  ， 2 --- 勾在下面

-(void) setNOSelected;

-(void) setIsSelected;

@end
