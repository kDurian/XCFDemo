//
//  XCFRecipeTipsCell.m
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 3/19/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "XCFRecipeTipsCell.h"
#import "Recipe.h"

@implementation XCFRecipeTipsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setRecipe:(Recipe *)recipe
{
    self.recipeTipsLabel.text = recipe.tips;
}

@end
