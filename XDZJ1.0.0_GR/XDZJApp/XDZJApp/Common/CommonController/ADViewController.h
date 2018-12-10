//
//  ADViewController.h
//  DDGAPP
//
//  Created by admin on 15/3/3.
//  Copyright (c) 2015年 Cary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADViewController : CommonViewController

/**
 *  <#Description#>
 */
@property (nonatomic, copy)NSString *url;

/**
 *  <#Description#>
 */
@property (nonatomic, copy)NSString *adTitle;

/**
 *  
 */
@property (nonatomic, copy) NSDictionary *param;

@property (nonatomic, assign) BOOL reloadTitle;

@end
