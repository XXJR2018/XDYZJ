//
//  ButtonDelegateWithParameter.h
//  ButtonDelegate
//
//  Created by HEYANG on 15/11/20.
//  Copyright © 2015年 HEYANG. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ButtonDelegateWithParameter <NSObject>


/**
 *  含参数的事件监听方法
 */
-(void)delegateFunctionWithParameter:(id)parameter;

@end
