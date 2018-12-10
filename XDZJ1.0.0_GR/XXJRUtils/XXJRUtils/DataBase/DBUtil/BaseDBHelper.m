//
//  BaseDBHelper.m
//  PMH.DAL
//
//  Created by paidui-mini on 13-11-19.
//  Copyright (c) 2013年 Paidui, Inc. All rights reserved.
//

#import "BaseDBHelper.h"
#import "FMDatabase.h"

@interface BaseDBHelper ()
/*!
 @brief     数据库队列
 */
@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

@end

@implementation BaseDBHelper

- (id)init
{
    if (self = [super init])
    {
        self.dbQueue = [self instanceDBQueue];
    }
    return self;
}

- (FMDatabaseQueue *)instanceDBQueue
{
    return nil;
}

- (NSArray *)fMSetColumnArray:(FMResultSet *)fmset
{
    FMStatement *statement = fmset.statement;
    int columnCount = sqlite3_column_count(statement.statement);
    NSMutableArray *columnArray = [NSMutableArray array];
    
    for (int columnIdx = 0; columnIdx < columnCount; columnIdx++)
    {
        NSString *columnName = [NSString stringWithUTF8String:sqlite3_column_name(statement.statement, columnIdx)];
        [columnArray addObject:columnName];
    }
    return columnArray;
}

- (NSArray *)queryAllToModel:(BaseModel *)model
                       where:(NSArray *)expressions
{
    return [self queryDbToModel:model
                        cloumns:nil
                          where:expressions
                        orderBy:nil
                          limit:NSIntegerMax
                         offset:NSIntegerMax];
}

- (NSArray *)queryDBToModel:(BaseModel *)model
                    columns:(NSArray *)columns
                      where:(NSArray *)expressions
{
    return [self queryDbToModel:model
                        cloumns:columns
                          where:expressions
                        orderBy:nil
                          limit:NSIntegerMax
                         offset:NSIntegerMax];
}

- (NSArray *)queryDbToModel:(BaseModel *)model
                    cloumns:(NSArray *)columns
                      where:(NSArray *)expressions
                    orderBy:(NSArray *)orderStatements
                      limit:(NSInteger)mLimit
                     offset:(NSInteger)mOffset
{
    //model（表名）为必填，mColumns为空默认查询整张表
    if (model == nil) return nil;
    
    DBSqlStatment *sqlStatement = [[DBSqlStatment alloc] init];
    // 拼接sql查询语句
    NSString *sql = [sqlStatement
                     selectSqlfromCloumns:columns
                     tableModel:model
                     where:expressions
                     orderBy:orderStatements
                     limit:mLimit
                     offset:mOffset];
    
    NSArray *modelArray = [self executeToModel:model
                                           sql:sql
                                 withArguments:sqlStatement.sqlValues];
    return modelArray;
}

- (BOOL)updateDbByTableModels:(NSArray *)models
                   setColumns:(NSArray *)columns
                        where:(NSArray*)expressions
{
    if (models.count == 0 || !self.dbQueue) return NO;
    
    __block BOOL isSuccess = NO;
    DBSqlStatment *sqlStatement = [[DBSqlStatment alloc] init];
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         for (BaseModel *model in models)
         {
             NSString *sql = [sqlStatement
                              updateTableModel:model
                              setColumns:columns
                              where:expressions];
             isSuccess = [db executeUpdate:sql withArgumentsInArray:sqlStatement.sqlValues];
         }
     }];
    
    return isSuccess;
}

- (BOOL)deleteDbByTableModels:(NSArray *)models where:(NSArray *)expressions
{
    if (models.count == 0 || !self.dbQueue) return NO;
    
    __block BOOL isSuccess = NO;
    DBSqlStatment *sqlStatement = [[DBSqlStatment alloc] init];
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         for (BaseModel *model in models)
         {
             // 返回delete语句                           // [model class]来确定表名
             NSString *sql = [sqlStatement deleteTableModel:model where:expressions];
             isSuccess = [db executeUpdate:sql withArgumentsInArray:sqlStatement.sqlValues];
         }
     }];
    return isSuccess;
}

- (BOOL)insertAllByTableModels:(NSArray *)models
{
    if (models.count == 0) return NO;
    BOOL isSuccess = NO;
    for (BaseModel *model in models)
    {
        NSArray *properties = [model getPropertyList];
        isSuccess = [self insertDbByTableModels:@[model] columns:properties];
    }
    return isSuccess;
}

