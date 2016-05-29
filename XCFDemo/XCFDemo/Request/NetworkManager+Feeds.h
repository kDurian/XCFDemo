//
//  NetworkManager+Feeds.h
//  XCFDemo
//
//  Created by Durian on 5/22/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "NetworkManager.h"

@interface NetworkManager (Feeds)
+ (AFHTTPRequestOperation *)getFeedsWithSuccBlock:(RequestCallbackBlock)succBlock OrFailedBlock:(RequestCallbackBlock)failedBlock;

@end
