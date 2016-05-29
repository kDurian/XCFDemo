//
//  XFCRecipeTextStepCell.m
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 3/19/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "XCFRecipeTextStepCell.h"

@implementation XCFRecipeTextStepCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cellBindText:(NSString *)text
{
    self.recipeTextStepLabel.text = text;
}

@end
