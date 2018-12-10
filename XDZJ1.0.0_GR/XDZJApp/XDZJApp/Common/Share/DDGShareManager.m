//
//  BPShare.m
//  BigPlayers
//
//  Created by Cary on 13-7-4.
//  Copyright (c) 2013年 Cary. All rights reserved.
//

#import "DDGShareManager.h"
#import "ShareView.h"

NSString *const DDGShareType                       = @"DDGShareType";
NSString *const DDGShareTypeWeChat_haoyou          = @"DDGShareTypeWeChat_haoyou" ;
NSString *const DDGShareTypeWeChat_pengyouquan     = @"DDGShareTypeWeChat_pengyouquan" ;
NSString *const DDGShareTypeSinaWeibo              = @"DDGShareTypeSinaWeibo" ;
NSString *const DDGShareTypeQQ                     = @"DDGShareTypeQQ" ;
NSString *const DDGShareTypeQQqzone                = @"DDGShareTypeQQqzone" ;
NSString *const DDGShareTypeCopyUrl                = @"DDGShareTypeCopyUrl" ;


@interface DDGShareManager ()<DDGSinaWeiboDelegate,DDGQQDelegate,DDGWeChatDelegate>

@property (nonatomic,strong) DDGSinaWeibo *sinaWeibo;
@property (nonatomic,strong) DDGQQ *tcQQ;

/**
 *  分享弹出的视图
 */
@property (nonatomic,strong) UIView *shareView;


/**
 *  父视图
 */
@property (nonatomic,strong) UIView *parentView;

@end

static DDGShareManager *_DDGShareManager = nil;

@implementation DDGShareManager

@synthesize sinaWeibo = _sinaWeibo;
@synthesize tcQQ =  _tcQQ;

+ (DDGShareManager *)shareManager
{
    if (_DDGShareManager == nil)
    {
        @synchronized(self)
        {
            if (_DDGShareManager == nil){
                _DDGShareManager = [[DDGShareManager alloc] init];
            }
        }
    }
    return _DDGShareManager;
}

- (void)loginType:(int)type block:(Block_Id)block view:(UIView *)view{
    _block = block;
    _parentView = view;
    if (type == 1) {
        [DDGQQ getSharedQQ].delegate = self;
        [[DDGQQ getSharedQQ] loginBlock:^{
            [MBProgressHUD showErrorWithStatus:@"请先安装QQ" toView:view];
        }];
    }else if (type == 2){
        [DDGWeChat getSharedWeChat].delegate = self;
        [[DDGWeChat getSharedWeChat] loginBlock:^{
            [MBProgressHUD showErrorWithStatus:@"请先安装微信APP" toView:view];
        }];
    }
}

-(NSString *)lastLoginType{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"lastLoginType"];
}

-(void)setLastLoginType:(NSString *)lastLoginType{
    [[NSUserDefaults standardUserDefaults] setObject:lastLoginType forKey:@"lastLoginType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)share:(ShareContentType)contentType items:(NSDictionary *)items types:(NSArray *)types showIn:(UIViewController *)viewController block:(Block_Id)block{
    _block = block;
    _items = items;
    
    _types = [NSMutableArray arrayWithArray:types];
    _viewController = viewController;
    
    if ([types containsObject:DDGShareTypeWeChat_haoyou] || [types containsObject:DDGShareTypeWeChat_pengyouquan]) {
        [DDGWeChat getSharedWeChat].delegate = self;
    }
    
    if ([types containsObject:DDGShareTypeSinaWeibo]) {
        if (!self.sinaWeibo) {
            self.sinaWeibo = [[DDGSinaWeibo alloc] init];
            _sinaWeibo.delegate = self;
        }
    }
    
    if ([types containsObject:DDGShareTypeQQ] || [types containsObject:DDGShareTypeQQqzone]) {
        if (!_tcQQ) {
            _tcQQ = [DDGQQ getSharedQQ];
            _tcQQ.delegate = self;
        }
    }
    
    // 弹出分享按钮
    [ShareView showIn:viewController types:types block:^(int index){
        if ([types[index] isEqualToString:DDGShareTypeWeChat_pengyouquan]) {
            [self weChatShare:items shareScene:1];
        }else if ([types[index] isEqualToString:DDGShareTypeWeChat_haoyou]){
            [self weChatShare:items shareScene:0];
        }else if ([types[index] isEqualToString:DDGShareTypeSinaWeibo]){
            [self sinaWeiboShare:items contentType:contentType];
        }else if ([types[index] isEqualToString:DDGShareTypeQQ]){
            [self qqShare:items type:0];
        }else if ([types[index] isEqualToString:DDGShareTypeQQqzone]){
            [self qqShare:items type:1];
        }else if ([types[index] isEqualToString:DDGShareTypeCopyUrl]){
            [self copyUrl:[items objectForKey:@"url"]];
        }
    }];
    
}

#pragma mark === 持久化授权数据
-(NSString *)accessToken{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
}

-(void)setAccessToken:(NSString *)accessToken{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:accessToken forKey:@"accessToken"];
    [userDefault synchronize];
}

