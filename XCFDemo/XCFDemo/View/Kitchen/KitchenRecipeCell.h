//
//  FifthTableViewCell.h
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 1/13/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageRecipeModel.h"

@interface KitchenRecipeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *recipeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *authorAvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *recipeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *recipeSummaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreAndCookedLabel;
@property(nonatomic, strong) RecipeItem *item;
@end
