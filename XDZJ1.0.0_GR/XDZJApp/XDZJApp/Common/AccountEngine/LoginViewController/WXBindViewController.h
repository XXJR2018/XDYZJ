//
//  WXBindViewController.h
//  XXJR
//
//  Created by xxjr03 on 17/2/7.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import "CommonViewController.h"

@interface WXBindViewController : CommonViewController
@property(nonatomic,copy)NSString *unionid;

/*!
 @property  param
 @brief     请求参数
 */
@property (nonatomic, strong) NSMutableDictionary *paramDictionary;


@end
