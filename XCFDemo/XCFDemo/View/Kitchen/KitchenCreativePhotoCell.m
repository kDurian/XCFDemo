//
//  Template4Cell.m
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 1/14/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "KitchenCreativePhotoCell.h"
#import "YYWebImage.h"

@implementation KitchenCreativePhotoCell
- (void)setItem:(RecipeItem *)item{
    _item = item;
    self.recipeImageView.yy_imageURL = [NSURL URLWithString:item.contents.image.url];
    self.recipeWhisperLabel.text = item.contents.whisper;
}
@end
