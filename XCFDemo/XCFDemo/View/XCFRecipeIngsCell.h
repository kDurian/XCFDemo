//
//  XCFRecipeIngsCell.h
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 3/19/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RecipeIngredient;

@interface XCFRecipeIngsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *ingredientNameLable;

@property (weak, nonatomic) IBOutlet UITextField *ingredientAmountLabel;

@property(nonatomic, strong) RecipeIngredient *recipeIngredient;

@end
