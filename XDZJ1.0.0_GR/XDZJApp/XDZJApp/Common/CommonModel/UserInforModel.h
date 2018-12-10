//
//  UserInforModel.h
//  DDGAPP
//
//  Created by admin on 15/6/5.
//  Copyright (c) 2015年 Cary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInforModel : BaseModel
/**
 *  真实姓名
 */
@property (nonatomic,copy) NSString *realName;

/**
 *  用户手机号码
 */
@property (nonatomic,copy) NSString *mobile;

/**
 *  用户账户
 */
@property (nonatomic,copy) NSString *userName;

/**
 *  身份证号码
 */
@property (nonatomic,copy) NSString *idcard;

/**
 *  邮箱
 */
@property (nonatomic,copy) NSString *email;

/**
 *  用户状态
 */
@property (nonatomic,copy) NSString *status ;

/**
 *  注册时间
 */
@property (nonatomic,copy) NSString *reg_time ;

/**
 *  实名认证类型
 */
@property (nonatomic,copy) NSString *certification ;


@end
