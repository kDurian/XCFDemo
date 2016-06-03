//
//  NetworkManager+Notification.m
//  XCFDemo
//
//  Created by Durian on 6/3/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "NetworkManager+Notification.h"
#import "NetworkManager+Extension.h"

@implementation NetworkManager (Notification)
+ (AFHTTPRequestOperation *)getNotificationWithSuccBlock:(RequestCallbackBlock)succBlock OrFailedBlock:(RequestCallbackBlock)failedBlock{
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionary];
    requestDict[@"api_sign"] = @"50366e22d1168daa0123a3d39dde8357";
    requestDict[@"limit"] = @"1";
    requestDict[@"offset"] = @"0";
    NSDictionary *paramDict = [NetworkManager appendBaseParamWith:requestDict];
    [paramDict setValue:@"160" forKey:@"version"];
    
    return [NetworkManager getRequestForService:PATH_NOTIFICATION_COMMUNITY_BADGE
                                   withParamDic:paramDict
                               withResponseName:@"NotificationResponse"
                                  withSuccBlock:succBlock
                                withFailedBlock:failedBlock];
    
}
@end