- (BOOL)insertDbByTableModels:(NSArray *)models columns:(NSArray *)mColumns
{
    if (models.count == 0 || mColumns.count == 0 || !self.dbQueue) return NO;
    
    __block BOOL isSuccess = NO;
    DBSqlStatment *sqlStatement = [[DBSqlStatment alloc] init];
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         for (BaseModel *model in models)
         {
             // 返回插入操作的sql语句        // 将value保存在sqlStatement.sqlValues中
             NSString *sql = [sqlStatement insertTableModel:model columns:mColumns];
             NSLog(@"------->>>>sql is %@",sql);
             isSuccess = [db executeUpdate:sql withArgumentsInArray:sqlStatement.sqlValues];
             
         }
     }];
    
    return isSuccess;
}

- (NSArray *)executeToModel:(NSObject *)model sql:(NSString *)sqlStament withArguments:(NSArray *)arguments
{
    if (!self.dbQueue) return nil;
    
    NSMutableArray *modelArray = [NSMutableArray array];
    [_dbQueue inDatabase:^(FMDatabase *db)
     {
         ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
         // 返回数据库查询结果，但是数据还要处理一下
         FMResultSet *rs = [db executeQuery:sqlStament withArgumentsInArray:arguments];
         // 返回属性组成的数组
         NSArray *properties = [self fMSetColumnArray:rs];
         NSString *columnName = nil;
         @autoreleasepool
         {
             while ([rs next])
             {
                 ////   √√√√----  [[model class] alloc] ------√√√√√
                 BaseModel *obj = [[[model class] alloc] init];
                 
                 // for 循环完成BaseModel的属性的赋值
                 for (int i=0; i<properties.count; i++)
                 {
                     columnName = [[properties objectAtIndex:i] lowercaseFirstString];  // 小写第一个字符
                     id columnValue = [rs objectForColumnName:columnName];
                     
                     NSString *setMethodString = @"set%@:";                                                 // 大写第一个字符
                     SEL selector = NSSelectorFromString([NSString stringWithFormat:setMethodString, [columnName capitalize]]);
                     
                     if (columnValue != [NSNull null] && [obj respondsToSelector:selector])
                     {
                         if ([[obj typeClassName:columnName] isEqualToString:@"NSDate"])
                         {
                             [obj setValue:[self covertToDate:columnValue] forKey:columnName];
                         }
                         else
                         {
                             [obj setValue:columnValue forKey:columnName];
                         }
                     }
                 }
                 
                 [modelArray addObject:obj];
             }

         }
         [rs close];
     }];
    
    if (modelArray.count == 0)
    {
        return nil;
    }
    
    return modelArray;
}

- (NSDate *)covertToDate:(id)object
{
    //从数据库取出的时间为double类型
    if ([object isKindOfClass:[NSNumber class]] && strcmp([(NSNumber *)object objCType], @encode(double)) == 0)
    {
        NSNumber *valueNumber = (NSNumber *)object;
        return [NSDate dateWithTimeIntervalSince1970:valueNumber.doubleValue];
    }
    else
    {
        NSString *valueString = [object description];
        if (valueString.length == 19 && [valueString matches:@"^\\d{4}(-\\d{2}){2} \\d{2}(\\:\\d{2}){2}$"])
        {
            //pass "9999-12-31 23:59:59"
            if ([valueString startsWith:@"9999"]) return nil;
            
            return [valueString convertToDateWithFormat:DefaultDateTimeFormatString];
        }
    }
    return nil;
}

#pragma mark - xiehaiyan添加的方法
- (NSArray *)executeSql:(NSString *) sqlStament withArguments:(NSArray *) arguments andColumnName:(NSArray *) columnNames
{
    if (!self.dbQueue) {
        return nil;
    }
    
    NSMutableArray *resultArr = [[NSMutableArray alloc] init];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sqlStament withArgumentsInArray:arguments];
        @autoreleasepool
        {
            while ([rs next])
            {
                NSMutableArray *arr = [[NSMutableArray alloc] init];
                
                NSString *value1 = [rs stringForColumn:[columnNames objectAtIndex:0]];
                NSString *value2 = [rs stringForColumn:[columnNames objectAtIndex:1]];
                NSString *value3 = [rs stringForColumn:[columnNames objectAtIndex:2]];
                
                [arr addObject:value1];
                [arr addObject:value2];
                [arr addObject:value3];
                
                [resultArr addObject:arr];
            }
            [rs close];
        }
    }];
    return resultArr;
}

- (NSInteger) executeSql_errorTitleCount:(NSString *) sqlStament withArguments:(NSArray *) arguments
{
    if (!self.dbQueue) {
        return 0;
    }
    
    NSMutableArray *arr = [NSMutableArray array];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sqlStament withArgumentsInArray:arguments];
        @autoreleasepool
        {
            while ([rs next])
            {
                NSString *str = [rs stringForColumn:@"errorTitleCount"];
                [arr addObject:str];
            }
            [rs close];
        }
    }];
    return [[arr objectAtIndex:0] integerValue];
}

@end
