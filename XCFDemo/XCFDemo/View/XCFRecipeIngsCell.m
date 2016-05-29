//
//  XCFRecipeIngsCell.m
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 3/19/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "XCFRecipeIngsCell.h"
#import "Recipe.h"

@implementation XCFRecipeIngsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setRecipeIngredient:(RecipeIngredient *)recipeIngredient
{
    self.ingredientNameLable.text = recipeIngredient.ingredientName;
    self.ingredientAmountLabel.text = recipeIngredient.ingredientAmount;
}

@end
