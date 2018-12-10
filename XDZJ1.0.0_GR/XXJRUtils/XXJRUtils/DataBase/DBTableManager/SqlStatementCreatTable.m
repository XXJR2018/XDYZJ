//
//  SqlStatementCreatTable.m
//  DDGUtils
//
//  Created by Cary on 15/1/1.
//  Copyright (c) 2015年 Cary. All rights reserved.
//

#import "SqlStatementCreatTable.h"

@implementation SqlStatementCreatTable

+ (NSString *)createUserTable
{
    return @" "
    " CREATE TABLE [DDGUser] ( "
    " [user_id] text,  "
    " [mobile] text,  "
    " [avatar_url] text,  "
    " [gender] integer,  "
    " [realname] text,  "
    " [newest_score] integer"
    " )";
}

/*!
 @brief     create table CardModel
 @return	NSString 创建用户未成功绑定的银行卡表的sql语句
 */
+ (NSString *)createUserBankCardTable{
    return @" "
    " CREATE TABLE [CardModel] ( "
    " [uid] text,  "
    " [noagree] text,  "
    " [banknumber] text,  "
    " [bankcode] text,  "
    " [bankname] text,  "
    " [cardtype] text,"
    " [bankAbbre] text,"
    " [updataSuccess] integer,"
    " [setWithdrawSuccess] integer"
    " )";
}

@end
