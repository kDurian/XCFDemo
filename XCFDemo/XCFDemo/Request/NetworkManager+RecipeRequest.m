//
//  NetworkManager+RecipeRequest.m
//  Demo_GotoKitchen
//
//  Created by 阳小东 on 16/1/26.
//  Copyright © 2016年 durian. All rights reserved.
//

#import "NetworkManager+RecipeRequest.h"
#import "NetworkManager+Extension.h"
#import "NetworkCodeDef.h"

@implementation NetworkManager (RecipeRequest)

+ (AFHTTPRequestOperation *)getRecipeInfoWithSuccBlock:(RequestCallbackBlock)succBlock andFailBlock:(RequestCallbackBlock)failBlock atDate:(NSString *)cursorDate
{
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    requestDic[@"api_sign"] = @"7484c285f61e2d80694af1c4b6a4b8a0";
    requestDic[@"timezone"] = QUERY_TIMEZONE;
    requestDic[@"size"] = @"1";
    requestDic[@"version"] = QUERY_APP_VERSION;

    if (cursorDate) {
        requestDic[@"cursor"] = cursorDate;
        [requestDic removeObjectForKey:@"api_sign"];
        [requestDic setObject:@"1cdf2d9745da12bea803d82f0f90a219" forKey:@"api_sign"];
    }
    
    NSDictionary *paraDic = [NetworkManager appendBaseParamWith:requestDic];
    
    return [NetworkManager getRequestForService:PATH_ISSUES_LIST_JSON
                                   withParamDic:paraDic
                               withResponseName:@"HomePageRecipeResponse"
                                  withSuccBlock:succBlock
                                withFailedBlock:failBlock];
    
}

@end
