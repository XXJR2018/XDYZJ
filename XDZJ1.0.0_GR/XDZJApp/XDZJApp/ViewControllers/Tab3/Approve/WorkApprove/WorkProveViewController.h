//
//  WorkProveViewController.h
//  XXJR
//
//  Created by xxjr03 on 2017/8/1.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import "CommonViewController.h"

@interface WorkProveViewController : CommonViewController

@property(nonatomic,assign)NSInteger type;

@property(nonatomic,assign)NSDictionary *workDic;

@property(nonatomic,copy)void (^proveBlock) (void);

@property(nonatomic ,assign)  BOOL   isShowJump;   //是否显示跳过

@end
