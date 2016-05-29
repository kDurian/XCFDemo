//
//  NetworkManager+SearchMoreResultRecipes.h
//  XCFDemo
//
//  Created by Durian on 5/16/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "NetworkManager.h"

@interface NetworkManager (SearchMoreResultRecipes)

+ (AFHTTPRequestOperation *)getMoreUnversalSearchWithSuccBlock:(RequestCallbackBlock)succBlock OrFailedBlock:(RequestCallbackBlock)failedBlock;


@end
