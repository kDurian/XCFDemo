//
//  XCFRecipeNameCell.h
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 3/19/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Recipe;

@interface XCFRecipeNameCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *recipeNameLabel;

@property(nonatomic, strong) Recipe *recipe;

@end
