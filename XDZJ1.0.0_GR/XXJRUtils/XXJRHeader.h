//
//  DDGHeader.h
//  DDGUtils
//
//  Created by Cary on 15/1/1.
//  Copyright (c) 2015年 Cary. All rights reserved.
//

#ifndef DDGUtils_DDGHeader_h
#define DDGUtils_DDGHeader_h




#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)  

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_HEIGHT < 568.0)
#define IS_IPHONE_5_OR_LESS (IS_IPHONE && SCREEN_HEIGHT <= 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_HEIGHT == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_HEIGHT == 667.0)
#define IS_IPHONE_6_LATER (IS_IPHONE && SCREEN_HEIGHT >= 667.0)

#define IS_IPHONE_6P (IS_IPHONE && SCREEN_HEIGHT == 736.0)
#define IS_IPHONE_Plus (IS_IPHONE && SCREEN_HEIGHT == 736.0)
#define IS_IPHONE_X_MORE (IS_IPHONE && SCREEN_HEIGHT >= 812.0)

// > iOS7
#define AtLeast_iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0f ? NO : YES)

// iOS7
#define iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0f && [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)

// iOS8
#define iOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0f && [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f)

// iOS9
#define iOS9 ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0f ? NO : YES)

// iOS11
#define iOS11 ([[[UIDevice currentDevice] systemVersion] floatValue] < 11.0f ? NO : YES)

// iOS11以下的系统
#define iOS11Less  ( [[[UIDevice currentDevice] systemVersion] floatValue] < 11.0f)

#define NavHeight   (IS_IPHONE_X_MORE ? 88.f : 64.f) //64.f

// 是竖屏
#define SCREEN_IS_LANDSCAPE  UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])


#define kBorder 10
#define ScaleSize SCREEN_WIDTH/320.f

#define TabbarHeight     (IS_IPHONE_X_MORE ? 83 : 49.f)
#define TableViewEdgeOffset 20.f

#define CellSpaceReserved 10.f
#define CellHeight44 44.f
#define CellTitleFontSize 14.0

#define CornerRadius    4.0
#define LineHeight      0.60

#define RandomColor [UIColor colorWithRed:arc4random()%255/255.f green:arc4random()%255/255.f blue:arc4random()%255/255.f alpha:1.f]

#define loginFontSize 13


#define  GET_WD_INFO           1000  // 获取微店的本地命令码
#define  GET_HX_INFO           1001  // 获取环信的本地命令码
#define  GET_WDXQ_INFO         1002  // 获取微店详情的本地命令码



#ifdef DEBUG
#   define XXLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define XXLog(...)
#endif


//===================================测试专用======================
#define kdomainSelectedIndex @"domainSelectedIndex"
#endif
