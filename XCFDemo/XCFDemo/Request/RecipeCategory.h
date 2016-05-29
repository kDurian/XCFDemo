//
//  RecipeCategorg.h
//  XCFDemo
//
//  Created by Durian on 5/3/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "BaseEntity.h"

@interface Exploration : NSObject

@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *picurl;

@end


@interface RecipeCategoryContent : NSObject

@property(nonatomic, assign) NSInteger count;
@property(nonatomic, strong) NSArray *explorations;

@end


@interface RecipeCategoryResponse : BaseEntity

@property(nonatomic, strong) RecipeCategoryContent *content;

@end
