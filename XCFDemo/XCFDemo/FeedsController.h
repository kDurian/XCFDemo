//
//  FeedsController.h
//  XCFDemo
//
//  Created by Durian on 5/22/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageNotification.h"

@interface FeedsController : UITableViewController
@property(nonatomic, strong) NotificationContent *content;
@end
