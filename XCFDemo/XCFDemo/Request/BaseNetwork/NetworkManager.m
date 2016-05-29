//
//
//  GMiOSClient
//
//  Created by 阳小东 on 15/11/22.
//  Copyright © 2015年 xdyang. All rights reserved.
//

#import "NetworkManager.h"
#import "AFHTTPRequestOperation.h"
#import "YYModel.h"
#import "NSURL+URLQueryBuilder.h"
#import <YYCategories/YYCategories.h>
#import "NSDictionary+CustomConvert.h"

#define MBConst (1024 * 1024)
#define URLCacheFolderName @"urlCache"

#define UrlDefaultCacheKey @"defaultCache"

#define RequestTimeout 30



@implementation POSTDataModel

@end




@interface NetworkManager ()
{
    
}

@end



@implementation NetworkManager

+ (instancetype)getInstance
{
    static NetworkManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NetworkManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if(self = [super init]){
        
        //初始化url缓存系统
        NSString *urlCachePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        urlCachePath = [urlCachePath stringByAppendingPathComponent:URLCacheFolderName];
        //内存：10M 磁盘：30M
        NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:(10 * MBConst) diskCapacity:(30 * MBConst) diskPath:urlCachePath];
        [NSURLCache setSharedURLCache:cache];
    }
    return self;
}

#pragma mark - 内部接口
//检查基础参数
+ (BOOL)checkeBaseArgWithService:(NSString *)service withResponseName:(NSString *)reponseName withFailedBlock:(RequestCallbackBlock)failedBlock
{
    BaseEntity *wrongEntity = [BaseEntity new];
    if (service.length <= 0){
        wrongEntity.code = ReqCodeNoServiceName;
#ifdef DEBUG
        wrongEntity.msg = @"没有传入正确的service参数";
#endif
    }else if (reponseName.length <= 0){
        wrongEntity.code = ReqCodeNoResponseName;
#ifdef DEBUG
        wrongEntity.msg = @"没有传入正确的response class name参数";
#endif
    }
    
    if (wrongEntity.code != 0){
        failedBlock(wrongEntity);
        return NO;
    }
    
    return YES;
}

+ (NSString *)getUrlWithService:(NSString *)service
{
    return [NSString stringWithFormat:@"%@%@", SERVER_BASE_ADDRESS, service];
}

//获取缓存的request
+ (NSURLRequest *)getCacheRequestWithUrl:(NSString *)urlStr withCacheKey:(NSString *)cacheKey
{
    NSString *key = cacheKey;
    if (key.length <= 0){
        key = UrlDefaultCacheKey;
    }
    NSString *cacheUrlStr = [NSString stringWithFormat:@"%@/%@", urlStr, key];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:cacheUrlStr]];
    return request;
}

//ORM模块:「对象关系映射」
+ (BaseEntity *)parseEntityWithResponseClassName:(NSString *)responseClassName withResponseDic:(NSDictionary *)responseDic
{
    BaseEntity *entity = nil;
    Class responseClass = NSClassFromString(responseClassName);
    if (responseClass)
    {
        if ([responseClass respondsToSelector:@selector(yy_modelWithJSON:)]){
            entity = [responseClass yy_modelWithJSON:responseDic];
            if (entity){
                return entity;
            }
        }
    }
    return nil;
}

//从NSURLCache中加载缓存
+ (BaseEntity *)getCacheEntityWithUrl:(NSString *)urlStr withCacheKey:(NSString *)cacheKey withResponseClassName:(NSString *)responseClassName
{
    NSURLRequest *request = [self getCacheRequestWithUrl:urlStr withCacheKey:cacheKey];
    
//    NSURLCache *urlCache = [NSURLCache sharedURLCache];
//    NSCachedURLResponse *cacheResponse = [urlCache cachedResponseForRequest:request];
    
    NSCachedURLResponse *cacheResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
    
    NSData *data = [cacheResponse data];
    if (!data)
    {
        return nil;
    }
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if (!dic)
    {
        return nil;
    }
    BaseEntity *entity = nil;
    //解析对象
    entity = [self parseEntityWithResponseClassName:responseClassName withResponseDic:dic];
    if (entity)
    {
        return entity;
    }
    
    //传入的responseClassName无效
    entity = [BaseEntity new];
    entity.code = ReqCodeResponseNameError;
    
#ifdef DEBUG
    entity.msg = @"传入的response class name错误，没有从缓存中解析出对象";
#endif
    
    return entity;
}

