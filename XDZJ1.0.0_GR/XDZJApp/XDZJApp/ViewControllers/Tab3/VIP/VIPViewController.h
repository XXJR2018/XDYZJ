//
//  VIPViewController.h
//  XXJR
//
//  Created by xxjr03 on 16/10/26.
//  Copyright © 2016年 Cary. All rights reserved.
//

#import "CommonViewController.h"

@interface VIPViewController : CommonViewController

@property(nonatomic,assign)NSInteger vipGrade;
@property(nonatomic,copy)NSString *vipEndDate;
@property(nonatomic,copy)NSString *usableAmount;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *imageUrl;

@property(nonatomic,assign) BOOL isPopRoot;

@end
