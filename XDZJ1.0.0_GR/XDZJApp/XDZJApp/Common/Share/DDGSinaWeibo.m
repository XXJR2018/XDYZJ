//
//  DPSinaWeibo.m
//  BigPlayers
//
//  Created by Cary on 13-7-4.
//  Copyright (c) 2013年 Cary. All rights reserved.
//

#import "DDGSinaWeibo.h"
#import "WeiboSDK.h"

@implementation DDGSinaWeibo


-(id)init{
    
    if(self = [super init]){
        
        [WeiboSDK enableDebugMode:YES];
        [WeiboSDK registerApp:kAppKey];
        
        _result = [[NSMutableDictionary alloc] initWithDictionary:@{DDGShareType:DDGShareTypeSinaWeibo}];
    }
    return self;
}


/**
 *  发布分享
 */
-(void)shareWithMessage:(WBBaseMediaObject *)message shareType:(WeiBoShareType)type{
    self.shareType = type;
    
    // sso 认证
    if (![DDGShareManager shareManager].accessToken)
        [self sso];
    
    else if ([WeiboSDK isCanShareInWeiboAPP]) {
        
        [WBHttpRequest requestWithAccessToken:[DDGShareManager shareManager].accessToken url:@"https://api.weibo.com/2/statuses/upload_url_text.json" httpMethod:@"POST" params:@{@"status":[(WBWebpageObject *)message description],@"url":@"http://www.ddgbank.com/Public/Mobile/images/appShareImg.png"} delegate:self withTag:nil];
        return;
        
//        WBAuthorizeRequest *authRequest = (WBAuthorizeRequest *)[WBAuthorizeRequest request];
//        authRequest.redirectURI = kRedirectURI;
//        authRequest.scope = @"all";
//        
//        WBMessageObject *messageObj = [WBMessageObject message];
//        messageObj.mediaObject = message;
//        WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:messageObj];
//        
//        [WeiboSDK sendRequest:request];
    }
}

/**
 *  sso 认证
 */
-(BOOL)sso{
    if([WeiboSDK isCanSSOInWeiboApp]){
        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
        request.redirectURI = kRedirectURI;
        request.scope = @"all";
        //    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
        //                         @"Other_Info_1": [NSNumber numberWithInt:123],
        //                         @"Other_Info_2": @[@"obj1", @"obj2"],
        //                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
        return [WeiboSDK sendRequest:request];
    }
    
    return NO;
}

#pragma mark -
#pragma Internal Method

- (WBMessageObject *)messageToShare
{
    WBMessageObject *message = [WBMessageObject message];
    
    if (self.shareType == WeiBoShareTypeText)
    {
        message.text = NSLocalizedString(@"测试通过WeiboSDK发送文字到微博!", nil);
    }
    
    else if (self.shareType == WeiBoShareTypeImage)
    {
        WBImageObject *image = [WBImageObject object];
        image.imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image_1" ofType:@"jpg"]];
        message.imageObject = image;
    }
    
    else if (self.shareType == WeiBoShareTypeMedia)
    {
        WBWebpageObject *webpage = [WBWebpageObject object];
        webpage.objectID = @"identifier1";
        webpage.title = NSLocalizedString(@"分享网页标题", nil);
        webpage.description = [NSString stringWithFormat:NSLocalizedString(@"分享网页内容简介-%.0f", nil), [[NSDate date] timeIntervalSince1970]];
        webpage.thumbnailData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image_2" ofType:@"jpg"]];
        webpage.webpageUrl = @"http://sina.cn?a=1";
        message.mediaObject = webpage;
    }
    
    return message;
}


#pragma mark -
#pragma WBHttpRequestDelegate

- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    [self.result setObject:result forKey:@"result"];
    [self.result setObject:@(YES) forKey:@"success"];
    if (_delegate && [_delegate respondsToSelector:@selector(sinaweiboShareSuccess:)]) {
        [_delegate sinaweiboShareSuccess:self.result];
    }
}

- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error;
{
    NSString *title = nil;
    UIAlertView *alert = nil;
    
    title = NSLocalizedString(@"请求异常", nil);
    alert = [[UIAlertView alloc] initWithTitle:title
                                       message:[NSString stringWithFormat:@"%@",error]
                                      delegate:nil
                             cancelButtonTitle:NSLocalizedString(@"确定", nil)
                             otherButtonTitles:nil];
    [alert show];
    
    [self.result setObject:error forKey:@"result"];
    [self.result setObject:@(NO) forKey:@"success"];
    if (_delegate && [_delegate respondsToSelector:@selector(sinaweiboShareSuccess:)]) {
        [_delegate sinaweiboShareSuccess:self.result];
    }
}



@end

