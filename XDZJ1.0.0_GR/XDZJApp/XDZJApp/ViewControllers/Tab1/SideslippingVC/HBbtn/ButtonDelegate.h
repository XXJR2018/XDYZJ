//
//  ButtonDelegate.h
//  ButtonDelegate
//
//  Created by HEYANG on 15/11/20.
//  Copyright © 2015年 HEYANG. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ButtonDelegate <NSObject>

@required

/**
 *  不含参数的事件监听方法
 */
-(void)delegateFunction;


@end
