//
//  PDAPI.h
//  DDGProject
//
//  Created by Cary on 15/2/27.
//  Copyright (c) 2015年 Cary. All rights reserved.
//

#import <Foundation/Foundation.h>



// 获取自己创建的短信模版列表
static NSString *const kDDGQueryShorturlTemp = @"busi/account/sms/SMSApply/queryShorturlTemp";

// 获取系统创建的短信模版列表
static NSString *const kDDGqueryApplyTemplate = @"busi/account/sms/SMSApply/queryApplyTemplate";

// 创建短信模版
static NSString *const kDDGCreateShortUrl = @"busi/account/sms/SMSApply/createShortUrl";

// 修改短信模版
static NSString *const kDDGUpdateShortUrl = @"busi/account/sms/SMSApply/updateShortUrl";

// 验证码登录获取验证码
static NSString *const kDDGGetNologinKjlogAPIString = @"xxcust/smsAction/newNologin/kjLogin";


//房价评估

// 所在城市列表
static NSString *const kDDGGetCheckAllCityAPIString = @"cpQuery/newAllCity";
// 查询此城市是否被支持  cpQuery/verifyCity
static NSString *const kDDGGetCheckCity = @"cpQuery/verifyCity";
// 选择物业查询楼盘
static NSString *const kDDGGetQueryEstateAPIString = @"cpQuery/app/xxjrEval/querySlEstate";
// 选择物业查询楼栋
static NSString *const kDDGGetQueryBuildingAPIString = @"cpQuery/app/xxjrEval/querySlBuilding";
// 选择物业查询单元号
static NSString *const kDDGGetQueryUnitAPIString = @"cpQuery/app/xxjrEval/queryYfzUnit";
// 选择物业查询门牌号
static NSString *const kDDGGetQueryHouseAPIString = @"cpQuery/app/xxjrEval/querySlHouse";
// 查询评估
static NSString *const kDDGGetSaveHouseEvalAPIString = @"cpQuery/app/xxjrEval/queryHouseEval";
// 查询世联房价评估
static NSString *const kDDGGetSaveSLHouseEvalAPIString = @"cpQuery/app/xxjrEval/querySlHouseEval";
// 查询近期房屋成交(云房数据)
static NSString *const kDDGGetYfEstateCase = @"cpQuery/app/xxjrEval/queryYfEstateCase";
// 评估历史
static NSString *const kDDGGetHistoryRecordAPIString = @"cpQuery/app/xxjrEval/evalHouseHistory";
// 查询历史评估详情
static NSString *const kDDGGetHistoryRecordDetail = @"cpQuery/app/xxjrEval/evalDetail";
// 再次查询
static NSString *const kDDGGetqueryHistoryEval = @"cpQuery/app/xxjrEval/queryHistoryEval";

// 产品推广相关接口

// 获得首页的两条推广记录
static NSString *const kDDGGetqueryProdRank = @"busi/account/wd/product/queryProdList";
// 获得某条推广条件的信息
static NSString *const kDDGGetqueryProdInfo = @"busi/account/wd/product/queryQulifyInfo";
// 设置推广信息
static NSString *const kDDGSetTgProduct = @"busi/account/wd/product/saveProInfo";
// 获取微店产品编辑信息（第一步）
static NSString *const kDDGGetTgProduct = @"busi/account/wd/product/info";
// 取消推广
static NSString *const kDDGCancelTg = @"busi/account/wd/product/cancelTgProduct";
// 立即推广
static NSString *const KDDGtgProduct = @"busi/account/wd/product/tgProduct";
// 获得微店产品详情（不需要登录）
static NSString *const kDDGGetproductDetailNew = @"busi/wd/productDetailNew";
// 出价设置接口
static NSString *const kDDGtgProdOffer = @"busi/account/wd/product/tgProdOffer";

// 设置微店日期望消费金额、日期望订单笔数
static NSString *const kDDGupdateWdExpect = @"busi/account/wd/info/updateWdExpect";


// 推荐好友的相关接口

// 获取用户二维码及对应配置信息
static NSString *const kDDGGetQRcode = @"xxcust/account/invite/getQRCode";


//  抢单券的接口

