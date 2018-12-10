//
//  MapLocation.m
//  XXJR
//
//  Created by xxjr03 on 16/8/5.

//  Copyright © 2016年 Cary. All rights reserved.
//

#import "MapLocation.h"

@implementation MapLocation

#pragma mark 标点上的主标题
- (NSString *)title{
    return @"您的位置!";
}

#pragma  mark 标点上的副标题
- (NSString *)subtitle{
    NSMutableString *ret = [NSMutableString new];
    if (_state) {
        [ret appendString:_state];
    }
    if (_city) {
        [ret appendString:_city];
    }
    if (_city && _state) {
        [ret appendString:@", "];
    }
    if (_streetAddress && (_city || _state || _zip)) {
        [ret appendString:@" · "];
    }
    if (_streetAddress) {
        [ret appendString:_streetAddress];
    }
    if (_zip) {
        [ret appendFormat:@",  %@",_zip];
    }
    return ret;
}
@end
