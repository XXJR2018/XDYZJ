//
//  BorrowerRedactViewController.h
//  XXJR
//
//  Created by xxjr03 on 16/10/20.
//  Copyright © 2016年 Cary. All rights reserved.
//

#import "CommonViewController.h"

@interface BorrowerRedactViewController : CommonViewController
/*!
 @brief     需要上传的图片
 */
@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, copy) NSDictionary *dataDic;
@end