//获取所有有效的抢单劵
static NSString *const kDDGgetTicketConfig = @"mjb/account/member/getTicketConfig";
//获取抢单劵详情
static NSString *const kDDGgetTicketDtl = @"mjb/account/member/getTicketDtl";
// 积分兑换接口
static NSString *const kDDGexchangeTicket = @"mjb/account/member/exchangeTicket";
//客户获取打折劵数量
static NSString *const kDDGqueryTicketNum = @"mjb/account/member/queryTicketNum";
// 客户获取打折劵列表
static NSString *const kDDGqueryTicketList = @"mjb/account/member/queryTicketList";
// 获取兑换记录
static NSString *const kDDGgetExchangeList = @"mjb/account/member/getExchangeList";
// 用户获取所有有效的抢单劵
static NSString *const kDDGgetTicketInfo = @"mjb/account/member/getTicketInfo";


// 抢单的相关接口

// 普通抢单付款时用的接口 （抢单付款使用抢单劵）
static NSString *const kDDGrobByAmount = @"mjb/account/dai/rob/robByAmount";
// 优质客户抢单付款时用的接口 （优质客户抢单付款使用抢单劵）
static NSString *const kDDGseniorcustRobByAmount =@"mjb/account/dai/seniorcust/robByAmount";
// 推广客户付款时用的接口  (推广获客付款使用抢单券)
static NSString *const kDDGrobBorrowPay = @"mjb/account/dai/rob/robBorrowPay";
// 判断是否可以退款
static NSString *const kDDGcanBorrowBack = @"mjb/account/dai/rob/canBorrowBack";

//免费抢单时，获取系统时间
static NSString *const KDDGgetSysTime = @"mjb/borrow/list/getNewFreeRobTime";
//查询免费抢单列表
static NSString *const KDDGqueryFreeRobList = @"mjb/borrow/list/queryFreeRobList";
//查询优质客户列表
static NSString *const KDDGquerySeniorCustList = @"mjb/borrow/list/querySeniorCustList";
//查询直借客户列表
static NSString *const KDDGqueryBorrowList = @"mjb/borrow/list/queryBorrowList";
// 存储筛选条件
static NSString *const KDDGcustCondition = @"mjb/account/dai/borrow/custCondition";
// 查询筛选条件
static NSString *const KDDGqueryCustCondition = @"mjb/account/dai/borrow/queryCustCondition";
// 获取月经营流水和月收入的取值范围
static NSString *const KDDGgetIncomeOfJournal = @"mjb/borrow/list/getIncomeInfo";

// 查询客户自动抢单条件
static NSString *const KDDGqueryAutoRobInf = @"mjb/account/dai/borrow/queryAutoRobInfo";
// 设置客户自动抢单条件
static NSString *const KDDGsetRemindCfg = @"mjb/account/dai/borrow/setRemindCfg";



// 客户相关接口
//查询抢单、推广客户订单统计
static NSString *const KDDGqueryRobOfTgCount = @"mjb/account/dai/rob/queryRobOfTgCount";
//查询短信客户统计
static NSString *const KDDGquerySmsCount = @"mjb/account/dai/rob/querySmsCount";
//查询抢单客户记录
static NSString *const KDDGnewRobList = @"mjb/account/dai/rob/robList"; //@"busi/account/dai/rob/newRobList";
//查询推广客户记录
static NSString *const KDDGtgRobList = @"mjb/account/dai/rob/tgRobList";
//查询短信客户记录
static NSString *const KDDGSMSquery = @"mjb/account/sms/SMSApply/query";
//查询抢单客户详情
static NSString *const KDDGrobDetail = @"mjb/account/dai/rob/robDetail/";
//查询推广客户详情
static NSString *const KDDGtgDetail = @"mjb/account/dai/rob/tgDetail/";
//查询订单详情————处理记录
static NSString *const KDDGqueryHandleRecord = @"mjb/account/dai/borrow/queryHandleRecord";
//查询订单详情————跟进记录
static NSString *const KDDGqueryFollowRecord = @"mjb/account/dai/borrow/queryFollowRecord";
//添加订单详情————跟进记录
static NSString *const KDDGsaveFollowRecord = @"mjb/account/dai/borrow/saveFollowRecord";
//更新订单详情————跟进记录
static NSString *const KDDGupdateFollowRecord = @"mjb/account/dai/borrow/updateFollowRecord";
//删除订单详情————跟进记录
static NSString *const KDDGdelFollowRecord = @"mjb/account/dai/borrow/delFollowRecord";
//查询订单详情————标记配置信息
static NSString *const KDDGgetLabelCfgInfo = @"mjb/account/dai/borrow/getLabelCfgInfo";
//订单详情————保存标记信息
static NSString *const KDDGsaveLabelInfo = @"mjb/account/dai/borrow/saveLabelInfo";
//查询订单详情————标记信息
static NSString *const KDDGqueryLabelInfo = @"mjb/account/dai/borrow/queryLabelInfo";



