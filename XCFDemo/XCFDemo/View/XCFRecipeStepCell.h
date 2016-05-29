//
//  XCFRecipeStepCell.h
//  Demo_TestRecipeEdited
//
//  Created by Durian on 4/13/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RecipePracticeStep;

@interface XCFRecipeStepCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *stepNumberLabel;

@property (weak, nonatomic) IBOutlet UIImageView *picStepImageView;

@property (weak, nonatomic) IBOutlet UIButton *addRecipeTextStepButton;

@property (weak, nonatomic) IBOutlet UILabel *textStepLabel;

@property (weak, nonatomic) IBOutlet UIView *textStepAddView;

@property(nonatomic, strong) RecipePracticeStep *practiceStep;

@property(nonatomic, assign) NSInteger stepNumber;


@end
