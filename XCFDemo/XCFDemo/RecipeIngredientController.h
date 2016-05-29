//
//  RecipeIngsControllerTableViewController.h
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 4/1/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Recipe.h"

@class RecipeIngredientController;

@protocol RecipeIngredientDelegate <UITextViewDelegate>

- (void)recipeIngredientDidEndEditing:(RecipeIngredientController *)viewController withContent:(RLMArray *)content;

@end

@interface RecipeIngredientController : UITableViewController

@property(nonatomic, weak) id<RecipeIngredientDelegate>  delegate;

@property(nonatomic, strong) RLMArray<RecipeIngredient *><RecipeIngredient> *recipeIngredients;

@end
