//
//  RecipesFiltersModel.m
//  XCFDemo
//
//  Created by Durian on 5/18/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "RecipesFiltersModel.h"

@implementation FiltersDishes
@end

@implementation FiltersScore
@end

@implementation RecipesFiltersContent
- (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"n_dishes_hits" : @"n_dishes.hits",
             @"n_dishes_min" : @"n_dished.min",
             @"score_hits" : @"score.hits",
             @"score_min" : @"score.min"};
}
@end


@implementation RecipesFiltersResponse

@end
