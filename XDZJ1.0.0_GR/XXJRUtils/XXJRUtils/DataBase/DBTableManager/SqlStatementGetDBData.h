//
//  SqlStatementGetDBData.h
//  DDGUtils
//
//  Created by Cary on 15/1/1.
//  Copyright (c) 2015年 Cary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SqlStatementGetDBData : NSObject

// 获取用户信息
+ (NSString *)getUserByUserId;

/**
 *  获取用户未绑定银行卡
 *
 *  @return <#return value description#>
 */
+ (NSString *)getUserBankCards;



/*!
 @brief     查询多个id的name, 查询条件是传入的多个id
 @param     idColumn: id 的列名
 @param     nameColume: name 的列名的名字
 @param     tableName: 表名
 @param     inIds: 查询条件,拼接成'id1','id2','id3'
 @return    NSString
 */
+ (NSString *)sqlSelectId:(NSString *)idColumn
                     Name:(NSString *)nameColume
            FromTableName:(NSString *)tableName
                    ByIDs:(NSString *)inIds;

/*!
 @brief     是否已经缓存要求
 */
+ (NSString *)isSelectedDishRequire;

@end
