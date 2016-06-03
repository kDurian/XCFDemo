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
    NSTimeInterval intervalOfSeconds = currentTime - createTime;
    
    NSInteger aHour = 60 * 60;
    NSInteger aMinute = 60;
    
    NSInteger days = 0;
    NSInteger hours = 0;
    NSInteger minutes = 0;
    
    hours = intervalOfSeconds / aHour;
    if (hours == 0) {
        minutes = intervalOfSeconds / aMinute;
        if (minutes == 0) {
            return @"刚刚";
        }else {
            return [NSString stringWithFormat:@"%ld分钟前", minutes];
        }
    }else if (hours < 24) {
        return [NSString stringWithFormat:@"%ld小时前", hours];
    }else {
        days = hours / 24;
        if (days < 7) {
            return [NSString stringWithFormat:@"%ld天前", days];
        }else {
            if (dateStr.length > 10) {
                return [dateStr substringWithRange:NSMakeRange(0, 10)];
            }else {
                return @"";
            }
        }
    }
}
@end
