//
//  XCFRecipeNameCell.m
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 3/19/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "XCFRecipeNameCell.h"

#import "Recipe.h"

@implementation XCFRecipeNameCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setRecipe:(Recipe *)recipe
{
    self.recipeNameLabel.text = recipe.name;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.recipeNameLabel.text = nil;
}

@end
