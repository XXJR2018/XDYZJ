//
//  QDKHPresonVC.h
//  XXJR
//
//  Created by xxjr02 on 2018/5/9.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QDKHPresonVC : CommonViewController

@property (nonatomic,strong) NSDictionary *dataDicionary;// 详情数据存储字典

@property (nonatomic,strong) NSString *applyID;// 抢单ID

@property (nonatomic,copy) NSString *borrowId;

@property (nonatomic,copy) NSString *tel;  // 真实电话号码

@property (nonatomic,copy) NSDictionary *lightDic;    // 数据

@property (nonatomic,assign) float usableAmount;    // 可用余额

/*!
 @brief     需要上传的图片
 */
@property (nonatomic, strong) NSData *imageData;

@end
