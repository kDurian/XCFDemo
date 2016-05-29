//
//  NSDate+KDExtension.h
//  XCFDemo
//
//  Created by Durian on 5/24/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (KDExtension)
+ (NSString *)timeInternalSinceTime:(NSString *)dateStr withDateFormat:(NSString *)dateFormat;
@end
