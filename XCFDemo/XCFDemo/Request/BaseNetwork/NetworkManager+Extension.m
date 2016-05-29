//
//  NetworkManager+Extension.m
//  XCFDemo
//
//  Created by Durian on 5/4/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "NetworkManager+Extension.h"
#import "NSString+YYAdd.h"
#import "NetworkCodeDef.h"

@implementation NetworkManager (Extension)

//添加基本请求参数
+ (NSMutableDictionary *)appendBaseParamWith:(NSDictionary *)param
{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    paramDic[@"version"] = QUERY_APP_VERSION;
    paramDic[@"api_key"] = QUERY_API_KEY;
    paramDic[@"origin"] = QUERY_ORIGIN;
    paramDic[@"sk"] = QUERY_SECRET_KEY;
    
    if (param && param.count > 0)
    {
        [paramDic addEntriesFromDictionary:param];
    }
    
    return paramDic;
}

//对参数进行签名,根据服务端定义来定
+ (NSDictionary *)SignatureWithPara:(NSDictionary *)param
{
    if (param.count <= 0){
        return param;
    }
    
    NSArray *keys = param.allKeys;
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *key1 = (NSString *)obj1;
        NSString *key2 = (NSString *)obj2;
        return [key1 compare:key2];
    }];
    
    NSMutableString *queryString = [NSMutableString string];
    for (NSString *key in sortedKeys){
        NSString *signleStr = [NSString stringWithFormat:@"&%@=%@", key, param[key]];
        [queryString appendString:signleStr];
    }
    NSString *keyString = [NSString stringWithFormat:@"&key=%@", RequestAuthKey];
    [queryString appendString:keyString];
    //去掉头部的&
    NSString *resultStr = [queryString substringFromIndex:1];
    resultStr = [resultStr md5String];
    resultStr = [resultStr uppercaseString];
    if (resultStr.length <= 0){
        return nil;
    }
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionaryWithDictionary:param];
    resultDic[@"sign"] = resultStr;
    
    return resultDic;
}

@end
