//
//  RecipeDraftCell.h
//  Demo_TestRecipeEdited
//
//  Created by Durian on 4/20/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Recipe.h"

@interface RecipeDraftCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *ingredientLabel;

@property(nonatomic, strong) Recipe *recipe;

@end
