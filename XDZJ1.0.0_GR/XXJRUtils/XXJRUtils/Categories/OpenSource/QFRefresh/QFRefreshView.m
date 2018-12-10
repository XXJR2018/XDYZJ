//
//  QFRefreshView.m
//  刷新加载
//
//  Created by Honey on 15/9/18.
//  Copyright (c) 2015年 Honey. All rights reserved.
//

#import "QFRefreshView.h"

@implementation QFRefreshView
{
    void (^_action)(void);
    UILabel *_titleLabel;
    UILabel *_dateTimeLabel;
    UIActivityIndicatorView *_activityIndicator;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.refreshState = RefreshStateNone;
        
        _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        _titleLabel.font = [UIFont systemFontOfSize:14];
               
        [self addSubview:_titleLabel];
        
        
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        _activityIndicator.center = CGPointMake(130, CGRectGetHeight(frame) / 2);
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        
       
        _activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        
        [self addSubview:_activityIndicator];
    }
    return self;
}

- (void)setTitleText:(NSString *)titleText
{
    _titleLabel.text = titleText;
}


- (void)startAnimation
{
    [_activityIndicator startAnimating];
}

- (void)stopAnimation
{
    [_activityIndicator stopAnimating];
}

- (void)stopRefresh
{
    
}
@end







