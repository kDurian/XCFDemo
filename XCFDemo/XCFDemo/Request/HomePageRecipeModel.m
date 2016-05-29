//
//  KitchenRecipeModel.m
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 1/27/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "HomePageRecipeModel.h"

@implementation RecipeCursor

@end

@implementation RecipeItemImage

@end


@implementation RecipeItemAuthor

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"photoURL" : @"photo",
             @"authorID" : @"id"
             };
}

@end

@implementation RecipeItemContents

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"videoURL" : @"video_url",
             @"recipeID" : @"recipe_id"
             };
}

@end


@implementation RecipeItem

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"publishTime"  : @"publish_time",
             @"cellTemplate" : @"template",
             @"itemID"       : @"id",
             @"columnName"   : @"column_name"
             };
}

@end

@implementation RecipeIssue

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"itemsCount"  : @"items_count",
             @"issueID"     : @"issue_id",
             @"publishDate" : @"publish_date"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{
             @"items" : [RecipeItem class]
             };
}


@end


@implementation RecipeInfo
+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{ @"issues" : [RecipeIssue class] };
}
@end

@implementation HomePageRecipeResponse
@end
