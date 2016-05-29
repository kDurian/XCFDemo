//
//  PopSearchRecipeCell.h
//  XCFDemo
//
//  Created by Durian on 4/29/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopSearchRecipeCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

+ (CGFloat)cellWidth;

+ (CGFloat)cellHeight;


@end
