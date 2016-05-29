//
//  RelatedProductsCell.m
//  XCFDemo
//
//  Created by Durian on 5/6/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "RelatedProductsCell.h"
#import "UIImageView+WebCache.h"

@implementation RelatedProductsCell

- (void)setRelatedGoodsItem:(Item *)relatedGoodsItem
{
    _relatedGoodsItem = relatedGoodsItem;
    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:relatedGoodsItem.itemObject.main_pic.pic240]];
    _nameLabel.text = relatedGoodsItem.itemObject.name;
    _averageRateLabel.text = [NSString stringWithFormat:@"%@", @(relatedGoodsItem.itemObject.average_rate)];
    _priceRangeLabel.text = [NSString stringWithFormat:@"￥%@", relatedGoodsItem.itemObject.display_price];
}

@end
