//
//  RecipeEditedPageCellManager.h
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 3/19/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Recipe.h"

static NSString * const kRecipeDescCellID = @"kRecipeDescCellID";
static NSString * const kRecipeIngsCellID = @"kRecipeIngsCellID";
static NSString * const kRecipeTextStepCellID = @"kRecipeTextStepCellID";
static NSString * const kRecipeTipsCellID = @"kRecipeTipsCellID";
static NSString * const kRecipeStepCellID = @"kRecipeStepCellID";

static NSString * const kRecipeCoverImageKey = @"recipeCoverImage";
static NSString * const kRecipeNameKey = @"recipeName";
static NSString * const kRecipeDescKey = @"recipeDesc";
static NSString * const kRecipeIngredientsKey = @"recipeIngredients";
static NSString * const kRecipeIngredientNameKey = @"ingredientName";
static NSString * const kRecipeIngredientAmountKey = @"ingredientAmount";
static NSString * const kRecipePracticeStepsKey = @"recipePracticeSteps";
static NSString * const kRecipePracticePicStepKey = @"pic";
static NSString * const kRecipePracticeTextStepKey = @"text";
static NSString * const kRecipeTipsKey = @"recipeTips";
static NSString * const kRecipeUpdateTimeKey = @"recipeUpdateTime";


@class Recipe;

@interface RecipeEditedPageCellManager : NSObject

+ (UITableViewCell *)cellWithTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath withRecipe:(Recipe *)recipe;

//+ (CGFloat)heightOFCellAtIndexPath:(NSIndexPath *)indexPath withDictionary:(NSMutableDictionary *)content;

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withRecipe:(Recipe *)recipe;



@end