// 推广客户订单相关接口
// 取消推广客户订单
static NSString *const kDDGtgRobCancel = @"busi/account/dai/rob/tgRobCancel";
//推广客户，判断是否触发拨号或查看详情接口
static NSString *const KDDGclickTgDetail = @"busi/account/dai/rob/clickTgDetail";


// 短信获客相关接口
//查询短信链接信息
static NSString *const KDDGshortUrlInfo = @"busi/account/sms/SMSApply/shortUrlInfo";
//创建/编辑短信链接
static NSString *const KDDGcreateShortUrlNew = @"busi/account/sms/SMSApply/createShortUrlNew";




// 分享红包的相关接口
// 预分享接口
static NSString *const kDDGpreShareTicket = @"xxcust/account/ticket/shareTicket";
// 分享红包成功
static NSString *const kDDGaddShareRecord = @"xxcust/account/ticket/addShareRecord";


// 专属客服接口
// 查询客服与用户的留言记录
static NSString *const kDDGkfmsgList = @"xxcust/account/kf/msgList";
// 发送留言信息
static NSString *const kDDGkfsendMsg = @"xxcust/account/kf/sendMsg";

// 获取短信验证码相关接口
// 短信验证码第一步（拿到短信TOKE）
static NSString *const kDDGgetSmsToken = @"mjb/smsAction/getSmsToken/custLogin";
// 短信验证码第二步（获取登录验证码）
static NSString *const kDDGgetSmsLogin = @"mjb/smsAction/nologin/smsLogin";
// 短信验证码第二步（获取修改密码验证码）
static NSString *const kDDGgetSmsUpdatePwd = @"mjb/smsAction/nologin/updatePwd";
// 短信验证码第二步（获取注册验证码）
static NSString *const kDDGgetSmsRegister = @"mjb/smsAction/nologin/register";

//注册用户
static NSString *const kDDGRegisterUser = @"mjb/comm/login/register";

// 锁单相关接口
// 锁单
static NSString *const kDDGRobLock = @"mjb/account/dai/rob/lock";
// 解锁单
static NSString *const kDDGRobUnlock = @"mjb/account/dai/rob/unLock";
// 查询某个城市中，所有的锁定单
static NSString *const kDDGqueryBorrowLock = @"mjb/borrow/list/queryBorrowLock";


// 认证相关接口
// 认证照片上传
static NSString *const kDDGuploadIDCard = @"mjb/account/identify/uploadIDCard";
// 身份证信息存储
static NSString *const kDDGmodifyInfo = @"mjb/account/info/modifyInfo";
// 查询身份证信息
static NSString *const kDDGqueryRZInfo = @"mjb/account/query/queryLoanInfo";
// 身份证和人脸对比
static NSString *const kDDGfaceAuthCompare = @"mjb/account/auth/xxjrxdFaceCompare";//@"mjb/account/identify/faceAuthCompare";



#if PMHEnableSwitchURLGesture
/*!
 @brief 是否允许URL后带版本号
 */
FOUNDATION_EXPORT BOOL kEnableUrlVersion;
#endif

/*!
 @brief 管理所有接口URL
 */
@interface PDAPI : NSObject

/*!
 @brief     获取base url
 @return    base url string
 */
+ (NSString *)getBaseUrlString;

+ (NSString *)getBaseImageUrlString;



/*!
 @brief     获取业务 url
 @return    Busi url string
 */
+ (NSString *)getBusiUrlString;


//是否审核中
+(BOOL)isTestUser;


/*!
 @brief     return the url string of stat
 @return    stat url string
 */
#if PMHEnableSwitchURLGesture

/*!
 @brief     设置base url和stat url
 */
+ (void)setBaseUrl:(NSString *)baseUrlString statUrl:(NSString *)statUrlString;

#endif
/*!
 @brief     获取完整api的url
 @param     urlString url的名称
 @return    NSString 完全的api
 */
+ (NSString *)getFullApi:(NSString *)urlString;

/*!
 @brief     获取完整api的url
 @param     urlString url的名称
 @return    NSString 完全的api
 */
+ (NSString *)getFullApi2:(NSString *)urlString;

/*!
 @brief     跳转微信端路径
 @return    NSString
 */
+ (NSString *)WXSysRouteAPI;



#pragma mark === Function
/*!
 @brief     图片下载API
 @return    NSString
 */
+ (NSString *)imageDownloadAPI;

/*!
 @brief     版本检测
 @return    NSString
 */
+ (NSString *)getCheckVersionAPI;

