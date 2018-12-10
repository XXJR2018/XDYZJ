//
//  PDNotifications.m
//  PMH.Common
//
//  Created by well xeon on 9/10/12.
//  Copyright (c) 2012 Paidui, Inc. All rights reserved.
//

#import "PDNotifications.h"

/**
 *  推送通知
 */
/*!
 @brief 通知
 */
NSString *const DDGPushNotification = @"DDGPushNotification";

/*!
 @brief 登陆成功通知
 */
 NSString *const DDGAccountEngineDidLoginNotification = @"DDGAccountEngineDidLoginNotification";

/*!
 @brief 退出登陆成功通知
 */
 NSString *const DDGAccountEngineDidLogoutNotification = @"DDGAccountEngineDidLogoutNotification";

/*!
 @brief token过期通知  signId过期通知
 */
NSString *const DDGUserTokenOutOfDataNotification = @"DDGUserTokenOutOfDataNotification";


/*!
 @brief 设置通知
 */
NSString *const DDGPushNotificationSetting = @"DDGPushNotificationSetting";

/*!
 @brief userInfo需要更新通知
 */
NSString *const DDGNotificationAccountNeedRefresh = @"DDGNotificationAccountNeedRefresh";


/*!
 @brief 账号类型切换的通知
 */
NSString *const DDGSwitchAccountTypeNotification = @"DDGSwitchAccountTypeNotification";

/*!
 @brief 首页跳转到其它tab的通知
 */
NSString *const DDGSwitchTabNotification = @"DDGSwitchTabNotification";



/*!
 @brief 抢单成功通知
 */
NSString *const GrabSuccessNotification = @"GrabSuccessNotification";


/*!
 @brief 刷新抢单列表的通知
 */
NSString *const UpdataListNotification = @"UpdataListNotification";


/*!
 @brief 免费抢单切换状态通知
 */
NSString *const FreeGrabSwitchNotification = @"FreeGrabSwitchNotification";


/*!
 @brief 推广客户抢单成功通知
 */
NSString *const TGGrabSuccessNotification = @"TGGrabSuccessNotification";

/*!
 @brief GPS未打开通知
 */
NSString *const LocationGPSNotOnNotification = @"LocationGPSNotOnNotification";

/*!
 @brief
 */
NSString *const LocationCityDidChangeNotification = @"LocationCityDidChangeNotification";

/*!
 @brief 标签变化通知
 */
NSString *const DDGMarksChangedNotification = @"DDGMarksChangedNotification";

/*!
 @brief 新增查号通知
 */
NSString *const DDGSearchNumNotification = @"DDGSearchNumNotification";

/*!
 @brief APP进入前台的通知
 */
NSString *const DDGEnterForeground = @"DDGEnterForeground";


