//
//  FilerBussinessVC.h
//  XXJR
//
//  Created by xxjr02 on 2018/4/8.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilerBussinessVC : UIViewController

@property (nonatomic, assign) int  bussinessType; // 客户页面的类型(1-抢单客户，2-推广客户， 3-短信客户)


@property (nonatomic,strong) Block_Id   popBlock; // 返回时的 block

@end
