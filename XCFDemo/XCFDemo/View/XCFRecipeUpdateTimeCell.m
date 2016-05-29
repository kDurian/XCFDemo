//
//  XCFRecipeUpdateTimeCell.m
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 3/19/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "XCFRecipeUpdateTimeCell.h"
#import "Recipe.h"

@implementation XCFRecipeUpdateTimeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setRecipe:(Recipe *)recipe
{
    self.timeLabel.text = recipe.updateTime;
}

@end
