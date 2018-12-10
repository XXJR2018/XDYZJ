//
//  MapLocation.h
//  XXJR
//
//  Created by xxjr03 on 16/8/5.
//  Copyright © 2016年 Cary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface MapLocation : NSObject<MKAnnotation>
// 地图标点类必须实现 MKAnnotation 协议
// 地理坐标
@property (nonatomic ,readwrite) CLLocationCoordinate2D coordinate ;

//街道属性信息
@property (nonatomic , copy) NSString * streetAddress ;

// 城市信息属性
@property (nonatomic ,copy) NSString * city ;

// 州，省 市 信息

@property(nonatomic ,copy ) NSString * state ;
//邮编
@property (nonatomic ,copy) NSString * zip  ;



@end
