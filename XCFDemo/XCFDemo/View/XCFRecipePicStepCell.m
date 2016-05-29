//
//  XCFRecipeStepCell.m
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 3/19/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "XCFRecipePicStepCell.h"

@implementation XCFRecipePicStepCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cellBindImage:(UIImage *)image atIndexPath:(NSIndexPath *)indexPath
{
    NSData *imageData = UIImagePNGRepresentation(image);
    if (imageData.length != 0) {
        self.picStepImageView.image = image;
    }
    NSString *text = [NSString stringWithFormat:@"%ld", (indexPath.row + 1) / 2];
    self.stepNumberLabel.text = text;
}
@end
