//
//  XCFRecipeDescCell.m
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 3/19/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "XCFRecipeDescCell.h"
#import "Recipe.h"

@implementation XCFRecipeDescCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setRecipe:(Recipe *)recipe
{
    self.recipeDescLabel.text = recipe.desc;
}
@end