#pragma mark -
#pragma mark - 微信
#pragma mark -
-(void) weChatLoginFinishedWithResult:(NSMutableDictionary *)result{
    if (_block)
     {
        _block(result);
     }
}

-(BOOL) weChatShare:(NSDictionary *)items shareScene:(int) scene
{
    [DDGWeChat getSharedWeChat].delegate = self;
    if (![WXApi isWXAppInstalled]) {
        [MBProgressHUD showErrorWithStatus:@"请先安装微信APP" toView:_viewController.view];
        return NO;
    }
    return [[DDGWeChat getSharedWeChat] share:items shareScene:scene];
}

-(BOOL) weChatShare:(NSDictionary *)items shareScene:(int) scene block:(Block_Id)block
{
    _block = block;
    [DDGWeChat getSharedWeChat].delegate = self;
    if (![WXApi isWXAppInstalled]) {
        [MBProgressHUD showErrorWithStatus:@"请先安装微信APP" toView:_viewController.view];
        return NO;
    }
    return [[DDGWeChat getSharedWeChat] share:items shareScene:scene];
}

// 回调
-(void) weChatShareFinishedWithResult:(NSMutableDictionary *)result
{
    if (_block)
     {
        _block(result);
     }
}

#pragma mark -
#pragma mark - 新浪微博
#pragma mark -
- (void)sinaWeiboShare:(NSDictionary *)items contentType:(ShareContentType)contentType{
    if (![WeiboSDK isWeiboAppInstalled]) {
        [MBProgressHUD showErrorWithStatus:@"请安装微博APP" toView:_viewController.view];
        return;
    }
    
    WBWebpageObject *messageObject = [[WBWebpageObject alloc] init];
    messageObject.title = [items objectForKey:@"title"];
    if (contentType == ShareContentTypeNews) {
        messageObject.description = [NSString stringWithFormat:@"%@>>> %@",messageObject.title,[items objectForKey:@"subTitle"]];
    }else if (contentType == ShareContentTypeApp){
        messageObject.description = [NSString stringWithFormat:@"袋袋金客户端下载，推荐码%@ >>> %@",[items objectForKey:@"title"],[items objectForKey:@"url"]];
    }
    
//    messageObject.thumbnailData = [items objectForKey:@"image"];
//    messageObject.webpageUrl = @"好友给你推荐了一款赚钱神器,快点击链接进去看看吧>>> http://www.ddgbank.com";
//    messageObject.objectID = @"sinaWeiBoShare_id";
    [_sinaWeibo shareWithMessage:messageObject shareType:WeiBoShareTypeDefault];
}

// 回调
-(void)sinaweiboShareSuccess:(NSMutableDictionary *)result{
    if (_block)
     {
        _block(result);
     }
}

-(void)sinaweiboShareFailed:(NSMutableDictionary *)result{
    if (_block)
     {
        _block(result);
     }
}

#pragma mark -
#pragma mark - 腾讯QQ
#pragma mark -
-(void)qqLoginFinishedWithResult:(NSMutableDictionary *)result{
    if (_block)
     {
        _block(result);
     }
}

- (void)qqShare:(NSDictionary *)items type:(int)type{
    if (![TencentApiInterface isTencentAppInstall:kIphoneQQ]){
        [MBProgressHUD showErrorWithStatus:@"请先安装QQ" toView:_viewController.view];
        return;
    }
    [_tcQQ qqShareNewsType:type title:items[@"title"] Content:items[@"subTitle"] ImageUrl:items[@"image"] gotoUrl:items[@"url"] other:nil];
}

// 回调
-(void)qqShareFinishedWithResult:(NSMutableDictionary *)result //分享结果
{
    if (_block)
     {
        _block(result);
     }
}

#pragma mark -
#pragma mark - 复制链接
#pragma mark -
-(void)copyUrl:(NSString *)url{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = url;
    
    if (url)
        [MBProgressHUD showSuccessWithStatus:@"复制成功" toView:_viewController.view];
}


@end
