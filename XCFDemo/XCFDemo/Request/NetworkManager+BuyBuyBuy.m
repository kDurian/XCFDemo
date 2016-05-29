//
//  NetworkManager+BuyBuyBuy.m
//  XCFDemo
//
//  Created by Durian on 5/24/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "NetworkManager+BuyBuyBuy.h"
#import "NetworkManager+Extension.h"


@implementation NetworkManager (BuyBuyBuy)
+ (AFHTTPRequestOperation *)getReviewsWithSuccBlock:(RequestCallbackBlock)succBlock OrFailedBlock:(RequestCallbackBlock)failedBlock
{
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionary];
    requestDict[@"api_sign"] = @"c3793a8e0d693d5f26b6bd09060cdb4e";
    requestDict[@"cursor"] = @"";
    NSDictionary *paramDict = [NetworkManager appendBaseParamWith:requestDict];
    [paramDict setValue:@"160" forKey:@"version"];
    
    return [NetworkManager getRequestForService:PATH_EXPLORE_JUSTBUY
                                   withParamDic:paramDict
                               withResponseName:@"BuyBuyBuyResponse"
                                  withSuccBlock:succBlock
                                withFailedBlock:failedBlock];
}
@end
