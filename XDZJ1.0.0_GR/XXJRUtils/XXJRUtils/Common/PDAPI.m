//
//  PDAPI.m
//  DDGProject
//
//  Created by Cary on 15/2/27.
//  Copyright (c) 2015年 Cary. All rights reserved.
//

#import "PDAPI.h"

/*!
 @brief 基础API接口地址, 注意后面必须有/
 */

// 接口URL
static NSString *const kBaseURL =  @"https://newapp.xxjr.com/";
static NSString *const kBaseImageURL = @"viewFile/client?imageName=";


#if PMHEnableSwitchURLGesture
/*!
 @brief 存储baseurl的key
 */
static NSString *const kBaseURLinUserDefaultsString     = @"URLinUserDefaultsString";
/*!
 @brief 存储统计url的key
 */
static NSString *const kStatURLinUserDefaultsString     = @"kStatURLinUserDefaultsString";
/*!
 @brief 是否允许URL后带版本号
 */
BOOL kEnableUrlVersion = YES;

#endif

// 版本检测
static NSString *const kDDGCheckVersionAPIString = @"mjb/app/version/upgradeInfo";
// 获取验证码
static NSString *const kDDGRegSendMsgAPIString = @"SendMsg/regSendMsg";
//手机号注册
static NSString *const kDDGUserGetRegisterAPIString = @"xxcust/register";
//手机号注册获取验证码
static NSString *const KDDGUserRegistPwdSendMsgAPIString = @"smsAction/nologin/register";
// 用户注册协议
static NSString *const kDDGGetAgreementAPIString = @"app/about/registerProtocol";
//忘记密码
static NSString *const KDDGUserForgetPasswordAPIString = @"xxcust/forgetPwd";
//忘记密码获取验证码
static NSString *const KDDGUserForgetPwdSendMsgAPIString = @"smsAction/nologin/forgetPwd";
// 登录
static NSString *const kDDGGetLoginAPIString = @"xxcust/login";

// 验证码登录
static NSString *const kDDGGetVerifyLoginAPIString = @"xxcust/kjLogin";

// 退出登录
static NSString *const kDDGUserDoLogoutAPIString = @"account/info/logOut";

// 获取引导页图片列表
static NSString *const kDDGGetLoadingImgsAPIString = @"Sys/GetLoadingImgs";

// 意见反馈
static NSString *const kDDGFeedBackAPIString = @"account/order/orderDtlLog";

// 获取版本号
static NSString *const kDDGGetVersionAPIString = @"page/version";

// 获取最近的放款信息
static NSString *const kDDGGetNewTreat = @"busi/borrow/home/getNewTreat";





/**
 *  ////  首页 (交单相关)
 */
// 获取banner 广告
static NSString *const kDDGGetBannerAPIString = @"xxcust/comm/queryTheBanner";
// 武功秘籍类型
static NSString *const kDDGGetMiJiAPIString = @"miji/mijiInfo";
// 武功秘籍列表
static NSString *const kDDGGetQueryListAPIString = @"miji/queryList";
// 武功秘籍详情
static NSString *const kDDGGetMiJiDetailAPIString = @"app/miji/detail";
// 武功秘籍详情分享
static NSString *const kDDGGetMiJiShareAPIString = @"app/miji/share";
// 上传城市
static NSString *const kDDGGetSelectCityAPIString = @"app/account/rzb/question/home";
// 贷款测算
static NSString *const kDDGGetCalcLoanAmountAPIString = @"org/loan/calcLoanAmount";


// 信贷员列表
static NSString *const kDDGGetQueryCirclesListAPIString = @"queryCircles";
// 增加关注
static NSString *const kDDGGetAddJoinCirclesAPIString = @"account/cust/join/addJoin";

//取消关注
static NSString *const kDDGGetCancelJoinCirclesAPIString = @"account/cust/join/cancelJoin";

// 我的关注列表
static NSString *const kDDGGetMyJoinListAPIString = @"account/cust/join/myJoinList";


// 机构列表
static NSString *const kDDGGetInstitutionListAPIString = @"org/queryList";
// 机构产品
static NSString *const kDDGGetInstitutionProductListAPIString = @"org/loan/queryList";
// 机构产品详情
static NSString *const kDDGGetInstitutionProductDetailAPIString = @"org/loan/queryDetail";

// 交单
static NSString *const kDDGGetSendOrderAPIString = @"account/order/simpleSubmit";
// 交单 -- 简单交单之获取验证码
static NSString *const kDDGGetSendOrderVerifyCodeAPIString = @"smsAction/nologin/simpleSubmit";
// 交单 -- 简单交单之微信分享交单
static NSString *const kDDGGetSendOrderWXAPIString = @"app/share/applyLoan";
// 交单 -- 简单交单之短信分享交单
static NSString *const kDDGGetSendOrderSMSAPIString = @"account/order/smsSubmit";
// 取消交单
static NSString *const kDDGGetCancelOrderAPIString = @"account/order/cancelOrderDtl";

// 我的交单
static NSString *const kDDGGetMyOrderAPIString = @"account/order/queryList";

// 交单详情
static NSString *const kDDGGetOrderDetailAPIString = @"account/order/queryDetail";

// 读取材料
static NSString *const kDDGGetFileListAPIString = @"account/order/materialList";



// 删除材料
static NSString *const kDDGGetDeleteFileAPIString = @"account/order/delImg";

// 完整交单 -- 提交材料
static NSString *const kDDGGetSendCompleteOrderAPIString = @"account/order/fullSubmit";
// 完整交单 -- 重新提交材料
static NSString *const kDDGGetReSendCompleteOrderAPIString = @"account/order/resubmit";

// 查号记录
static NSString *const kDDGGetSearchRecordListAPIString = @"account/query/queryList";
// 申请查号
static NSString *const kDDGGetSearchNumAPIString = @"account/query/add";

/**
 *  获取金融资讯
 */
static NSString *const kDDGGetFinanceNewsAPIString = @"zixun/queryList";




// 系统通知
static NSString *const kDDGGetNewsQueryListAPIString = @"xxcust/account/message/queryList";
// 系统通知详情
static NSString *const kDDGGetViewAPIString = @"xxcust/account/message/view";


//征信查询
//图片验证码
static NSString *const kDDGGetCheckCreditAPIString = @"cpQuery/credit/page/viewImageStream";
//注册第一步
static NSString *const kDDGGetCheckCreditRegAPIString = @"cpQuery/credit/page/reg";
//注册第二步
static NSString *const kDDGGetCheckCreditRegSupplementAPIString = @"cpQuery/credit/page/regSupplementInfo";
// 登陆
static NSString *const kDDGGetCheckCreditLoginAPIString = @"cpQuery/credit/page/login";
//注册验证码
static NSString *const kDDGGetCheckCreditSendRegMsgAPIString = @"cpQuery/credit/page/sendRegMsg";
//问题验证问题
static NSString *const kDDGGetCheckCreditIdentityDataAPIString = @"cpQuery/credit/page/questionIdentityData";
//提交问题
static NSString *const kDDGGetCheckCreditQuestionAPIString = @"cpQuery/credit/page/submitQuestion";
//用户列表
static NSString *const kDDGGetCheckCreditInitDataAPIString = @"cpQuery/credit/page/initData";
//用户列表信息
static NSString *const kDDGGetCheckCreditReportListDataAPIString = @"cpQuery/credit/page/creditReportListData";

//核对银行验证码
static NSString *const kDDGGetCheckCreditReportAPIString = @"cpQuery/credit/page/creditReport";
//信息列表
static NSString *const kDDGGetCheckCreditReportDataAPIString = @"cpQuery/credit/page/creditReportData";
//贷款记录明细
static NSString *const kDDGGetCheckCreditRecordDataAPIString = @"cpQuery/credit/page/creditRecordData";
//查询记录明细
static NSString *const kDDGGetCheckQueryReocrdDataAPIString = @"cpQuery/credit/page/queryReocrdData";

//企业查询
//企业查询结果
static NSString *const kDDGGetCheckQueryDataAPIString = @"cpQuery/company/page/queryData";
//企业查询结果详情
static NSString *const kDDGGetCheckQueryDetailDataAPIString = @"cpQuery/company/page/detailData";

