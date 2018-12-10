//
//  NewAddSetupViewController.h
//  XXJR
//
//  Created by xxjr02 on 2017/12/21.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewAddSetupViewController : CommonViewController

//反向传值
@property (nonatomic, copy) void(^blockServe) (NSArray *);
@property (nonatomic, copy)NSString *comStr;

@end
