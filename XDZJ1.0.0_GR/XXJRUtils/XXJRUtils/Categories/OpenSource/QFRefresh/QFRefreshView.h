//
//  QFRefreshView.h
//  刷新加载
//
//  Created by Honey on 15/9/18.
//  Copyright (c) 2015年 Honey. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kOffsetY            50
#define kHeight             kOffsetY

#define kTimeDelay          0.5
#define kTimeBack           0.25

#define kHeaderTitle              @"下拉刷新"
#define kHeaderTitle2Refresh      @"松手刷新"

#define kFooterTitle              @"上拉加载"
#define kFooterTitle2Refresh      @"加载更多"



typedef enum : NSUInteger {
    RefreshStateNone = 0, //正常状态
    RefreshStateDraging, //正在拖拽
    RefreshStateDrageEnd, //拖拽停止
    RefreshStateRefresh, //开始刷新操作
    RefreshStateLoding //正在加载数据
} RefreshStateing;

typedef enum : NSUInteger {
    PullStateNone,
    PullDown,
    PullUp,
} PullState;




@interface QFRefreshView : UIView

@property (nonatomic, strong) NSString *titleText;

- (id)initWithFrame:(CGRect)frame;

//- (void)setAction:(void (^)(void))action;

@property (nonatomic, strong) void (^action)(void);

@property (nonatomic, assign) RefreshState refreshState;

- (void)startAnimation;
- (void)stopAnimation;

- (void)stopRefresh;



@end