/*!
 @brief     获取最近的放款信息
 @return    NSString
 */
+ (NSString *)getNewTreatAPI;

/*!
 @brief     获取验证码
 @return    NSString
 */
+ (NSString *)getRegSendMsghAPI;

/*!
 @brief     手机注册
 @return    NSString
 */
+ (NSString *)userGetRegisterAPI;

/*!
 @brief     手机注册获取验证码
 @return    NSString
 */
+ (NSString *)userRegisterPasswordAPI;

/*!
 @brief     用户注册协议
 @return    NSString
 */
+ (NSString *)getAgreementAPI;

/*!
 @brief     忘记密码
 @return    NSString
 */
+ (NSString *)userForgetPasswordAPI;

/*!
 @brief     忘记密码获取验证码
 @return    NSString
 */
+ (NSString *)userForgetPwdSendMsgAPI;

/*!
 @brief     登录
 @return    NSString
 */
+ (NSString *)userDoLoginAPI;

/*!
 @brief     验证码登录
 @return    NSString
 */
+ (NSString *)userVerifyLoginAPI;

/*!
 @brief     退出登录
 @return    NSString
 */
+ (NSString *)userDoLogoutAPI;

/*!
 @brief     获取引导页图片列表
 @return    NSString 获取引导页图片API
 */
+ (NSString *)getLoadingImgsAPI;

/*!
 @brief     发送反馈数据
 @return    NSString    发送反馈数据API字符串
 */
+ (NSString *)sendFeedbackAPI;

/*!
 @brief     获取版本号
 @return    NSString
 */
+ (NSString *)checkAppNewVersionAPI;

/**
 *  //// ------------------------------      ------------------------------------ /////
 */
#pragma mark === 公用
/*!
 @brief     banner 链接
 @return    NSString
 */
+ (NSString *)getBannerAPI;
/*!
 @brief     武功秘籍类型
 @return    NSString
 */
+ (NSString *)getInMiJiInfoAPI;
/*!
 @brief     武功秘籍列表
 @return    NSString
 */
+ (NSString *)getInQueryListAPI;
/*!
 @brief     武功秘籍详情
 @return    NSString
 */
+ (NSString *)getInMiJiDetailAPI;
/*!
 @brief     武功秘籍详情分享
 @return    NSString
 */
+ (NSString *)getInMiJiShareAPI;
/*!
 @brief     上传城市
 @return    NSString
 */
+ (NSString *)getSelectCityAPI;
    
 /*!
 @brief     贷款测算
 @return    NSString
 */
+ (NSString *)getInCalCLoanAmountAPI;

/*!
 @brief     信贷员列表
 @return    NSString
 */
+ (NSString *)getQueryCirclesListAPI;
/*!
 @brief     增加关注
 @return    NSString
 */
+ (NSString *)getAddJoinCirclesAPI;
/*!
 @brief     取消关注
 @return    NSString
 */
+ (NSString *)getCancelJoinCirclesAPI;
/*!
 @brief     我的关注列表
 @return    NSString
 */
+ (NSString *)getMyJoinListAPI;
/*!
 @brief     机构列表
 @return    NSString
 */
+ (NSString *)getInstitutionListAPI;

/*!
 @brief     机构产品
 @return    NSString
 */
+ (NSString *)getInstitutionProductListAPI;

/*!
 @brief     产品详情
 @return    NSString
 */
+ (NSString *)getInstitutionProductDetailAPI;

/*!
 @brief     交单
 @return    NSString
 */
+ (NSString *)getSendOrderAPI;

/*!
 @brief     交单 -- 简单交单之获取验证码
 @return    NSString
 */
+ (NSString *)getSendOrderVerifyCodeAPI;

/*!
 @brief     交单 -- 简单交单之微信分享
 @return    NSString
 */
+ (NSString *)getSendOrderWXAPI;

/*!
 @brief     交单 -- 简单交单之短信分享
 @return    NSString
 */
+ (NSString *)getSendOrderSMSAPI;

/*!
 @brief     取消订单
 @return    NSString
 */
+ (NSString *)getCanelOrderAPI;

/*!
 @brief     我的交单
 @return    NSString
 */
+ (NSString *)getMyOrderAPI;

/*!
 @brief     交单详情
 @return    NSString
 */
+ (NSString *)getOrderDetailAPI;

/*!
 @brief     读取材料
 @return    NSString
 */
+ (NSString *)getSendProductFileAPI;

/*!
 @brief     删除材料
 @return    NSString
 */
+ (NSString *)getDeleteFileAPI;

