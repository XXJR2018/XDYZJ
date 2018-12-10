//
//  QFRefreshFooterView.m
//  刷新加载
//
//  Created by Honey on 15/9/19.
//  Copyright © 2015年 Honey. All rights reserved.
//

#import "QFRefreshFooterView.h"

@implementation QFRefreshFooterView
{
    BOOL canRefresh;
    
    UIScrollView *_scrollView;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (!_scrollView)
    {
        _scrollView = object;
    }
    
    if ([keyPath isEqualToString:@"contentSize"])
    {
        CGSize size = [change[NSKeyValueChangeNewKey] CGSizeValue];
        
        if  (size.height != 0)
        {
            CGRect frame = self.frame;
            
            frame.origin.y = size.height;
            
            self.frame = frame;
            
            self.hidden = NO;
            
            canRefresh = YES;
        }
        else
        {
            self.hidden = YES;
            canRefresh = NO;
        }
    }
    else if ([keyPath isEqualToString:@"contentOffset"])
        {
            CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];
            
            //NONE --> Draging --> DragEnd --> Refresh --> Loading
            
            switch (self.refreshState) {
                case RefreshStateNone: //正常状态
                    if (canRefresh &&
                        ((offset.y + CGRectGetHeight(_scrollView.frame) >= (_scrollView.contentSize.height + kHeight))))
                    {
                        self.refreshState = RefreshStateDraging;
                    }
                    break;
                    
                case RefreshStateDraging: //拖拽状态
                    //如果是正在拖拽并且没有执行刷新操作
                    
                    if ([object isDragging])
                    {
                        if ((offset.y + CGRectGetHeight(_scrollView.frame) >= (_scrollView.contentSize.height + kHeight)))
                        {
                            self.titleText = kFooterTitle2Refresh;
                        }
                        else
                        {
                            self.titleText = kFooterTitle;
                        }

                    }
                    else
                    {
                        self.refreshState = RefreshStateDrageEnd;
                    }
                    break;
                case RefreshStateDrageEnd:
                    if ((offset.y + CGRectGetHeight(_scrollView.frame) >= (_scrollView.contentSize.height + kHeight)))
                    {
                        self.titleText = @"正在加载数据...";
                        self.refreshState = RefreshStateRefresh;
                    }
                    else
                    {
                        self.refreshState = RefreshStateNone;
                    }
                    break;
                    
                case RefreshStateRefresh: //刷新状态
                    
                    self.refreshState = RefreshStateLoding;
                    if (![object isDragging] && self.action)
                    {
                        [UIView animateWithDuration:kTimeDelay animations:^{
                            
                            [self startAnimation];
                            
                            _scrollView.contentInset = UIEdgeInsetsMake(0, 0, kHeight, 0);
                            
                        } completion:^(BOOL finished) {
                            self.action();
                            
                        }];
                    }
                    
                    break;
                    
                default:
                    break;
            }
        }
}

- (void)stopRefresh
{
    if (self.refreshState == RefreshStateLoding)
    {
        [UIView animateWithDuration:kTimeBack animations:^{
            
            _scrollView.contentInset = UIEdgeInsetsZero;
            
            [self stopAnimation];
            
            self.titleText = kFooterTitle;
        }];
        
        self.refreshState = RefreshStateNone;
    }
}

- (void)dealloc
{
    NSLog(@"footer");
}

@end
