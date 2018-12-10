//
//  DDGUtils.m
//  DDGUtils
//
//  Created by Cary on 14/12/31.
//  Copyright (c) 2014年 Cary. All rights reserved.
//

#import "XXJRUtils.h"

#import "Reachability.h"

#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <objc/runtime.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <sys/sockio.h>
#include <net/if.h> 
#include <errno.h>
#include <net/if_dl.h>

#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>



#define min(a,b) ((a) < (b) ? (a) : (b))
#define max(a,b) ((a) > (b) ? (a) : (b))

static XXJRUtils *_evtUtils = nil;
static Reachability *_reachablity = nil;
static NetworkStatus _networkStatus = NotReachable;

NSString * const kReachabilityChangedNotification = @"kReachabilityChangedNotification";

///////////////////////////////////////////////////////////////////////////////////////////////////
void DDGSwapInstanceMethods(Class cls, SEL originalSel, SEL newSel)
{
    Method originalMethod = class_getInstanceMethod(cls, originalSel);
    Method newMethod = class_getInstanceMethod(cls, newSel);
    method_exchangeImplementations(originalMethod, newMethod);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
void DDGSwapClassMethods(Class cls, SEL originalSel, SEL newSel)
{
    Method originalMethod = class_getClassMethod(cls, originalSel);
    Method newMethod = class_getClassMethod(cls, newSel);
    method_exchangeImplementations(originalMethod, newMethod);
}

void DDGReplaceRootViewWithController(UIViewController *oldViewController, UIViewController *newViewController)
{
    id delegate = [UIApplication sharedApplication].delegate;
    if ([delegate respondsToSelector:@selector(setRootViewController:)])
        [delegate performSelector:@selector(setRootViewController:) withObject:newViewController];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if ([keyWindow respondsToSelector:@selector(setRootViewController:)])
        keyWindow.rootViewController = newViewController;
    else {
        [oldViewController.view removeFromSuperview];
        [keyWindow addSubview:newViewController.view];
    }
}

@implementation XXJRUtils


+ (void)initialize
{
    if (_reachablity == nil)
    {
        // 设置网络检测的站点
//        _reachablity = [Reachability reachabilityWithHostName:@"www.baidu.com"];
        _reachablity = [Reachability reachabilityForInternetConnection];
        [_reachablity startNotifier];  //开始监听,会启动一个run loop
        _networkStatus = [_reachablity currentReachabilityStatus];
        
        _evtUtils = [[XXJRUtils alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:_evtUtils
                                                 selector:@selector(handleReachabilityDidChangedNotification:)
                                                     name:ReachabilityDidChangedNotification
                                                   object:nil];
    }
}

- (void)handleReachabilityDidChangedNotification:(NSNotification *)notification
{
    NetworkStatus status = [_reachablity currentReachabilityStatus];
    if (_networkStatus != status)
    {
        BOOL isNeedPostNotification = (_networkStatus == NotReachable || status == NotReachable);
        _networkStatus = status;
        if (isNeedPostNotification)
            [[NSNotificationCenter defaultCenter] postNotificationName:kReachabilityChangedNotification object:nil];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ReachabilityDidChangedNotification object:nil];
}


+ (BOOL)isRetinaDisplay
{
    return [[self class] scale] == 2.f;
}

+ (CGFloat)scale
{
    static BOOL isScaled;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isScaled = [[UIScreen mainScreen] respondsToSelector:@selector(scale)];
    });
    if (isScaled)
        return [[UIScreen mainScreen] scale];
    else
        return 1.f;
}



+ (BOOL)isIPhone5
{
    static NSInteger isIP5 = -1;
    if (isIP5 < 0)
        isIP5 = CGRectGetHeight([UIScreen mainScreen].bounds) == 568.f;
    return isIP5 > 0;
}

+ (BOOL)isAtLeastIOS_6_0{
    //    return [[[UIDevice currentDevice] systemVersion] floatValue] >= 6.f;
    return kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_6_0;
}

