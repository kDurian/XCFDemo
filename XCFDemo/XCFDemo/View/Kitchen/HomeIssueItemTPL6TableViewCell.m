//
//  HomeIssueItemTPL1TableViewCell.m
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 3/6/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "HomeIssueItemTPL6TableViewCell.h"
#import "YYWebImage.h"

@implementation HomeIssueItemTPL6TableViewCell
- (void)setItem:(RecipeItem *)item{
    _item = item;
    self.recipeImageView.yy_imageURL = [NSURL URLWithString:item.contents.image.url];
}
@end
