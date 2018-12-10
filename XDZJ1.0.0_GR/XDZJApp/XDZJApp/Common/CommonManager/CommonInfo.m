//
//  CommonInfo.m
//  Save
//
//  Created by xxjr03 on 16/2/24.
//  Copyright © 2016年 xxjr03. All rights reserved.
//

#import "CommonInfo.h"
#import "SIAlertView.h"

//注册状态
NSString * const KRegistType =      @"registType";

@implementation CommonInfo

//注册状态
+(void)setRegistType:(NSString *)registType
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[registType change] forKey:KRegistType];
}

+(NSString *)registType
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:KRegistType];
}


//清空全部数据
+(void)AllDeleteInfo{
    
    [CommonInfo setRegistType:nil];
}


// 根据KEY来设置VALUE (函数内部为此KEY值会加上UID， 每个用户都是唯一的 ,Uid要去掉前面8位的随机数)
+(void)setKey:(NSString *) strkey withValue:(NSString*) strValue
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * strUserKey = [self SetNotNull:strkey];
    NSString * strUid = [DDGSetting sharedSettings].uid;
    if (strUid.length > 8)
     {
        strUid = [strUid substringFromIndex:8];
     }
    strUserKey = [strUserKey stringByAppendingString:strUid];
    [defaults setObject:[self SetNotNull:strValue] forKey:strUserKey];
}

// 根据KEY来得到VALUE (函数内部为此KEY值会加上UID， 每个用户都是唯一的， Uid要去掉前面8位的随机数) ,返回值必定为非空
+(NSString*)getKey:(NSString *) strkey
{
    NSString * strRet = @"";
    NSString * strUserKey = [self SetNotNull:strkey];
    NSString * strUid = [DDGSetting sharedSettings].uid;
    if (strUid.length > 8)
     {
        strUid = [strUid substringFromIndex:8];
     }
    strUserKey = [strUserKey stringByAppendingString:strUid];
    NSString *strValue = [[NSUserDefaults standardUserDefaults]objectForKey:strUserKey];
    strRet = [self SetNotNull:strValue];
    
    return strRet;

}

// 根据KEY来设置VALUE (函数内部为此KEY值会加上UID， 每个用户都是唯一的)
+(void)setKey:(NSString *) strkey withDicValue:(NSDictionary*) strValue
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * strUserKey = [self SetNotNull:strkey];
    NSString * strUid = [DDGSetting sharedSettings].uid;
    if (strUid.length > 8)
     {
        strUid = [strUid substringFromIndex:8];
     }
    strUserKey = [strUserKey stringByAppendingString:strUid];
    [defaults setObject:strValue forKey:strUserKey];
}

// 根据KEY来得到VALUE (函数内部为此KEY值会加上UID， 每个用户都是唯一的)
+(NSDictionary*)getKeyOfDic:(NSString *) strkey
{
    NSDictionary * dicRet = nil;
    NSString * strUserKey = [self SetNotNull:strkey];
    NSString * strUid = [DDGSetting sharedSettings].uid;
    if (strUid.length > 8)
     {
        strUid = [strUid substringFromIndex:8];
     }
    strUserKey = [strUserKey stringByAppendingString:strUid];
    dicRet = [[NSUserDefaults standardUserDefaults]objectForKey:strUserKey];
   
    
    return dicRet;

}

// 根据KEY来设置VALUE (函数内部为此KEY值会加上UID， 每个用户都是唯一的)
+(void)setKey:(NSString *) strkey withArrayValue:(NSArray*) aryValue
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * strUserKey = [self SetNotNull:strkey];
    NSString * strUid = [DDGSetting sharedSettings].uid;
    if (strUid.length > 8)
     {
        strUid = [strUid substringFromIndex:8];
     }
    strUserKey = [strUserKey stringByAppendingString:strUid];
    [defaults setObject:aryValue forKey:strUserKey];
}

