//
//  QFRefreshHeaderView.m
//  刷新加载
//
//  Created by Honey on 15/9/18.
//  Copyright (c) 2015年 Honey. All rights reserved.
//

#import "QFRefreshHeaderView.h"

#define kDateTimeKey              @"QFLastRefreshDateTimeKey"

@implementation QFRefreshHeaderView
{
   
    BOOL canRefresh;
    
    UIScrollView *_scrollView;
    
    UILabel *_dateTimeLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        _dateTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, fabs(CGRectGetMidY(self.frame)), CGRectGetWidth(self.frame), 30)];
        
        _dateTimeLabel.textAlignment = NSTextAlignmentCenter;
        
        _dateTimeLabel.font = [UIFont systemFontOfSize:13];
        
        _dateTimeLabel.numberOfLines = 0;
        
        //取出之前保存的最后刷新时间


        
        [self addSubview:_dateTimeLabel];
        
        _dateTimeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        


    }
    
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (!_scrollView)
    {
        _scrollView = object;
    }

    if ([keyPath isEqualToString:@"contentOffset"])
    {
        CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];

        
        //NONE --> Draging --> DragEnd --> Refresh --> Loading
        
        switch (self.refreshStateing) {
            case RefreshStateNone: //正常状态
                if (offset.y < -10)
                {
                    self.refreshStateing = RefreshStateDraging;
                }
                break;
                
            case RefreshStateDraging: //拖拽状态
                //如果是正在拖拽并且没有执行刷新操作
                if ([object isDragging])
                {
                    //根据当前的偏移量设置标题内容
                    if (offset.y < -kOffsetY - 20)
                    {
                        self.titleText = kHeaderTitle2Refresh;
                    }
                    else
                    {
                        self.titleText = kHeaderTitle;
                    }
                }
                else
                {
                    self.refreshStateing = RefreshStateDrageEnd;
                }
                break;
            case RefreshStateDrageEnd:
                if (offset.y < -kOffsetY)
                {
                    self.refreshStateing = RefreshStateRefresh;
                
                    self.titleText = @"正在加载数据中..";
                }
                else
                {
                    self.refreshStateing = RefreshStateNone;
                }
                
                break;
                
            case RefreshStateRefresh: //刷新状态
                
                self.refreshStateing = RefreshStateLoding;
                
                if (![object isDragging] && self.action)
                {
                    [UIView animateWithDuration:kTimeDelay animations:^{
                        
                        [self startAnimation];
                        [object setContentInset:UIEdgeInsetsMake(kHeight, 0, 0, 0)];
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
    if (self.refreshStateing == RefreshStateLoding)
    {
        [UIView animateWithDuration:kTimeBack animations:^{
            
            _scrollView.contentInset = UIEdgeInsetsZero;
            
            [self stopAnimation];
            
            self.titleText = kHeaderTitle;
        }];
        
        NSDate *date = [NSDate date];
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        self.dateTimeText = [formater stringFromDate:date];
        self.refreshState = RefreshStateNone;
    }
}

- (void)setDateTimeText:(NSString *)dateTimeText
{
    _dateTimeLabel.text = dateTimeText;
    
    NSLog(@"%@", [[self viewController] class]);
    
    //保存最后刷新时间
    [[NSUserDefaults standardUserDefaults] setObject:dateTimeText forKey:NSStringFromClass([[self viewController] class])];
    
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (void)layoutSubviews
{
    if (_dateTimeLabel.text.length == 0)
    {
        NSString *key = NSStringFromClass([[self viewController] class]);
        _dateTimeLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:key];
        
        NSLog(@"%@", key);
  
    }
}

//获取当前刷新控件所在的viewcontroller,然后利用该类名作为保存最后刷新时间的key
- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}



- (void)dealloc
{
    NSLog(@"header");
}


@end
