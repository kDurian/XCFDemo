//
//  NetworkManager+BuyBuyBuy.h
//  XCFDemo
//
//  Created by Durian on 5/24/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "NetworkManager.h"

@interface NetworkManager (BuyBuyBuy)
+ (AFHTTPRequestOperation *)getReviewsWithSuccBlock:(RequestCallbackBlock)succBlock OrFailedBlock:(RequestCallbackBlock)failedBlock;
@end
