//
//  RecipeResultsTableController.m
//  XCFDemo
//
//  Created by Durian on 4/28/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "RecipeSearchResultsController.h"

#import "SearchResultRecipesHeaderCell.h"
#import "SearchResultFriendsOrMenusHeaderCell.h"
#import "SearchResultKitchenFriendCell.h"
#import "SearchResultMenuCell.h"
#import "SearchResultCollectionCell.h"
#import "SearchResultCollectionHeaderCell.h"
#import "RecentSearchCell.h"

#import "RecipeResultsController.h"
#import "KitchenFriendResultsController.h"
#import "MenuResultsController.h"

#import "RecipeDetailController.h"

static NSString * const kSearchResultRecipesHeaderCellID = @"kSearchResultRecipesHeaderCell";
static NSString * const kSearchResultFriendsOrMenusHeaderCellID = @"kSearchResultFriendsOrMenusHeaderCell";
static NSString * const kSearchResultKitchenFriendCellID = @"kSearchResultKitchenFriendCell";
static NSString * const kSearchResultMenuCellID = @"kSearchResultMenuCell";
static NSString * const kSearchResultCollectionCellID = @"kSearchResultCollectionCell";
static NSString * const kSearchResultCollectionHeaderCellID = @"kSearchResultCollectionHeaderCell";
static NSString * const kRecentSearchCellID = @"kRecentSearchCell";


static NSString * const kRecipeResultsControllerID = @"kRecipeResultsController";
static NSString * const kKitchenFriendsResultsControllerID = @"kKitchenFriendsResultsController";
static NSString * const kMenuResultsControllerID = @"kMenuResultsController";
static NSString * const kRecipeDetailControllerID = @"kRecipeDetailController";

static NSString * const kRecipeSearchStoryboardName = @"RecipeSearchResults";


@interface RecipeSearchResultsController ()

@property(nonatomic, strong) NSMutableArray *kitchenFriendResults;
@property(nonatomic, strong) NSMutableArray *menuResults;
@property(nonatomic, strong) NSMutableArray *collectionResults;

@end

@implementation RecipeSearchResultsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
//    self.tableView.separatorColor = [UIColor clearColor];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.collectionResults.count == 0) {
        return 3;
    }else {
        return 4;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0){
        return self.recipeResults.count + 1;
    }else if (section == 1) {
        return self.kitchenFriendResults.count + 1;
    }else if (section == 2) {
        return self.menuResults.count + 1;
    }else {
        return self.collectionResults.count + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            SearchResultRecipesHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:kSearchResultRecipesHeaderCellID forIndexPath:indexPath];
            cell.titleLabel.text = @"搜菜谱";
            cell.nameLabel.text = self.searchName;
            return cell;
        }else {
            RecentSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecentSearchCellID forIndexPath:indexPath];
            cell.titleLabel.text = self.recipeResults[indexPath.row - 1];
            return cell;
        }
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            SearchResultFriendsOrMenusHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:kSearchResultFriendsOrMenusHeaderCellID forIndexPath:indexPath];
            cell.titleLabel.text = @"搜厨友";
            cell.nameLabel.text = self.searchName;
            return cell;
        }else {
            SearchResultKitchenFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:kSearchResultKitchenFriendCellID forIndexPath:indexPath];
            cell.avatarImageView.image = nil;
            cell.nameLabel.text = nil;
            return cell;
        }
    }else if(indexPath.section == 2){
        if (indexPath.row == 0) {
            SearchResultFriendsOrMenusHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:kSearchResultFriendsOrMenusHeaderCellID forIndexPath:indexPath];
            cell.titleLabel.text = @"搜菜单";
            cell.nameLabel.text = self.searchName;
            return cell;
        }else {
            
        }
    }else {
        if (indexPath.row == 0) {
            SearchResultCollectionHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:kSearchResultCollectionHeaderCellID forIndexPath:indexPath];
            cell.titleLabel.text = @"我的收藏";
            return cell;
        }else {
            SearchResultCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:kSearchResultCollectionCellID forIndexPath:indexPath];
            cell.coverImageView.image = nil;
            cell.titleLabel.text = nil;
            return cell;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kRecipeSearchStoryboardName bundle:nil];
    if (indexPath.section == 0) {
        RecipeResultsController *controller = [storyboard instantiateViewControllerWithIdentifier:kRecipeResultsControllerID];
        if (indexPath.row == 0) {
            controller.searchName = self.searchName;
        }else {
            if (self.recipeResults.count > (indexPath.row - 1)) {
                controller.searchName = self.recipeResults[indexPath.row - 1];
            }
        }
        [self.navigationController pushViewController:controller animated:YES];
    }else if (indexPath.section == 1) {
        KitchenFriendResultsController *controller = [storyboard instantiateViewControllerWithIdentifier:kKitchenFriendsResultsControllerID];
        if (indexPath.row == 0) {
            controller.searchName = self.searchName;
        }else {
            if (self.kitchenFriendResults.count > (indexPath.row - 1)) {
                controller.searchName = self.kitchenFriendResults[indexPath.row - 1];
            }
        }
        [self.navigationController pushViewController:controller animated:YES];
    }else if (indexPath.section == 2) {
        MenuResultsController *controller = [storyboard instantiateViewControllerWithIdentifier:kMenuResultsControllerID];
        if (indexPath.row == 0) {
            controller.searchName = self.searchName;
        }else {
            if (self.menuResults.count > (indexPath.row - 1)) {
                controller.searchName = self.menuResults[indexPath.row -1];
            }
        }
        [self.navigationController pushViewController:controller animated:YES];
    }else {
        if (indexPath.row > 0) {
            RecipeDetailController *controller = [storyboard instantiateViewControllerWithIdentifier:kRecipeDetailControllerID];
            if (self.collectionResults.count > (indexPath.row - 1)) {
                controller.recipeName = self.collectionResults[indexPath.row - 1];
            }
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 65.0f;
        }else {
            return 60.0f;
        }
    }else if(indexPath.section == 1) {
        if (indexPath.row == 0) {
            return 65.0f;
        }else {
            return 70.0f;
        }
    }else if(indexPath.section == 2){
        if (indexPath.row == 0) {
            return 65.0f;
        }else {
            return 60.0f;
        }
    }else {
        if (indexPath.row == 0) {
            return 60.0f;
        }else {
            return 70.0f;
        }
    }
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *view = [[UITableViewHeaderFooterView alloc] init];
    view.contentView.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8.0f;
}

- (BOOL)hidesBottomBarWhenPushed
{
    return YES;
}
@end
