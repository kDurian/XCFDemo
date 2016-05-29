//
//  Feeds.m
//  XCFDemo
//
//  Created by Durian on 5/22/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "Feeds.h"

@implementation RecipeStep
@end

@implementation FeedIngredient
@end

@implementation RecipeStats
@end

@implementation DishEvent
@end

@implementation DiggUsers
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{ @"users" : @"FeedAuthorOrUser" };
}
@end

@implementation DishPic
@end

@implementation FeedAuthorOrUser
@end

@implementation FeedRecipe
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{ @"instruction" : @"RecipeStep",
              @"ingredient" : @"FeedIngredient" };
}
@end

@implementation FeedDish
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{ @"events" : @"DishEvent",
              @"lastest_comments" : @"LastestComment",
              @"extra_pics" : @"DishPic"
              };
}
@end

@implementation Feed
@end

@implementation FeedsContent
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{ @"feeds" : @"Feed" };
}
@end

@implementation FeedsResponse

@end
