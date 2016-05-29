//
//  XCFCoverCell.m
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 3/19/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "XCFRecipeCoverCell.h"
#import "Recipe.h"

@implementation XCFRecipeCoverCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRecipe:(Recipe *)recipe
{
    NSData *imageData = recipe.coverImageData;
    if (imageData.length > 0) {
        self.coverImageView.image = [UIImage imageWithData:imageData];
    }
}


- (void)prepareForReuse
{
    [super prepareForReuse];
    self.coverImageView.image = [UIImage imageNamed:@"createRecipeCamera"];
}

@end
