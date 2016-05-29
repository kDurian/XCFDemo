//
//  RecipeDraftCell.m
//  Demo_TestRecipeEdited
//
//  Created by Durian on 4/20/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "RecipeDraftCell.h"


@implementation RecipeDraftCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRecipe:(Recipe *)recipe
{
    self.coverImageView.image = [UIImage imageWithData:recipe.coverImageData];
    self.titleLabel.text = recipe.name;
    
    NSString *ingredientNames = @"";
    for (NSUInteger index = 0; index < recipe.ingredients.count; ++index) {
        RecipeIngredient *ingredient = recipe.ingredients[index];
        [ingredientNames stringByAppendingString:[NSString stringWithFormat:@"%@ ", ingredient.ingredientName]];
    }
    
    self.ingredientLabel.text = ingredientNames;
}

@end
