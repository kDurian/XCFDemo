//
//  CreateRecipeViewController.m
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 3/14/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "RecipeInitialEntryController.h"

#import "RecipeEditedController.h"

#import "SVProgressHUD.h"
#import "MBProgressHUD.h"
#import "Recipe.h"

#import "UIColor+KDExtension.h"

#import "RecipeEditedController.h"

#import "RecipeDraftController.h"

static NSString * const kRecipeCreatedStoryboardName = @"RecipeCreated";

static NSString * const kRecipeDraftControllerStoryboardID = @"kRecipeDraftControllerStoryboardID";
static NSString * const kRecipeEditedControllerStoryboardID = @"kRecipeEditedControllerStoryboardID";

@implementation RecipeInitialEntryController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [[RLMRealm defaultRealm] transactionWithBlock:^{
//        [[RLMRealm defaultRealm] deleteAllObjects];
//    }];
    
    self.hidesBottomBarWhenPushed = YES;

    [self setupNavBar];
    
    self.recipeNameTextField.delegate = self;
    
    self.edgesForExtendedLayout = UIRectEdgeTop;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.recipeNameTextField.text = nil;
}

#pragma mark - Set NavBar
- (void)setupNavBar
{
    UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backToHomePage)];
    
    UIBarButtonItem *conformBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(enterRecipeEditedPage)];
    
    self.navigationItem.leftBarButtonItem = cancelBarButtonItem;
    self.navigationItem.rightBarButtonItem = conformBarButtonItem;
}

#pragma mark - Jump Logic
- (void)backToHomePage
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)enterRecipeEditedPage
{
    if (![self recipeNameIsVaild])
    {
        [self showAlertMessage];
    } else {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:kRecipeCreatedStoryboardName bundle:nil];
        
        RecipeEditedController *recipeEditedController = [storyBoard instantiateViewControllerWithIdentifier:kRecipeEditedControllerStoryboardID];
        
        recipeEditedController.recipeName = self.recipeNameTextField.text;
        
        [self.navigationController pushViewController:recipeEditedController animated:YES];
        
    }
}

- (IBAction)draftButtonDidClick:(id)sender
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:kRecipeCreatedStoryboardName bundle:nil];
    RecipeDraftController *recipeDraftController = [storyBoard instantiateViewControllerWithIdentifier:kRecipeDraftControllerStoryboardID];
    [self.navigationController pushViewController:recipeDraftController animated:YES];
}

#pragma mark - Private Method
- (void)showAlertMessage
{
    MBProgressHUD *Hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    Hud.userInteractionEnabled = NO;
    Hud.mode = MBProgressHUDModeText;
    Hud.yOffset = 200.0f;
    Hud.labelText = @"请输入菜谱名称";
    [Hud hide:YES afterDelay:2];
}

- (BOOL)recipeNameIsVaild
{
    return self.recipeNameTextField.text.length > 0;
}
@end
