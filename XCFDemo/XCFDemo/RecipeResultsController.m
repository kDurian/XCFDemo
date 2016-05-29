//
//  RecipeResultsController.m
//  XCFDemo
//
//  Created by Durian on 5/3/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "RecipeResultsController.h"

#import "CollectionUserItemCell.h"
#import "CategoryExplorationsCell.h"
#import "ExplorationCell.h"
#import "SearchResultRecipeItemCell.h"
#import "RelatedMenuCell.h"
#import "RelatedProductsCell.h"
#import "RelatedSearchCell.h"
#import "ShowMoreCell.h"
#import "CustomHeaderFooterView.h"
#import "SearchInResultsController.h"

#import "SeparatorCell.h"

#import "NetworkManager+SearchResultRecipes.h"
#import "NetworkManager+RecipeCategory.h"
#import "NetworkManager+RecipesFilters.h"
#import "NetworkManager+SearchMoreResultRecipes.h"

#import "UniversalSearchModel.h"
#import "RecipeCategory.h"
#import "RecipesFiltersModel.h"

#import "UIImageview+WebCache.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "MJRefresh.h"

static NSString * const kSearchInResultsStroyboardID = @"kSearchInResults";
static NSString * const kRecipeSearchResultsStoryboardName = @"RecipeSearchResults";

static NSString * const kCollectionUserItemCellID = @"kCollectionUserItemCell";
static NSString * const kCategoryExplorationsCellID = @"kCategoryExplorationsCell";
static NSString * const kExplorationCellID = @"kExplorationCell";
static NSString * const kSearchResultRecipeItemCellID = @"kSearchResultRecipeItemCell";
static NSString * const kRelatedMenuCellID = @"kRelatedMenuCell";
static NSString * const kRelatedProductsCellID = @"kRelatedProductsCell";
static NSString * const kRelatedSearchCellID = @"kRelatedSearchCell";
static NSString * const kShowMoreCellID = @"kShowMoreCell";
static NSString * const kSeparatorCellID = @"kSeparatorCellID";

static NSString * const kSectionHeaderViewID = @"kSectionHeaderView";
static NSString * const kSectionFooterViewID = @"kSectionFooterView";

@interface RecipeResultsController ()<UICollectionViewDelegate, UICollectionViewDataSource, SearchInResultsControllerDelegate>
@property(nonatomic, strong) NSMutableArray *explorations;
@property(nonatomic, strong) NSMutableArray *recipeResults;
@property(nonatomic, strong) NSMutableArray *itemSections;
@property(nonatomic, assign) BOOL isExplorationsAsIndependentSection;
@property(nonatomic, strong) UISearchBar *searchBar;
@property(nonatomic, strong) RecipesFiltersContent *recipesFiltersContent;

@property(nonatomic, assign) ModalSelectCellType selectCellTypeOfPresented;

@property(nonatomic, assign) NSInteger totalRecipesCount;
@end

@implementation RecipeResultsController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectCellTypeOfPresented = ModalSelectCellTypeAll;
    
    [self setNavBar];
    
    self.searchBar.text = self.searchName;
    
    self.recipeResults = [NSMutableArray new];
    
    [self.tableView registerClass:[CustomHeaderFooterView class] forHeaderFooterViewReuseIdentifier:kSectionHeaderViewID];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:kSectionFooterViewID];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SeparatorCell" bundle:nil] forCellReuseIdentifier:kSeparatorCellID];

    
    
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    [self getData];
}

- (void)setNavBar
{
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backStretchBackgroundNormal"] style:UIBarButtonItemStylePlain target:self action:@selector(goBackToPreviousPage)];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search_result_btn"] style:UIBarButtonItemStylePlain target:self action:@selector(popRecipesFilters)];

    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.placeholder = @"菜谱、食材";
    
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
//    [button setImage:[UIImage imageNamed:@"search_result_btn"] forState:UIControlStateNormal];
//    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    self.navigationItem.titleView = searchBar;
    
    self.searchBar = searchBar;
}

