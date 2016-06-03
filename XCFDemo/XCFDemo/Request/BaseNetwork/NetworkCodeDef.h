//
//  NetworkCodeDef.h
//  GMiOSClient
//  description:网络请求错误码定义
//  Created by 阳小东 on 15/11/25.
//  Copyright © 2015年 xdyang. All rights reserved.
//

#ifndef NetworkCodeDef_h
#define NetworkCodeDef_h


#pragma mark - 参数定义
//~~~~~~控制开关
#define SERVER_DEBUG 1            //BaseUrl设置  1为测试环境、0为现网环境

#define DEBUG_HTTPURL            1            //打印请求的url
#define DEBUG_HTTPRequestParam   1            //打印请求的参数
#define DEBUG_HTTPReponse        1            //打印请求的返回数据
#define DEBUG_HTTPCache          0            //打印请求的缓存数据


//BaseUrl
#ifdef SERVER_DEBUG
#define SERVER_BASE_ADDRESS @"http://api.xiachufang.com/v2/"    //测试服务器
#else
#define SERVER_BASE_ADDRESS @"http://api.xiachufang.com/v2/"    //正式服务器
#endif

//Query Param
//Common Param
#define QUERY_API_KEY         @"07e72bef932537c71f9cafbe4c94df1c"
#define QUERY_APP_VERSION     @"142"
#define QUERY_ORIGIN          @"android"
#define QUERY_SECRET_KEY      @"-NUcwAZxSguPzxxYxLx1TA"

//Profession Param
#define QUERY_TIMEZONE        @"Asia/Shanghai"
#define QUERY_AD1_SLOT_NAME   @"homepage_banner_ad1"
#define QUERY_AD2_SLOT_NAME   @"homepage_banner_ad2"
#define QUERY_AD_IAMGE_HEIGHT @"1920"
#define QUERY_AD_IAMGE_WIDTH  @"1080"
#define QUERY_AD_SUPPORTED_TYPES @"1"


//Path String
//HomePage
#define PATH_INIT_PAGE_JSON     @"init_page_v5.json"
#define PATH_ISSUES_LIST_JSON   @"issues/list.json"
#define PATH_AD_SHOW_JSON       @"ad/show.json"
//Search
#define PATH_SEARCH_KEYWORD_YEAR @"search/keyword_year.json"
#define PATH_SEARCH_KEYWORD_HOUR @"search/keyword_hour.json"
#define PATH_CATEGORIES_EXPLORATIONS @"categories/explorations.json"
#define PATH_SEARCH_UNIVERSAL_SEARCH @"search/universal_search.json"
#define PATH_SEARCH_RECIPES_FILTERS @"search/recipes_filters.json"
#define PATH_ACCOUNT_FEEDS @"account/feeds_v4.json"
#define PATH_EXPLORE_JUSTBUY @"explore/buybuybuy.json"
#define PATH_NOTIFICATION_COMMUNITY_BADGE @"notifications/community/badge_v2.json"

//网络日志
#if (DEBUG_HTTPURL == 1)
#define LogRequestUrl(...) NSLog(__VA_ARGS__)
#else
#define LogRequestUrl(...)
#endif

#if (DEBUG_HTTPRequestParam == 1)
#define LogRequestParam(...) NSLog(__VA_ARGS__)
#else
#define LogRequestParam(...)
#endif

#if (DEBUG_HTTPReponse == 1)
#define LogRequestResponse(...) NSLog(__VA_ARGS__)
#else
#define LogRequestResponse(...)
#endif

#if (DEBUG_HTTPCache == 1)
#define LogRequestCache(...) NSLog(__VA_ARGS__)
#else
#define LogRequestCache(...)
#endif


#pragma mark - 定下返回码
static NSString *const ReqStatusSucc = @"ok";
static NSString *const ReqStatusError = @"error";

typedef NS_ENUM(NSUInteger, ReqCodeType) {
    ReqCodeSucc = 200,                          //请求成功
    ReqCodeLackParam = 1000,                    //缺少参数
    ReqCodeSignatureError = 1001,               //签名错误
    ReqCodeInvalidUserType = 1002,              //用户类型不存在
    ReqCodeRegisterAgain = 1003,                //用户已注册
    ReqCodeNameOrPassError = 1004,              //用户名或者密码错误
    ReqCodeNoLogin         = 1006,              //没有登录
    ReqCodePhoneAccountEmpty = 1005,            //手机号对应用户不存在
    ReqCodeNoServiceName = 5024,                //没有提供service参数
    
    ReqCodeNoResponseName,                      //没有提供response class name
    ReqCodeResponseNameError,                   //提供的response类名错误
    
    ReqCodeNetworkError,                        //网络错误(没有网络连接、HTTP错误)
};


#pragma mark - 业务相关
//签名key
#define RequestAuthKey @"EB615DD1AEC972528161AE44FFEE3EFB"
//cookie key
#define CookieKey @"gd.session.id"

//默认的一页请求数据量
#define DefaultPageSize 20


#endif /* NetworkCodeDef_h */
