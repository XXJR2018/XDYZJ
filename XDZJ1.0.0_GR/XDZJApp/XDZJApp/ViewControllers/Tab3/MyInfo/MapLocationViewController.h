//
//  MapLocationViewController.h
//  XXJR
//
//  Created by xxjr03 on 16/8/5.
//  Copyright © 2016年 Cary. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CommonViewController.h" 
#import "MapLocation.h"
@interface MapLocationViewController : CommonViewController<MKMapViewDelegate>

@property(nonatomic,copy)NSString *cityStr;
@property(nonatomic,copy)NSString *addressStr;

@property(nonatomic,copy)void (^cityBlock)(NSArray *);

@end
