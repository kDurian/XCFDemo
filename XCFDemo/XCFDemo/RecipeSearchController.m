//
//  RecipeSearchController.m
//  XCFDemo
//
//  Created by Durian on 4/28/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "RecipeSearchController.h"

#import "RecipeSearchResultsController.h"
#import "CustomSearchController.h"

#import "RecipeResultsController.h"
#import "KitchenFriendResultsController.h"
#import "MenuResultsController.h"

#import "RecentSearchesHeaderCell.h"
#import "RecentSearchCell.h"
#import "SearchKitchenFriendsOrMenuCell.h"
#import "PopSearchRecipesCell.h"
#import "PopSearchRecipeCell.h"
#import "PopSearchRecipesHeaderView.h"
#import "Config.h"

#import "CustomSearchBar.h"

static NSString * const kRecentSearchesHeaderCellID = @"kRecentSearchesHeaderCell";
static NSString * const kRecentSearchCellID = @"kRecentSearchCell";
static NSString * const kSearchKitchenFriendsOrMenuCellID = @"kSearchKitchenFriendsOrMenuCell";
static NSString * const kPopSearchRecipesCellID = @"kPopSearchRecipesCell";
static NSString * const kPopSearchRecipeCellID = @"kPopSearchRecipeCell";
static NSString * const kPopSearchRecipesHeaderViewID = @"kPopSearchRecipesHeaderView";

static NSString * const kSectionHeaderViewID = @"kSectionHeaderView";

static NSString * const kRecipeSearchResultsControllerID = @"kRecipeSearchResultsController";

static NSString * const kRecipeResultsControllerID = @"kRecipeResultsController";
static NSString * const kKitchenFriendsResultsControllerID = @"kKitchenFriendsResultsController";
static NSString * const kMenuResultsControllerID = @"kMenuResultsController";

static NSString * const kRecipeSearchStoryboardName = @"RecipeSearchResults";

static NSString * const kRecentSearchesKey = @"kRecentSearchesKey";


@interface RecipeSearchController ()<UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong) NSMutableArray *recentSearches;
@property(nonatomic, strong) NSMutableArray *popSearches;
@property(nonatomic, strong) CustomSearchController *searchController;
//@property(nonatomic, strong) UISearchController *searchController;
@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;
@end


@implementation RecipeSearchController

- (void)dealloc
{
    [_searchController.view removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *recentSearches = [[NSUserDefaults standardUserDefaults] objectForKey:kRecentSearchesKey];
    if (recentSearches.count != 0) {
        self.recentSearches = [NSMutableArray arrayWithArray:recentSearches];
    }else {
        self.recentSearches = [NSMutableArray new];
    }
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:kSectionHeaderViewID];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"RecipeSearchResults" bundle:nil];
    RecipeSearchResultsController *resultsController = [storyboard instantiateViewControllerWithIdentifier:kRecipeSearchResultsControllerID];
    self.searchController = [[CustomSearchController alloc] initWithSearchResultsController:resultsController];
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.definesPresentationContext = YES;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.searchResultsUpdater = self;
    [self setupNavBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // restore the searchController's active state
    if (self.searchControllerWasActive) {
        self.searchController.active = self.searchControllerWasActive;
        _searchControllerWasActive = NO;
        
        if (self.searchControllerSearchFieldWasFirstResponder) {
            [self.searchController.searchBar becomeFirstResponder];
            _searchControllerSearchFieldWasFirstResponder = NO;
        }
    }
}

- (NSMutableArray *)popSearches
{
    if (!_popSearches) {
        NSMutableArray *keywords = self.hourKeyword.keywords.mutableCopy;
        _popSearches = [keywords subarrayWithRange:NSMakeRange(0, 9)].mutableCopy;
    }
    return _popSearches;
}

- (void)setupNavBar
{
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backStretchBackgroundNormal"] style:UIBarButtonItemStylePlain target:self action:@selector(backToHomePage)];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(startSearch)];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    UISearchBar *searchBar = self.searchController.searchBar;
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchBar.placeholder = @"菜谱、食材";
    searchBar.tintColor = [UIColor blackColor];
    self.navigationItem.titleView = searchBar;
    
    [searchBar becomeFirstResponder];
}

- (void)backToHomePage
{
    [[NSUserDefaults standardUserDefaults] setObject:self.recentSearches forKey:kRecentSearchesKey];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)startSearch
{
    
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"");
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"searchBarBegin");
    return YES;
}




