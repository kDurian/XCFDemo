//
//  Template2Cell.m
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 1/14/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "KitchenRecipeCollectionsCell.h"
#import "YYWebImage.h"

@implementation KitchenRecipeCollectionsCell
- (void)setItem:(RecipeItem *)item{
    _item = item;
    self.recipeImageView.yy_imageURL = [NSURL URLWithString:item.contents.image.url];
    self.recipeFirstLabel.text = item.contents.title_1st;
    self.recipeSecondLabel.text = item.contents.title_2nd;
}
@end
