//
//  CreateRecipeViewController.h
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 3/14/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecipeInitialEntryController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *draftButton;

@property (weak, nonatomic) IBOutlet UITextField *recipeNameTextField;


@end