//失信人查询
// 失信人查询结果
static NSString *const kDDGGetCheckSXRQueryDataAPIString = @"cpQuery/lose/page/sxrQueryData";
// 失信人查询结果详情
static NSString *const kDDGGetCheckSXRDetailDataAPIString = @"cpQuery/lose/page/sxrDetailData";





// 直贷头像
static NSString *const kDDGGetLoanListHeadImgAPIString = @"uploadAction/viewImage?imageName=";
// 抢单－直借
static NSString *const kDDGGetLoanLightingAPIString = @"rzb/account/borrow/robLend";
// 抢单－甩单
static NSString *const kDDGGetLoanLighting2APIString = @"account/dai/rob/robExchange";

/**
 *  ////  客户
 */
// 客户列表
static NSString *const kDDGGetContactListString = @"account/contact/queryList";
// 删除客户
static NSString *const kDDGGetDeleteContactString = @"account/contact/delete";
// 添加客户
static NSString *const kDDGGetAddContactString = @"account/contact/add";
// 修改客户信息
static NSString *const kDDGGetUpdateContactString = @"account/contact/update";
// 修改客户标签初始数据
static NSString *const kDDGGetContactMarksDtlString = @"account/contact/queryTagDtl";
// 修改客户标签
static NSString *const kDDGGetUpdateContactMarksString = @"account/contact/updateTag";
// 客户标星处理
static NSString *const kDDGGetUpdateContactStarString = @"account/contact/important";


// 查寻标签
static NSString *const kDDGGetMarksListString = @"account/tag/queryList";
// 标签下的客户
static NSString *const kDDGGetMarksContactListString = @"account/tag/queryContact";
// 添加标签
static NSString *const kDDGGetAddMarksString = @"account/tag/add";
// 修改标签
static NSString *const kDDGGetUpdateMarksString = @"account/tag/update";
// 删除标签
static NSString *const kDDGGetDeleteMarksString = @"account/tag/delete";

/**
 *  ////  微店
 */
// 微店首页
static NSString *const kDDGUserGetWDShopIndexInfoAPIString = @"busi/account/wd/info/index";
// 申请列表
static NSString *const kDDGUserGetWDShopApplyListInfoAPIString = @"busi/account/wd/apply/list";
// 申请产品详情
static NSString *const kDDGUserGetApplyDetailInfoAPIString = @"busi/account/wd/apply/info";
// 申请展示
static NSString *const kDDGUserGetWDShowInfoAPIString = @"busi/account/wd/info/applyWdShow";

// 创建微店的初始化信息
static NSString *const kDDGUserGetWDShopWdInfoInitInfoAPIString = @"busi/account/wd/info/wdInfoInit";
// 修改微店信息
static NSString *const kDDGUserGetWDShopEditInfoAPIString = @"busi/account/wd/info/editWd";
// 查询微店信息
static NSString *const kDDGUserGetWDShopQueryInfoAPIString = @"busi/account/wd/info/queryWdInfo";
// 微店统计
static NSString *const kDDGUserGetWdApplyStatistic = @"busi/account/wd/apply/statistic";
// 微店排行
static NSString *const kDDGUserGetwdShopRankInfoAPIString = @"busi/account/wd/info/wdRank";
// 微店产品增加/修改
static NSString *const kDDGUserGetWdProductInfoAPIString = @"busi/account/wd/product/edit";
// 微店产品增加第二步
static NSString *const kDDGUserGetWdProductDtlInfoAPIString = @"busi/account/wd/product/editRule";
// 微店产品增加选项
static NSString *const kDDGUserGetProductInitDataInfoAPIString = @"busi/account/wd/product/initData";

// 微店产品列表
//static NSString *const kDDGUserGetWdProductListInfoAPIString = @"busi/account/wd/product/list";
static NSString *const kDDGUserGetWdProductListInfoAPIString = @"busi/account/wd/product/queryProdList";
// 微店产品删除
static NSString *const kDDGUserGetWddelWdProductInfoAPIString = @"busi/account/wd/product/delete";
// 微店产品信息
static NSString *const kDDGUserGetWdPordInfoAPIString = @"busi/account/wd/product/info";
// 微店产品信息第二步
static NSString *const kDDGUserGetWdProRuleInfoAPIString = @"busi/account/wd/product/ruleInfo";

// 微店名片信息
static NSString *const kDDGUserGetwdCardInfoAPIString = @"busi/account/quweitu/funyCardInfo";
// 微店名片新增或修改
static NSString *const kDDGUserGetwdeditCardInfoAPIString = @"busi/account/wdShop/editWdCard";


// 成功案例列表
static NSString *const kDDGUserGetCustCaseListInfoAPIString = @"busi/account/wd/case/list";
// 添加成功案例
static NSString *const kDDGUserGetEditCustCaseInfoAPIString = @"busi/account/wd/case/edit";
// 查询成功案例
static NSString *const kDDGUserGetCustCaseInfoAPIString = @"busi/account/wd/case/info";
// 删除成功案例
static NSString *const kDDGUserGetDelCustCaseInfoAPIString = @"busi/account/wd/case/delete";

// 微店模板
static NSString *const kDDGUserGetTemplateListInfoAPIString = @"busi/account/wd/info/templateList";
// 微店模板修改
static NSString *const kDDGUserGetEditWdShopInfoAPIString = @"busi/account/wd/info/editWd";
// 分享微店H5
static NSString *const kDDGUserGetShareWdWedInfoAPIString = @"busi/app/wd/share/preSharePage";
// 所有城市列表
static NSString *const kDDGUserGetWDShopCityInfoAPIString = @"busi/area/allCity";

/**
 *  ////tab_4  我的
 */
// 用户信息
//static NSString *const kDDGGetUserInfoAPIString = @"busi/app/version/iosXdjl";
static NSString *const kDDGGetUserInfoAPIString = @"mjb/app/version/upgradeInfo";


//切换身份
static NSString *const kDDGGetUserUserTypeInfoAPIString = @"account/cust/info/changeUserType";
//信贷经理入驻条件
static NSString *const kDDGGetUserQueryCheckJoinInfoAPIString = @"account/cust/query/checkJoin";


// 头像
static NSString *const kDDGUserGetUserHeadImageInfoAPIString = @"viewFile/viewImage";
// 个人认证
static NSString *const kDDGGetpersonalAuthInfoAPIString = @"mjb/account/info/personalAuth";
// 机构列表
static NSString *const kDDGGetProfessionInfoAPIString =@"mjb/company/queryCompanys";
// 添加公司
static NSString *const kDDGGetAddCompanyAPIString = @"mjb/company/addCompany";

// 查询认证信息
static NSString *const kDDGGetQueryProfessionInfoAPIString = @"mjb/account/query/personalAuthInfo";

// 借款人单独身份认证
static NSString *const kDDGGetValidateNameInfoAPIString = @"xxcust/account/info/validateName";
// 查询借款人单独身份认证信息
static NSString *const kDDGGetQueryIdentifyInfoAPIString = @"xxcust/account/query/queryIdentifyInfo";
// 服务区域
static NSString *const kDDGGetAllAreaInfoAPIString = @"mjb/area/allAreaInfo";

//提交工作地点
static NSString *const kDDGGetModifyLocaAPIString = @"account/cust/modifyLocaInfo";

