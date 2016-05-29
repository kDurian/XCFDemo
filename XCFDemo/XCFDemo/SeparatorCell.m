//
//  SeparatorCell.m
//  Demo_TestRecipeEdited
//
//  Created by Durian on 4/20/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "SeparatorCell.h"

@implementation SeparatorCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)cellHeight
{
    return 10.0f;
}

@end
