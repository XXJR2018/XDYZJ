//
//  DBSelectColumnsManager.h
//  DBDemo
//
//  Created by paidui-mini on 13-10-15.
//  Copyright (c) 2013年 paidui-mini. All rights reserved.
//


@interface DBSqlColumnsManager : NSObject
/*!
 @brief     查找没有任何限制或sql函数限制的列语句
 */
- (NSString *)sqlColumns:(NSArray *)columns;

/*!
 @brief     查找有限制的（Distinct）或函数修饰（Founctions(c))的列语句
 @prama     dic key:定义的model的属性  value：对应的修饰条件
 */
- (NSString *)sqlColumnsWithLimit:(NSDictionary *)dic;

@end
