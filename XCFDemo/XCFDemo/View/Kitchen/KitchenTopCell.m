//
//  FirstRowTableViewCell.m
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 1/11/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "KitchenTopCell.h"
#import "YYWebImage.h"

@implementation KitchenTopCell
- (void)setContent:(HomePageContentModel *)content{
    
    _content = content;
    [self.leftImageView yy_setImageWithURL:[NSURL URLWithString:content.pop_recipe_picurl] options:YYWebImageOptionUseNSURLCache];
    self.leftTitleLabel.text = @"本周流行菜谱";
    [self.rightImageView yy_setImageWithURL:nil options:YYWebImageOptionUseNSURLCache];
    self.rightTitleLabel.text = @"关注动态";
}
@end