//添加NSUrlCache缓存
+ (void)storeCacheEntityWithUrl:(NSString *)urlStr withCacheKey:(NSString *)cacheKey withOperation:(AFHTTPRequestOperation *)operation
{
    NSURLRequest *request = [self getCacheRequestWithUrl:urlStr withCacheKey:cacheKey];
    
    NSURLCache *urlCache = [NSURLCache sharedURLCache];
    NSCachedURLResponse *cacheResponse = [[NSCachedURLResponse alloc] initWithResponse:operation.response data:operation.responseData];
    [urlCache storeCachedResponse:cacheResponse forRequest:request];
}

//处理成功返回
+ (void)handleSuccResponseWithResponseName:(NSString *)responseClassName withOperation:(AFHTTPRequestOperation *)operation withObject:(id)responseObject withSuccBlock:(RequestCallbackBlock)succBlock withFailedBlock:(RequestCallbackBlock)failedBlock
{
    //解析数据
    BaseEntity *entity = [self parseEntityWithResponseClassName:responseClassName withResponseDic:responseObject];
    LogRequestResponse(@"请求返回数据是:\n%@", [entity yy_modelToJSONString]);
    if (entity && [entity.status isEqualToString:ReqStatusSucc]){
        
        entity.code = ReqCodeSucc;
        //处理cookie
        [self handelResponseCookie:operation.response];
        
        //成功
        succBlock(entity);
        return;
    }else if (!entity){
        //没有解析到数据
        entity = [BaseEntity new];
        entity.code = ReqCodeResponseNameError;
#ifdef DEBUG
        entity.msg = @"传入的response class name错误,没有从返回接口中解析出对象";
#endif
    }
    
    //服务器返回错误码
    failedBlock(entity);
}

//处理失败返回
+ (void)handleFailedResponseWithResponseName:(NSString *)responseClassName withOperation:(AFHTTPRequestOperation *)operation withError:(NSError *)error withFailedBlock:(RequestCallbackBlock)failedBlock
{
    LogRequestResponse(@"请求返回错误是:\n%@", error);
    //网络问题
    BaseEntity *entity = [BaseEntity new];
    entity.code = ReqCodeNetworkError;
    failedBlock(entity);
}


#pragma mark - 功能接口相关
/**
 *  带参数不带缓存的GET请求
 *
 *  @param service           <#service description#>
 *  @param paramDic          <#paramDic description#>
 *  @param responseClassName <#responseClassName description#>
 *  @param succBlock         <#succBlock description#>
 *  @param failedBlock       <#failedBlock description#>
 */
+ (AFHTTPRequestOperation *)getRequestForService:(NSString *)service
                                    withParamDic:(NSDictionary *)paramDic
                                withResponseName:(NSString *)responseClassName
                                   withSuccBlock:(RequestCallbackBlock)succBlock
                                 withFailedBlock:(RequestCallbackBlock)failedBlock
{
    return [self getRequestForService:service
                         withParamDic:paramDic
                     withResponseName:responseClassName
                             cacheKey:nil
                      withRequestType:RequestTypeRefreshAfterCache
                        withSuccBlock:succBlock
                      withFailedBlock:failedBlock];
}

/**
 *  带缓存的GET请求
 *
 *  @param service           <#service description#>
 *  @param paramDic          <#paramDic description#>
 *  @param responseClassName <#responseClassName description#>
 *  @param cacheKey          <#cacheKey description#>
 *  @param requestTyep       <#requestTyep description#>
 *  @param succBlock         <#succBlock description#>
 *  @param failedBlock       <#failedBlock description#>
 */
