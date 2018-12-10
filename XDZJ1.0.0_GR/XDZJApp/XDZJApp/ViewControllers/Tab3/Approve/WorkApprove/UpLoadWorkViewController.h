//
//  UpLoadWorkViewController.h
//  XXJR
//
//  Created by xxjr03 on 2017/8/1.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import "CommonViewController.h"

@interface UpLoadWorkViewController : CommonViewController

@property(nonatomic,copy)NSString *jobImage;

@property(nonatomic,copy)void (^workBlock)(NSString *);
/*!
 @brief     需要上传的图片
 */
@property (nonatomic, strong) NSData *imageData;

/*!
 @brief    认证状态
 */
@property (nonatomic, assign) NSInteger statusType;

@end
