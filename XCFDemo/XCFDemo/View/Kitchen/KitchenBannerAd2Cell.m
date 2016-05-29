//
//  FouthRowTableViewCell.m
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 1/11/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "KitchenBannerAd2Cell.h"
#import "YYWebImage.h"


@implementation KitchenBannerAd2Cell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cellBindHomePageBannerAd2Content:(AdContent *)content
{
    if (content == nil) {
        return;
    }else
    {
        self.adImageView.yy_imageURL = [NSURL URLWithString:content.adInfo.image.url];

    }
}

@end
