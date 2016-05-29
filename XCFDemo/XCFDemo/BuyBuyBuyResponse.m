//
//  BuyBuyBuyResponse.m
//  XCFDemo
//
//  Created by Durian on 5/23/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "BuyBuyBuyResponse.h"

@implementation CommodityGoods
@end

@implementation ReviewPhoto
@end

@implementation ReviewCommodity
@end

@implementation ReviewDiggUsers
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass
{
    return @{@"users" : [ReviewAuthorOrUser class]};
}
@end

@implementation ReviewAuthorOrUser
@end

@implementation ReviewLastestComment
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass
{
    return @{@"at_users" : [ReviewAuthorOrUser class]};
}
@end

@implementation BuyBuyBuyReview
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass
{
    return @{ @"latest_comments" : [ReviewLastestComment class],
              @"photos"          : [ReviewPhoto class] };
}
@end

@implementation BuyBuyBuyCursor
@end

@implementation BuyBuyBuyContent
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass
{
    return @{ @"reviews" : [BuyBuyBuyReview class] };
}
@end

@implementation BuyBuyBuyResponse

@end
