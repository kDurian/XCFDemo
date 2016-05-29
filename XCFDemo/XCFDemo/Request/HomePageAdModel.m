//
//  HomePageAdModel.m
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 1/27/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "HomePageAdModel.h"


@implementation AdImageModel

@end

@implementation AdInfoModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"picurl" : @"pic_url",
             @"displayTime" : @"display_time",
             @"displayInterval" : @"display_interval"
             };
}

@end


@implementation AdContent

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"startTime" : @"start_time",
             @"adType" : @"ad_type",
             @"endTime" : @"end_time",
             @"adInfo" : @"ad_info"
             };
}

@end

@implementation HomePageAdResponse

@end
