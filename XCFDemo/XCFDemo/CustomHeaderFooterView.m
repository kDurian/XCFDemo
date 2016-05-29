//
//  CustomHeaderFooterView.m
//  XCFDemo
//
//  Created by Durian on 5/20/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "CustomHeaderFooterView.h"

@implementation CustomHeaderFooterView

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.textLabel.font = [UIFont systemFontOfSize:12.0];
    self.textLabel.textColor = [UIColor colorWithRed:112 / 255.0f green:122 / 255.0f blue:122 / 255.0f alpha:1];
}

@end
