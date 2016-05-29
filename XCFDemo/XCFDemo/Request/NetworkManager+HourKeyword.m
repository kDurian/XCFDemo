//
//  NetworkManager+HourKeyword.m
//  XCFDemo
//
//  Created by Durian on 5/3/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "NetworkManager+HourKeyword.h"
#import "NetworkManager+Extension.h"

@implementation NetworkManager (HourKeyword)

+ (AFHTTPRequestOperation *)getHourKeywordsWithSuccBlock:(RequestCallbackBlock)succBlock OrFailedBlock:(RequestCallbackBlock)failedBlock
{
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionary];
    
    requestDict[@"api_sign"] = @"3ca077e34255cac0d5c30f2e9ec541f7";
    
    NSDictionary *paramDict = [NetworkManager appendBaseParamWith:requestDict];
    [paramDict setValue:@"159" forKey:@"version"];
    
    return [NetworkManager getRequestForService:PATH_SEARCH_KEYWORD_HOUR
                                   withParamDic:paramDict
                               withResponseName:@"KeywordResponse"
                                  withSuccBlock:succBlock
                                withFailedBlock:failedBlock];

}

@end
