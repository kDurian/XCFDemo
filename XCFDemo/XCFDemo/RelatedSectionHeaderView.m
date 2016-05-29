//
//  RelatedSectionHeaderView.m
//  XCFDemo
//
//  Created by Durian on 5/9/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "RelatedSectionHeaderView.h"

@implementation RelatedSectionHeaderView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *view = [[NSBundle mainBundle] loadNibNamed:@"RelatedSectionHeaderView" owner:nil options:nil].firstObject;
        [self addSubview:view];
    }
    
    return self;
}

@end
