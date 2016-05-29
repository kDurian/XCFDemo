//
//  
//  GMiOSClient
//
//  Created by 阳小东 on 15/11/22.
//  Copyright © 2015年 xdyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "BaseEntity.h"
#import "NetworkCodeDef.h"


/**
 Appends the HTTP header `Content-Disposition: file; filename=#{filename}; name=#{name}"` and `Content-Type: #{mimeType}`, followed by the encoded file data and the multipart form boundary.
 
 @param data The data to be encoded and appended to the form data.
 @param name The name to be associated with the specified data. This parameter must not be `nil`.
 @param fileName The filename to be associated with the specified data. This parameter must not be `nil`.
 @param mimeType The MIME type of the specified data. (For example, the MIME type for a JPEG image is image/jpeg.) For a list of valid MIME types, see http://www.iana.org/assignments/media-types/. This parameter must not be `nil`.
 */
@interface POSTDataModel : NSObject

@property (nonatomic)NSData *data;              //要传输的二进制数据
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *fileName;  //默认为  @"image.jpg"
@property (nonatomic, copy)NSString *mimeType;  //默认为  @"multipart/form-data"

@end





typedef NS_ENUM(NSUInteger, RequestType) {
    RequestTypeRefresh,               //刷新
    RequestTypeLoadMore,              //加载更多
    RequestTypeRefreshAfterCache,     //先加载缓存，再刷新
    RequestTypeNoCache,               //不缓存
};


typedef void(^RequestCallbackBlock)(BaseEntity *entity);


@interface NetworkManager : NSObject


+ (instancetype)getInstance;


#pragma mark - 功能接口
#pragma mark - GET请求
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
             withFailedBlock:(RequestCallbackBlock)failedBlock;

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
             withFailedBlock:(RequestCallbackBlock)failedBlock;

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
              withFailedBlock:(RequestCallbackBlock)failedBlock;

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
              withFailedBlock:(RequestCallbackBlock)failedBlock;

@end
