//
//  KitchenRecipeModel.h
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 1/27/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseNetwork/BaseEntity.h"

@interface RecipeCursor : NSObject

@property(nonatomic, copy) NSString *has_next;
@property(nonatomic, copy) NSString *has_prev;
@property(nonatomic, copy) NSString *next;
@property(nonatomic, copy) NSString *prev;

@end

@interface RecipeItemAuthor : NSObject

@property(nonatomic, copy) NSString *url;
@property(nonatomic, copy) NSString *photoURL;
@property(nonatomic, copy) NSString *authorID;
@property(nonatomic, copy) NSString *name;

@end

@interface RecipeItemImage : NSObject

@property(nonatomic, copy) NSString *url;
@property(nonatomic, assign) NSInteger width;
@property(nonatomic, assign) NSInteger height;

@end

@interface RecipeItemContents : NSObject

@property(nonatomic, copy) NSString *videoURL;
@property(nonatomic, strong) RecipeItemAuthor *author;
@property(nonatomic, strong) RecipeItemImage *image;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, assign) NSInteger n_cooked;
@property(nonatomic, assign) NSInteger n_dishes;
@property(nonatomic, assign) NSString *score;
@property(nonatomic, copy) NSString *recipeID;
@property(nonatomic, copy) NSString *desc;
@property(nonatomic, copy) NSString *title_1st;
@property(nonatomic, copy) NSString *title_2nd;
@property(nonatomic, copy) NSString *whisper;

@end

@interface RecipeItem : NSObject

@property(nonatomic, copy) NSString *publishTime;
@property(nonatomic, copy) NSString *url;
@property(nonatomic, assign) NSInteger cellTemplate;
@property(nonatomic, assign) NSString *itemID;
@property(nonatomic, copy) NSString *columnName;
@property(nonatomic, strong) RecipeItemContents *contents;


@end

@interface RecipeIssue : NSObject

@property(nonatomic, assign) NSInteger itemsCount;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, strong) NSArray *items;
@property(nonatomic, assign) NSInteger issueID;
@property(nonatomic, copy) NSString *publishDate;

@end

@interface RecipeInfo : NSObject

@property(nonatomic, assign) NSInteger count;
@property(nonatomic, strong) NSArray *issues;
@property(nonatomic, strong) RecipeCursor *cursor;

@end

@interface HomePageRecipeResponse : BaseEntity

@property(nonatomic, strong) RecipeInfo *content;

@end
