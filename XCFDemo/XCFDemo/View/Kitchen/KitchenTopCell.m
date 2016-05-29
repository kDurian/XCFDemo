//
//  FirstRowTableViewCell.m
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 1/11/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "KitchenTopCell.h"
#import "YYWebImage.h"

static NSString * const kHomePageTopCellLeftLabelName = @"本周流行菜谱";

@implementation KitchenTopCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cellBindHomePageNavContent:(HomePageContentModel *)content
{
    if (content == nil) {
        return;
    }else
    {
        [self.leftButton yy_setImageWithURL:[NSURL URLWithString:content.pop_recipe_picurl] forState:UIControlStateNormal options:YYWebImageOptionUseNSURLCache];
        self.leftTitleLabel.text = @"本周流行菜谱";
        [self.rightButton yy_setImageWithURL:nil forState:UIControlStateNormal options:YYWebImageOptionUseNSURLCache];
        self.rightTitleLabel.text = @"关注动态";
    }
}

@end