+ (AFHTTPRequestOperation *)getRequestForService:(NSString *)service
                withParamDic:(NSDictionary *)paramDic
            withResponseName:(NSString *)responseClassName
                    cacheKey:(NSString *)cacheKey
             withRequestType:(RequestType)requestType
               withSuccBlock:(RequestCallbackBlock)succBlock
             withFailedBlock:(RequestCallbackBlock)failedBlock
{
    //*检查基础参数
    if (![self checkeBaseArgWithService:service withResponseName:responseClassName withFailedBlock:failedBlock]){
        return nil;
    }
    
    //*获取url
    NSString *serviceUrl = [self getUrlWithService:service];
    
    //*加载缓存
//    if (requestType == RequestTypeRefreshAfterCache)
//    {
//        BaseEntity *entity = [self getCacheEntityWithUrl:serviceUrl withCacheKey:cacheKey withResponseClassName:responseClassName];
//        LogRequestCache(@"缓存数据为:\n%@", entity);
//        //回调缓存
//        if (entity){
//            succBlock(entity);
//        }
//    }
    
    
    
    //*构建Request
    NSDictionary *requestParam = [NSDictionary convertAllValueToString:paramDic];
    //这里会对参数进行urlEncoding
    NSURL *requestUrl = [NSURL ars_queryWithString:serviceUrl queryElements:requestParam];
//    LogRequestUrl(@"请求的URL是:\n%@", requestUrl);
//    LogRequestParam(@"请求的参数是:\n%@", requestParam);
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:requestUrl];
    
    [urlRequest setHTTPMethod:@"GET"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [urlRequest setTimeoutInterval:RequestTimeout];       //设置超时时间;

    //*构建Operation
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    AFJSONResponseSerializer *ser = [AFJSONResponseSerializer serializer];
    [op  setResponseSerializer:ser];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        LogRequestResponse(@"请求返回数据是:\n%@", responseObject);
        //解析数据
        BaseEntity *entity = [self parseEntityWithResponseClassName:responseClassName withResponseDic:responseObject];
        if (entity && [entity.status isEqualToString:ReqStatusSucc]){
            
            entity.code = ReqCodeSucc;
            //处理cookie
            [self handelResponseCookie:operation.response];
            
            //成功
            succBlock(entity);
            
            //更新缓存
            if (requestType == RequestTypeRefreshAfterCache){
                [self storeCacheEntityWithUrl:serviceUrl withCacheKey:cacheKey withOperation:operation];
            }
            return;
        }else if (!entity){
            //没有解析到数据
            entity = [BaseEntity new];
            entity.code = ReqCodeResponseNameError;
#ifdef DEBUG
            entity.msg = @"传入的response class name错误,没有从返回接口中解析出对象";
#endif
        }
        
        //服务器返回错误码
        failedBlock(entity);
        
    }
    failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        LogRequestResponse(@"请求返回错误是:\n%@", error);
        //网络问题
        BaseEntity *entity = [BaseEntity new];
        entity.code = ReqCodeNetworkError;
        failedBlock(entity);
    }];

    
    //*请求
    [op start];
    return op;
}


#pragma mark - POST请求
/**
 *  POST请求
 *
 *  @param service           <#service description#>
 *  @param paramDic          拼接到url里面的参数
 *  @param httpFieldParamDic 放到HTTP头里面的参数
 *  @param responseClassName <#responseClassName description#>
 *  @param succBlock         <#succBlock description#>
 *  @param failedBlock       <#failedBlock description#>
 */
+ (AFHTTPRequestOperation *)postRequestForService:(NSString *)service
                 withParamDic:(NSDictionary *)paramDic
        withHTTPFieldParamDic:(NSDictionary *)httpFieldParamDic
             withResponseName:(NSString *)responseClassName
                withSuccBlock:(RequestCallbackBlock)succBlock
              withFailedBlock:(RequestCallbackBlock)failedBlock
{
    return [self postRequestForService:service withParamDic:paramDic withHTTPFieldParamDic:httpFieldParamDic withDataArray:nil withResponseName:responseClassName withSuccBlock:succBlock withFailedBlock:failedBlock];
}

/**
 *  POST请求
 *
 *  @param service           <#service description#>
 *  @param paramDic          拼接到url里面的参数
 *  @param httpFieldParamDic 放到HTTP头里面的参数
 *  @param dataArray         需要传输的二进制数据，是POSTDataModel对象的数组
 *  @param responseClassName <#responseClassName description#>
 *  @param succBlock         <#succBlock description#>
 *  @param failedBlock       <#failedBlock description#>
 */
