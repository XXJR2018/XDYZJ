//
//  PDSelectButton.m
//  PMH
//
//  Created by qiu lijian on 14-3-4.
//  Copyright (c) 2014年 Paidui, Inc. All rights reserved.
//

#import "XXJRSelectButton.h"

@implementation XXJRSelectButton

- (void)setSelectedState:(BOOL)selectedState
{
	_selectedState = selectedState;
	if (selectedState)
	{
		[self setTitleColor:_selectedTextColor forState:UIControlStateNormal];
		[self setBackgroundImage:_selectedBackgroundImage forState:UIControlStateNormal];
		[self setImage:_selectedImage forState:UIControlStateNormal];
        [self setBackgroundColor:_selectedBGColor];
	}
	else
	{
		[self setTitleColor:_normalTextColor forState:UIControlStateNormal];
		[self setBackgroundImage:_normalBackgroundImage forState:UIControlStateNormal];
		[self setImage:_normalImage forState:UIControlStateNormal];
        [self setBackgroundColor:_normalBGColor];
	}
}

@end