// 根据KEY来得到VALUE (函数内部为此KEY值会加上UID， 每个用户都是唯一的)
+(NSArray*)getKeyOfArray:(NSString *) strkey
{
    NSArray * arrayRet = nil;
    NSString * strUserKey = [self SetNotNull:strkey];
    NSString * strUid = [DDGSetting sharedSettings].uid;
    if (strUid.length > 8)
     {
        strUid = [strUid substringFromIndex:8];
     }
    strUserKey = [strUserKey stringByAppendingString:strUid];
    arrayRet = [[NSUserDefaults standardUserDefaults]objectForKey:strUserKey];
    
    
    return arrayRet;
}

// 设置字符串为非空
+(NSString*) SetNotNull:(NSString*) strValue
{
    
    if ( !strValue || strValue == nil ||strValue == NULL || ([strValue isKindOfClass:[NSNull class]])){
        return @"";
    }
    return strValue;
}


// 删除NSArray中的NSNull
+ (NSMutableArray *)removeNullFromArray:(NSArray *)arr
{
    NSMutableArray *marr = [NSMutableArray array];
    for (int i = 0; i < arr.count; i++) {
        NSValue *value = arr[i];
        // 删除NSDictionary中的NSNull，再添加进数组
        if ([value isKindOfClass:NSDictionary.class]) {
            [marr addObject:[self removeNullFromDictionary:(NSDictionary *)value]];
        }
        // 删除NSArray中的NSNull，再添加进数组
        else if ([value isKindOfClass:NSArray.class]) {
            [marr addObject:[self removeNullFromArray:(NSArray *)value]];
        }
        // 剩余的非NSNull类型的数据添加进数组
        else if (![value isKindOfClass:NSNull.class]) {
            [marr addObject:value];
        }
    }
    return marr;
}

// Dictionary中的NSNull转换成@“”
+ (NSMutableDictionary *)removeNullFromDictionary:(NSDictionary *)dic
{
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    for (NSString *strKey in dic.allKeys) {
        NSValue *value = dic[strKey];
        // 删除NSDictionary中的NSNull，再保存进字典
        if ([value isKindOfClass:NSDictionary.class]) {
            mdic[strKey] = [self removeNullFromDictionary:(NSDictionary *)value];
        }
        // 删除NSArray中的NSNull，再保存进字典
        else if ([value isKindOfClass:NSArray.class]) {
            mdic[strKey] = [self removeNullFromArray:(NSArray *)value];
        }
        // 剩余的非NSNull类型的数据保存进字典
        else if (![value isKindOfClass:NSNull.class]) {
            mdic[strKey] = dic[strKey];
        }
        // NSNull类型的数据转换成@“”保存进字典
        else if ([value isKindOfClass:NSNull.class]) {
            mdic[strKey] = @"";
        }
    }
    return mdic;
}

// 千分符来格式化字符串
+(NSString*) formatString:(NSString*) str
{
    NSString * strRetrun = str;
    if (str &&
        str.length )
     {
        double dAmount = [str doubleValue];
        strRetrun  = [NSNumberFormatter localizedStringFromNumber:@(dAmount) numberStyle:NSNumberFormatterDecimalStyle];
     }
    return strRetrun;
}


// 千分符来格式化字符串
+(NSString*) dFormatString:(double) dValue
{
    NSString * strRetrun = @"";
    strRetrun  = [NSNumberFormatter localizedStringFromNumber:@(dValue) numberStyle:NSNumberFormatterDecimalStyle];
    
    return strRetrun;
}

// 选择的城市，是否和个人信息城市一致
+(BOOL) isCityEqual
{
    
    NSString *strPRCity = [CommonInfo getKey:K_PR_City];
    if ([strPRCity isEqualToString:@""])
     {
        return YES;
     }
    
    NSString *strTSCity = [CommonInfo getKey:K_TS_City];
    if ([strTSCity isEqualToString:@""])
     {
        if ([strPRCity isEqualToString:@"深圳市"])
         {
            return YES;
         }
     }
    
    if (![strPRCity isEqualToString:strTSCity])
     {
        return NO;
     }
    
    return YES;
}


