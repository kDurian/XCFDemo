//
//  TestTableViewController.h
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 3/30/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Recipe;

typedef NS_ENUM(NSInteger, RecipeManageStyle)
{
    RecipeManageStyleSave,
    RecipeManageStyleRelease,
    RecipeManageStyleDelete
};

typedef NS_ENUM(NSInteger, EmptyRecipe)
{
    EmptyRecipeCoverImage,
    EmptyRecipeIngredient,
    EmptyRecipePracticeStep,
    EmptyRecipePracticeTextStep
};

@interface RecipeEditedController : UITableViewController

@property(nonatomic, strong) NSString *recipeName;

@property(nonatomic, strong) Recipe *currentRecipe;

@property(nonatomic, assign) NSInteger currentRecipeIndex;

@end
