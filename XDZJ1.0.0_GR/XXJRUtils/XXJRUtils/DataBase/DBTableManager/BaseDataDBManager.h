//
//  BaseDataDBManager.h
//  PMH.DAL
//
//  Created by Desrie Qi on 13-8-7.
//  Copyright (c) 2013年 Paidui, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

/*!
 @class BaseDataDBManager
 @brief	基础数据数据库处理器,基础数据库包括数据从服务器下载的数据表Area-城市,Scope-商圈,Trade-业务分类.和本地数据SysConfig-版本信息数据.
 */
@interface BaseDataDBManager : NSObject

/*!
 @brief     data base queue
 */
@property (nonatomic, readonly, strong) FMDatabaseQueue *dbQueue;

/*!
 @brief     BaseDataDBManager单例
 @return    BaseDataDBManager singleton
 */
DEFINE_SINGLETON_FOR_HEADER(BaseDataDBManager);

/*!
 @brief     resetDBManager单例
 @return    nil
 */
+ (void)resetDBManager;

/*!
 @brief     处理数据库错误
 */
- (void)handleDBError;

/*!
 @brief 删除数据库
 *	
 */
- (void)removeDBFile:(NSInteger)dbVersion;

@end
