//
//  PDSelectButton.h
//  PMH
//
//  Created by qiu lijian on 14-3-4.
//  Copyright (c) 2014年 Paidui, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXJRSelectButton : UIButton
/*!
 @brief 状态
 */
@property (nonatomic, assign) BOOL selectedState;


/**
 *  选中图片
 */
@property (nonatomic, retain) UIImage *normalImage;
/**
 *  选中图片
 */
@property (nonatomic, retain) UIImage *selectedImage;


/**
 *  选中背景图片
 */
@property (nonatomic, retain) UIImage *selectedBackgroundImage;

/**
 *  正常状态图片
 */
@property (nonatomic, retain) UIImage *normalBackgroundImage;


/**
 *  选中文字颜色
 */
@property (nonatomic, retain) UIColor *selectedTextColor;
/**
 *  文字颜色
 */
@property (nonatomic, retain) UIColor *normalTextColor;


/**
 *  选中背景颜色
 */
@property (nonatomic, retain) UIColor *selectedBGColor;
/**
 *  背景颜色
 */
@property (nonatomic, retain) UIColor *normalBGColor;


@end
