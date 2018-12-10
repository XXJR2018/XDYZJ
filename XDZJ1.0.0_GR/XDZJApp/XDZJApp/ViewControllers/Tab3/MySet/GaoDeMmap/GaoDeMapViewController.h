//
//  GaoDeMapViewController.h
//  XXJR
//
//  Created by xxjr03 on 16/11/30.
//  Copyright © 2016年 Cary. All rights reserved.
//

#import "CommonViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <MAMapKit/MAMapView.h>
#import <AMapSearchKit/AMapSearchKit.h>
//#import "PlaceAroundTableView.h"
#import <AMapFoundationKit/AMapFoundationKit.h>

@interface GaoDeMapViewController : CommonViewController<AMapSearchDelegate,MAMapViewDelegate>

@property(nonatomic,copy)NSString *cityStr;

@property(nonatomic,copy)NSString *addressStr;

@property(nonatomic,copy)void (^cityBlock)(NSArray *);

@end
