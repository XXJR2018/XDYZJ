//
//  ServeViewController.h
//  XXJR
//
//  Created by xxjr03 on 16/8/1.
//  Copyright © 2016年 Cary. All rights reserved.
//

#import "CommonViewController.h"

@interface ServeViewController : CommonViewController
//反向传值
@property (nonatomic, copy) void(^blockServe) (NSArray *);
@end
