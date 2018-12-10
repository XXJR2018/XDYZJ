//
//  JYJAnimateViewController.h
//  JYJSlideMenuController
//
//  Created by JYJ on 2017/6/16.
//  Copyright © 2017年 baobeikeji. All rights reserved.
//

#import <UIKit/UIKit.h>

#define   CLOSE_SIDE_VIEW     @"colseSideView"

@interface JYJAnimateViewController : UIViewController



@property (nonatomic,strong) Block_Id   popBlock; // 返回时的 block

@property (nonatomic, assign) int  pageType; //  1 - 抢单列表筛选页面 ， 2 - 客户筛选页面

@property (nonatomic, assign) int  borrowType; // 抢单列表的类型(1-优质客户，2-直借客户)

@property (nonatomic, assign) int  bussinessType; // 客户页面的类型(1-抢单客户，2-推广客户， 3-短信客户)







@end
