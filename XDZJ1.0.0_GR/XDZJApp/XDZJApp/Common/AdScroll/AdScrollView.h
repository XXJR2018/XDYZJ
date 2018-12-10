//
//  AdScrollView.h
//  广告循环滚动效果
//
//  Created by QzydeMac on 14/12/20.
//  Copyright (c) 2014年 Qzy. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^ PostADViewController) (NSString * url,NSString *adTitle);


typedef NS_ENUM(NSUInteger, UIPageControlShowStyle)
{
    UIPageControlShowStyleNone,//default
    UIPageControlShowStyleLeft,
    UIPageControlShowStyleCenter,
    UIPageControlShowStyleRight,
};

typedef NS_ENUM(NSUInteger, AdTitleShowStyle)
{
    AdTitleShowStyleNone,
    AdTitleShowStyleLeft,
    AdTitleShowStyleCenter,
    AdTitleShowStyleRight,
};

@interface AdScrollView : UIScrollView<UIScrollViewDelegate>

@property (retain,nonatomic,readonly) UIPageControl * pageControl;

//@property (retain,nonatomic) NSArray * adDataArray;
@property (retain,nonatomic,readwrite) NSArray * imageNameArray;
@property (retain,nonatomic,readwrite) NSArray * adTitleArray;
@property (retain,nonatomic,readwrite) NSArray * urlArray;
@property (nonatomic, assign)int currentImageNum;

@property (assign,nonatomic,readwrite) UIPageControlShowStyle  PageControlShowStyle;
@property (assign,nonatomic,readonly) AdTitleShowStyle  adTitleStyle;
@property (nonatomic, assign)   BOOL  bDefalutImage;  //  是否全部为默认图片

@property (nonatomic,copy) PostADViewController postADViewControllerBlock;

- (void)setAdTitleArray:(NSArray *)adTitleArray withShowStyle:(AdTitleShowStyle)adTitleStyle;
@end

