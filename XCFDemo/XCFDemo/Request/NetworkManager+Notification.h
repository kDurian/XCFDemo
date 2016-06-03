//
//  NetworkManager+Notification.h
//  XCFDemo
//
//  Created by Durian on 6/3/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "NetworkManager.h"

@interface NetworkManager (Notification)
+ (AFHTTPRequestOperation *)getNotificationWithSuccBlock:(RequestCallbackBlock)succBlock OrFailedBlock:(RequestCallbackBlock)failedBlock;
@end
