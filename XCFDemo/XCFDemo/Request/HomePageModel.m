//
//  HomePageModel.m
//  Demo_GotoKitchen
//
//  Created by 阳小东 on 16/1/26.
//  Copyright © 2016年 durian. All rights reserved.
//

#import "HomePageModel.h"

@implementation HomePageDishModel

@end

@implementation HomePageEvent

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"dishes" : [HomePageDishModel class]};
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"dishes" : @"dishes.dishes",
             @"eventID" : @"id"};
}

@end

@implementation HomePagePopEventsModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"events" : [HomePageEvent class]};
}

@end

@implementation HomePageNavsModel

@end

@implementation HomePageContentModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"navs" : [HomePageNavsModel class]};
}

@end

@implementation HomePageResponse

@end
