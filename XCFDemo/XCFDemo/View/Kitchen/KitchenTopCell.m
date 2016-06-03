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
- (void)awakeFromNib{
    _leftImageView.userInteractionEnabled = YES;
    _rightImageView.userInteractionEnabled = YES;
    _rightNotificationLabel.hidden = YES;
}

- (void)setContent:(HomePageContentModel *)content{
    _content = content;
    [self.leftImageView yy_setImageWithURL:[NSURL URLWithString:content.pop_recipe_picurl] options:YYWebImageOptionUseNSURLCache];
    self.leftTitleLabel.text = @"本周流行菜谱";
    self.rightTitleLabel.text = @"关注动态";
    
    if (self.number == 0) {
        self.rightNotificationLabel.hidden = YES;
    }else {
        self.rightNotificationLabel.text = [NSString stringWithFormat:@"%ld个消息", _number];
        self.rightNotificationLabel.hidden = NO;
    }

    NSString *urlStr = @"";
    if (_feed.kind == 1001) {
        urlStr = _feed.recipe.photo140;
    }else if (_feed.kind == 1005) {
        urlStr = _feed.dish.thumbnail_160;
    }
    [self.rightImageView yy_setImageWithURL:[NSURL URLWithString:urlStr] options:YYWebImageOptionUseNSURLCache];
}
@end