- (void)goBackToPreviousPage
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)popRecipesFilters
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kRecipeSearchResultsStoryboardName bundle:nil];
    SearchInResultsController *controller = [storyboard instantiateViewControllerWithIdentifier:kSearchInResultsStroyboardID];
    controller.content = self.recipesFiltersContent;
    controller.totalRecipesCount = self.totalRecipesCount;
    controller.curCellType = self.selectCellTypeOfPresented;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self isShowTableHeaderView]) {
        UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), 8.0)];
        tableHeaderView.backgroundColor = [UIColor clearColor];
        self.tableView.tableHeaderView = tableHeaderView;
    }
}

- (void)getData
{
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    [NetworkManager getRecipesFiltersWithSuccBlock:^(BaseEntity *entity) {
        RecipesFiltersResponse *response = (RecipesFiltersResponse *)entity;
        self.recipesFiltersContent = response.content;
        dispatch_group_leave(group);
    } OrFailedBlock:^(BaseEntity *entity) {
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [NetworkManager getUnversalSearchWithSuccBlock:^(BaseEntity *entity) {
        SearchResultResponse *response = (SearchResultResponse *)entity;
        self.totalRecipesCount = response.content.total;
        [self.recipeResults addObject:response.copy];
        dispatch_group_leave(group);
    } OrFailedBlock:^(BaseEntity *entity) {
        NSLog(@"Get universal search results error.");
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [NetworkManager getExplorationsWithSuccBlock:^(BaseEntity *entity) {
        RecipeCategoryResponse *response = (RecipeCategoryResponse *)entity;
        self.explorations = response.content.explorations.mutableCopy;
        dispatch_group_leave(group);
    } OrFailedBlock:^(BaseEntity *entity) {
        NSLog(@"Get explorations error.");
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self handleData];
        [self.tableView reloadData];
    });
}

- (void)loadMoreData
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    
    [NetworkManager getMoreUnversalSearchWithSuccBlock:^(BaseEntity *entity) {
        SearchResultResponse *response = (SearchResultResponse *)entity;
        [self.recipeResults addObject:response.copy];
        dispatch_group_leave(group);
    } OrFailedBlock:^(BaseEntity *entity) {
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self handleData];
        [self.tableView reloadData];
    });
}

- (void)handleData
{
    NSMutableArray *items = [NSMutableArray new];
    self.itemSections = nil;
    for (SearchResultResponse *obj in self.recipeResults) {
        [items addObjectsFromArray:obj.content.content];
    }
    NSMutableArray *itemSections = [NSMutableArray new];
    self.itemSections = itemSections;
    NSInteger mark = 0;
    for (NSInteger i = 0; i < items.count; ++i) {
        ItemContent *itemContent = items[i];
        if ([itemContent.type isEqualToString:@"collection"]) {
            NSMutableArray *nonCollectionItems;
            NSMutableArray *collectionItems;
            if (mark == 0) {
                nonCollectionItems = [items subarrayWithRange:NSMakeRange(0, i)].mutableCopy;
                collectionItems = [NSArray arrayWithObject:itemContent].mutableCopy;
                if (nonCollectionItems.count == 0) {
                    [itemSections addObject:collectionItems];
                }else {
                    [itemSections addObjectsFromArray:@[nonCollectionItems, collectionItems]];
                }
            }else {
                nonCollectionItems = [items subarrayWithRange:NSMakeRange(mark + 1, i - mark - 1)].mutableCopy;
                collectionItems = [NSArray arrayWithObject:itemContent].mutableCopy;
                if (nonCollectionItems.count == 0) {
                    [itemSections addObject:collectionItems];
                }else {
                    [itemSections addObjectsFromArray:@[nonCollectionItems, collectionItems]];
                }
            }
            mark = i;
        }
    }
    if (mark < ((NSInteger)items.count - 1)) {
        NSMutableArray *lastSection = [items subarrayWithRange:NSMakeRange(mark + 1, items.count - mark - 1)].mutableCopy;
        if (lastSection.count > 0) {
            [itemSections addObject:lastSection];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)isShowTableHeaderView
{
    if (self.explorations.count == 0) {
        NSMutableArray *sectionItems = self.itemSections[0];
        if (sectionItems.count > 0) {
            ItemContent *itemContent = sectionItems.firstObject;
            if ([itemContent.type isEqualToString:@"collection"]) {
                if ([itemContent.style isEqualToString:@"recipe_list_collection"]
                    || [itemContent.style isEqualToString:@"goods_collection"]
                    || [itemContent.style isEqualToString:@"related_query_collection"]) {
                    return YES;
                }
            }
        }
    }
    return NO;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger numberOfSections = 0;
    if (self.itemSections.count > 0) {
        NSMutableArray *sectionItems = self.itemSections[0];
        if (sectionItems.count > 0) {
            ItemContent *itemContent = sectionItems.firstObject;
            if ([itemContent.type isEqualToString:@"collection"] && self.explorations.count > 0) {
                numberOfSections = self.itemSections.count + 1;
                self.isExplorationsAsIndependentSection = YES;
            }else {
                numberOfSections = self.itemSections.count;
            }
        }
    }
    return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"%@: %ld", NSStringFromSelector(_cmd), section);
    NSInteger numberOfRows = 0;
    if (self.explorations.count == 0) {
        if (self.itemSections.count > section) {
            NSMutableArray *sectionItems = self.itemSections[section];
            if (sectionItems.count > 0) {
                ItemContent *itemContent = sectionItems.firstObject;
                if ([itemContent.type isEqualToString:@"collection"]) {
                    numberOfRows = [self numberOfRowsWithCollectionItemContent:itemContent];
                }else if ([itemContent.type isEqualToString:@"item"]) {
                    numberOfRows = sectionItems.count + 1;
                }
            }
        }
    }else {
        if (self.isExplorationsAsIndependentSection)
        {
            if (section == 0) {
                numberOfRows = 2;
            }else {
                if (self.itemSections.count > (section - 1)) {
                    NSMutableArray *sectionItems = self.itemSections[section - 1];
                    if (sectionItems.count > 0) {
                        ItemContent *itemContent = sectionItems.firstObject;
                        if ([itemContent.type isEqualToString:@"collection"]) {
                            numberOfRows = [self numberOfRowsWithCollectionItemContent:itemContent];
                        }else if ([itemContent.type isEqualToString:@"item"]) {
                            numberOfRows = sectionItems.count + 1;
                        }
                    }
                }
            }
        }else {
            if (self.itemSections.count > section) {
                NSMutableArray *sectionItems = self.itemSections[section];
                if (section == 0) {
                    numberOfRows = sectionItems.count + 2;
                }else {
                    ItemContent *itemContent = sectionItems.firstObject;
                    if ([itemContent.type isEqualToString:@"collection"]) {
                        numberOfRows = [self numberOfRowsWithCollectionItemContent:itemContent];
                    }else if ([itemContent.type isEqualToString:@"item"]) {
                        numberOfRows = sectionItems.count + 1;
                    }
                }
            }
        }
    }
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%@: %@", NSStringFromSelector(_cmd), indexPath);
    if (self.explorations.count == 0) {
        if (self.itemSections.count > indexPath.section) {
            NSMutableArray *sectionItems = self.itemSections[indexPath.section];
            return [self tableView:tableView cellForRowAtIndexPath:indexPath withSectionItems:sectionItems];
        }
    }else {
        if (self.isExplorationsAsIndependentSection) {
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {
                    CategoryExplorationsCell *cell = [tableView dequeueReusableCellWithIdentifier:kCategoryExplorationsCellID forIndexPath:indexPath];
                    cell.collectionView.delegate = self;
                    cell.collectionView.dataSource = self;
                    return cell;
                }else if(indexPath.row == 1){
                    SeparatorCell *cell = [tableView dequeueReusableCellWithIdentifier:kSeparatorCellID forIndexPath:indexPath];
                    return cell;
                }
            }else {
                if (self.itemSections.count > (indexPath.section - 1)) {
                    NSMutableArray *sectionItems = self.itemSections[indexPath.section - 1];
                    return [self tableView:tableView cellForRowAtIndexPath:indexPath withSectionItems:sectionItems];
                }
            }
        }else {
            if (indexPath.section == 0){
                if (indexPath.row == 0) {
                    CategoryExplorationsCell *cell = [tableView dequeueReusableCellWithIdentifier:kCategoryExplorationsCellID forIndexPath:indexPath];
                    cell.collectionView.delegate = self;
                    cell.collectionView.dataSource = self;
                    return cell;
                }else {
                    if (self.itemSections.count > 0) {
                        NSMutableArray *sectionItems = self.itemSections[0];
                        if (sectionItems.count > (indexPath.row - 1)) {
                            ItemContent *itemContent = sectionItems[indexPath.row - 1];
                            Item *item = itemContent.contentInfo;
                            SearchResultRecipeItemCell *cell = [tableView dequeueReusableCellWithIdentifier:kSearchResultRecipeItemCellID forIndexPath:indexPath];
                            cell.recipeItem = item;
                            return cell;
                        }else if ((sectionItems.count + 1) == indexPath.row) {
                            SeparatorCell *cell = [tableView dequeueReusableCellWithIdentifier:kSeparatorCellID forIndexPath:indexPath];
                            return cell;
                        }
                    }
                }
            }else {
                if (self.itemSections.count > indexPath.section) {
                    NSMutableArray *sectionItems = self.itemSections[indexPath.section];
                    return [self tableView:tableView cellForRowAtIndexPath:indexPath withSectionItems:sectionItems];
                }
            }
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%@: %@", NSStringFromSelector(_cmd), indexPath);
    if (self.explorations.count == 0) {
        if (self.itemSections.count > indexPath.section) {
            NSMutableArray *sectionItems = self.itemSections[indexPath.section];
            return [self tableView:tableView heightForRowAtIndexPath:indexPath withSectionItems:sectionItems];
         }
    }else {
        if (self.isExplorationsAsIndependentSection) {
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {
                    return [CategoryExplorationsCell cellHeight];
                }else if (indexPath.row == 1) {
                    return [SeparatorCell cellHeight];
                }
            }else {
                if (self.itemSections.count > (indexPath.section - 1)) {
                    NSMutableArray *sectionItems = self.itemSections[indexPath.section - 1];
                    return [self tableView:tableView heightForRowAtIndexPath:indexPath withSectionItems:sectionItems];
                }
            }
        }else {
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {
                    return [CategoryExplorationsCell cellHeight];
                }else {
                    if (self.itemSections.count > 0) {
                        NSMutableArray *sectionItems = self.itemSections[0];
                        if (sectionItems.count > (indexPath.row - 1)) {
                            ItemContent *itemContent = sectionItems[indexPath.row - 1];
                            Item *item = itemContent.contentInfo;
                            return  [tableView fd_heightForCellWithIdentifier:kSearchResultRecipeItemCellID cacheByIndexPath:indexPath configuration:^(SearchResultRecipeItemCell *cell) {
                                cell.recipeItem = item;
                            }];
                        }else if (sectionItems.count + 1 == indexPath.row) {
                            return [SeparatorCell cellHeight];
                        }
                    }
                }
            }else {
                if (self.itemSections.count > indexPath.section) {
                    NSMutableArray *sectionItems = self.itemSections[indexPath.section];
                    return [self tableView:tableView heightForRowAtIndexPath:indexPath withSectionItems:sectionItems];
                }
            }
        }
    }
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    NSLog(@"%@: %ld", NSStringFromSelector(_cmd), section);
    if (self.explorations.count == 0) {
        if (self.itemSections.count > section) {
            NSMutableArray *sectionItems = self.itemSections[section];
            return [self tableView:tableView viewForHeaderWithSectionItems:sectionItems];
        }
    }else {
        if (self.isExplorationsAsIndependentSection) {
            if (section > 0) {
                if (self.itemSections.count > (section - 1)) {
                    NSMutableArray *sectionItems = self.itemSections[section - 1];
                    return [self tableView:tableView viewForHeaderWithSectionItems:sectionItems];
                }
            }
        }else {
            if (self.itemSections.count > section) {
                NSMutableArray *sectionItems = self.itemSections[section];
                return [self tableView:tableView viewForHeaderWithSectionItems:sectionItems];
            }
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    NSLog(@"%@: %ld", NSStringFromSelector(_cmd), section);
    if (self.explorations.count == 0) {
        if (self.itemSections.count > section) {
            NSMutableArray *sectionItems = self.itemSections[section];
            return [self tableView:tableView heightForHeaderWithSectionItems:sectionItems];
        }
    }else {
        if (self.isExplorationsAsIndependentSection) {
            if (section > 0) {
                if (self.itemSections.count > (section - 1)) {
                    NSMutableArray *sectionItems = self.itemSections[section - 1];
                    return [self tableView:tableView heightForHeaderWithSectionItems:sectionItems];
                }
            }
        }else {
            if (self.itemSections.count > section) {
                NSMutableArray *sectionItems = self.itemSections[section];
                return [self tableView:tableView heightForHeaderWithSectionItems:sectionItems];
            }
        }
    }
    return 0.0f;
}

#pragma mark - Private Methods
- (NSInteger)numberOfRowsWithCollectionItemContent:(ItemContent *)itemContent
{
    NSInteger numberOfRows = 0;
    if ([itemContent.style isEqualToString:@"user_collection"]) {
        numberOfRows = itemContent.count + 1;
    }else if ([itemContent.style isEqualToString:@"recipe_list_collection"]) {
        numberOfRows = itemContent.count + 2;
    }else if ([itemContent.style isEqualToString:@"goods_collection"]) {
        numberOfRows = itemContent.count + 2;
    }else if ([itemContent.style isEqualToString:@"related_query_collection"]) {
        numberOfRows = 2;
    }
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath withSectionItems:(NSMutableArray *)sectionItems
{
    if (sectionItems.count > 0){
        ItemContent *itemContent = sectionItems.firstObject;
        if ([itemContent.type isEqualToString:@"collection"]){
            if ([itemContent.style isEqualToString:@"user_collection"]) {
                NSArray *userItems = itemContent.contentArray;
                if (userItems.count > indexPath.row) {
                    ItemContent *nestedItemContent = userItems[indexPath.row];
                    CollectionUserItemCell *cell = [tableView dequeueReusableCellWithIdentifier:kCollectionUserItemCellID forIndexPath:indexPath];
                    cell.userItem = nestedItemContent.contentInfo;
                    return cell;
                }else if (userItems.count == indexPath.row) {
                    SeparatorCell *cell = [tableView dequeueReusableCellWithIdentifier:kSeparatorCellID forIndexPath:indexPath];
                    return cell;
                }
            }else if ([itemContent.style isEqualToString:@"recipe_list_collection"]) {
                NSArray *recipeMenuItems = itemContent.contentArray;
                if (recipeMenuItems.count > indexPath.row) {
                    ItemContent *nestedItemContent = recipeMenuItems[indexPath.row];
                    RelatedMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:kRelatedMenuCellID forIndexPath:indexPath];
                    cell.relatedMenuItem = nestedItemContent.contentInfo;
                    return cell;
                }else if(recipeMenuItems.count == indexPath.row){
                    ShowMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:kShowMoreCellID forIndexPath:indexPath];
                    cell.titleLabel.text = @"查看更多";
                    return cell;
                }else if ((recipeMenuItems.count + 1) == indexPath.row) {
                    SeparatorCell *cell = [tableView dequeueReusableCellWithIdentifier:kSeparatorCellID forIndexPath:indexPath];
                    return cell;
                }
            }else if ([itemContent.style isEqualToString:@"goods_collection"]) {
                NSArray *relatedProductItems = itemContent.contentArray;
                if (relatedProductItems.count > indexPath.row) {
                    ItemContent *nestedItemContent = relatedProductItems[indexPath.row];
                    RelatedProductsCell *cell = [tableView dequeueReusableCellWithIdentifier:kRelatedProductsCellID forIndexPath:indexPath];
                    cell.relatedGoodsItem = nestedItemContent.contentInfo;
                    return cell;
                }else if(relatedProductItems.count == indexPath.row){
                    ShowMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:kShowMoreCellID forIndexPath:indexPath];
                    cell.titleLabel.text = @"查看更多";
                    return cell;
                }else if (relatedProductItems.count + 1 == indexPath.row) {
                    SeparatorCell *cell = [tableView dequeueReusableCellWithIdentifier:kSeparatorCellID forIndexPath:indexPath];
                    return cell;
                }
            }else if ([itemContent.style isEqualToString:@"related_query_collection"]) {
                if (indexPath.row == 0) {
                    NSArray *relatedQueryItems = itemContent.contentArray;
                    RelatedSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:kRelatedSearchCellID forIndexPath:indexPath];
                    [relatedQueryItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        ItemContent *nestedItemContent = relatedQueryItems[idx];
                        if (idx == 0) {
                            cell.fistLabel.text = nestedItemContent.contentInfo.itemObject.name;
                        }else if (idx == 1) {
                            cell.secondLabel.text = nestedItemContent.contentInfo.itemObject.name;
                        }else if (idx == 2) {
                            cell.thirdLabel.text = nestedItemContent.contentInfo.itemObject.name;
                        }else if (idx == 3) {
                            cell.fourthLabel.text = nestedItemContent.contentInfo.itemObject.name;
                        }
                    }];
                    return cell;
                }else if (indexPath.row == 1) {
                    SeparatorCell *cell = [tableView dequeueReusableCellWithIdentifier:kSeparatorCellID forIndexPath:indexPath];
                    return cell;
                }
            }
            
        }else if ([itemContent.type isEqualToString:@"item"]) {
            if (sectionItems.count > indexPath.row) {
                SearchResultRecipeItemCell *cell = [tableView dequeueReusableCellWithIdentifier:kSearchResultRecipeItemCellID forIndexPath:indexPath];
                ItemContent *nestedItemContent = sectionItems[indexPath.row];
                cell.recipeItem = nestedItemContent.contentInfo;
                return cell;
            }else if (sectionItems.count == indexPath.row) {
                SeparatorCell *cell = [tableView dequeueReusableCellWithIdentifier:kSeparatorCellID forIndexPath:indexPath];
                return cell;
            }
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withSectionItems:(NSMutableArray *)sectionItems
{
    if (sectionItems.count > 0) {
        ItemContent *itemContent = sectionItems.firstObject;
        if ([itemContent.type isEqualToString:@"collection"]) {
            if ([itemContent.style isEqualToString:@"user_collection"]) {
                NSArray *userItems = itemContent.contentArray;
                if (userItems.count > indexPath.row) {
                    ItemContent *nestedItemContent = userItems[indexPath.row];
                    return [tableView fd_heightForCellWithIdentifier:kCollectionUserItemCellID cacheByIndexPath:indexPath configuration:^(CollectionUserItemCell *cell) {
                        cell.userItem = nestedItemContent.contentInfo;
                    }];
                }else if (userItems.count == indexPath.row) {
                    return [SeparatorCell cellHeight];
                }
            }else if ([itemContent.style isEqualToString:@"recipe_list_collection"]) {
                NSArray *relatedMenuItems = itemContent.contentArray;
                if (relatedMenuItems.count > indexPath.row) {
                    ItemContent *nestedItemContent = relatedMenuItems[indexPath.row];
                    return [tableView fd_heightForCellWithIdentifier:kRelatedMenuCellID cacheByIndexPath:indexPath configuration:^(RelatedMenuCell *cell) {
                        cell.relatedMenuItem = nestedItemContent.contentInfo;
                    }];
                }else if(relatedMenuItems.count == indexPath.row){
                    return [ShowMoreCell cellHeight];
                }else if (relatedMenuItems.count + 1 == indexPath.row) {
                    return [SeparatorCell cellHeight];
                }
            }else if ([itemContent.style isEqualToString:@"goods_collection"]) {
                NSArray *relatedGoodsItems = itemContent.contentArray;
                if (relatedGoodsItems.count > indexPath.row) {
                    ItemContent *nestedItemContent = relatedGoodsItems[indexPath.row];
                    return [tableView fd_heightForCellWithIdentifier:kRelatedProductsCellID cacheByIndexPath:indexPath configuration:^(RelatedProductsCell *cell) {
                        cell.relatedGoodsItem = nestedItemContent.contentInfo;
                    }];
                }else if(relatedGoodsItems.count == indexPath.row){
                    return [ShowMoreCell cellHeight];
                }else if (relatedGoodsItems.count + 1 == indexPath.row) {
                    return [SeparatorCell cellHeight];
                }
            }else if ([itemContent.style isEqualToString:@"related_query_collection"]) {
                if (indexPath.row == 0) {
                    return [RelatedSearchCell cellHeight];
                }else if (indexPath.row == 1) {
                    return [SeparatorCell cellHeight];
                }
            }
        }else if ([itemContent.type isEqualToString:@"item"]) {
            if (sectionItems.count > indexPath.row) {
                Item *item = itemContent.contentInfo;
                return [tableView fd_heightForCellWithIdentifier:kSearchResultRecipeItemCellID cacheByIndexPath:indexPath configuration:^(SearchResultRecipeItemCell *cell) {
                    cell.recipeItem = item;
                }];
            }else if (sectionItems.count == indexPath.row) {
                return [SeparatorCell cellHeight];
            }

        }
    }
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderWithSectionItems:(NSMutableArray *)sectionItems
{
    if (sectionItems.count > 0) {
        ItemContent *itemContent = sectionItems.firstObject;
        if ([itemContent.type isEqualToString:@"collection"]) {
            if ([itemContent.style isEqualToString:@"recipe_list_collection"]) {
                return  [self tableView:tableView viewForHeaderWithTitle:@"相关菜单"];
            }else if ([itemContent.style isEqualToString:@"goods_collection"]) {
                return [self tableView:tableView viewForHeaderWithTitle:@"相关商品"];
            }else if ([itemContent.style isEqualToString:@"related_query_collection"]) {
                return [self tableView:tableView viewForHeaderWithTitle:@"相关搜索"];
            }
        }
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderWithTitle:(NSString *)title
{
    CustomHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kSectionHeaderViewID];
    headerView.textLabel.text= title;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderWithSectionItems:(NSMutableArray *)sectionItems
{
    if (sectionItems.count > 0) {
        ItemContent *itemContent = sectionItems.firstObject;
        if ([itemContent.type isEqualToString:@"collection"]) {
            if ([itemContent.style isEqualToString:@"recipe_list_collection"]
                || [itemContent.style isEqualToString:@"goods_collection"]
                || [itemContent.style isEqualToString:@"related_query_collection"]) {
                return 40.0f;
            }
        }
    }
    return 0.0f;
}

#pragma mark - UICollectionView Delegate && DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.explorations.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ExplorationCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kExplorationCellID forIndexPath:indexPath];
    if (self.explorations.count > indexPath.row) {
        Exploration *exploration = self.explorations[indexPath.row];
        cell.titleLabel.text = exploration.name;
    }
    return cell;
}

#pragma mark - SearchInResultsControllerDelegate
- (void)searchInResultsControllerDidClickedDismissButton:(SearchInResultsController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchInResultsControllerDidSelectRowWithType:(ModalSelectCellType)type
{
    self.selectCellTypeOfPresented = type;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -

- (BOOL)hidesBottomBarWhenPushed
{
    return YES;
}
@end
