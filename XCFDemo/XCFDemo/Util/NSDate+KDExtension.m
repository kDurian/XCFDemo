//
//  NSDate+KDExtension.m
//  XCFDemo
//
//  Created by Durian on 5/24/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "NSDate+KDExtension.h"

@implementation NSDate (KDExtension)
+ (NSString *)timeInternalSinceTime:(NSString *)dateStr withDateFormat:(NSString *)dateFormat
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = dateFormat;
    NSDate *createDate = [formatter dateFromString:dateStr];
    NSTimeInterval createTime = [createDate timeIntervalSince1970];
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval intervalTime = currentTime - createTime;
    NSInteger hour = 60 * 60;
    NSInteger hours = intervalTime / hour;
    NSInteger days = 0;
    if (hours < 24) {
        return [NSString stringWithFormat:@"%ld小时前", hours];
    }else {
        days = hours / 24;
        return [NSString stringWithFormat:@"%ld天前", days];
    }
}
@end
