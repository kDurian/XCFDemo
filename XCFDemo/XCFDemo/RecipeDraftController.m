//
//  RecipeDraftController.m
//  Demo_TestRecipeEdited
//
//  Created by Durian on 4/20/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "RecipeDraftController.h"
#import "SeparatorCell.h"
#import "RecipeDraftCell.h"

#import "RecipeEditedController.h"

#import "UITableView+FDTemplateLayoutCell.h"

#import "UIScrollView+EmptyDataSet.h"

#import "UIColor+KDExtension.h"

static NSString * const kRecipeDraftCellID = @"kRecipeDraftCellID";
static NSString * const kSeparatorCellID = @"kSeparatorCellID";

static NSString * const kRecipeCreatedStoryboardName = @"RecipeCreated";
static NSString * const kRecipeEditedControllerStoryboardID = @"kRecipeEditedControllerStoryboardID";



@interface RecipeDraftController ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property(nonatomic, strong) RecipeDraft *recipeDraft;

@end

@implementation RecipeDraftController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    [self setNavBar];
    
    [self registerCell];

}

- (void)setNavBar
{
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backStretchBackgroundNormal"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonItemDidClicked)];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (RecipeDraft *)recipeDraft
{
    if (!_recipeDraft) {
        if ([[RLMRealm defaultRealm] isEmpty]) {
            _recipeDraft = [[RecipeDraft alloc] init];
        }else {
            _recipeDraft = [RecipeDraft allObjects].firstObject;
        }
    }
    return _recipeDraft;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)registerCell
{
    [self.tableView registerNib:[UINib nibWithNibName:@"SeparatorCell" bundle:nil] forCellReuseIdentifier:kSeparatorCellID];
}

#pragma mark - DZNEmptyDataSetSource && DZNEmptyDataSetDelegate
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"草稿箱为空，求投喂~";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor emptyRecipeDraftPlaceHolderTextColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -200.0f;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.recipeDraft.recipes.count * 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0) {
        return [tableView fd_heightForCellWithIdentifier:kRecipeDraftCellID cacheByIndexPath:indexPath configuration:^(id cell) {
            RecipeDraftCell *recipeDraftCell = (RecipeDraftCell *)cell;
            [self configuration:recipeDraftCell atIndexPath:indexPath];
        }];
    }else {
        return 10.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row % 2 == 0) {
        RecipeDraftCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecipeDraftCellID forIndexPath:indexPath];
        [self configuration:cell atIndexPath:indexPath];
        return cell;
    }else {
        SeparatorCell *cell = [tableView dequeueReusableCellWithIdentifier:kSeparatorCellID forIndexPath:indexPath];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0) {
        [self editRecipeAtIndexPath:indexPath];
    }
}

#pragma mark - Jump Logic
- (void)backBarButtonItemDidClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editRecipeAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kRecipeCreatedStoryboardName bundle:nil];
    RecipeEditedController *recipeEditedController = [storyboard instantiateViewControllerWithIdentifier:kRecipeEditedControllerStoryboardID];
    NSInteger index = indexPath.row / 2;
    if (self.recipeDraft.recipes.count > index) {
        Recipe *recipe = self.recipeDraft.recipes[index];
        recipeEditedController.currentRecipe = recipe;
        recipeEditedController.currentRecipeIndex = index;
    }
    [self.navigationController pushViewController:recipeEditedController animated:YES];
}

- (void)configuration:(RecipeDraftCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if (self.recipeDraft.recipes.count > indexPath.row / 2) {
        cell.recipe = self.recipeDraft.recipes[indexPath.row / 2];
    }
}
@end
