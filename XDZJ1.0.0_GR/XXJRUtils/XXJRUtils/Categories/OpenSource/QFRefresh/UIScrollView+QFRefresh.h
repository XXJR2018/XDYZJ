//
//  UITableView+RefreshHeader.h
//  kissxml
//
//  Created by Honey on 15/9/18.
//  Copyright (c) 2015年 Honey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QFRefreshView.h"
#import "QFRefreshHeaderView.h"
#import "QFRefreshFooterView.h"


@interface UIScrollView (QFRefresh)


- (void)addRefreshHeaderWithAction:(void (^)(void))action;

- (void)addRefreshFooterWithAction:(void (^)(void))action;

- (void)endRefresh;

//释放操作
- (void)freeRefresh;


@end
