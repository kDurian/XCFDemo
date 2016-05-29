//
//  NetworkManager+SearchResultRecipes.m
//  XCFDemo
//
//  Created by Durian on 5/3/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "NetworkManager+SearchResultRecipes.h"
#import "NetworkManager+Extension.h"

@implementation NetworkManager (SearchResultRecipes)

+ (AFHTTPRequestOperation *)getUnversalSearchWithSuccBlock:(RequestCallbackBlock)succBlock OrFailedBlock:(RequestCallbackBlock)failedBlock
{
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionary];
    
    requestDict[@"api_sign"] = @"5af32d7836997a7b6ecc12f73a8ae5de";
    requestDict[@"recipe_mode"] = @"simple";
    requestDict[@"q"] = @"烘焙";
    requestDict[@"via"] = @"recipe_suggestion";
    requestDict[@"offset"] = @"0";
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
