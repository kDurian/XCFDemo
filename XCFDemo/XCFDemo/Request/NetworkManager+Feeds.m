//
//  NetworkManager+Feeds.m
//  XCFDemo
//
//  Created by Durian on 5/22/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "NetworkManager+Feeds.h"
#import "NetworkManager+Extension.h"

@implementation NetworkManager (Feeds)
+ (AFHTTPRequestOperation *)getFeedsWithSuccBlock:(RequestCallbackBlock)succBlock OrFailedBlock:(RequestCallbackBlock)failedBlock
{
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionary];
    requestDict[@"api_sign"] = @"ef5b25a270fa75e36d486e66a4cf7399";
    requestDict[@"limit"] = @"20";
    requestDict[@"offset"] = @"0";
    NSDictionary *paramDict = [NetworkManager appendBaseParamWith:requestDict];
    [paramDict setValue:@"160" forKey:@"version"];
    
    return [NetworkManager getRequestForService:PATH_ACCOUNT_FEEDS
                                   withParamDic:paramDict
                               withResponseName:@"FeedsResponse"
                                  withSuccBlock:succBlock
                                withFailedBlock:failedBlock];
}
@end
