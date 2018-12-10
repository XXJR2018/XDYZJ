//
//  SqlStatementGetDBData.m
//  DDGUtils
//
//  Created by Cary on 15/1/1.
//  Copyright (c) 2015年 Cary. All rights reserved.
//

#import "SqlStatementGetDBData.h"

@implementation SqlStatementGetDBData

#pragma mark -
#pragma mark ==== Common ====
#pragma mark -

+ (NSString *)getUserByUserId
{
    return @"select * from [DDGUser] where uid = ?";
}

+ (NSString *)getUserBankCards
{
    return @"select * from [CardModel] where uid = ?";
}

























+ (NSString *)sqlSelectId:(NSString *)idColumn
                     Name:(NSString *)nameColume
            FromTableName:(NSString *)tableName
                    ByIDs:(NSString *)inIdString
{
    return DDG_str(@"SELECT [%@], [%@] FROM [%@] WHERE [%@] IN (%@) ",
                   idColumn,
                   nameColume,
                   tableName,
                   idColumn,
                   inIdString);
}

+ (NSString *)isSelectedDishRequire
{
    return @" "
    " SELECT count(1) AS count FROM [xxx] WHERE [xxId] = ?";
}






@end
