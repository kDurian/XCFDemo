//
//  XCFRecipeStepCell.h
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 3/19/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XCFRecipePicStepCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *stepNumberLabel;

@property (weak, nonatomic) IBOutlet UIImageView *picStepImageView;

- (void)cellBindImage:(UIImage *)image atIndexPath:(NSIndexPath *)indexPath;

@end
