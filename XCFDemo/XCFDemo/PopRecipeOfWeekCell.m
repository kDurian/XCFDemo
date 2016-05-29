//
//  PopRecipeOfWeekCell.m
//  XCFDemo
//
//  Created by Durian on 5/21/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "PopRecipeOfWeekCell.h"

@interface PopRecipeOfWeekCell ()
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreAndDishNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorNameLabel;
@property (weak, nonatomic) IBOutlet UIView *exclusiveLogoView;
@end

@implementation PopRecipeOfWeekCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