+ (BOOL) isGZRZannSMRZ:(UIViewController*) vc
{
    NSDictionary *dic = [DDGAccountManager sharedManager].userInfo;
    
    if (dic == nil)
     {
        [MBProgressHUD showErrorWithStatus:@"请先登录" toView:vc.view];
        return FALSE;
     }
    

    
    
    // 身份认证
    if (!([[dic objectForKey:@"identifyStatus"] integerValue] == 1))
     {
        //[MBProgressHUD showErrorWithStatus:@"请先实名认证" toView:vc];
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"提示" andMessage:@"请先实名认证和工作认证"];
        [alertView addButtonWithTitle:@"取消"
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alertView) {
                                  
                              }];
        [alertView addButtonWithTitle:@"确定"
                                 type:SIAlertViewButtonTypeCancel
                              handler:^(SIAlertView *alertView) {
                                  // 切换到认证页面
                                  [vc.navigationController popToRootViewControllerAnimated:NO];
                                  [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@(3),@"index":@(1)}];
                                  
                              }];
        
        alertView.cornerRadius = 5;
        alertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
        alertView.transitionStyle = SIAlertViewTransitionStyleSlideFromTop;
        [alertView show];
        return FALSE;
        
        return FALSE;
        
     }
    
    
    // 工作认证
    if (!([[dic objectForKey:@"cardStatus"] integerValue] == 1))
     {
        //[MBProgressHUD showErrorWithStatus:@"请先工作认证" toView:vc];
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"提示" andMessage:@"请先工作认证"];
        [alertView addButtonWithTitle:@"取消"
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alertView) {
                                  
                              }];
        [alertView addButtonWithTitle:@"确定"
                                 type:SIAlertViewButtonTypeCancel
                              handler:^(SIAlertView *alertView) {
                                  // 切换到认证页面
                                  [vc.navigationController popToRootViewControllerAnimated:NO];
                                  [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@(3),@"index":@(1)}];
                                  
                              }];
        
        alertView.cornerRadius = 5;
        alertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
        alertView.transitionStyle = SIAlertViewTransitionStyleSlideFromTop;
        [alertView show];
        return FALSE;
        return FALSE;
     }
    
    return  TRUE;
}


+ (BOOL) isSMRZ:(UIViewController*) vc
{
    NSDictionary *dic = [DDGAccountManager sharedManager].userInfo;
    
    if (dic == nil)
     {
        [MBProgressHUD showErrorWithStatus:@"请先登录" toView:vc.view];
        return FALSE;
     }
    
    
    
    
    // 身份认证
    if (!([[dic objectForKey:@"identifyStatus"] integerValue] == 1))
     {
        //[MBProgressHUD showErrorWithStatus:@"请先实名认证" toView:vc.view];
        
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"提示" andMessage:@"请先实名认证"];
        [alertView addButtonWithTitle:@"取消"
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alertView) {
                                  
                              }];
        [alertView addButtonWithTitle:@"确定"
                                 type:SIAlertViewButtonTypeCancel
                              handler:^(SIAlertView *alertView) {
                                  // 切换到认证页面
                                  [vc.navigationController popToRootViewControllerAnimated:NO];
                                  [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@(3),@"index":@(1)}];
                                  
                              }];
        
        alertView.cornerRadius = 5;
        alertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
        alertView.transitionStyle = SIAlertViewTransitionStyleSlideFromTop;
        [alertView show];
        return FALSE;
        
     }
    

    

    
    return  TRUE;
}

@end

@implementation NSObject(change)
-(instancetype)change
{
    if ( !self || self == nil ||self == NULL || ([self isKindOfClass:[NSNull class]])){
        return @"";
    }
    if ([self isKindOfClass:[NSNumber class]]) //可能还有NSValue,待观察
    {
        return [NSString stringWithFormat:@"%@",self];
    }
    
    if ([self isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)self];
        for (NSString *key in dic.allKeys) {
            if (dic[key] == [NSNull null] || dic[key] == nil) {
                [dic setObject:@"" forKey:key];
            }
        }
        return dic;
    }
    
    return self;
    
}



@end