/*!
 @brief     完整交单
 @return    NSString
 */
+ (NSString *)getSendCompleteFileAPI;

/*!
 @brief     完整交单 -- 重新提交材料
 @return    NSString
 */
+ (NSString *)getReSendCompleteFileAPI;

/*!
 @brief     查号记录
 @return    NSString
 */
+ (NSString *)getSearchRecordListAPI;

/*!
 @brief     申请查号
 @return    NSString
 */
+ (NSString *)getSearchNumAPI;


/**
 *  获取金融资讯
 */
+ (NSString *)getFinanceNewsAPI;



/*!
 @brief     系统通知
 @return    NSString
 */
+ (NSString *)getNewsQueryListAPI;
/*!
 @brief     系统通知详情
 @return    NSString
 */
+ (NSString *)getNewsViewAPI;


//征信查询
/*!
 @brief     登陆注册图片验证码
 @return    NSString
 */
+ (NSString *)getCheckCreditAPI;
/*!
 @brief     注册第一步
 @return    NSString
 */
+ (NSString *)getCheckCreditRegAPI;
/*!
 @brief     注册第二步
 @return    NSString
 */
+ (NSString *)getCheckCreditRegSupplementInfoAPI;
/*!
 @brief     登陆
 @return    NSString
 */
+ (NSString *)getCheckCreditLoginAPI;
/*!
 @brief     注册验证码
 @return    NSString
 */
+ (NSString *)getCheckCreditSendRegMsgAPI;
/*!
 @brief     问题验证问题
 @return    NSString
 */
+ (NSString *)getCheckCreditIdentityDataAPI;
/*!
 @brief     提交问题
 @return    NSString
 */
+ (NSString *)getCheckCreditQuestionDataAPI;
/*!
 @brief     用户列表
 @return    NSString
 */
+ (NSString *)getCheckCreditInitDataAPI;
/*!
 @brief     用户列表信息
 @return    NSString
 */
+ (NSString *)getCheckCreditReportListDataAPI;
/*!
 @brief     核对银行验证码
 @return    NSString
 */
+ (NSString *)getCheckCreditReportAPI;
/*!
 @brief     信息列表
 @return    NSString
 */
+ (NSString *)getCheckCreditReportDataAPI;
/*!
 @brief     贷款记录明细
 @return    NSString
 */
+ (NSString *)getCheckCreditRecordDataAPI;
/*!
 @brief     查询记录明细
 @return    NSString
 */
+ (NSString *)getCheckQueryReocrdDataAPI;


//企业查询
/*!
 @brief     企业查询结果
 @return    NSString
 */
+ (NSString *)getCheckQueryDataAPI;
/*!
 @brief     查询结果详情
 @return    NSString
 */
+ (NSString *)getCheckQueryDetailDataAPI;
//失信人查询
/*!
 @brief     失信人查询结果
 @return    NSString
 */
+ (NSString *)getChecksSXRQueryDataAPI;
/*!
 @brief     失信人查询结果详情
 @return    NSString
 */
+ (NSString *)getChecksSXRDetailDataAPI;




/*!
 @brief     直贷头像
 @return    NSString
 */
+ (NSString *)getLoanListHeadImgAPI;

/*!
 @brief     抢单
 @return    NSString
 */
+ (NSString *)getLoanLightingAPI;

/*!
 @brief     抢单－甩单
 @return    NSString
 */
+ (NSString *)getLoanLighting2API;


#pragma mark === Tab_2  客户
/*!
 @brief     客户列表
 @return    NSString
 */
+ (NSString *)getContactListAPI;

/*!
 @brief     删除客户
 @return    NSString
 */
+ (NSString *)getDeleteContactAPI;

/*!
 @brief     添加客户
 @return    NSString
 */
+ (NSString *)getAddContactAPI;

/*!
 @brief     修改客户信息
 @return    NSString
 */
+ (NSString *)getUpdateContactListAPI;

/*!
 @brief     修改客户标签初始数据
 @return    NSString
 */
+ (NSString *)getContactMarksDtlAPI;

/*!
 @brief     修改客户标签
 @return    NSString
 */
+ (NSString *)getUpdateContactMarksAPI;

/*!
 @brief     客户标星处理
 @return    NSString
 */
+ (NSString *)getUpdateContactStarAPI;


/*!
 @brief     查寻标签
 @return    NSString
 */
+ (NSString *)getMarksListAPI;

/*!
 @brief     标签下的客户
 @return    NSString
 */
+ (NSString *)getMarksContactListAPI;

/*!
 @brief     添加标签
 @return    NSString
 */