#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchText = searchController.searchBar.text;
    
    NSMutableArray *searchResults = self.hourKeyword.keywords.mutableCopy;
    
    NSString *strippedString = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSArray *searchItems = nil;
    if (strippedString.length > 0) {
        searchItems = [strippedString componentsSeparatedByString:@" "];
    }
    
    NSMutableArray *predicates = [NSMutableArray array];
    
    for (NSString *searchString in searchItems) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSString *evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            return [evaluatedObject containsString:searchString];
        }];
        [predicates addObject:predicate];
    }
    
    NSCompoundPredicate *finalCompoundPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:predicates];
    
    searchResults = [searchResults filteredArrayUsingPredicate:finalCompoundPredicate].mutableCopy;
    if (searchResults.count >= 3) {
        searchResults = [searchResults subarrayWithRange:NSMakeRange(0, 3)].mutableCopy;
    }
    RecipeSearchResultsController *searchResultController = (RecipeSearchResultsController *)searchController.searchResultsController;
    searchResultController.recipeResults = searchResults;
    searchResultController.searchName = searchText;
    [searchResultController.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (self.recentSearches.count > 0 ? 1 : 0) + 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.recentSearches.count == 0) {
        switch (section) {
            case 0:
            case 1:
            case 2:
                return 1;
                break;
            default:
                break;
        }
    }else {
        switch (section) {
            case 0:
                return self.recentSearches.count + 1;
                break;
            case 1:
            case 2:
            case 3:
                return 1;
                break;
            default:
                break;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (self.recentSearches.count == 0) {
        switch (indexPath.section) {
            case 0:
            {
                SearchKitchenFriendsOrMenuCell *kitchenFriendsCell = [tableView dequeueReusableCellWithIdentifier:kSearchKitchenFriendsOrMenuCellID forIndexPath:indexPath];
                kitchenFriendsCell.titleLabel.text = @"搜厨友";
                cell = kitchenFriendsCell;
                break;
            }
            case 1:
            {
                SearchKitchenFriendsOrMenuCell *menuCell = [tableView dequeueReusableCellWithIdentifier:kSearchKitchenFriendsOrMenuCellID forIndexPath:indexPath];
                menuCell.titleLabel.text = @"搜菜单";
                cell = menuCell;
                break;
            }
            case 2:
            {
                PopSearchRecipesCell *popSearchCell = [tableView dequeueReusableCellWithIdentifier:kPopSearchRecipesCellID forIndexPath:indexPath];
                [self configFlowLayoutForCollectionView:popSearchCell.collectionView];
                cell = popSearchCell;
                break;
            }
            default:
                break;
        }
    }else {
        switch (indexPath.section) {
            case 0:
            {
                if (indexPath.row == 0) {
                    RecentSearchesHeaderCell *recentSearchesCell = [tableView dequeueReusableCellWithIdentifier:kRecentSearchesHeaderCellID forIndexPath:indexPath];
                    recentSearchesCell.titleLabel.text = @"最近搜索";
                    [recentSearchesCell.closeButton addTarget:self action:@selector(deleteRecentSearchHistory) forControlEvents:UIControlEventTouchUpInside];
                    cell = recentSearchesCell;
                }else {
                    RecentSearchCell *recentSearchCell = [tableView dequeueReusableCellWithIdentifier:kRecentSearchCellID forIndexPath:indexPath];
                    recentSearchCell.titleLabel.text = self.recentSearches[indexPath.row - 1];
                    cell = recentSearchCell;
                }
                break;
            }
            case 1:
            {
                SearchKitchenFriendsOrMenuCell *kitchenFriendsCell = [tableView dequeueReusableCellWithIdentifier:kSearchKitchenFriendsOrMenuCellID forIndexPath:indexPath];
                kitchenFriendsCell.titleLabel.text = @"搜厨友";
                cell = kitchenFriendsCell;
                break;
            }
            case 2:
            {
                SearchKitchenFriendsOrMenuCell *menuCell = [tableView dequeueReusableCellWithIdentifier:kSearchKitchenFriendsOrMenuCellID forIndexPath:indexPath];
                menuCell.titleLabel.text = @"搜菜单";
                cell = menuCell;
                break;
            }
            case 3:
            {
                PopSearchRecipesCell *popSearchCell = [tableView dequeueReusableCellWithIdentifier:kPopSearchRecipesCellID forIndexPath:indexPath];
                [self configFlowLayoutForCollectionView:popSearchCell.collectionView];
                cell = popSearchCell;
                break;
            }
            default:
                break;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kRecipeSearchStoryboardName bundle:nil];
    if (self.recentSearches.count == 0) {
        if (indexPath.section == 0) {
            KitchenFriendResultsController *controller = [storyboard instantiateViewControllerWithIdentifier:kKitchenFriendsResultsControllerID];
            [self.navigationController pushViewController:controller animated:YES];
        }else if (indexPath.section == 1) {
            MenuResultsController *controller = [storyboard instantiateViewControllerWithIdentifier:kMenuResultsControllerID];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }else {
        if (indexPath.section == 0) {
            if (indexPath.row > 0) {
                RecipeResultsController *controller = [storyboard instantiateViewControllerWithIdentifier:kRecipeResultsControllerID];
                RecentSearchCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                controller.searchName = cell.titleLabel.text.copy;
                [self.navigationController pushViewController:controller animated:YES];
            }
        }else if(indexPath.section == 1) {
            KitchenFriendResultsController *controller = [storyboard instantiateViewControllerWithIdentifier:kKitchenFriendsResultsControllerID];
            [self.navigationController pushViewController:controller animated:YES];
        }else if (indexPath.section == 2) {
            MenuResultsController *controller = [storyboard instantiateViewControllerWithIdentifier:kMenuResultsControllerID];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

- (void)deleteRecentSearchHistory
{
    [self.recentSearches removeAllObjects];
    [[NSUserDefaults standardUserDefaults] setObject:self.recentSearches forKey:kRecentSearchesKey];
    [self.tableView reloadData];
}

- (void)configFlowLayoutForCollectionView:(UICollectionView *)collectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake([PopSearchRecipeCell cellWidth], [PopSearchRecipeCell cellHeight]);
    flowLayout.minimumLineSpacing = 1.0f;
    flowLayout.minimumInteritemSpacing =1.0f;
    collectionView.collectionViewLayout = flowLayout;
    collectionView.delegate = self;
    collectionView.dataSource = self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.recentSearches.count == 0) {
        switch (indexPath.section) {
            case 0:
            case 1:
            {
                return [SearchKitchenFriendsOrMenuCell cellHeight];
                break;
            }
            case 2:
            {
                return [PopSearchRecipesHeaderView viewHeight] + [PopSearchRecipeCell cellHeight] * ceil(self.popSearches.count / 3) + 2;
                break;
            }
            default:
                break;
        }
    }else {
        switch (indexPath.section) {
            case 0:
            {
                if (indexPath.row == 0) {
                    return [RecentSearchesHeaderCell cellHeight];
                }else {
                    return [RecentSearchCell cellHeight];
                }
                break;
            }
            case 1:
            case 2:
            {
                return [SearchKitchenFriendsOrMenuCell cellHeight];
                break;
            }
            case 3:
            {
                return [PopSearchRecipesHeaderView viewHeight] + [PopSearchRecipeCell cellHeight] * ceil(self.popSearches.count / 3) + 1;
                break;
            }
            default:
                break;
        }
    }
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kSectionHeaderViewID];
//    headerView.contentView.backgroundColor = [UIColor clearColor];
//    headerView.backgroundColor = [UIColor clearColor];
    headerView.contentView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8.0f;
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.popSearches.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PopSearchRecipeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPopSearchRecipeCellID forIndexPath:indexPath];
    cell.titleLabel.text = self.popSearches[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kRecipeSearchStoryboardName bundle:nil];
    RecipeResultsController *controller = [storyboard instantiateViewControllerWithIdentifier:kRecipeResultsControllerID];
    NSString *searchName = self.popSearches[indexPath.row];
    controller.searchName = searchName;
    if (![self.recentSearches containsObject:searchName]) {
        [self.recentSearches addObject:searchName];
    }
    [self.navigationController pushViewController:controller animated:YES];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        PopSearchRecipesHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kPopSearchRecipesHeaderViewID forIndexPath:indexPath];
        view.titleLabel.text = @"流行搜索";
        reusableView = view;
    }
    return reusableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake([PopSearchRecipesHeaderView viewWidth], [PopSearchRecipesHeaderView viewHeight]);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1, 0, 0, 0);
}

- (BOOL)hidesBottomBarWhenPushed
{
    return YES;
}
@end
