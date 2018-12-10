//
//  UITableView+RefreshHeader.m
//  kissxml
//
//  Created by Honey on 15/9/18.
//  Copyright (c) 2015年 Honey. All rights reserved.
//

#import "UIScrollView+QFRefresh.h"

#import <objc/runtime.h>




@implementation UIScrollView (QFRefresh)

//ToDo:
// 添加动态刷新图



- (void)addRefreshHeaderWithAction:(void (^)(void))action
{
    
    QFRefreshHeaderView *header = [[QFRefreshHeaderView alloc] initWithFrame:CGRectMake(0, -kOffsetY, CGRectGetWidth(self.bounds), kHeight)];
    
    [header setAction:action];
    
    
    header.titleText = kHeaderTitle;
    
    [self addSubview:header];

    [self addObserver:header forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    [self setHeader:header];
}


- (void)addRefreshFooterWithAction:(void (^)(void))action
{
    
    QFRefreshFooterView *footer = [[QFRefreshFooterView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds), kHeight)];
        
    footer.action = action;
    
    footer.titleText = kFooterTitle;
    
    if (self.contentSize.height == 0)
    {
        footer.hidden = YES;
    }
    
    [self addSubview:footer];
    
    [self addObserver:footer forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:footer forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    [self setFooter:footer];
    
}

//停止刷新
- (void)endRefresh
{
    [self.header stopRefresh];
    [self.footer stopRefresh];
}

//用来释放kvo监听对象
- (void)freeRefresh
{
    if ([self header])
    {
        [self removeObserver:[self header] forKeyPath:@"contentOffset"];
    }
    
    if ([self footer])
    {
        [self removeObserver:[self footer] forKeyPath:@"contentOffset"];
        [self removeObserver:[self footer] forKeyPath:@"contentSize"];
    }
}


//runtime 添加成员
static char *headerKey;
static char *footerKey;

- (void)setHeader:(QFRefreshHeaderView *)header
{
    objc_setAssociatedObject(self, &headerKey, header, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (QFRefreshHeaderView *)header
{
    return objc_getAssociatedObject(self, &headerKey);
}

- (void)setFooter:(QFRefreshFooterView *)footer
{
    objc_setAssociatedObject(self, &footerKey, footer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (QFRefreshFooterView *)footer
{
    return objc_getAssociatedObject(self, &footerKey);
}



@end





