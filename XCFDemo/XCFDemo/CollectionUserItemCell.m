//
//  CollectionUserItemCell.m
//  XCFDemo
//
//  Created by Durian on 5/6/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "CollectionUserItemCell.h"
#import "UIimageView+WebCache.h"

@implementation CollectionUserItemCell

- (void)setUserItem:(Item *)userItem
{
    _userItem = userItem;
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:userItem.itemObject.photo]];
    _titleLabel.text = userItem.itemObject.name;
}

@end
