//
//  RecipeSectionHeaderCell.m
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 2/29/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "RecipeSectionHeaderCell.h"

@implementation RecipeSectionHeaderCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)recipeSectionHeaderCellBindRecipeItem:(RecipeIssue *)item
{
    self.titleLable.text = item.title;
}

@end