+ (BOOL)isAtLeastIOS_7_0
{
    return kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_7_0;
}

+ (NSString *)tempPath
{
    return NSTemporaryDirectory();
}


/*!
 @brief     getCurrentIP
 @return    当前设备的IP
 */
static NSString *currentIP = nil;
+ (NSString *)getCurrentIP
{
    int  MAXADDRS = 32;
    int BUFFERSIZE = 4000 ;
    char *if_names[MAXADDRS];
    char *ip_names[MAXADDRS];
    unsigned long ip_addrs[MAXADDRS];
    int                 i, len, flags;
    char                buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;
    struct ifconf       ifc;
    struct ifreq        *ifr, ifrcopy;
    struct sockaddr_in  *sin;
    int nextAddr = 0;
    char temp[80];
    
    if (currentIP != nil) {
        return currentIP;
    }
    int sockfd;
    
    for (i=0; i<MAXADDRS; ++i)
    {
        if_names[i] = ip_names[i] = NULL;
        ip_addrs[i] = 0;
    }
    
    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0)
    {
        perror("socket failed");
        return nil;
    }
    
    ifc.ifc_len = BUFFERSIZE;
    ifc.ifc_buf = buffer;
    
    if (ioctl(sockfd, SIOCGIFCONF, &ifc) < 0)
    {
        perror("ioctl error");
        return nil;
    }
    
    lastname[0] = 0;
    
    for (ptr = buffer; ptr < buffer + ifc.ifc_len; )
    {
        ifr = (struct ifreq *)ptr;
        len = max(sizeof(struct sockaddr), ifr->ifr_addr.sa_len);
        ptr += sizeof(ifr->ifr_name) + len;  // for next one in buffer
        
        if (ifr->ifr_addr.sa_family != AF_INET)
        {
            continue;   // ignore if not desired address family
        }
        
        if ((cptr = (char *)strchr(ifr->ifr_name, ':')) != NULL)
        {
            *cptr = 0;      // replace colon will null
        }
        
        if (strncmp(lastname, ifr->ifr_name, IFNAMSIZ) == 0)
        {
            continue;   /* already processed this interface */
        }
        
        memcpy(lastname, ifr->ifr_name, IFNAMSIZ);
        
        ifrcopy = *ifr;
        ioctl(sockfd, SIOCGIFFLAGS, &ifrcopy);
        flags = ifrcopy.ifr_flags;
        if ((flags & IFF_UP) == 0)
        {
            continue;   // ignore if interface not up
        }
        
        if_names[nextAddr] = (char *)malloc(strlen(ifr->ifr_name)+1);
        if (if_names[nextAddr] == NULL)
        {
            for (int j=0; j<nextAddr;j++) {
                free(if_names[j]);
            }
            free(if_names);
            return nil;
        }
        strcpy(if_names[nextAddr], ifr->ifr_name);
        
        sin = (struct sockaddr_in *)&ifr->ifr_addr;
        strcpy(temp, inet_ntoa(sin->sin_addr));
        
        ip_names[nextAddr] = (char *)malloc(strlen(temp)+1);
        if (ip_names[nextAddr] == NULL)
        {
            for (int j=0; j<nextAddr;j++) {
                free(if_names[j]);
            }
            free(if_names);
            
            for (int j=0; j<nextAddr;j++) {
                free(ip_names[j]);
            }
            free(ip_names);
            
            
            return nil;
        }
        strcpy(ip_names[nextAddr], temp);
        
        ip_addrs[nextAddr] = sin->sin_addr.s_addr;
        
        ++nextAddr;
    }
    
    close(sockfd);
    
    currentIP = [NSString stringWithFormat:@"%s", ip_names[1]];
    
    for (int j=0; j<nextAddr;j++) {
        free(if_names[j]);
    }
    
    
    for (int j=0; j<nextAddr;j++) {
        free(ip_names[j]);
    }
    
    return currentIP;
}

