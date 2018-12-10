//
//  RedactInfoViewController.h
//  XXJR
//
//  Created by xxjr03 on 16/8/18.
//  Copyright © 2016年 Cary. All rights reserved.
//

#import "CommonViewController.h"
#import <MapKit/MapKit.h>
#import "CommonViewController.h"
#import "MapLocation.h"
@interface RedactInfoViewController : CommonViewController<MKMapViewDelegate>
/*!
 @brief     需要上传的图片
 */
@property (nonatomic, strong) NSData *imageData;

@property(nonatomic,copy) NSDictionary *dataDic;


@end
