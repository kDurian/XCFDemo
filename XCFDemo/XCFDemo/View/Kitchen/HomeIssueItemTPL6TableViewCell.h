//
//  HomeIssueItemTPL1TableViewCell.h
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 3/6/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageRecipeModel.h"

@interface HomeIssueItemTPL6TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *recipeImageView;

- (void)homeIssueItemTPL6TableViewCellBindRecipeItem:(RecipeItem *)item;

@end
