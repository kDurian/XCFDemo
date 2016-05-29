//
//  Template1Cell.m
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 1/14/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "KitchenArticleOfFoodCell.h"
#import "YYWebImage.h"


@implementation KitchenArticleOfFoodCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)articleOfFoodCellBindRecipeItem:(RecipeItem *)item
{
    self.recipeImageView.yy_imageURL = [NSURL URLWithString:item.contents.image.url];
    self.titleLabel.text = item.contents.title;
    self.summaryLabel.text =  item.contents.desc;
}

@end
