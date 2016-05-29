 //
//  NetworkManager+HomePageRequest.m
//  Demo_GotoKitchen
//
//  Created by 阳小东 on 16/1/26.
//  Copyright © 2016年 durian. All rights reserved.
//

#import "NetworkManager+HomePageRequest.h"
#import "NetworkManager+Extension.h"

@implementation NetworkManager (HomePageRequest)

+ (AFHTTPRequestOperation *)getHomePageInfoWithSuccBlock:(RequestCallbackBlock)succBlock withFailedBlock:(RequestCallbackBlock)failedBlock
{
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    requestDic[@"timezone"] = QUERY_TIMEZONE;
    requestDic[@"api_sign"] = @"7765712ebea94c4f9643db237ffddb14";
    
    NSDictionary *paramDic = [NetworkManager appendBaseParamWith:requestDic];
    
    return [NetworkManager getRequestForService:PATH_INIT_PAGE_JSON
                                   withParamDic:paramDic
                               withResponseName:@"HomePageResponse"
                                  withSuccBlock:succBlock
                                withFailedBlock:failedBlock];
}

@end
