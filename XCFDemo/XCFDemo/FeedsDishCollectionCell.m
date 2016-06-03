//
//  FeedsDishCollectionCell.m
//  XCFDemo
//
//  Created by Durian on 5/24/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "FeedsDishCollectionCell.h"

@implementation FeedsDishCollectionCell

- (void)prepareForReuse{
    self.coverImageView.image = nil;
    [super prepareForReuse];
}

@end