// 第一次添加邮箱
static NSString *const kDDGUserGetUserEmailInfoAPIString = @"account/cust/email/insertEmail";
// 修改邮箱
static NSString *const kDDGUserGetUserAmendEmailInfoAPIString = @"account/cust/email/updateEmail";
// 修改邮箱获取验证码
static NSString *const KDDGUserForgetEmailSendMsgAPIString = @"smsAction/login/email";
// 修改登录密码
static NSString *const kDDGUserGetUserModifyLoginPwdInfoAPIString = @"xxcust/account/cust/info/changeLoginPwd";
// 公司简介,关于小小金融
static NSString *const kDDGUserGetUserXxjrInfoAPIString = @"app/about/xxjr";
// 设置交易密码
static NSString *const KDDGSetPayPasswordAPIString = @"User/setUserPayPwd";
// 修改交易密码
static NSString *const KDDGUserEditPayPwdAPIString = @"User/editUserPayPwd";
// 更换手机
static NSString *const kDDGUserGetUserNewTelInfoAPIString = @"account/cust/info/chanageNewTel";
// 更换手机获取原手机验证码
static NSString *const kDDGUserGetUserChangeTelSendAPIString = @"smsAction/login/changeTel";
// 验证获取的原手机验证码
static NSString *const kDDGUserGetUserTelInfoAPIString = @"smsAction/valid/login/changeTel";
// 更换手机获取新手机验证码
static NSString *const kDDGUserGetUserTelNewSendAPIString = @"smsAction/login/changeTelNew";
// 意见反馈，设置里面的
static NSString *const kDDGUserGetUserFeedBackInfoAPIString = @"account/cust/feedback";

/*!
 @brief 我的业绩
 */
// 我的业绩总信息
static NSString *const kDDGUserGetUserSummaryInfoAPIString = @"account/reward/summary";
// 绑定微信
static NSString *const kDDGUserBindingWXAPIString = @"account/cust/info/bindingWX";
// 剩余佣金提现处理
static NSString *const kDDGUserGetUserAddWithdrawInfoAPIString = @"account/fund/addWithdraw";
// 剩余佣金提现处理获取验证码
static NSString *const kDDGUserGetWithdrawSendInfoAPIString = @"smsAction/login/withdraw";
// 已返佣金
static NSString *const kDDGUserGetUserQueryMyListInfoAPIString = @"account/reward/queryMyList";
// 提现明细
static NSString *const kDDGUserGetUserQueryWithdrawInfoAPIString = @"account/fund/queryWithdraw";
//可提现的银行
static NSString *const kDDGUserGetUserBankAllListInfoAPIString = @"account/bank/addBankInit";
// 获取银行卡信息
static NSString *const kDDGUserGetUserCardListInfoAPIString = @"account/bank/cardList";
// 添加银行卡
static NSString *const kDDGUserGetUserBankAddCardInfoAPIString = @"account/bank/addCard";
// 收徒信息
static NSString *const kDDGUserGetUsershoutuInfoAPIString = @"account/cust/shoutu/shoutuSummary";
// 收徒赚佣金分享
static NSString *const kDDGUserGetUsershoutuShareInfoAPIString = @"app/share/shoutuShare";

// 我的学徒
static NSString *const kDDGUserGetUserApprenticeListInfoAPIString = @"app/account/apprenticeList";
// 为什么要收徒
static NSString *const kDDGUserGetUserReasonInfoAPIString = @"app/about/reason";
// 如何收取更多徒弟
static NSString *const kDDGUserGetUserStrategyInfoAPIString = @"app/about/strategy";
// 我的会员
static NSString *const kDDGUserGetUserCustGradeInfoAPIString= @"xxapp/account/member/custGrade";
// 我的抢单
static NSString *const kDDGUserGetUserGrabListInfoAPIString= @"app/account/signOn/grabList";

// 小安时代推荐列表
static NSString *const kDDGUserGetRefererListInfoAPIString= @"xxcust/account/info/referList";
// 摇一摇礼品记录
static NSString *const kDDGUserGetDrawLotteryListInfoAPIString= @"xxcust/account/sign/drawLotteryList";


#pragma mark 借款人-个人中心


// 我的借款记录
static NSString *const kDDGUserGetBorrowMyListAPIString= @"busi/account/dai/borrow/myList";

// 找贷款(经理)记录
static NSString *const kDDGUserGetBorrowMyLoanRecordsAPIString= @"busi/account/wd/apply/myLoanRecords";

// 借款人评论
static NSString *const kDDGUserGetBorrowCommentAPIString= @"busi/account/wd/apply/comment";



#pragma mark 借款人-借款相关

// 贷款申请-第一步
static NSString *const kDDGUserGetApplySaveSimpleInfoAPIString= @"busi/borrow/apply/saveSimpleInfo";

// 贷款申请-第二步
static NSString *const kDDGUserGetApplySaveBaseInfoAPIString= @"busi/borrow/apply/saveBaseInfo";

// 贷款申请-第三步
static NSString *const kDDGUserGetApplySaveAssetInfoAPIString= @"busi/borrow/apply/saveAssetInfo";

// 贷款申请-第四步
static NSString *const kDDGUserGetApplySaveOtherInfoAPIString= @"busi/borrow/apply/saveOtherInfo";

// 信用卡列表
static NSString *const kDDGUserGetCreditCardListAPIString= @"busi/borrow/home/getCreditCardList";

// 贷款超市列表
static NSString *const kDDGUserGetLoanShopListAPIString= @"busi/borrow/home/getLoanShopList";

// 信贷经理列表
static NSString *const kDDGUserBorrowLoanListAPIString= @"busi/remcomAdvisers";

// 信贷经理列表详情申请贷款
static NSString *const kDDGUserGetBorrowWdApplyAPIString= @"busi/borrow/apply/loan/wdApply";




#pragma mark 公用接口

// 用户基本信息
static NSString *const kDDGGetUserBaseInfoAPIString = @"mjb/account/query/getInfo";//@"xxcust/account/query/getInfo";
// 修改个人信息
static NSString *const kDDGUserGetModifyInfoAPIString = @"mjb/account/info/modifyInfo";

// 资讯类型
static NSString *const kDDGUserZixunQueryTypeAPIString= @"busi/zixun/queryType";

// 资讯列表
static NSString *const kDDGUserZixunQueryListAPIString= @"busi/zixun/queryList";

// 资讯详情
static NSString *const kDDGUserGetCardNewsDetailInfoAPIString = @"busi/app/zixun/detail";

// 资讯详情分享
static NSString *const kDDGUserGetCardNewsShareInfoAPIString = @"busi/app/zixun/share";

// 资讯分享成功修改积分
static NSString *const kDDGUserGetRewardShareInfoAPIString = @"busi/zixun/updateCount";

//  设置-更改绑定手机号
static NSString *const kDDGUserForceBindingWXAPIString= @"mjb/account/info/forceBindingWX";

// 设置-查询当前绑定微信
static NSString *const kDDGUserInfoBindingWXAPIString= @"mjb/account/info/bindingWXNew";

// 设置-修改密码
static NSString *const kDDGUserChangeLoginPwdAPIString= @"mjb/comm/changeLoginPwd";

// 上传材料、头像
static NSString *const kDDGGetSendFileAPIString = @"mjb/uploadAction/uploadFile";//@"busi/uploadAction/uploadFile";


#pragma mark 登陆及验证码

// 验证码登陆
static NSString *const kDDGUserKJLoginAPIString= @"mjb/comm/login/smsLogin";

// 密码登陆
static NSString *const kDDGUserPassWordLoginAPIString= @"mjb/comm/login/pwdLogin";

// 微信登陆
static NSString *const kDDGUserWXLoginAPIString= @"xxcust/comm/app/xdjl/wxLogin";

// 微信登陆绑定手机号
static NSString *const kDDGUserWxLoginBindAPIString= @"xxcust/comm/app/xdjl/wxLoginBind";

// 设置密码
static NSString *const kDDGUserSetLoginPwdAPIString= @"xxcust/account/info/setLoginPwd";



// 信贷经理列表申请按钮填写资料发送验证码
static NSString *const kDDGGetNologinWdApplyAPIString = @"busi/smsAction/nologin/wdApply";
















@implementation PDAPI

// 跳转微信端h5路径
+ (NSString *)WXSysRouteAPI{

#if DEBUG
    return @"https://newapp.xxjr.com/";
//    return @"http://192.168.10.146:1123/";        // 刘俊全
    return @"http://192.168.10.182:3000/";        //  测试2
#else
    return @"https://newapp.xxjr.com/";
#endif

}




