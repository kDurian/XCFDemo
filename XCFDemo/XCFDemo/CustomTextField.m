//
//  CustomTextField.m
//  XCFDemo
//
//  Created by Durian on 4/25/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "CustomTextField.h"
#import "UIColor+KDExtension.h"

@implementation CustomTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UIView *leftPlaceHoldView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, CGRectGetHeight(self.frame))];
    leftPlaceHoldView.backgroundColor = [UIColor clearColor];
    self.leftView = leftPlaceHoldView;
    self.leftViewMode = UITextFieldViewModeAlways;
//    self.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
}


@end
