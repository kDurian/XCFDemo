//
//  Template4Cell.h
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 1/14/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageRecipeModel.h"

@interface KitchenCreativePhotoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *recipeImageView;
@property (weak, nonatomic) IBOutlet UILabel *recipeWhisperLabel;

- (void)creativePhotoCellBindRecipeItem:(RecipeItem *)item;

@end
