//
//  Template2Cell.h
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 1/14/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageRecipeModel.h"

@interface KitchenRecipeCollectionsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *recipeImageView;
@property (weak, nonatomic) IBOutlet UILabel *recipeFirstLabel;
@property (weak, nonatomic) IBOutlet UILabel *recipeSecondLabel;
@property(nonatomic, strong) RecipeItem *item;
@end
