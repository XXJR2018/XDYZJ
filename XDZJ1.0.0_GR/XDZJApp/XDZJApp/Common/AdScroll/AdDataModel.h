//
//  AdDataModel.h
//  广告循环滚动效果
//
//  Created by QzydeMac on 14/12/20.
//  Copyright (c) 2014年 Qzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdDataModel : BaseModel

@property (strong,nonatomic) NSString * homeImg;
@property (strong,nonatomic) NSString * title;
@property (strong,nonatomic) NSString * homeUrl;



@property (retain,nonatomic,readonly) NSArray * imageNameArray;
@property (retain,nonatomic,readonly) NSArray * adTitleArray;

- (instancetype)initWithImageName;
- (instancetype)initWithImageNameAndAdTitleArray;
+ (id)adDataModelWithImageName;
+ (id)adDataModelWithImageNameAndAdTitleArray;


@end
