//
//  NetworkManager+RecipeCategory.m
//  XCFDemo
//
//  Created by Durian on 5/3/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "NetworkManager+RecipeCategory.h"
#import "NetworkManager+Extension.h"

@implementation NetworkManager (RecipeCategory)

+ (AFHTTPRequestOperation *)getExplorationsWithSuccBlock:(RequestCallbackBlock)succBlock OrFailedBlock:(RequestCallbackBlock)failedBlock
{
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionary];
    
    requestDict[@"api_sign"] = @"e658591a7f3697c5836c92cd14fb4dbb";
    requestDict[@"q"] = @"烘焙";
    
    NSDictionary *paramDict = [NetworkManager appendBaseParamWith:requestDict];
    [paramDict setValue:@"159" forKey:@"version"];

    return [NetworkManager getRequestForService:PATH_CATEGORIES_EXPLORATIONS
                                   withParamDic:paramDict
                               withResponseName:@"RecipeCategoryResponse"
                                  withSuccBlock:succBlock
                                withFailedBlock:failedBlock];
}

@end
