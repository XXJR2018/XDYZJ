//
//  WXLoginViewController_2.h
//  XXJR
//
//  Created by xxjr03 on 17/3/27.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import "CommonViewController.h"

@interface WXLoginViewController_2 : CommonViewController

@property(nonatomic,copy)NSString *unionid;

/*!
 @property  param
 @brief     请求参数
 */
@property (nonatomic, strong) NSMutableDictionary *paramDictionary;

@end
