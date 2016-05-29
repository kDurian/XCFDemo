//
//  NetworkManager+HomePageAd1Request.m
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 1/27/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "NetworkManager+HomePageAd1Request.h"
#import "NetworkManager+Extension.h"
#import "NetworkCodeDef.h"

@implementation NetworkManager (HomePageAd1Request)

+ (AFHTTPRequestOperation *)getAd1ContentWithSuccBlock:(RequestCallbackBlock)succBlock withFailBlock:(RequestCallbackBlock)failBlock
{
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    requestDic[@"api_sign"] = @"d986e5e95fb01c1413be5f6e73c1da2e";
    requestDic[@"slot_name"]       = QUERY_AD1_SLOT_NAME;
    requestDic[@"height"]          = QUERY_AD_IAMGE_HEIGHT;
    requestDic[@"width"]           = QUERY_AD_IAMGE_WIDTH;
    requestDic[@"supported_types"] = QUERY_AD_SUPPORTED_TYPES;
    
    NSDictionary *paraDic = [NetworkManager appendBaseParamWith:requestDic];
    
    return [NetworkManager getRequestForService:PATH_AD_SHOW_JSON
                                   withParamDic:paraDic
                               withResponseName:@"HomePageAdResponse"
                                  withSuccBlock:succBlock
                                withFailedBlock:failBlock];
}

@end