+ (NSString *)getAddMarksAPI;

/*!
 @brief     修改标签
 @return    NSString
 */
+ (NSString *)getUpdateMarksAPI;

/*!
 @brief     删除标签
 @return    NSString
 */
+ (NSString *)getDeleteMarksAPI;



#pragma mark === Tab_3  微店
/*!
 @brief     微店首页
 @return    NSString
 */
+ (NSString *)userGetWDShopIndexInfoAPI;

/*!
 @brief     申请列表
 @return    NSString
 */
+ (NSString *)userGetWDShopApplyListInfoAPI;
/*!
 @brief     申请产品详情
 @return    NSString
 */
+ (NSString *)userGetApplyDetailInfoAPI;
/*!
 @brief     申请展示
 @return    NSString
 */
+ (NSString *)userGetWDShowInfoAPI;
/*!
 @brief    创建微店的初始化信息
 @return    NSString
 */
+ (NSString *)userGetWDShopWdInfoInitInfoAPI;
/*!
 @brief     修改微店信息
 @return    NSString
 */
+ (NSString *)userGetWDShopEditInfoAPI;
/*!
 @brief     查询微店信息
 @return    NSString
 */
+ (NSString *)userGetWDShopQueryInfoAPI;

/*!
 @brief     微店统计
 @return    NSString
 */
+ (NSString *)userGetWdApplyStatisticAPI;

/*!
 @brief     微店排行
 @return    NSString
 */
+ (NSString *)userGetwdShopRankInfoAPI;
/*!
 @brief     微店产品选项
 @return    NSString
 */
+ (NSString *)userGetProductInitDataInfoAPI;
/*!
 @brief     微店产品增加/修改
 @return    NSString
 */
+ (NSString *)userGetWdProductInfoAPI;
/*!
 @brief      微店产品增加第二步
 @return    NSString
 */
+ (NSString *)userGetWdProductDtlInfoAPI;
/*!
 @brief     微店产品列表
 @return    NSString
 */
+ (NSString *)userGetwdproductListInfoAPI;
/*!
 @brief     微店产品删除
 @return    NSString
 */
+ (NSString *)userGetwddelWdProductInfoAPI;
/*!
 @brief     微店产品信息
 @return    NSString
 */
+ (NSString *)userGetwdWdPordInfoAPI;
/*!
 @brief     微店产品信息第二步
 @return    NSString
 */
+ (NSString *)userGetWdProRuleInfoAPI;
/*!
 @brief     微店名片信息
 @return    NSString
 */
+ (NSString *)userGetwdCardInfoAPI;
/*!
 @brief     微店名片新增或修改
 @return    NSString
 */
+ (NSString *)userGetwdeditCardInfoAPI;

/*!
 @brief     成功案例列表
 @return    NSString
 */
+ (NSString *)userGetCustCaseListInfoAPI;
/*!
 @brief     添加成功案例
 @return    NSString
 */
+ (NSString *)userGetEditCustCaseInfoAPI;
/*!
 @brief     查询成功案例
 @return    NSString
 */
+ (NSString *)userGetCustCaseInfoAPI;
/*!
 @brief     删除成功案例
 @return    NSString
 */
+ (NSString *)userGetDelCustCaseInfoAPI;

/*!
 @brief     所有城市列表
 @return    NSString
 */
+ (NSString *)userGetWDShopCityInfoAPI;
/*!
 @brief    微店模板
 @return    NSString
 */
+ (NSString *)userGetWdShopTemplateListInfoAPI;
/*!
 @brief    微店模板修改
 @return    NSString
 */
+ (NSString *)userGetEditWdShopInfoAPI;
/*!
 @brief     分享微店Html5
 @return    NSString
 */
+ (NSString *)userGetShareWdWedInfoAPI;
#pragma mark === Tab_4  我的
/*!
 @brief     用户信息 不需要登录 -- （用户名、头像、真实姓名、身份证、邮箱、手机号码、登陆密码、交易密码、IM账号）
 @return    NSString
 */
+ (NSString *)getUserInfoAPI;

/*!
 @brief     切换身份
 @return    NSString
 */
+ (NSString *)userGetUserUserTypeInfoAPI;
/*!
 @brief     信贷经理入驻条件
 @return    NSString
 */
+ (NSString *)userGetQueryCheckJoinInfoAPI;

/*!
 @brief     修改个人信息
 @return    NSString
 */
+ (NSString *)userGetModifyInfoAPI;

/*!
 @brief     头像
 @return    NSString
 */
