//
//  RecipesFiltersModel.h
//  XCFDemo
//
//  Created by Durian on 5/18/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"
#import <UIKit/UIKit.h>
#import "BaseEntity.h"

@interface FiltersDishes : NSObject
@property(nonatomic, assign) NSInteger hits;
@property(nonatomic, assign) NSInteger min;
@end

@interface FiltersScore : NSObject
@property(nonatomic, assign) NSInteger hits;
@property(nonatomic, assign) CGFloat min;
@end

@interface RecipesFiltersContent : NSObject<YYModel>
@property(nonatomic, strong) FiltersDishes *n_dishes;
@property(nonatomic, strong) FiltersScore *score;
@end

@interface RecipesFiltersResponse : BaseEntity

@property(nonatomic, strong) RecipesFiltersContent *content;

@end
