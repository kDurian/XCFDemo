//
//  GoodsUserMenuGenericCell.m
//  XCFDemo
//
//  Created by Durian on 5/18/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "GoodsUserMenuGenericCell.h"

@implementation GoodsUserMenuGenericCell

- (void)setIsYesMarkHidden:(BOOL)isYesMarkHidden
{
    if(!isYesMarkHidden) {
        self.checkMarkImageView.hidden = NO;
    }
}

@end
