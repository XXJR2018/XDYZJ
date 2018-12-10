//
//  DBUserController.h
//  Chinaren.dal
//
//  Created by 登文 陈 on 14-8-12.
//  Copyright (c) 2014年 Cary. All rights reserved.
//

#import "BaseDataDBController.h"
#import "DDGUser.h"
#import "BaseDataDBHelper.h"

@interface DBUserController : BaseDataDBController

/*!
 @brief     获取所有账号
 @param     userID 用户ID
 @return	返回JMKUser实体
 */
- (DDGUser *)getUserByUserId:(NSInteger)user_id;

/*!
 @brief     插入用户数据,插入前判断用户user_id是否存在而断定是插入还是更新
 @param
 */
- (void)insertUser:(DDGUser *)user;

/**
 *  删除用户
 *
 *  @param userID 用户id
 *
 */
- (void)deleteUserWithUserId:(NSString *)userID;


/**
 *  是否存在用户
 *
 *  @param userID 用户id
 *
 */
- (BOOL )isExistUser:(NSString *)userID;

@end
