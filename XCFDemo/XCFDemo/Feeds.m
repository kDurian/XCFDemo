//
//  Feeds.m
//  XCFDemo
//
//  Created by Durian on 5/22/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "Feeds.h"

@implementation LatestComment
@end

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
    return @{ @"users" : [FeedAuthorOrUser class] };
}
@end

@implementation DishPic
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{
             @"pic_280" : @"280",
             @"pic_600" : @"600"
             };
}
@end

@implementation FeedAuthorOrUser
@end

@implementation FeedRecipe
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{ @"instruction" : [RecipeStep class],
              @"ingredient" : [FeedIngredient class]
            };
}
@end

@implementation FeedDish
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{ @"events" : [DishEvent class],
              @"latest_comments" : [LatestComment class],
              @"extra_pics" : [DishPic class]
              };
}
@end

@implementation Feed
@end

@implementation FeedsContent
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{ @"feeds" : [Feed class] };
}
@end

@implementation FeedsResponse
@end
