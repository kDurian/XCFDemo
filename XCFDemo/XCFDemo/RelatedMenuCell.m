//
//  RelatedMenuCell.m
//  XCFDemo
//
//  Created by Durian on 5/6/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "RelatedMenuCell.h"
#import "UIImageView+WebCache.h"

@implementation RelatedMenuCell

- (void)prepareForReuse
{
    _relatedMenuItem = nil;
    _coverImageView.image = nil;
    _nameLabel.text = nil;
    _recipeNumAndAuthorNameLabel.text = nil;
}

- (void)setRelatedMenuItem:(Item *)relatedMenuItem
{
    _relatedMenuItem = relatedMenuItem;
    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:relatedMenuItem.itemObject.first_recipe.thumb]];
    _nameLabel.text = relatedMenuItem.itemObject.name;
    _recipeNumAndAuthorNameLabel.text = [NSString stringWithFormat:@"%ld个菜谱 • %@", relatedMenuItem.itemObject.nrecipes, relatedMenuItem.itemObject.author.name];
}

@end