+ (NSString *)getUserHeadImageAPI;

/*!
 @brief     个人认证
 @return    NSString
 */
+ (NSString *)getpersonalAuthAPI;
/*!
 @brief     查询认证信息
 @return    NSString
 */
+ (NSString *)getQueryProfessionListAPI;
/*!
 @brief     机构列表
 @return    NSString
 */
+ (NSString *)getqueryCompanyListAPI;
/*!
 @brief     添加公司
 @return    NSString
 */
+ (NSString *)getAddCompanyAPI;

/*!
 @brief     借款人单独身份认证
 @return    NSString
 */
+ (NSString *)getValidateNameAPI;
/*!
 @brief     查询借款人单独身份认证信息
 @return    NSString
 */
+ (NSString *)getQueryIdentifyAPI;

/*!
 @brief     服务区域
 @return    NSString
 */
+ (NSString *)getAllAreaInfoAPI;
/*!
 @brief     提交工作地点
 @return    NSString
 */
+ (NSString *)getModifyLocaInfoAPI;
/*!
 @brief     第一次添加邮箱
 @return    NSString
 */
+ (NSString *)userGetUserEmailInfoAPI;

/*!
 @brief     修改邮箱
 @return    NSString
 */
+ (NSString *)userGetUserAmendEmailInfoAPI;

/*!
 @brief     修改邮箱获取验证码
 @return    NSString
 */
+ (NSString *)userForgetEmailSendMsgAPI;

/*!
 @brief     修改密码，设置里面的
 @return    NSString
 */
+ (NSString *)userGetUserModifyLoginPwdInfoAPI;
/*!
 @brief     公司简介，关于小小金融
 @return    NSString
 */
+ (NSString *)userGetUserXxjrInfoAPI;

/*!
 @brief     设置交易密码
 @return    NSString
 */
+ (NSString *)setPayPassword;

/*!
 @brief     修改交易密码
 @return    NSString
 */
+ (NSString *)userEditPayPwdAPI;

/*!
 @brief     更换手机
 @return    NSString
 */
+ (NSString *)userGetUserNewTelInfoAPI;

/*!
 @brief     更换手机获取原手机号验证码
 @return    NSString
 */
+ (NSString *)userGetUserChangeTelSendAPI;

/*!
 @brief     验证原手机获取的验证码
 @return    NSString
 */
+ (NSString *)userGetUserTelInfoAPI;

/*!
 @brief     更换手机获取新手机验证码
 @return    NSString
 */
+ (NSString *)userGetUserTelNewSendAPI;

/*!
 @brief     意见反馈，设置里面的
 @return    NSString
 */
+ (NSString *)userGetUserFeedBackInfoAPI;


/*!
 @brief     我的业绩总信息
 @return    NSString
 */
+ (NSString *)userGetUserSummaryInfoAPI;

/*!
 @brief     绑定微信
 @return    NSString
 */
+ (NSString *)userGetUserBindingWXAPI;

/*!
 @brief     提现明细
 @return    NSString
 */
+ (NSString *)userGetUserQueryWithdrawInfoAPI;

/*!
 @brief     剩余佣金提现处理
 @return    NSString
 */
+ (NSString *)userGetUserAddWithdrawInfoAPI;

/*!
 @brief     剩余佣金提现处理获取验证码
 @return    NSString
 */
+ (NSString *)getRegWithdrawSendMsghAPI;

/*!
 @brief     已返佣金
 @return    NSString
 */
+ (NSString *)userGetUserQueryMyListInfoAPI;

/*!
 @brief     可提现的银行
 @return    NSString
 */
+ (NSString *)userGetUserBankAllListInfoAPI;

/*!
 @brief     获取银行卡信息
 @return    NSString
 */
+ (NSString *)userGetUserCardListInfoAPI;

/*!
 @brief     添加银行卡
 @return    NSString
 */
+ (NSString *)userGetUserAddCardInfoAPI;
/*!
 @brief     我要收徒
 @return    NSString
 */
+ (NSString *)userGetUsershoutuInfoAPI;
/*!
 @brief     收徒赚佣金分享
 @return    NSString
 */
+ (NSString *)userGetUsershoutuShareInfoAPI;
/*!
 @brief     我的学徒
 @return    NSString
 */
+ (NSString *)userGetUserApprenticeListInfoAPI;
/*!
 @brief     为什么要收徒
 @return    NSString
 */
+ (NSString *)userGetUserReasonInfoAPI;
/*!
 @brief     如何收取更多徒弟
 @return    NSString
 */
