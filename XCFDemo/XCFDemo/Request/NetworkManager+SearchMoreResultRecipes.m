//
//  NetworkManager+SearchMoreResultRecipes.m
//  XCFDemo
//
//  Created by Durian on 5/16/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "NetworkManager+SearchMoreResultRecipes.h"
#import "NetworkManager+Extension.h"

@implementation NetworkManager (SearchMoreResultRecipes)

+ (AFHTTPRequestOperation *)getMoreUnversalSearchWithSuccBlock:(RequestCallbackBlock)succBlock OrFailedBlock:(RequestCallbackBlock)failedBlock
{
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionary];
    
    requestDict[@"api_sign"] = @"0a87f82107eae3fd44d792eaa1d5c8fb";
    requestDict[@"recipe_mode"] = @"simple";
    requestDict[@"q"] = @"烘焙";
    requestDict[@"via"] = @"recipe_suggestion";
    requestDict[@"offset"] = @"20";
    requestDict[@"limit"] = @"20";
    
    NSDictionary *paramDict = [NetworkManager appendBaseParamWith:requestDict];
    [paramDict setValue:@"160" forKey:@"version"];
    
    
    return [NetworkManager getRequestForService:PATH_SEARCH_UNIVERSAL_SEARCH
                                   withParamDic:paramDict
                               withResponseName:@"SearchResultResponse"
                                  withSuccBlock:succBlock
                                withFailedBlock:failedBlock];
}

@end
