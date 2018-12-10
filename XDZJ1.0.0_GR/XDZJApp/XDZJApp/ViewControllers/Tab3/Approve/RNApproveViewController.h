//
//  RNApproveViewController.h
//  XXJR
//
//  Created by xxjr03 on 2017/7/27.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import "CommonViewController.h"

@interface RNApproveViewController : CommonViewController

/*!
 @brief     需要上传的图片
 */
@property (nonatomic, strong) NSData *imageData;

@property (nonatomic, copy) NSDictionary *idCardDic;

@end