+ (NSString *)getBaseUrlString{
#if DEBUG
//   return @"https://newapp.xxjr.com/";
//    return @"http://192.168.10.129:81/";  // 刘礼伟
    return @"http://192.168.10.182/";        //  测试
//    return @"http://192.168.10.132/";    //  方然青
//    return @"http://192.168.10.89/";    //  黄木俊
//    return @"http://192.168.10.128/";    //  余应府
//    return @"http://192.168.10.142/";     //  陈传新
//    return @"http://192.168.10.133/";     //  赵松
//    return @"http://192.168.10.175/";      // 连鸿山

#else
    
    return kBaseURL;
#endif
}

+ (NSString *)getBusiUrlString
{
#if DEBUG
//   return @"https://newapp.xxjr.com/";
//    return @"http://192.168.10.129:81/";  // 刘礼伟
    return @"http://192.168.10.182/";        //  测试
//   return @"http://192.168.10.132/";    //  方然青
//    return @"http://192.168.10.89/";    //  黄木俊
//    return @"http://192.168.10.128/";    //  余应府
//    return @"http://192.168.10.142/";     //  陈传新
//    return @"http://192.168.10.133/";     //  赵松
//    return @"http://192.168.10.175/";      // 连鸿山

    
#else
    
    return kBaseURL;
#endif
}


+ (NSString *)getBaseImageUrlString{
    return kBaseImageURL;
}




+(BOOL)isTestUser
{
    return FALSE; //  发布时，一定要屏蔽
    //return  TRUE;// 发布时，一定要屏蔽
    BOOL bRet =FALSE;
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *strValue = [defaults objectForKey:@"isAppReview"]; // 1 代表审核中， 0 代表 审核通过
    
    if (strValue)
     {
        return [strValue isEqualToString:@"1"];
     }
    return bRet;
}


#if PMHEnableSwitchURLGesture

/*!
 @brief     设置base url和stat url
 */
