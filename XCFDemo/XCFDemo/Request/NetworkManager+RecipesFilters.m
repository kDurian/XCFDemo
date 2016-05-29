//
//  NetworkManager+RecipesFilters.m
//  XCFDemo
//
//  Created by Durian on 5/18/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "NetworkManager+RecipesFilters.h"
#import "NetworkManager+Extension.h"

@implementation NetworkManager (RecipesFilters)

+ (AFHTTPRequestOperation *)getRecipesFiltersWithSuccBlock:(RequestCallbackBlock)succBlock OrFailedBlock:(RequestCallbackBlock)failedBlock
{
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionary];
    
    requestDict[@"api_sign"] = @"571cf4ec522dda7b4d1d598266080384";
    requestDict[@"q"] = @"烘焙";
    NSDictionary *paramDict = [NetworkManager appendBaseParamWith:requestDict];
    [paramDict setValue:@"160" forKey:@"version"];
    
    
    return [NetworkManager getRequestForService:PATH_SEARCH_RECIPES_FILTERS
                                   withParamDic:paramDict
                               withResponseName:@"RecipesFiltersResponse"
                                  withSuccBlock:succBlock
                                withFailedBlock:failedBlock];
}

@end
