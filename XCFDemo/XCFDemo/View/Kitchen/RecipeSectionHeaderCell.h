//
//  RecipeSectionHeaderCell.h
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 2/29/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageRecipeModel.h"

@interface RecipeSectionHeaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLable;

- (void)recipeSectionHeaderCellBindRecipeItem:(RecipeIssue *)item;

@end
