//
//  BaseDataDBController.h
//  PMH.DAL
//
//  Created by Desrie Qi on 13-8-7.
//  Copyright (c) 2013年 Paidui, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDGTableFieldKeys.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

#import "BaseDataDBHelper.h"

/*!
 @class BaseDataDBController
 @brief 基础数据库控制器
 */
@interface BaseDataDBController : NSObject
{
    BaseDataDBHelper *_dbHelper;
}

/*!
 @brief     基础数据db queue
 */
@property (nonatomic, readonly, strong) FMDatabaseQueue *dbQueue;

/*!
 @brief     自动化数据库操作类
 */
@property (nonatomic, strong) BaseDataDBHelper *dbHelper;


/*!
 @brief     单例
 */
+ (instancetype)dbController;

@end
