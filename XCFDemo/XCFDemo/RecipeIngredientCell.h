//
//  RecipeIngredientCell.h
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 4/1/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecipeIngredientCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *ingredientNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *ingredientAmountTextField;

@end