+(NSDictionary *)deviceWANIPAdress{
    NSError *error;
    NSURL *ipURL = [NSURL URLWithString:@"http://pv.sohu.com/cityjson?ie=utf-8"];
    NSMutableString *ip = [NSMutableString stringWithContentsOfURL:ipURL encoding:NSUTF8StringEncoding error:&error];
    //判断返回字符串是否为所需数据
    if ([ip hasPrefix:@"var returnCitySN = "]) {
        //对字符串进行处理，然后进行json解析
        //删除字符串多余字符串
        NSRange range = NSMakeRange(0, 19);
        [ip deleteCharactersInRange:range];
        NSString * nowIp =[ip substringToIndex:ip.length-1];
        //将字符串转换成二进制进行Json解析
        NSData * data = [nowIp dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        return dict[@"cip"];
    }
    return nil;
}

+ (NSString *)terminalSign
{
    NSString *_terminalSign = [[NSUserDefaults standardUserDefaults] objectForKey:DDGTerminalSignKey];
    if (_terminalSign == nil)
    {
        if ([XXJRUtils isAtLeastIOS_7_0])
        {
            _terminalSign = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        }
        else
        {
            //MAC地址
            _terminalSign = [[UIDevice wifiMacAddressString] stringByReplacingOccurrencesOfString:@":" withString:@""];
        }
        
        //最后再取UUid的值
        if (_terminalSign == nil)
        {
            _terminalSign = [NSString createUUID];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:_terminalSign forKey:DDGTerminalSignKey];
    }
    return _terminalSign;
}

+ (BOOL) isTwelveHourFormat{
    
    //下面的方法应该更简单， 直接返回AM/PM
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    
    [timeFormatter setDateFormat:@"a"];
    NSString *AMPMtext = [timeFormatter stringFromDate:[NSDate date]];
    return !([AMPMtext isEqualToString:@""]);
    
//	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];    //	[formatter setDateStyle:NSDateFormatterNoStyle];
//	[formatter setTimeStyle:NSDateFormatterShortStyle];
//	NSString *dateString = [formatter stringFromDate:[NSDate date]];
//	NSRange amRange = [dateString rangeOfString:[formatter AMSymbol]];
//	NSRange pmRange = [dateString rangeOfString:[formatter PMSymbol]];
//	return !(amRange.location == NSNotFound && pmRange.location == NSNotFound);
}

+ (NSString *)mobileType
{
    if ([XXJRUtils isIpad])
        return @"2.2";
    if ([[[UIDevice currentDevice] model] rangeOfString:@"iPhone"
                                                options:NSCaseInsensitiveSearch].location!= NSNotFound)
        return @"2.1";
    if ([[[UIDevice currentDevice] model] rangeOfString:@"iPod"
                                                options:NSCaseInsensitiveSearch].location != NSNotFound)
        return @"2.3";
    //apple tv, etc
    return @"2.0";
}


#pragma mark ===
#pragma mark === 文件路径方法
// 判断路径存在
+ (BOOL)fileExistsAtPath:(NSString *)path{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:path];
    
    if(fileExists){
        return YES;
    }else{
        return NO;
    }
}


// 按路径删除文件
+ (void)deleteFileAtPath:(NSString *)path{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:path];
    
    if(fileExists){
        
        [fileManager removeItemAtPath:path error:nil];
    }else{
        
        
    }
}


+ (NSString *)documentPath{
    static NSString* path= nil;
    if (nil == path) {
        NSArray* dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                            NSUserDomainMask,
                                                            YES);
        path = [dirs objectAtIndex:0];
    }
    return path;
}

+ (NSString *)libraryPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

// 缓存路径
+ (NSString *)cachePath
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

/**
 * Caches/global
 **/

