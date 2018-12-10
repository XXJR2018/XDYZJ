//
//  FaceScanViewController.h
//  XXJR
//
//  Created by xxjr03 on 2018/1/8.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import "CommonViewController.h"

@interface FaceScanViewController : CommonViewController
/*!
 @brief     需要上传的图片
 */
@property (nonatomic, strong) NSData *imageData;

@property (nonatomic,copy)NSMutableDictionary *paramDic;


@property(nonatomic ,assign)  BOOL   isShowJump;   //是否显示跳过

@end
