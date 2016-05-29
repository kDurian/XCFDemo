//
//  KitchenCouponAdCell.m
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 1/15/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "KitchenBannerAd1Cell.h"
#import "YYWebImage.h"

@implementation KitchenBannerAd1Cell

- (void)cellBindHomePageBannerAdContent:(AdContent *)content
{
    if (content == nil) {
        return;
    }else
    {
        self.adImageView.yy_imageURL = [NSURL URLWithString:content.adInfo.image.url];

    }
}

@end
