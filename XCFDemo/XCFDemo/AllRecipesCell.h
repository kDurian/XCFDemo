//
//  AllRecipesCell.h
//  XCFDemo
//
//  Created by Durian on 5/18/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchInResultsBaseCell.h"

@interface AllRecipesCell : SearchInResultsBaseCell
@property (weak, nonatomic) IBOutlet UIImageView *checkMarkImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@end