+ (AFHTTPRequestOperation *)postRequestForService:(NSString *)service
                 withParamDic:(NSDictionary *)paramDic
        withHTTPFieldParamDic:(NSDictionary *)httpFieldParamDic
                withDataArray:(NSArray *)dataArray
             withResponseName:(NSString *)responseClassName
                withSuccBlock:(RequestCallbackBlock)succBlock
              withFailedBlock:(RequestCallbackBlock)failedBlock
{
    //*检查基础参数
    if (![self checkeBaseArgWithService:service withResponseName:responseClassName withFailedBlock:failedBlock]){
        return nil;
    }
    
    //*获取url
    NSString *serviceUrl = [self getUrlWithService:service];
    LogRequestUrl(@"请求的URL是:\n%@", serviceUrl);
    LogRequestParam(@"请求URL参数是:\n%@\nHTTPField参数是:\n%@\n有%ld个待传data数据", paramDic, httpFieldParamDic, dataArray.count);
    
    //*初始化Manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //*添加HTTPField
    for(id key in httpFieldParamDic)
    {
        id value = [httpFieldParamDic objectForKey:key];
        NSString *stringValue = nil;
        if ([value isKindOfClass:[NSString class]]){
            stringValue = (NSString *)value;
        }else if ([value respondsToSelector:@selector(stringValue)]){
            stringValue = [value stringValue];
        }
        if (stringValue.length <= 0){
            continue;
        }
        [manager.requestSerializer setValue:stringValue
                                     forHTTPHeaderField:key];
    }
    
    //*添加URL参数
    //*添加data
    AFHTTPRequestOperation *op = nil;
    if(dataArray.count > 0)
    {
        op = [manager POST:serviceUrl parameters:paramDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            for(POSTDataModel *dataModel in dataArray){
                if ([dataModel isKindOfClass:[POSTDataModel class]]){
                    
                    if (!dataModel.data || !dataModel.name){
                        continue;
                    }
                    [formData appendPartWithFileData:dataModel.data
                                                name:dataModel.name
                                            fileName:dataModel.fileName?:@"image.jpg"
                                            mimeType:dataModel.mimeType?:@"multipart/form-data"];
                }
            }
        } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            [self handleSuccResponseWithResponseName:responseClassName withOperation:operation withObject:responseObject withSuccBlock:succBlock withFailedBlock:failedBlock];
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            [self handleFailedResponseWithResponseName:responseClassName withOperation:operation withError:error withFailedBlock:failedBlock];
        }];
    }else
    {
        op = [manager POST:serviceUrl parameters:paramDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            [self handleSuccResponseWithResponseName:responseClassName withOperation:operation withObject:responseObject withSuccBlock:succBlock withFailedBlock:failedBlock];
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            [self handleFailedResponseWithResponseName:responseClassName withOperation:operation withError:error withFailedBlock:failedBlock];
        }];
    }
    return op;
    
    
}

+ (void)handelResponseCookie:(NSHTTPURLResponse *)response
{
    NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
    
    NSDictionary *headerField = [httpResp allHeaderFields];
    NSLog(@"%@", headerField);
    NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:[httpResp allHeaderFields] forURL:[response URL]];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:cookies forURL:[response URL] mainDocumentURL:nil];
    
    if (cookies.count > 0){
        NSLog(@"获取到下列的cookie信息");
    }
    for (NSHTTPCookie *cookie in cookies) {
        NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
//        [cookieProperties setObject:cookie.name forKey:NSHTTPCookieName];
//        [cookieProperties setObject:cookie.value forKey:NSHTTPCookieValue];
//        [cookieProperties setObject:cookie.domain forKey:NSHTTPCookieDomain];
//        [cookieProperties setObject:cookie.path forKey:NSHTTPCookiePath];
//        [cookieProperties setObject:[NSNumber numberWithInteger:cookie.version] forKey:NSHTTPCookieVersion];
        
        cookieProperties = [NSMutableDictionary dictionaryWithDictionary:cookie.properties];
        
        //设定cookie在本地不过期
        [cookieProperties setObject:[[NSDate date] dateByAddingTimeInterval:LONG_MAX] forKey:NSHTTPCookieExpires];
        
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        NSLog(@"cookie:%@", cookie);
        
    }
}


@end
