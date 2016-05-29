//
//  RecipeIngsControllerTableViewController.m
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 4/1/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "RecipeIngredientController.h"


#import "RecipeIngredientCell.h"
#import "RecipeIngredientAddCell.h"
#import "RecipeIngredientAdjustCell.h"

#import "Recipe.h"

static NSString *const kRecipeIngredientCellID = @"kRecipeIngredientCellID";
static NSString *const kRecipeIngredientAddCellID = @"kRecipeIngredientAddCellID";
static NSString *const kRecipeIngredientAdjustCellID = @"kRecipeIngredientAdjustCellID";

@interface RecipeIngredientController ()<UITextFieldDelegate>

//@property(nonatomic, strong) NSMutableArray *ingredientsArray;

@property(nonatomic, strong) UIButton *adjustmentButton;

//@property(nonatomic, strong) RLMArray<RecipeIngredient *><RecipeIngredient> *ingredientsArray;

@end


@implementation RecipeIngredientController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self setupNavBar];
    
    
    [self initRecipeIngredients];
}

- (void)setupNavBar
{
    self.title = @"用料";
    
    UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelIngredientEditor)];
    
    UIBarButtonItem *conformBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(completeIngredientEditor)];
    
    self.navigationItem.leftBarButtonItem = cancelBarButtonItem;
    self.navigationItem.rightBarButtonItem = conformBarButtonItem;
}

#pragma mark - Lazy Loading Ingredients
- (void)initRecipeIngredients
{
    if (self.recipeIngredients.count == 0) {
        RecipeIngredient *recipeIngredient1 = [[RecipeIngredient alloc] initWithName:@"" amount:@""];
        RecipeIngredient *recipeIngredient2 = [[RecipeIngredient alloc] initWithName:@"" amount:@""];
        
        [[RLMRealm defaultRealm] transactionWithBlock:^{
            [self.recipeIngredients addObjects:@[recipeIngredient1, recipeIngredient2]];
        }];
    }
}