+ (void)setBaseUrl:(NSString *)baseUrlString statUrl:(NSString *)statUrlString
{
    [[NSUserDefaults standardUserDefaults] setObject:baseUrlString forKey:kBaseURLinUserDefaultsString];
    [[NSUserDefaults standardUserDefaults] setObject:statUrlString forKey:kStatURLinUserDefaultsString];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#endif

/*!
 @brief     获取完整api的url
 @param     urlString url的名称
 @return    NSString 完全的api
 */
+ (NSString *)getFullApi:(NSString *)urlString
{

    return DDG_str(@"%@%@", [PDAPI getBaseUrlString], urlString);

}

/*!
 @brief     获取完整api的url
 @param     urlString url的名称
 @return    NSString 完全的api
 */
+ (NSString *)getFullApi2:(NSString *)urlString
{
    return DDG_str(@"%@%@", [PDAPI getBusiUrlString], urlString);
}

+ (void)setApp_Token:(NSString *)app_Token{
    if (app_Token && app_Token.length > 1) {
        [[NSUserDefaults standardUserDefaults] setObject:app_Token forKey:APPToken];
    }else
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:APPToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getAppToken{
    NSString *app_token = [[NSUserDefaults standardUserDefaults] objectForKey:APPToken];
    if (!app_token) {
        return @"";
    }
    return app_token;
}

+ (NSString *)getAppTokenAdmin{
    NSString *app_token_admin = @"app_token=0&";
    if ([self getAppToken] && [[self getAppToken] length] > 1) {
        app_token_admin = [NSString stringWithFormat:@"app_token=%@/",[self getAppToken]];
    }
    return app_token_admin;
}



#pragma mark === Function
/*!
 @brief     图片下载API
 @return    NSString
 */
+ (NSString *)imageDownloadAPI
{
    return kBaseURL;
}

/*!
 @brief     版本检测
 @return    NSString
 */
+ (NSString *)getCheckVersionAPI{
    return [self getFullApi:kDDGCheckVersionAPIString];
}

/*!
 @brief     获取验证码
 @return    NSString
 */
+ (NSString *)getRegSendMsghAPI{
    return [self getFullApi:kDDGRegSendMsgAPIString];
}

/*!
 @brief     手机注册
 @return    NSString
 */
+ (NSString *)userGetRegisterAPI
{
    return [self getFullApi:kDDGUserGetRegisterAPIString];
}
/*!
 @brief     手机注册获取验证码
 @return    NSString
 */
+ (NSString *)userRegisterPasswordAPI
{
    return [self getFullApi:KDDGUserRegistPwdSendMsgAPIString];
}

/*!
 @brief     用户注册协议
 @return    NSString
 */
+ (NSString *)getAgreementAPI
{
    return [self getFullApi:kDDGGetAgreementAPIString];
}

/*!
 @brief     忘记密码
 @return    NSString
 */
+ (NSString *)userForgetPasswordAPI
{
    return [self getFullApi:KDDGUserForgetPasswordAPIString];
}

/*!
 @brief     忘记密码获取验证码
 @return    NSString
 */
+ (NSString *)userForgetPwdSendMsgAPI
{
    return [self getFullApi:KDDGUserForgetPwdSendMsgAPIString];
}

/*!
 @brief     登录
 @return    NSString
 */
+ (NSString *)userDoLoginAPI
{
    return [self getFullApi:kDDGGetLoginAPIString];
}

/*!
 @brief     验证码登录
 @return    NSString
 */
+ (NSString *)userVerifyLoginAPI
{
    return [self getFullApi:kDDGGetVerifyLoginAPIString];
}

/*!
 @brief     退出登录
 @return    NSString
 */
+ (NSString *)userDoLogoutAPI
{
    return [self getFullApi:kDDGUserDoLogoutAPIString];
}

/*!
 @brief     获取引导页图片列表
 @return    NSString 获取引导页图片API
 */
+ (NSString *)getLoadingImgsAPI
{
    return [self getFullApi:kDDGGetLoadingImgsAPIString];
}



/*!
 @brief     发送反馈数据
 @return    NSString    发送反馈数据API字符串
 */
+ (NSString *)sendFeedbackAPI
{
    return [self getFullApi:kDDGFeedBackAPIString];
}

/*!
 @brief     获取版本号
 @return    NSString
 */
+ (NSString *)checkAppNewVersionAPI{
    return [self getFullApi:kDDGGetVersionAPIString];
}

/*!
 @brief     获取最近的放款
 @return    NSString
 */
+ (NSString *)getNewTreatAPI{
    return [self getFullApi:kDDGGetNewTreat];
}



/**
 *  //// ------------------------------      ------------------------------------ /////
 */
#pragma mark === 首页 (交单相关)
/*!
 @brief     banner 广告
 @return    NSString
 */
+ (NSString *)getBannerAPI{
    return [self getFullApi:kDDGGetBannerAPIString];
}
/*!
 @brief     武功秘籍类型
 @return    NSString
 */
+ (NSString *)getInMiJiInfoAPI{
    return [self getFullApi:kDDGGetMiJiAPIString];
}
/*!
 @brief     上传城市
 @return    NSString
 */
+ (NSString *)getSelectCityAPI{
    return [self getFullApi:kDDGGetSelectCityAPIString];
}
/*!
 @brief     武功秘籍列表
 @return    NSString
 */
+ (NSString *)getInQueryListAPI{
    return [self getFullApi:kDDGGetQueryListAPIString];
}

/*!
 @brief     武功秘籍详情
 @return    NSString
 */
+ (NSString *)getInMiJiDetailAPI{
    return [self getFullApi:kDDGGetMiJiDetailAPIString];
}

/*!
 @brief     武功秘籍详情分享
 @return    NSString
 */
+ (NSString *)getInMiJiShareAPI{
    return [self getFullApi:kDDGGetMiJiShareAPIString];
}
/*!
 @brief     贷款测算
 @return    NSString
 */
+ (NSString *)getInCalCLoanAmountAPI{
    return [self getFullApi:kDDGGetCalcLoanAmountAPIString];
}

/*!
 @brief     信贷员列表
 @return    NSString
 */
+ (NSString *)getQueryCirclesListAPI
{
    return [self getFullApi:kDDGGetQueryCirclesListAPIString];
}
/*!
 @brief     增加关注
 @return    NSString
 */
+ (NSString *)getAddJoinCirclesAPI
{
    return [self getFullApi:kDDGGetAddJoinCirclesAPIString];
}
/*!
 @brief     取消关注
 @return    NSString
 */
+ (NSString *)getCancelJoinCirclesAPI
{
    return [self getFullApi:kDDGGetCancelJoinCirclesAPIString];
}
/*!
 @brief     我的关注列表
 @return    NSString
 */
+ (NSString *)getMyJoinListAPI
{
    return [self getFullApi:kDDGGetMyJoinListAPIString];
}
/*!
 @brief     机构列表
 @return    NSString
 */
+ (NSString *)getInstitutionListAPI{
    return [self getFullApi:kDDGGetInstitutionListAPIString];
}

/*!
 @brief     机构产品
 @return    NSString
 */
+ (NSString *)getInstitutionProductListAPI{
    return [self getFullApi:kDDGGetInstitutionProductListAPIString];
}

/*!
 @brief     产品详情
 @return    NSString
 */
+ (NSString *)getInstitutionProductDetailAPI{
    return [self getFullApi:kDDGGetInstitutionProductDetailAPIString];
}

/*!
 @brief     交单
 @return    NSString
 */
+ (NSString *)getSendOrderAPI{
    return [self getFullApi:kDDGGetSendOrderAPIString];
}

/*!
 @brief     交单 -- 简单交单之获取验证码
 @return    NSString
 */
+ (NSString *)getSendOrderVerifyCodeAPI{
    return [self getFullApi:kDDGGetSendOrderVerifyCodeAPIString];
}

/*!
 @brief     交单 -- 简单交单之微信分享
 @return    NSString
 */
+ (NSString *)getSendOrderWXAPI{
    return [self getFullApi:kDDGGetSendOrderWXAPIString];
}

/*!
 @brief     交单 -- 简单交单之短信分享
 @return    NSString
 */
+ (NSString *)getSendOrderSMSAPI{
    return [self getFullApi:kDDGGetSendOrderSMSAPIString];
}

/*!
 @brief     取消订单
 @return    NSString
 */
+ (NSString *)getCanelOrderAPI{
    return [self getFullApi:kDDGGetCancelOrderAPIString];
}

/*!
 @brief     我的交单
 @return    NSString
 */
+ (NSString *)getMyOrderAPI{
    return [self getFullApi:kDDGGetMyOrderAPIString];
}

/*!
 @brief     交单详情
 @return    NSString
 */
+ (NSString *)getOrderDetailAPI{
    return [self getFullApi:kDDGGetOrderDetailAPIString];
}

/*!
 @brief     读取材料
 @return    NSString
 */
+ (NSString *)getSendProductFileAPI{
    return [self getFullApi:kDDGGetFileListAPIString];
}



/*!
 @brief     删除材料
 @return    NSString
 */
+ (NSString *)getDeleteFileAPI{
    return [self getFullApi:kDDGGetDeleteFileAPIString];
}

/*!
 @brief     完整交单 -- 提交材料
 @return    NSString
 */
+ (NSString *)getSendCompleteFileAPI{
    return [self getFullApi:kDDGGetSendCompleteOrderAPIString];
}

/*!
 @brief     完整交单 -- 重新提交材料
 @return    NSString
 */
+ (NSString *)getReSendCompleteFileAPI{
    return [self getFullApi:kDDGGetReSendCompleteOrderAPIString];
}

/*!
 @brief     查号记录
 @return    NSString
 */
+ (NSString *)getSearchRecordListAPI{
    return [self getFullApi:kDDGGetSearchRecordListAPIString];
}

/*!
 @brief     申请查号
 @return    NSString
 */
+ (NSString *)getSearchNumAPI{
    return [self getFullApi:kDDGGetSearchNumAPIString];
}


/**
 *  获取金融资讯
 */
+ (NSString *)getFinanceNewsAPI{
    return [self getFullApi:kDDGGetFinanceNewsAPIString];
}




/*!
 @brief     系统通知
 @return    NSString
 */
+ (NSString *)getNewsQueryListAPI{
    return [self getFullApi:kDDGGetNewsQueryListAPIString];
}
/*!
 @brief     系统通知详情
 @return    NSString
 */
+ (NSString *)getNewsViewAPI{
    return [self getFullApi:kDDGGetViewAPIString];
}


//征信查询
/*!
 @brief     登陆注册图片验证码
 @return    NSString
 */
+ (NSString *)getCheckCreditAPI{
   return [self getFullApi:kDDGGetCheckCreditAPIString];
}
/*!
 @brief     注册第一步
 @return    NSString
 */
+ (NSString *)getCheckCreditRegAPI{
    return [self getFullApi:kDDGGetCheckCreditRegAPIString];
}
/*!
 @brief     注册第二步
 @return    NSString
 */
+ (NSString *)getCheckCreditRegSupplementInfoAPI{
    return [self getFullApi:kDDGGetCheckCreditRegSupplementAPIString];
}
/*!
 @brief     登陆
 @return    NSString
 */
+ (NSString *)getCheckCreditLoginAPI{
    return [self getFullApi:kDDGGetCheckCreditLoginAPIString];
}
/*!
 @brief     注册验证码
 @return    NSString
 */
+ (NSString *)getCheckCreditSendRegMsgAPI{
    return [self getFullApi:kDDGGetCheckCreditSendRegMsgAPIString];
}
/*!
 @brief     问题验证问题
 @return    NSString
 */
+ (NSString *)getCheckCreditIdentityDataAPI{
    return [self getFullApi:kDDGGetCheckCreditIdentityDataAPIString];
}
/*!
 @brief     提交问题
 @return    NSString
 */
+ (NSString *)getCheckCreditQuestionDataAPI{
    return [self getFullApi:kDDGGetCheckCreditQuestionAPIString];
}
/*!
 @brief     用户列表
 @return    NSString
 */
+ (NSString *)getCheckCreditInitDataAPI{
    return [self getFullApi:kDDGGetCheckCreditInitDataAPIString];
}
/*!
 @brief     用户列表信息
 @return    NSString
 */
+ (NSString *)getCheckCreditReportListDataAPI{
    return [self getFullApi:kDDGGetCheckCreditReportListDataAPIString];
}

/*!
 @brief     核对银行验证码
 @return    NSString
 */
+ (NSString *)getCheckCreditReportAPI{
    return [self getFullApi:kDDGGetCheckCreditReportAPIString];
}

/*!
 @brief     信息列表
 @return    NSString
 */
+ (NSString *)getCheckCreditReportDataAPI{
    return [self getFullApi:kDDGGetCheckCreditReportDataAPIString];
}
/*!
 @brief     贷款记录明细
 @return    NSString
 */
+ (NSString *)getCheckCreditRecordDataAPI{
    return [self getFullApi:kDDGGetCheckCreditRecordDataAPIString];
}
/*!
 @brief     查询记录明细
 @return    NSString
 */
+ (NSString *)getCheckQueryReocrdDataAPI{
    return [self getFullApi:kDDGGetCheckQueryReocrdDataAPIString];
}
//企业查询
/*!
 @brief     企业查询结果
 @return    NSString
 */
+ (NSString *)getCheckQueryDataAPI{
    return [self getFullApi:kDDGGetCheckQueryDataAPIString];
}

/*!
 @brief     查询结果详情
 @return    NSString
 */
+ (NSString *)getCheckQueryDetailDataAPI{
    return [self getFullApi:kDDGGetCheckQueryDetailDataAPIString];
}

//失信人查询
/*!
 @brief     失信人查询结果
 @return    NSString
 */
+ (NSString *)getChecksSXRQueryDataAPI{
    return [self getFullApi:kDDGGetCheckSXRQueryDataAPIString];
}
/*!
 @brief     失信人查询结果详情
 @return    NSString
 */
+ (NSString *)getChecksSXRDetailDataAPI{
    return [self getFullApi:kDDGGetCheckSXRDetailDataAPIString];
}





/*!
 @brief     直贷头像
 @return    NSString
 */
+ (NSString *)getLoanListHeadImgAPI{
    return [self getFullApi:kDDGGetLoanListHeadImgAPIString];
}

/*!
 @brief     抢单－直借
 @return    NSString
 */
+ (NSString *)getLoanLightingAPI{
    return [self getFullApi:kDDGGetLoanLightingAPIString];
}

/*!
 @brief     抢单－甩单
 @return    NSString
 */
+ (NSString *)getLoanLighting2API{
    return [self getFullApi:kDDGGetLoanLighting2APIString];
}

#pragma mark === Tab_2  客户
/*!
 @brief     客户列表
 @return    NSString
 */
+ (NSString *)getContactListAPI{
    return [self getFullApi:kDDGGetContactListString];
}

/*!
 @brief     删除客户
 @return    NSString
 */
+ (NSString *)getDeleteContactAPI{
    return [self getFullApi:kDDGGetDeleteContactString];
}

/*!
 @brief     添加客户
 @return    NSString
 */
+ (NSString *)getAddContactAPI{
    return [self getFullApi:kDDGGetAddContactString];
}

/*!
 @brief     修改客户信息
 @return    NSString
 */
+ (NSString *)getUpdateContactListAPI{
    return [self getFullApi:kDDGGetUpdateContactString];
}

/*!
 @brief     修改客户标签初始数据
 @return    NSString
 */
+ (NSString *)getContactMarksDtlAPI{
    return [self getFullApi:kDDGGetContactMarksDtlString];
}


/*!
 @brief     修改客户标签
 @return    NSString
 */
+ (NSString *)getUpdateContactMarksAPI{
    return [self getFullApi:kDDGGetUpdateContactMarksString];
}

/*!
 @brief     客户标星处理
 @return    NSString
 */
+ (NSString *)getUpdateContactStarAPI{
    return [self getFullApi:kDDGGetUpdateContactStarString];
}

/*!
 @brief     查寻标签
 @return    NSString
 */
+ (NSString *)getMarksListAPI{
    return [self getFullApi:kDDGGetMarksListString];
}

/*!
 @brief     标签下的客户
 @return    NSString
 */
+ (NSString *)getMarksContactListAPI{
    return [self getFullApi:kDDGGetMarksContactListString];
}

/*!
 @brief     添加标签
 @return    NSString
 */
+ (NSString *)getAddMarksAPI{
    return [self getFullApi:kDDGGetAddMarksString];
}

/*!
 @brief     修改标签
 @return    NSString
 */
+ (NSString *)getUpdateMarksAPI{
    return [self getFullApi:kDDGGetUpdateMarksString];
}

/*!
 @brief     删除标签
 @return    NSString
 */
+ (NSString *)getDeleteMarksAPI{
    return [self getFullApi:kDDGGetDeleteMarksString];
}



#pragma mark === Tab_3  微店
/*!
 @brief     微店首页
 @return    NSString
 */
+ (NSString *)userGetWDShopIndexInfoAPI
{
    return [self getFullApi:kDDGUserGetWDShopIndexInfoAPIString];
}
/*!
 @brief     申请列表
 @return    NSString
 */
+ (NSString *)userGetWDShopApplyListInfoAPI
{
    return [self getFullApi:kDDGUserGetWDShopApplyListInfoAPIString];
}
/*!
 @brief     申请产品详情
 @return    NSString
 */
+ (NSString *)userGetApplyDetailInfoAPI
{
    return [self getFullApi:kDDGUserGetApplyDetailInfoAPIString];
}
/*!
 @brief     申请展示
 @return    NSString
 */
+ (NSString *)userGetWDShowInfoAPI
{
    return [self getFullApi:kDDGUserGetWDShowInfoAPIString];
}
/*!
  @brief     创建微店的初始化信息
  @return    NSString
  */
+ (NSString *)userGetWDShopWdInfoInitInfoAPI
{
    return [self getFullApi:kDDGUserGetWDShopWdInfoInitInfoAPIString];
}
/*!
 @brief     修改微店信息
 @return    NSString
 */
+ (NSString *)userGetWDShopEditInfoAPI
{
    return [self getFullApi:kDDGUserGetWDShopEditInfoAPIString];
}
/*!
 @brief     查询微店信息
 @return    NSString
 */
+ (NSString *)userGetWDShopQueryInfoAPI
{
    return [self getFullApi:kDDGUserGetWDShopQueryInfoAPIString];
}

/*!
 @brief     微店统计
 @return    NSString
 */
+ (NSString *)userGetWdApplyStatisticAPI
{
    return [self getFullApi:kDDGUserGetWdApplyStatistic];
}

/*!
 @brief     所有城市列表
 @return    NSString
 */
+ (NSString *)userGetWDShopCityInfoAPI;

{
    return [self getFullApi:kDDGUserGetWDShopCityInfoAPIString];
}

/*!
 @brief     微店排行
 @return    NSString
 */
+ (NSString *)userGetwdShopRankInfoAPI
{
    return [self getFullApi:kDDGUserGetwdShopRankInfoAPIString];
}
/*!
 @brief     微店产品增加/修改
 @return    NSString
 */
+ (NSString *)userGetWdProductInfoAPI
{
    return [self getFullApi:kDDGUserGetWdProductInfoAPIString];
}
/*!
 @brief     微店产品选项
 @return    NSString
 */
+ (NSString *)userGetProductInitDataInfoAPI
{
    return [self getFullApi:kDDGUserGetProductInitDataInfoAPIString];
}
/*!
 @brief     微店产品增加第二步
 @return    NSString
 */
+ (NSString *)userGetWdProductDtlInfoAPI
{
    return [self getFullApi:kDDGUserGetWdProductDtlInfoAPIString];
}
/*!
 @brief     微店产品列表
 @return    NSString
 */
+ (NSString *)userGetwdproductListInfoAPI
{
    return [self getFullApi:kDDGUserGetWdProductListInfoAPIString];
}

/*!
 @brief     微店产品删除
 @return    NSString
 */
+ (NSString *)userGetwddelWdProductInfoAPI
{
    return [self getFullApi:kDDGUserGetWddelWdProductInfoAPIString];
}

/*!
 @brief     微店产品信息
 @return    NSString
 */
+ (NSString *)userGetwdWdPordInfoAPI
{
    return [self getFullApi:kDDGUserGetWdPordInfoAPIString];
}
/*!
 @brief     微店产品信息第二步
 @return    NSString
 */
+ (NSString *)userGetWdProRuleInfoAPI
{
    return [self getFullApi:kDDGUserGetWdProRuleInfoAPIString];
}
/*!
 @brief     微店名片信息
 @return    NSString
 */
+ (NSString *)userGetwdCardInfoAPI
{
    return [self getFullApi:kDDGUserGetwdCardInfoAPIString];
}

/*!
 @brief     微店名片新增或修改
 @return    NSString
 */
+ (NSString *)userGetwdeditCardInfoAPI
{
    return [self getFullApi:kDDGUserGetwdeditCardInfoAPIString];
}
/*!
 @brief     成功案例列表
 @return    NSString
 */
+ (NSString *)userGetCustCaseListInfoAPI{
    return [self getFullApi:kDDGUserGetCustCaseListInfoAPIString];
}
/*!
 @brief     添加成功案例
 @return    NSString
 */
+ (NSString *)userGetEditCustCaseInfoAPI
{
    return [self getFullApi:kDDGUserGetEditCustCaseInfoAPIString];
}
/*!
 @brief     查询成功案例
 @return    NSString
 */
+ (NSString *)userGetCustCaseInfoAPI
{
    return [self getFullApi:kDDGUserGetCustCaseInfoAPIString];
}
/*!
 @brief     删除成功案例
 @return    NSString
 */
+ (NSString *)userGetDelCustCaseInfoAPI
{
    return [self getFullApi:kDDGUserGetDelCustCaseInfoAPIString];
}
/*!
 @brief     微店模板
 @return    NSString
 */
+ (NSString *)userGetWdShopTemplateListInfoAPI
{
    return [self getFullApi:kDDGUserGetTemplateListInfoAPIString];
}
/*!
 @brief     微店模板修改
 @return    NSString
 */
+ (NSString *)userGetEditWdShopInfoAPI
{
    return [self getFullApi:kDDGUserGetEditWdShopInfoAPIString];
}

/*!
 @brief     分享微店Html5
 @return    NSString
 */
+ (NSString *)userGetShareWdWedInfoAPI
{
    return [self getFullApi:kDDGUserGetShareWdWedInfoAPIString];
}


#pragma mark === Tab_4  我的

/*!
 @brief     不需要登录 -- 当前版本的配置与版本号等
 @return    NSString
 */
+ (NSString *)getUserInfoAPI
{
    return [self getFullApi:kDDGGetUserInfoAPIString];
}



/*!
 @brief     切换身份
 @return    NSString
 */
+ (NSString *)userGetUserUserTypeInfoAPI
{
    return [self getFullApi:kDDGGetUserUserTypeInfoAPIString];
}

/*!
 @brief     信贷经理入驻条件
 @return    NSString
 */
+ (NSString *)userGetQueryCheckJoinInfoAPI
{
    return [self getFullApi:kDDGGetUserQueryCheckJoinInfoAPIString];
}





/*!
 @brief     头像
 @return    NSString
 */
+ (NSString *)getUserHeadImageAPI
{
    return [self getFullApi:kDDGUserGetUserHeadImageInfoAPIString];
}

/*!
 @brief     个人认证
 @return    NSString
 */
+ (NSString *)getpersonalAuthAPI
{
    return [self getFullApi:kDDGGetpersonalAuthInfoAPIString];
}
/*!
 @brief     查询认证信息
 @return    NSString
 */
+ (NSString *)getQueryProfessionListAPI
{
    return [self getFullApi:kDDGGetQueryProfessionInfoAPIString];
}

/*!
 @brief     机构列表
 @return    NSString
 */
+ (NSString *)getqueryCompanyListAPI
{
    return [self getFullApi:kDDGGetProfessionInfoAPIString];
}
/*!
 @brief     添加公司
 @return    NSString
 */
+ (NSString *)getAddCompanyAPI
{
    return [self getFullApi:kDDGGetAddCompanyAPIString];
}

/*!
 @brief     借款人单独身份认证
 @return    NSString
 */
+ (NSString *)getValidateNameAPI
{
    return [self getFullApi:kDDGGetValidateNameInfoAPIString];
}

/*!
 @brief     查询借款人单独身份认证信息
 @return    NSString
 */
+ (NSString *)getQueryIdentifyAPI
{
    return [self getFullApi:kDDGGetQueryIdentifyInfoAPIString];
}

/*!
 @brief     服务区域
 @return    NSString
 */
+ (NSString *)getAllAreaInfoAPI
{
    return [self getFullApi:kDDGGetAllAreaInfoAPIString];
}

/*!
 @brief     提交工作地点
 @return    NSString
 */
+ (NSString *)getModifyLocaInfoAPI
{
    return [self getFullApi:kDDGGetModifyLocaAPIString];
}

/*!
 @brief     第一次添加邮箱
 @return    NSString
 */
+ (NSString *)userGetUserEmailInfoAPI
{
    return [self getFullApi:kDDGUserGetUserEmailInfoAPIString];
}

/*!
 @brief     修改邮箱
 @return    NSString
 */
+ (NSString *)userGetUserAmendEmailInfoAPI
{
    return [self getFullApi:kDDGUserGetUserAmendEmailInfoAPIString];
}

/*!
 @brief     修改邮箱获取验证码
 @return    NSString
 */
+ (NSString *)userForgetEmailSendMsgAPI
{
    return [self getFullApi:KDDGUserForgetEmailSendMsgAPIString];
}

/*!
 @brief     修改密码，设置里面的
 @return    NSString
 */
+ (NSString *)userGetUserModifyLoginPwdInfoAPI
{
    return [self getFullApi:kDDGUserGetUserModifyLoginPwdInfoAPIString];
}
/*!
 @brief     公司简介，关于小小金融
 @return    NSString
 */
+ (NSString *)userGetUserXxjrInfoAPI
{
    return [self getFullApi:kDDGUserGetUserXxjrInfoAPIString];
}

/*!
 @brief     设置交易密码
 @return    NSString
 */
+ (NSString *)setPayPassword
{
    return [self getFullApi:KDDGSetPayPasswordAPIString];
}

/*!
 @brief     修改交易密码
 @return    NSString
 */
+ (NSString *)userEditPayPwdAPI
{
    return [self getFullApi:KDDGUserEditPayPwdAPIString];
}



/*!
 @brief     更换手机
 @return    NSString
 */
+ (NSString *)userGetUserNewTelInfoAPI
{
    return [self getFullApi:kDDGUserGetUserNewTelInfoAPIString];
}

/*!
 @brief     更换手机获取原手机号验证码
 @return    NSString
 */
+ (NSString *)userGetUserChangeTelSendAPI
{
    return [self getFullApi:kDDGUserGetUserChangeTelSendAPIString];
}

/*!
 @brief     验证原手机获取的验证码
 @return    NSString
 */
+ (NSString *)userGetUserTelInfoAPI
{
    return [self getFullApi:kDDGUserGetUserTelInfoAPIString];
}

/*!
 @brief     更换手机获取新手机验证码
 @return    NSString
 */
+ (NSString *)userGetUserTelNewSendAPI
{
    return [self getFullApi:kDDGUserGetUserTelNewSendAPIString];
}

/*!
 @brief     意见反馈，设置里面的
 @return    NSString
 */
+ (NSString *)userGetUserFeedBackInfoAPI
{
    return [self getFullApi:kDDGUserGetUserFeedBackInfoAPIString];
}


/*!
 @brief     我的业绩总信息
 @return    NSString
 */
+ (NSString *)userGetUserSummaryInfoAPI
{
    return [self getFullApi:kDDGUserGetUserSummaryInfoAPIString];
}

/*!
 @brief     绑定微信
 @return    NSString
 */
+ (NSString *)userGetUserBindingWXAPI
{
    return [self getFullApi:kDDGUserBindingWXAPIString];
}


/*!
 @brief     提现明细
 @return    NSString
 */
+ (NSString *)userGetUserQueryWithdrawInfoAPI
{
    return [self getFullApi:kDDGUserGetUserQueryWithdrawInfoAPIString];
}

/*!
 @brief     剩余佣金提现处理
 @return    NSString
 */
+ (NSString *)userGetUserAddWithdrawInfoAPI
{
    return [self getFullApi:kDDGUserGetUserAddWithdrawInfoAPIString];
}
/*!
 @brief     剩余佣金提现处理获取验证码
 @return    NSString
 */
+ (NSString *)getRegWithdrawSendMsghAPI
{
    return [self getFullApi:kDDGUserGetWithdrawSendInfoAPIString];
}
/*!
 @brief     已返佣金
 @return    NSString
 */
+ (NSString *)userGetUserQueryMyListInfoAPI
{
    return [self getFullApi:kDDGUserGetUserQueryMyListInfoAPIString];
}

/*!
 @brief     可提现的银行
 @return    NSString
 */
+ (NSString *)userGetUserBankAllListInfoAPI
{
    return [self getFullApi:kDDGUserGetUserBankAllListInfoAPIString];
}

/*!
 @brief     获取银行卡信息
 @return    NSString
 */
+ (NSString *)userGetUserCardListInfoAPI
{
    return [self getFullApi:kDDGUserGetUserCardListInfoAPIString];
}
/*!
 @brief     添加银行卡
 @return    NSString
 */
+ (NSString *)userGetUserAddCardInfoAPI
{
    return [self getFullApi:kDDGUserGetUserBankAddCardInfoAPIString];
}
/*!
 @brief     我要收徒
 @return    NSString
 */
+ (NSString *)userGetUsershoutuInfoAPI
{
    return [self getFullApi:kDDGUserGetUsershoutuInfoAPIString];
}
/*!
 @brief     收徒赚佣金分享
 @return    NSString
 */
+ (NSString *)userGetUsershoutuShareInfoAPI
{
    return [self getFullApi:kDDGUserGetUsershoutuShareInfoAPIString];
}
/*!
 @brief     我的学徒
 @return    NSString
 */
+ (NSString *)userGetUserApprenticeListInfoAPI
{
    return [self getFullApi:kDDGUserGetUserApprenticeListInfoAPIString];
}
/*!
 @brief     为什么要收徒
 @return    NSString
 */
+ (NSString *)userGetUserReasonInfoAPI
{
    return [self getFullApi:kDDGUserGetUserReasonInfoAPIString];
}
/*!
 @brief     如何收取更多徒弟
 @return    NSString
 */
+ (NSString *)userGetUserStrategyInfoAPI
{
    return [self getFullApi:kDDGUserGetUserStrategyInfoAPIString];
}

/*!
 @brief     我的会员
 @return    NSString
 */
+ (NSString *)userGetUserCustGradeInfoAPI
{
    return [self getFullApi:kDDGUserGetUserCustGradeInfoAPIString];
}

/*!
 @brief     我的抢单
 @return    NSString
 */
+ (NSString *)userGetUserCustGrabListInfoAPI
{
    return [self getFullApi:kDDGUserGetUserGrabListInfoAPIString];
}

/*!
 @brief     小安时代推荐列表
 @return    NSString
 */
+ (NSString *)userGetRefererListInfoAPI
{
    return [self getFullApi:kDDGUserGetRefererListInfoAPIString];
}
/*!
 @brief    摇一摇礼品记录
 @return    NSString
 */
+ (NSString *)userGetDrawLotteryListInfoAPI
{
    return [self getFullApi:kDDGUserGetDrawLotteryListInfoAPIString];
}


#pragma mark 借款人-个人中心

/*!
 @brief    我的借款记录
 @return    NSString
 */
+ (NSString *)userBorrowMyListInfoAPI
{
    return [self getFullApi:kDDGUserGetBorrowMyListAPIString];
}

/*!
 @brief    找贷款(经理)记录
 @return    NSString
 */
+ (NSString *)userBorrowMyLoanRecordsInfoAPI
{
    return [self getFullApi:kDDGUserGetBorrowMyLoanRecordsAPIString];
}

/*!
 @brief   借款人评论
 @return    NSString
 */
+ (NSString *)userBorrowCommentInfoAPI
{
    return [self getFullApi:kDDGUserGetBorrowCommentAPIString];
}

#pragma mark 借款人-借款相关

/*!
 @brief    贷款申请-第一步
 @return    NSString
 */
+ (NSString *)userApplySaveSimpleInfoAPI
{
    return [self getFullApi:kDDGUserGetApplySaveSimpleInfoAPIString];
}

/*!
 @brief    贷款申请-第二步
 @return    NSString
 */
+ (NSString *)userApplySaveBaseInfoAPI
{
    return [self getFullApi:kDDGUserGetApplySaveBaseInfoAPIString];
}

/*!
 @brief   贷款申请-第三步
 @return    NSString
 */
+ (NSString *)userApplySaveAssetInfoAPI
{
    return [self getFullApi:kDDGUserGetApplySaveAssetInfoAPIString];
}

/*!
 @brief   贷款申请-第四步
 @return    NSString
 */
+ (NSString *)userApplySaveOtherInfoAPI
{
    return [self getFullApi:kDDGUserGetApplySaveOtherInfoAPIString];
}

/*!
 @brief   信用卡列表
 @return    NSString
 */
+ (NSString *)userGetCreditCardListAPI
{
    return [self getFullApi:kDDGUserGetCreditCardListAPIString];
}

/*!
 @brief   贷款超市列表
 @return    NSString
 */
+ (NSString *)userGetLoanShopListAPI
{
    return [self getFullApi:kDDGUserGetLoanShopListAPIString];
}

/*!
 @brief   信贷经理列表
 @return    NSString
 */
+ (NSString *)userBorrowLoanListAPI
{
    return [self getFullApi:kDDGUserBorrowLoanListAPIString];
}


/*!
 @brief   信贷经理列表详情申请贷款
 @return    NSString
 */
+ (NSString *)userBorrowWdApplyAPI
{
    return [self getFullApi:kDDGUserGetBorrowWdApplyAPIString];
}



#pragma mark 公用接口

/*!
 @brief     用户基本信息 需要登录 -- 个人信息（用户ID、昵称、性别、生日、省份、城市、详细地址、个人说明、 ）
 @return    NSString
 */
+ (NSString *)getUserBaseInfoAPI{
    return [self getFullApi:kDDGGetUserBaseInfoAPIString];
}

/*!
 @brief     修改个人信息
 @return    NSString
 */
+ (NSString *)userGetModifyInfoAPI
{
    return [self getFullApi:kDDGUserGetModifyInfoAPIString];
}

/*!
 @brief   资讯类型
 @return    NSString
 */
+ (NSString *)userZixunQueryTypeAPI
{
    return [self getFullApi:kDDGUserZixunQueryTypeAPIString];
}

/*!
 @brief   资讯列表
 @return    NSString
 */
+ (NSString *)userZixunQueryListAPI
{
    return [self getFullApi:kDDGUserZixunQueryListAPIString];
}

/*!
 @brief     资讯详情
 @return    NSString
 */
+ (NSString *)userGetCardNewsDetailInfoAPI
{
    return [self getFullApi:kDDGUserGetCardNewsDetailInfoAPIString];
}
/*!
 @brief     资讯详情分享
 @return    NSString
 */
+ (NSString *)userGetCardNewsShareInfoAPI;

{
    return [self getFullApi:kDDGUserGetCardNewsShareInfoAPIString];
}
/*!
 @brief     资讯分享成功修改积分
 @return    NSString
 */
+ (NSString *)userGetRewardShareInfoAPI
{
    return [self getFullApi:kDDGUserGetRewardShareInfoAPIString];
}




/*!
 @brief  设置-更改绑定手机号
 @return    NSString
 */
+ (NSString *)userForceBindingWXAPI
{
    return [self getFullApi:kDDGUserForceBindingWXAPIString];
}

/*!
 @brief  设置-查询当前绑定微信
 @return    NSString
 */
+ (NSString *)userInfoBindingWXWXAPI
{
    return [self getFullApi:kDDGUserInfoBindingWXAPIString];
}

/*!
 @brief   设置-修改密码
 @return    NSString
 */
+ (NSString *)userChangeLoginPwdAPI
{
    return [self getFullApi2:kDDGUserChangeLoginPwdAPIString];
}

/*!
 @brief     上传材料
 @return    NSString
 */
+ (NSString *)getSendFileAPI{
    return [self getFullApi:kDDGGetSendFileAPIString];
}






#pragma mark 登陆及验证码

/*!
 @brief   验证码登陆
 @return    NSString
 */
+ (NSString *)userKJLoginInfoAPI
{
    return [self getFullApi:kDDGUserKJLoginAPIString];
}

/*!
 @brief   密码登陆
 @return    NSString
 */
+ (NSString *)userPassWordLoginInfoAPI
{
    return [self getFullApi:kDDGUserPassWordLoginAPIString];
}

/*!
 @brief   微信登陆
 @return    NSString
 */
+ (NSString *)userWXLoginInfoAPI
{
    return [self getFullApi:kDDGUserWXLoginAPIString];
}

/*!
 @brief   微信登陆绑定手机号
 @return    NSString
 */
+ (NSString *)userWxLoginBindInfoAPI
{
    return [self getFullApi:kDDGUserWxLoginBindAPIString];
}

/*!
 @brief   设置密码
 @return    NSString
 */
+ (NSString *)userSetLoginPwdInfoAPI
{
    return [self getFullApi:kDDGUserSetLoginPwdAPIString];
}

/*!
 @brief     验证码登录登陆获取验证码
 @return    NSString
 */
+ (NSString *)userNologinKjloginAPI
{
    return [self getFullApi:kDDGGetNologinKjlogAPIString];
}

/*!
 @brief     信贷经理列表申请按钮填写资料发送验证码
 @return    NSString
 */
+ (NSString *)userNologinWdApplyAPI
{
    return [self getFullApi:kDDGGetNologinWdApplyAPIString];
}





















@end
