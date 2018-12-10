//
//  DPSinaWeibo.h
//  BigPlayers
//
//  Created by Cary on 13-7-4.
//  Copyright (c) 2013年 Cary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboSDK.h"

////新浪微博
#define kAppKey             @"2796001823" // 正式 2796001823  // 测试 3804320580
#define kAppSecret          @"47d00c986ddd12913c75bd1b021e1c06"  // 正式 47d00c986ddd12913c75bd1b021e1c06  // 测试 82ba85f2b749ed10c77722d21e470184
#define kRedirectURI        @"http://www.ddgbank.com/"

typedef NS_ENUM(NSUInteger, WeiBoShareType)
{
    WeiBoShareTypeDefault,
    WeiBoShareTypeUrl,
    WeiBoShareTypeText,
    WeiBoShareTypeImage,
    WeiBoShareTypeMedia
};


@class DDGSinaWeibo;

@protocol DDGSinaWeiboDelegate <NSObject>
@optional

- (void)sinaweiboShareSuccess:(NSMutableDictionary *)result;

- (void)sinaweiboShareFailed:(NSMutableDictionary *)result;


@end

@interface DDGSinaWeibo : NSObject<WBHttpRequestDelegate>

@property (assign, nonatomic) id<DDGSinaWeiboDelegate> delegate;

/**
 *  分享类型
 */
@property (assign, nonatomic) WeiBoShareType shareType;

/**
 *  
 */
@property (assign, nonatomic) NSString *token;

/**
 *  分享返回的结果/错误
 */
@property (nonatomic, strong) NSMutableDictionary *result;

/**
 *  发布分享
 *
 *  @param message  需要发送给微博的消息对象
 *  @param type     分享类型
 */
-(void)shareWithMessage:(WBBaseMediaObject *)message shareType:(WeiBoShareType)type;

@end


