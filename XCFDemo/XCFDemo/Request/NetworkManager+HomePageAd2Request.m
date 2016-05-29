//
//  NetworkManager+HomePageAd2Request.m
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 1/27/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "NetworkManager+HomePageAd2Request.h"
#import "NetworkManager+Extension.h"
#import "NetworkCodeDef.h"

@implementation NetworkManager (HomePageAd2Request)

+ (AFHTTPRequestOperation *)getAd2ContentWithSuccBlock:(RequestCallbackBlock)succBlock withFailBlock:(RequestCallbackBlock)failBlock
{
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    requestDic[@"api_sign"] = @"f68cd09de4df96ce8b468960f2ad14ca";
    requestDic[@"slot_name"] = @"homepage_banner_ad2";
    requestDic[@"height"] = @"1920";
    requestDic[@"width"] = @"1080";
    requestDic[@"supported_types"] = @"1";
    
    NSDictionary *paraDic = [NetworkManager appendBaseParamWith:requestDic];
    
    return [NetworkManager getRequestForService:PATH_AD_SHOW_JSON
                                   withParamDic:paraDic
                               withResponseName:@"HomePageAdResponse"
                                  withSuccBlock:succBlock
                                withFailedBlock:failBlock];
}

@end
