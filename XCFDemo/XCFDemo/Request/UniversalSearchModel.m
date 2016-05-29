//
//  UniversalSearchModel.m
//  XCFDemo
//
//  Created by Durian on 5/3/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "UniversalSearchModel.h"


@implementation FirstRecipe
@end



@implementation MainPic
+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"pic240" : @"240"};
}
@end


@implementation Ingredient
@end


@implementation Author
@end


@implementation Stats
@end


@implementation ItemObject
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"ingredient" : [Ingredient class]};
}
@end


@implementation TrackParam
@end


@implementation Item
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
    return @{@"itemObject" : @"object"};
}
@end


@implementation ItemContent

//+ (NSDictionary *)modelContainerPropertyGenericClass
//{
//    return @{@"contentArray" : [Item class]};
//}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    NSString *type = dic[@"type"];
    if ([type isEqualToString:@"collection"]) {
        _contentArray = [NSArray yy_modelArrayWithClass:[ItemContent class] json:dic[@"content"]];
    }else if([type isEqualToString:@"item"]) {
        _contentInfo = [Item yy_modelWithDictionary:dic[@"content"]];
    }
    return YES;
}
@end


@implementation UniversalSearchResult
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"content" : [ItemContent class]};
}
@end


@implementation SearchResultResponse
@end