// 全局根文件 .../Caches/global
+ (NSString *)cachesGlobalRootPath{
    
    NSString * path = [[self cachePath]stringByAppendingPathComponent:@"global"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:path];
    
    if(fileExists){
        
    }else{
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return path;
}


// 全局根文件 .../Caches/global + folder
+ (NSString *)cachesGlobalWithFolder:(NSString *)name{
    
    NSString * path = [[self cachesGlobalRootPath] stringByAppendingPathComponent:name];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:path];
    
    if(fileExists){
        
    }else{
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return path;
}

// 用户根文件 .../Caches/user
+ (NSString *)cachesUserRootPath{
    
    NSString * path = [[self cachePath]stringByAppendingPathComponent:@"user"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:path];
    
    if(fileExists){
        
    }else{
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return path;
}

// 用户关联id文件 .../Caches/user/user_id
+ (NSString *)cachesUserPath:(NSString *)userID{
    
    NSString * path = [[self cachesUserRootPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"user_%@",userID]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:path];
    
    if(fileExists){
        
    }else{
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}


// 用户头像路径 ...(Caches/user/userIcon)
+ (NSString *)userIconPath{
    
    NSString * path = [[self cachesUserRootPath] stringByAppendingPathComponent:@"userIcon"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:path];
    
    if(fileExists){
        
    }else{
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}


+ (NSString *)pathForResource:(NSString *)relativePath InBundle:(NSBundle *)bundle{
    return [[(bundle == nil ? [NSBundle mainBundle] : bundle) resourcePath]
            stringByAppendingPathComponent:relativePath];
}

+ (NSString *)pathForResrouceInDocuments:(NSString *)relativePath{
    
    return [[XXJRUtils documentPath] stringByAppendingPathComponent:relativePath];
}

+ (void)setUILabel:(UILabel *)myLabel withMaxFrame:(CGRect)maxFrame
          withText:(NSString *)theText usingVerticalAlign: (VerticalAlignment) vertAlign
{
    CGSize stringSize = [theText sizeWithFont:myLabel.font
                            constrainedToSize:maxFrame.size
                                lineBreakMode:myLabel.lineBreakMode];
    
    switch (vertAlign) {
        case VerticalAlignmentTop: // vertical align = top
            myLabel.frame = CGRectMake(myLabel.frame.origin.x,
                                       myLabel.frame.origin.y,
                                       myLabel.frame.size.width,
                                       stringSize.height
                                       );
            break;
            
        case VerticalAlignmentMiddle: // vertical align = middle
            // don't do anything, lines will be placed in vertical middle by default
            break;
            
        case VerticalAlignmentBottom: // vertical align = bottom
            myLabel.frame = CGRectMake(myLabel.frame.origin.x,
                                       (myLabel.frame.origin.y + myLabel.frame.size.height) - stringSize.height,
                                       myLabel.frame.size.width,
                                       stringSize.height
                                       );
            break;
        default:
            break;
    }
    
    myLabel.text = theText;
}

+ (void)setUILabel:(UILabel *)label fontSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    CGFloat fontSize = [font pointSize];
    CGFloat height = [label.text sizeWithFont:font
                            constrainedToSize:CGSizeMake(size.width, FLT_MAX)
                                lineBreakMode:NSLineBreakByCharWrapping].height;
    UIFont *newFont = font;
    
    //Reduce font size while too large, break if no height (empty string)
    while (height > size.height && height != 0) {
        fontSize--;
        newFont = [UIFont fontWithName:font.fontName size:fontSize];
        height = [label.text sizeWithFont:newFont
                        constrainedToSize:CGSizeMake(size.width, FLT_MAX)
                            lineBreakMode:NSLineBreakByWordWrapping].height;
    };
    
    // Loop through words in string and resize to fit
    //    for (NSString *word in [label.text componentsSeparatedByString:@""])
    //    {
    //        CGFloat width = [word sizeWithFont:newFont].width;
    //        while (width > size.width && width != 0) {
    //            fontSize--;
    //            newFont = [UIFont fontWithName:font.fontName size:fontSize];
    //            width = [word sizeWithFont:newFont].width;
    //        }
    //    }
    [label setFont:[UIFont systemFontOfSize:fontSize]];
}

+ (BOOL)isNetworkReachable
{
    return _networkStatus != NotReachable;
}

+ (BOOL)isNetworkReachableViaWiFi
{
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] == ReachableViaWiFi);
}

/*!
 @brief     判断网络是否是2G/3G
 */
+ (BOOL)isNetworkReachableVia2G3G
{
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableVia2G ||
            [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableVia3G);
}

+ (void)startNetworkNotifier
{
    [_reachablity startNotifier];
    
}

+ (BOOL)isAppFirstLoadTab:(NSInteger)index{
    NSString *firstLoadView = nil;
    
    switch (index) {
        case 1:
            firstLoadView = [[NSUserDefaults standardUserDefaults] stringForKey:FirstLoadView1];
            break;
        case 2:
            firstLoadView = [[NSUserDefaults standardUserDefaults] stringForKey:FirstLoadView2];
            break;
        case 3:
            firstLoadView = [[NSUserDefaults standardUserDefaults] stringForKey:FirstLoadView3];
            break;
        case 4:
            firstLoadView = [[NSUserDefaults standardUserDefaults] stringForKey:FirstLoadView4];
            break;
        default:
            break;
    }
    
    if (firstLoadView != nil) {
        return NO;
    }
    return YES;
}

+ (BOOL)isAppFirstLoaded
{
    NSString *savedVersionString = [[NSUserDefaults standardUserDefaults] stringForKey:DDGBundleVersionKey];
    if (savedVersionString == nil) return YES;
    // 比较是否第一次进入当前这个版本
    NSString *appVersionString = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    return ![savedVersionString isEqualToString:appVersionString];
}

+ (void)saveBundleVersion
{
    [[NSUserDefaults standardUserDefaults] setObject:[[[NSBundle mainBundle] infoDictionary]
                                                      objectForKey:(NSString *)kCFBundleVersionKey]
                                              forKey:DDGBundleVersionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)createNewSessionId
{
    return [NSString createUUID];
}
+ (NSString *)mobileResolution
{
    CGSize pixelBufferSize = [[[UIScreen mainScreen] currentMode] size];
    return [NSString stringWithFormat:@"%.0f*%.0f",pixelBufferSize.height,pixelBufferSize.width];
}

+ (NSDictionary *)getMobileNetworkPropertys
{
    NSMutableDictionary *returnDictionary = [[NSMutableDictionary alloc]init];
    CTTelephonyNetworkInfo *tni = [[CTTelephonyNetworkInfo alloc] init];
    [returnDictionary setValue:tni.subscriberCellularProvider.carrierName forKey:@"carrierName"];
    [returnDictionary setValue:tni.subscriberCellularProvider.mobileCountryCode forKey:@"mobileCountryCode"];

    return returnDictionary;
}

#pragma mark -
#pragma mark ==== 空对象处理函数 ====
#pragma mark -

+ (NSString *)replaceNilStringWithEmptyString:(id)stringIfNil
{
    static NSString *const emptyString = @"";
    return (stringIfNil == nil || stringIfNil == [NSNull null]) ? emptyString : stringIfNil;
}

+ (NSString *)replaceNilString:(id)stringIfNil withString:(NSString *)replaceString
{
    return (stringIfNil == nil || stringIfNil == [NSNull null]) ? replaceString : stringIfNil;
}


+ (id)replaceNilObjectWithNullObject:(id)objectIfNil
{
    return objectIfNil == nil ? [NSNull null] : objectIfNil;
}

+ (id)replaceNilObject:(id)objectIfNil withObject:(id)replaceObject
{
    return objectIfNil == nil ? replaceObject : objectIfNil;
}

// 将字典的内容 全部转为字符串
+(NSDictionary* ) setStringForDictionary:(NSDictionary*) dic
{
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    for (NSString *strKey in dic.allKeys)
     {
        NSValue *value = dic[strKey];
        if([value isKindOfClass:[NSNumber class]])
         {
            const char * pObjCType = [((NSNumber*)value) objCType];
            if (strcmp(pObjCType, @encode(BOOL)) == 0)
             {
                NSLog(@"key:%@ value:%@  is BOOL", strKey, value);;
                int iTemp = (int)[dic[strKey] intValue];
                mdic[strKey] = [NSString stringWithFormat:@"%d", iTemp];
             }
            else if (strcmp(pObjCType, @encode(int)) == 0)
             {
                NSLog(@"key:%@ value:%@  is int", strKey, value);;
                int iTemp = (int)[dic[strKey] intValue];
                mdic[strKey] = [NSString stringWithFormat:@"%d", iTemp];
             }
            else if (strcmp(pObjCType, @encode(float)) == 0)
             {
                NSLog(@"key:%@ value:%@  is float", strKey, value);;
                float fTemp = (int)[dic[strKey] floatValue];
                mdic[strKey] = [NSString stringWithFormat:@"%f", fTemp];
             }
            else if (strcmp(pObjCType, @encode(double)) == 0)
             {
                NSLog(@"key:%@ value:%@  is double", strKey, value);;
                double fTemp = (int)[dic[strKey] doubleValue];
                mdic[strKey] = [NSString stringWithFormat:@"%f", fTemp];
             }
            else
             {
                NSLog(@"key:%@ value:%@  ", strKey, value);
                printf("pObjCType:%s\n", pObjCType);
                double fTemp = (int)[dic[strKey] doubleValue];
                mdic[strKey] = [NSString stringWithFormat:@"%f", fTemp];
             }
         }
        else
         {
            NSLog(@"key:%@ value:%@  is string", strKey, value);
         }
        
     }
    return mdic;
    
}

// 计算字符长度和高度，根据frame 和 font
+  (CGSize) getSizeWithString:(NSString*) string withFrame:(CGRect) rect withFontSize:(int)fontSize
{
    CGSize titleSize = [string boundingRectWithSize:rect.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    
    return titleSize;
}


//将JASON字符串中的乱码中文，正确显示
+  (NSString*) getStringFromDic:(NSDictionary*) dic;
{
    NSString* strRet = @"";
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    strRet = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return strRet;
}

//将JASON字符串中的乱码中文，正确显示
+  (NSString*) getStringFromAry:(NSArray *) ary
{
    NSString* strRet = @"";
    NSData *data = [NSJSONSerialization dataWithJSONObject:ary options:NSJSONWritingPrettyPrinted error:nil];
    strRet = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return strRet;
}

// 将2017-11-12 12:12:12  转换为  多少分钟前
+  (NSString*) getStringFromTime:(NSString*) strValue
{

    
    //NSString *str = @"2014-05-12 17:22:30";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:strValue];
    //long
    
    
    long lTime = [date timeIntervalSince1970];
    
    
    NSString *strTime =@"1分钟前";
    long lCurrent = time(NULL);
    long lDiff = (long)fabs(lCurrent - lTime);
    //NSLog(@"当前时间间戳 = %ld， 后台时间戳 = %ld   时间差%ld秒",lCurrent, lTime, lDiff);
    if ( (int)lDiff / (24*60* 60))
     {
        int  iDate = (int)lDiff / (24*60* 60);
        strTime = [NSString stringWithFormat:@"  %d天前", iDate];
     }
    else if ((int)lDiff / (60* 60))
     {
        int  iHours = (int)lDiff / (60* 60);
        strTime = [NSString stringWithFormat:@"%d小时前", iHours];
     }
    else if ((int)(lDiff / 60))
     {
        int  iSecond = (int)lDiff / 60;
        strTime = [NSString stringWithFormat:@"%d分钟前", iSecond];
     }
    
    return strTime;
    
}


// 将2017-11-12   转换为  11月12号
+  (NSString*) getDateFromTime:(NSString*) strValue
{
    
    
    
    NSString *strTime = @"";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:strValue];
    
    
    
   if (strValue.length > 9)
    {
       
       NSCalendar *cal = [NSCalendar currentCalendar];
       unsigned int unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit;//这句是说你要获取日期的元素有哪些。
       NSDateComponents *d = [cal components:unitFlags fromDate:date];//把要从date中获取的unitFlags标示的日期元素存放在NSDateComponents类
       int year = [d year];
       int  month = [d month];
       int  day  =  [d day];
       
       strTime = [NSString stringWithFormat:@"%d月%d日", month, day];
    }
    

    return strTime;
    
}

+(NSString *) getStringFormTimeStamp:(long) lTimeStamp
{
    NSString *strTime  = NULL;
    
    // iOS 生成的时间戳是10位
    NSTimeInterval interval    = lTimeStamp / 1000.0;
    //NSTimeInterval interval    = iTimeStamp ;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    strTime = [formatter stringFromDate:date];
    NSLog(@"服务器返回的时间戳对应的时间是:%@",strTime);
    
    return  strTime;
}

// 浮点型数据转为字符串 （金额显示）
+ (NSString*) getMoneyString:(double) dValue
{
    NSString *strRet = @"";
    if (dValue > 0.0000)
     {
        strRet  = [NSNumberFormatter localizedStringFromNumber:@(dValue) numberStyle:NSNumberFormatterDecimalStyle];
     }
    return strRet;
}



#pragma mark   ===  周边加阴影，并且同时圆角
+ (void)addShadowToView:(UIView *)view
            withOpacity:(float)shadowOpacity
           shadowRadius:(CGFloat)shadowRadius
        andCornerRadius:(CGFloat)cornerRadius
{
    //////// shadow /////////
    CALayer *shadowLayer = [CALayer layer];
    shadowLayer.frame = view.layer.frame;
    
    shadowLayer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    shadowLayer.shadowOffset = CGSizeMake(0, 0);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    shadowLayer.shadowOpacity = shadowOpacity;//0.8;//阴影透明度，默认0
    shadowLayer.shadowRadius = shadowRadius;//8;//阴影半径，默认3
    
    //路径阴影
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    float width = shadowLayer.bounds.size.width;
    float height = shadowLayer.bounds.size.height;
    float x = shadowLayer.bounds.origin.x;
    float y = shadowLayer.bounds.origin.y;
    
    CGPoint topLeft      = shadowLayer.bounds.origin;
    CGPoint topRight     = CGPointMake(x + width, y);
    CGPoint bottomRight  = CGPointMake(x + width, y + height);
    CGPoint bottomLeft   = CGPointMake(x, y + height);
    
    CGFloat offset = -1.f;
    [path moveToPoint:CGPointMake(topLeft.x - offset, topLeft.y + cornerRadius)];
    [path addArcWithCenter:CGPointMake(topLeft.x + cornerRadius, topLeft.y + cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI endAngle:M_PI_2 * 3 clockwise:YES];
    [path addLineToPoint:CGPointMake(topRight.x - cornerRadius, topRight.y - offset)];
    [path addArcWithCenter:CGPointMake(topRight.x - cornerRadius, topRight.y + cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI_2 * 3 endAngle:M_PI * 2 clockwise:YES];
    [path addLineToPoint:CGPointMake(bottomRight.x + offset, bottomRight.y - cornerRadius)];
    [path addArcWithCenter:CGPointMake(bottomRight.x - cornerRadius, bottomRight.y - cornerRadius) radius:(cornerRadius + offset) startAngle:0 endAngle:M_PI_2 clockwise:YES];
    [path addLineToPoint:CGPointMake(bottomLeft.x + cornerRadius, bottomLeft.y + offset)];
    [path addArcWithCenter:CGPointMake(bottomLeft.x + cornerRadius, bottomLeft.y - cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    [path addLineToPoint:CGPointMake(topLeft.x - offset, topLeft.y + cornerRadius)];
    
    //设置阴影路径
    shadowLayer.shadowPath = path.CGPath;
    
    //////// cornerRadius /////////
    view.layer.cornerRadius = cornerRadius;
    view.layer.masksToBounds = YES;
    view.layer.shouldRasterize = YES;
    view.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    [view.superview.layer insertSublayer:shadowLayer below:view.layer];
}

@end
