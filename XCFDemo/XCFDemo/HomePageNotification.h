//
//  HomePageNotification.h
//  XCFDemo
//
//  Created by Durian on 6/3/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseEntity.h"

@interface NotificationContent : NSObject
@property(nonatomic, assign) NSInteger number;
@property(nonatomic, copy) NSString *avatar;
@end

@interface NotificationResponse : BaseEntity
@property(nonatomic, strong) NotificationContent *content;
@end