#pragma mark - Cancel Or Complete Ingredient Editor
- (void)cancelIngredientEditor
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)completeIngredientEditor
{
    if([self.navigationItem.rightBarButtonItem.title isEqualToString:@"完成"])
    {
        [self adjustmentButtonClicked:self.adjustmentButton];
    }else
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(recipeIngredientDidEndEditing:withContent:)]) {
            
            for (UITextField *textField in self.tableView.subviews) {
                [textField endEditing:YES];
            }
            
            [self.delegate recipeIngredientDidEndEditing:self withContent:self.recipeIngredients];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.recipeIngredients.count > 0) {
        return 2;
    }else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.recipeIngredients.count > 0) {
        if (section == 0) {
            return self.recipeIngredients.count;
        }else {
            return 2;
        }
    }else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.recipeIngredients.count > 0) {
        if (indexPath.section == 0) {
            RecipeIngredientCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecipeIngredientCellID forIndexPath:indexPath];
            cell.ingredientNameTextField.tag = 100 * (indexPath.row + 1);
            cell.ingredientAmountTextField.tag = 100 * (indexPath.row + 1) + 1;
            cell.ingredientNameTextField.delegate = self;
            cell.ingredientAmountTextField.delegate = self;
            RecipeIngredient *ingredient = self.recipeIngredients[indexPath.row];
            cell.ingredientNameTextField.text = ingredient.ingredientName;
            cell.ingredientAmountTextField.text = ingredient.ingredientAmount;
            cell.showsReorderControl = YES;
            return cell;
        }else {
            if (indexPath.row == 0) {
                RecipeIngredientAddCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecipeIngredientAddCellID forIndexPath:indexPath];
                [cell.ingredientAddedButton addTarget:self action:@selector(ingredientAddedButtonClicked) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }else {
                RecipeIngredientAdjustCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecipeIngredientAdjustCellID forIndexPath:indexPath];
                [cell.adjustmentButton addTarget:self action:@selector(adjustmentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }
        }
    }else {
        if (indexPath.row == 0) {
            RecipeIngredientAddCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecipeIngredientAddCellID forIndexPath:indexPath];
            return cell;
        }else {
            RecipeIngredientAdjustCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecipeIngredientAdjustCellID forIndexPath:indexPath];
            return cell;
        }
    }
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.recipeIngredients.count > 0) {
        if (indexPath.section == 0) {
            return YES;
        }else {
            return NO;
        }
    }else {
        return NO;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.recipeIngredients removeObjectAtIndex:indexPath.row];
        if (self.recipeIngredients.count == 0) {
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        }else {
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.recipeIngredients.count > 0) {
        if (indexPath.section == 0) {
            return YES;
        }else {
            return NO;
        }
    }else {
        return NO;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    RecipeIngredient *ingredient = [self.recipeIngredients objectAtIndex:sourceIndexPath.row];
    
    [[RLMRealm defaultRealm] transactionWithBlock:^{
        [self.recipeIngredients removeObjectAtIndex:sourceIndexPath.row];
        [self.recipeIngredients insertObject:ingredient atIndex:destinationIndexPath.row];
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.recipeIngredients.count > 0) {
        if (indexPath.section == 0) {
            return 50.0f;
        }else {
            if (indexPath.row == 0) {
                return 50.0f;
            }else {
                return 60.0f;
            }
        }
    }else {
        if (indexPath.row == 0) {
            return 50.0f;
        }else {
            return 60.0f;
        }
    }
    return 0.0f;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.recipeIngredients.count > 0) {
        if (indexPath.section == 0) {
            return UITableViewCellEditingStyleDelete;
        }else {
            return UITableViewCellEditingStyleNone;
        }
    }else {
        return UITableViewCellEditingStyleNone;
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (sourceIndexPath.section != proposedDestinationIndexPath.section) {
        return sourceIndexPath;
    }
    return proposedDestinationIndexPath;
}

#pragma mark - Adjust Ingredient
- (void)ingredientAddedButtonClicked
{
    RecipeIngredient *recipeIngredient = [[RecipeIngredient alloc] initWithName:@"" amount:@""];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.recipeIngredients.count inSection:0];
    if (self.recipeIngredients.count >= 1) {
        [[RLMRealm defaultRealm] transactionWithBlock:^{
            [self.recipeIngredients addObject:recipeIngredient];

        }];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }else {
        [[RLMRealm defaultRealm] transactionWithBlock:^{
            [self.recipeIngredients addObject:recipeIngredient];
            
        }];
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)adjustmentButtonClicked:(UIButton *)sender
{
    for (UITextField *textField in self.tableView.subviews) {
        [textField endEditing:YES];
    }
    self.adjustmentButton = sender;
    self.tableView.editing= !self.tableView.isEditing;
    
    if (self.tableView.editing)
    {
        [sender setTitle:@"调整完成" forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem.title = @"完成";
        for (NSInteger i = 0; i < self.recipeIngredients.count; ++i) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.backgroundColor = [UIColor lightGrayColor];
        }
    }else {
        [sender setTitle:@"调整" forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem.title = @"确定";
        for (NSInteger i = 0; i < self.recipeIngredients.count; ++i) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.backgroundColor = [UIColor clearColor];
        }
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    UITableViewCell *cell = (UITableViewCell *)textField.superview.superview;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSInteger row = indexPath.row;
    RecipeIngredient *ingredient = self.recipeIngredients[row];
    if (textField.tag == (row + 1) * 100) {
        [[RLMRealm defaultRealm] transactionWithBlock:^{
            ingredient.ingredientName = textField.text;

        }];
    }
    if (textField.tag == (100 * (row + 1) + 1)) {
        
        [[RLMRealm defaultRealm] transactionWithBlock:^{
            ingredient.ingredientAmount = textField.text;
            
        }];
    }
    [[RLMRealm defaultRealm] transactionWithBlock:^{
        self.recipeIngredients[row] = ingredient;
    }];
}
@end
