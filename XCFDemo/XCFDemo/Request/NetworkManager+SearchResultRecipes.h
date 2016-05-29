//
//  NetworkManager+SearchResultRecipes.h
//  XCFDemo
//
//  Created by Durian on 5/3/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "NetworkManager.h"

@interface NetworkManager (SearchResultRecipes)

+ (AFHTTPRequestOperation *)getUnversalSearchWithSuccBlock:(RequestCallbackBlock)succBlock OrFailedBlock:(RequestCallbackBlock)failedBlock;

@end