+ (NSString *)userGetUserStrategyInfoAPI;
/*!
 @brief     我的会员
 @return    NSString
 */
+ (NSString *)userGetUserCustGradeInfoAPI;
/*!
 @brief     我的抢单
 @return    NSString
 */
+ (NSString *)userGetUserCustGrabListInfoAPI;
/*!
 @brief     小安时代推荐列表
 @return    NSString
 */
+ (NSString *)userGetRefererListInfoAPI;
/*!
 @brief    摇一摇礼品记录
 @return    NSString
 */
+ (NSString *)userGetDrawLotteryListInfoAPI;



#pragma mark 借款人-个人中心

/*!
 @brief    我的借款记录
 @return    NSString
 */
+ (NSString *)userBorrowMyListInfoAPI;

/*!
 @brief    找贷款(经理)记录
 @return    NSString
 */
+ (NSString *)userBorrowMyLoanRecordsInfoAPI;

/*!
 @brief   借款人评论
 @return    NSString
 */
+ (NSString *)userBorrowCommentInfoAPI;



#pragma mark 借款人-借款相关

/*!
 @brief    贷款申请-第一步
 @return    NSString
 */
+ (NSString *)userApplySaveSimpleInfoAPI;

/*!
 @brief    贷款申请-第二步
 @return    NSString
 */
+ (NSString *)userApplySaveBaseInfoAPI;

/*!
 @brief   贷款申请-第三步
 @return    NSString
 */
+ (NSString *)userApplySaveAssetInfoAPI;

/*!
 @brief   贷款申请-第四步
 @return    NSString
 */
+ (NSString *)userApplySaveOtherInfoAPI;

/*!
 @brief   信用卡列表
 @return    NSString
 */
+ (NSString *)userGetCreditCardListAPI;

/*!
 @brief   贷款超市列表
 @return    NSString
 */
+ (NSString *)userGetLoanShopListAPI;

/*!
 @brief   信贷经理列表
 @return    NSString
 */
+ (NSString *)userBorrowLoanListAPI;

/*!
 @brief   信贷经理列表详情申请贷款
 @return    NSString
 */
+ (NSString *)userBorrowWdApplyAPI;



#pragma mark 公用接口

/*!
 @brief     用户基本信息 需要登录 -- 个人信息（用户ID、昵称、性别、生日、省份、城市、详细地址、个人说明、 ）
 @return    NSString
 */
+ (NSString *)getUserBaseInfoAPI;


/*!
 @brief   资讯类型
 @return    NSString
 */
+ (NSString *)userZixunQueryTypeAPI;

/*!
 @brief   资讯列表
 @return    NSString
 */
+ (NSString *)userZixunQueryListAPI;

/*!
 @brief     资讯详情
 @return    NSString
 */
+ (NSString *)userGetCardNewsDetailInfoAPI;
/*!
 @brief     资讯详情分享
 @return    NSString
 */
+ (NSString *)userGetCardNewsShareInfoAPI;
/*!
 @brief     资讯分享成功修改积分
 @return    NSString
 */
+ (NSString *)userGetRewardShareInfoAPI;


/*!
 @brief  设置-更改绑定手机号
 @return    NSString
 */
+ (NSString *)userForceBindingWXAPI;

/*!
 @brief  设置-查询当前绑定微信
 @return    NSString
 */
+ (NSString *)userInfoBindingWXWXAPI;

/*!
 @brief   设置-修改密码
 @return    NSString
 */
+ (NSString *)userChangeLoginPwdAPI;

/*!
 @brief     上传材料
 @return    NSString
 */
+ (NSString *)getSendFileAPI;




#pragma mark 登陆及验证码

/*!
 @brief    验证码登陆
 @return    NSString
 */
+ (NSString *)userKJLoginInfoAPI;

/*!
 @brief   密码登陆
 @return    NSString
 */
+ (NSString *)userPassWordLoginInfoAPI;

/*!
 @brief   微信登陆
 @return    NSString
 */
+ (NSString *)userWXLoginInfoAPI;

/*!
 @brief   微信登陆绑定手机号
 @return    NSString
 */
+ (NSString *)userWxLoginBindInfoAPI;

/*!
 @brief   设置密码
 @return    NSString
 */
+ (NSString *)userSetLoginPwdInfoAPI;

/*!
 @brief     验证码登录获取验证码
 @return    NSString
 */
+ (NSString *)userNologinKjloginAPI;

/*!
 @brief     信贷经理列表申请按钮填写资料发送验证码
 @return    NSString
 */
+ (NSString *)userNologinWdApplyAPI;














@end





