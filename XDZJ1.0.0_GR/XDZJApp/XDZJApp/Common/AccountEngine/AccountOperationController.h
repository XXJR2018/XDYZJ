//
//  DDGAccountBLController.h
//  DDGProject
//
//  Created by Cary on 15/1/5.
//  Copyright (c) 2015年 Cary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDGJsonParseManager.h"

typedef enum
{
    AccountRequestTypeLogin = 0,          //登录
    AccountRequestTypeRegister,           //注册
    AccountRequestTypeVerifyLogin,          //验证码登陆
    AccountRequestTypeGetVerifyCode,		//获取验证码
    AccountRequestTypeLogOut,				//用户退出登录
    AccountRequestTypeGetUserInfo,		//获取用户信息
    
    AccountRequestTypeResetPassword,   //重置密码
    AccountRequestTypeResetPassword_submitVerifyCode, //重置密码 - 提交验证码
    
    AccountRequestTypeResetPayPassword,   //重置交易密码
    AccountRequestTypeResetPayPassword_submitVerifyCode   //重置交易密码 - 提交验证码
    
} AccountRequestType;


@interface AccountOperationController : NSObject

/*!
 @property  request
 @brief     网络请求
 */
@property (nonatomic, strong) DDGAFHTTPRequestOperation *operation;

/**
 *  操作完成后的回调
 */
@property (nonatomic,strong) Block_Id successBlock;

/**
 *  操作失败后的回调
 */
@property (nonatomic,strong) Block_Id failedBlock;

/*!
 @property  param
 @brief     请求参数
 */
@property (nonatomic, strong) NSMutableDictionary *paramDictionary;

/*!
 @property  request
 @brief     请求类型
 */
@property (nonatomic, assign) AccountRequestType requestType;

/**
 *  正在执行功能的视图
 */
@property (nonatomic,strong) UIViewController *viewControler;



-(void)accountRequest:(AccountRequestType)businessType success:(Block_Id)successBlock fail:(Block_Id)failedBlock;

/*!
 @brief     取消请求
 @return    void
 */
- (void)cancelRequest;


@end




