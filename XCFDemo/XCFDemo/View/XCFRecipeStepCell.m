//
//  XCFRecipeStepCell.m
//  Demo_TestRecipeEdited
//
//  Created by Durian on 4/13/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "XCFRecipeStepCell.h"
#import "Recipe.h"

@implementation XCFRecipeStepCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setPracticeStep:(RecipePracticeStep *)practiceStep
{
    if (practiceStep.imageData.length > 0) {
        self.picStepImageView.image = [UIImage imageWithData:practiceStep.imageData];
    }
    self.textStepLabel.text = practiceStep.text;
    self.stepNumberLabel.text = [NSString stringWithFormat:@"%ld", self.stepNumber];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.picStepImageView.image = [UIImage imageNamed:@"createRecipeCamera"];
    self.stepNumberLabel.text = nil;
    self.textStepLabel.text = nil;
    
}

@end
