//
//  NetworkManager+RecipesFilters.h
//  XCFDemo
//
//  Created by Durian on 5/18/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "NetworkManager.h"

@interface NetworkManager (RecipesFilters)

+ (AFHTTPRequestOperation *)getRecipesFiltersWithSuccBlock:(RequestCallbackBlock)succBlock OrFailedBlock:(RequestCallbackBlock)failedBlock;

@end
