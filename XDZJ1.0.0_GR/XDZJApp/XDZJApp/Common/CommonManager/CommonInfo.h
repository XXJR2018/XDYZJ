//
//  CommonInfo.h
//  Save
//
//  Created by xxjr03 on 16/2/24.
//  Copyright © 2016年 xxjr03. All rights reserved.
//

#import <Foundation/Foundation.h>

#define  MY_APP_ID    @"xdyzjIOS"
//#define  MY_APP_ID    @"xdyjIOSTest"


#define  K_TS_DKED  @"Key_TS_Dked" // 推送设置_贷款额度
#define  K_TS_Income  @"Key_TS_Income" // 推送设置_月收入
#define   K_TS_Hourse  @"Key_TS_Hourse" // 推送设置_房产
#define   K_TS_Car  @"Key_TS_Car" // 推送设置_车产
#define  K_TS_SheBao  @"Key_TS_SheBao" // 推送设置_社保
#define  K_TS_GJJ  @"Key_TS_Gjj"// 推送设置_公积金
#define  K_TS_WLD  @"Key_TS_Wld"// 推送设置_微粒贷
#define  K_TS_Open  @"Key_TS_Open" // 推送设置_开关


//#define  K_PR_City   @"Key_PR_City" // 个人信息_城市
//#define  K_LOCATION_City   @"Key_Location_City" // 定位_城市
// 新版本下，推送城市 和 定位城市 统一设置
#define  K_TS_City   @"Key_TS_City" // 推送设置_城市
#define  K_LOCATION_City   @"Key_TS_City" // 定位_城市
#define  K_PR_City   @"Key_PR_City" // 个人信息_城市

#define K_LOCATION_City_Last  @"K_LOCATION_City_Last"  // 上一次的定位城市
#define K_PR_Ciyt_Last        @"K_PR_Ciyt_Last"        // 上一次的个人城市

#define K_CITY_NETVESION     @"K_City_NetVesion"     // 城市信息的网络版本号
#define K_CITY_CURVESION     @"K_City_CurVesion"     // 城市信息的当前版本号


#define  K_IS_HaveYZD   @"Key_IS_HaveYZD" // 是否有优质单

#define  K_VIP_DISCOUNT_FLAG   @"Key_Vip_DiscountFlag" // 是否打折
#define  K_SENIOR_DISCOUNT @"K_Senior_Discount"  // 优质客户单折扣率
#define  K_ROB_DISCOUNT @"K_Rob_Discount"  //  直接单单折扣率
#define  K_TG_BASICPRISCE @"K_tgBasicPrice"  //  推广底价
#define  K_VIP_WD @"K_Vip_Wd"  //  是否有微店
#define  K_VIP_ISNAME @"K_Vip_IsName"  //  是否实名
#define  K_VIP_ISWORK @"K_Vip_IsWork"  //  是否工作认证

#define  K_GOOD_FIlTER  @"K_Good_Filter"    //资质客户筛选条件（存取的都是字典）
#define  K_GOOD_QueryType  @"K_GOOD_QueryType"    //资质客户筛选类型  (1-自定义类型 2-资质客户3-全部订单)

#define  K_ZHIJIE_FILTER  @"K_ZhiJie_Filter"  // 直接客户筛选条件 （存取的都是字典）
#define  K_ZHIJIE_QueryType  @"K_ZhiJie_QueryType"    //资质客户筛选类型  (1-自定义类型 2-资质客户3-全部订单)

#define  K_FILTER_ELEMENT  @"K_Filter_Element"    // 筛选订单的元素  （后台返回）

#define  K_FILTER_BTNARRY_QD @"K_Filter_BtnArry_QD"  // 抢单客户筛选的按钮字段
#define  K_FILTER_BTNARRY_TG @"K_Filter_BtnArry_TG"  // 推广客户筛选的按钮字段
#define  K_FILTER_BTNARRY_DX @"K_Filter_BtnArry_DX"  // 短信客户筛选的按钮字段

#define  K_FILTER_ELEMENT_QD @"K_Filter_Element_QD"  // 抢单客户筛选的元素
#define  K_FILTER_ELEMENT_TG @"K_Filter_Element_TG"  // 抢单客户筛选的元素
#define  K_FILTER_ELEMENT_DX @"K_Filter_Element_DX"  // 抢单客户筛选的元素

#define  K_LABEL_VALUE_ELEMENT @"K_Lable_Value_Element"  // 标记配置信息_Value
#define  K_LABEL_KEY_ELEMENT @"K_Lable_Key_Element"  // 标记配置信息_Key


#define  K_LOCK_ROBLIST @"K_Lock_RobList"  // 锁单列表





@interface CommonInfo : NSObject


//注册状态
+(void)setRegistType:(NSString *)registType;

+(NSString *)registType;



//退出登录清空全部数据
+(void)AllDeleteInfo;

// 设置字符串为非空
+(NSString*)SetNotNull:(NSString*) strValue;

// 删除NSArray中的NSNull
+ (NSMutableArray *)removeNullFromArray:(NSArray *)arr;

// Dictionary中的NSNull转换成@“”
+ (NSMutableDictionary *)removeNullFromDictionary:(NSDictionary *)dic;

// 根据KEY来设置VALUE (函数内部为此KEY值会加上UID， 每个用户都是唯一的)
+(void)setKey:(NSString *) strkey withValue:(NSString*) strValue;

// 根据KEY来得到VALUE (函数内部为此KEY值会加上UID， 每个用户都是唯一的)
+(NSString*)getKey:(NSString *) strkey;


// 根据KEY来设置VALUE (函数内部为此KEY值会加上UID， 每个用户都是唯一的)
+(void)setKey:(NSString *) strkey withDicValue:(NSDictionary*) dicValue;

// 根据KEY来得到VALUE (函数内部为此KEY值会加上UID， 每个用户都是唯一的)
+(NSDictionary*)getKeyOfDic:(NSString *) strkey;


// 根据KEY来设置VALUE (函数内部为此KEY值会加上UID， 每个用户都是唯一的)
+(void)setKey:(NSString *) strkey withArrayValue:(NSArray*) aryValue;

// 根据KEY来得到VALUE (函数内部为此KEY值会加上UID， 每个用户都是唯一的)
+(NSArray*)getKeyOfArray:(NSString *) strkey;

// 千分符来格式化字符串
+(NSString*) formatString:(NSString*) str;

// 千分符来格式化字符串
+(NSString*) dFormatString:(double) dValue;

// 选择的城市，是否和个人信息城市一致
+(BOOL) isCityEqual;

//  是否 实名认证和工作认证
+ (BOOL) isGZRZannSMRZ:(UIViewController*) vc;

//  是否 实名认证
+ (BOOL) isSMRZ:(UIViewController*) vc;

@end


@interface NSObject (change)
-(instancetype)change;
@end
