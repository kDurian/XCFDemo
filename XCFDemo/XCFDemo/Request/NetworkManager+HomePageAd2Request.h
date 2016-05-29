//
//  NetworkManager+HomePageAd2Request.h
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 1/27/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "NetworkManager.h"

@interface NetworkManager (HomePageAd2Request)

+ (AFHTTPRequestOperation *)getAd2ContentWithSuccBlock:(RequestCallbackBlock)succBlock withFailBlock:(RequestCallbackBlock)failBlock;


@end
