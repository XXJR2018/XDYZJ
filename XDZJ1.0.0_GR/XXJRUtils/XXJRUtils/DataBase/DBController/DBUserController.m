//
//  DBUserController.m
//  Chinaren.dal
//
//  Created by 登文 陈 on 14-8-12.
//  Copyright (c) 2014年 Cary. All rights reserved.
//

#import "DBUserController.h"
#import "BaseDataDBHelper.h"
#import "SqlStatementGetDBData.h"


@interface DBUserController ()

@end

@implementation DBUserController

- (id)init
{
    if (self = [super init])
    {
        _dbHelper = [[BaseDataDBHelper alloc] init];
    }
    return self;
}

/*!
 @brief     获取所有账号
 @param     userID 用户ID
 @return	返回JMKUser实体
 */
- (DDGUser *)getUserByUserId:(NSInteger)user_id{
    if (user_id == 0) return nil;
    
    DDGUser  *userModel = [[DDGUser alloc] init];
    NSArray *userArr = [_dbHelper executeToModel:userModel
                                             sql:[SqlStatementGetDBData getUserByUserId]
                                   withArguments:@[[NSString stringWithFormat:@"%ld",(long)user_id]]];
    DDGUser *currentUser = nil;
    if (userArr.count > 0)
    {
        currentUser = [userArr objectAtIndex:0];
    }
    
    return currentUser;
}

/*!
 @brief     插入用户数据,插入前判断用户user_id是否存在而断定是插入还是更新
 @param
 */
- (void)insertUser:(DDGUser *)user{
    if (user == nil)
        return;
    
    NSMutableDictionary *userIdDictionary = [NSMutableDictionary dictionary];
    
    // 根据对应的sql语句，查询出对应的数据库实体的集合 model: 数据库表实体类 cloumns：对应查询的表字段 expressions：sql语句中的where表达式
    NSArray *userlistsArray = [_dbHelper queryDBToModel:user columns:@[PropertyStr(user.user_id)] where:nil];
    if (userlistsArray.count > 0)
    {
        DDGUser *dbUser = [userlistsArray objectAtIndex:0];
        [userIdDictionary setObject:dbUser.uid forKey:dbUser.uid];
    }
    
    if (![userIdDictionary containsKey:[DDGSetting sharedSettings].uid])
    {
        [_dbHelper insertDbByTableModels:@[user] columns:@[PropertyStr(user.uid),
                                                           PropertyStr(user.userName)
                                                           ]];
        
    }
    else
    {
        [_dbHelper updateDbByTableModels:@[user]
                              setColumns:@[PropertyStr(user.uid),
                                           PropertyStr(user.userName)
                                           ]
                                   where:@[WS_key(user.uid)]];
    }
}


/**
 *  删除用户
 *
 *  @param onlineOrderId 订单id
 *
 */
- (void)deleteUserWithUserId:(NSString *)userID
{
    DDGUser *user = [[DDGUser alloc] init];
    user.uid = userID;
    [_dbHelper deleteDbByTableModels:@[user] where:@[WS_key(user.uid)]];
}


- (BOOL )isExistUser:(NSString *)userID
{
	__block BOOL find = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db)
     {
         FMResultSet *rs = [db executeQuery:[SqlStatementGetDBData getUserByUserId],userID];
         if ([rs next])
         {
             find = [rs intForColumnIndex:0] > 0;
         }
         [rs close];
     }];
    return find;
}




@end
