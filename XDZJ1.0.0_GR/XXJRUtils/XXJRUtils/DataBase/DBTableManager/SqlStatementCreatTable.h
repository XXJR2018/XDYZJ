//
//  SqlStatementCreatTable.h
//  DDGUtils
//
//  Created by Cary on 15/1/1.
//  Copyright (c) 2015年 Cary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SqlStatementCreatTable : NSObject

/*!
 @brief     create table JMKUser
 @return	NSString 创建用户信息表的sql语句
 */
+ (NSString *)createUserTable;

/*!
 @brief     create table CardModel
 @return	NSString 创建用户未成功绑定的银行卡表的sql语句
 */
+ (NSString *)createUserBankCardTable;

@end
