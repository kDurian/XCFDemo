//
//  HomeTableViewController.m
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 1/11/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "HomePageController.h"

#import "RecipeInitialEntryController.h"
#import "RecipeEditedController.h"

#import "RecipeSearchController.h"

#import "KitchenTopCell.h"
#import "KitchenNavCell.h"
#import "KitchenBannerAd1Cell.h"
#import "KitchenBannerAd2Cell.h"
#import "KitchenPopEventsCell.h"

#import "KitchenRecipeCell.h"
#import "KitchenArticleOfFoodCell.h"
#import "KitchenRecipeCollectionsCell.h"
#import "KitchenCreativePhotoCell.h"

#import "RecipeSectionHeaderCell.h"
#import "PublicSeparatorCell.h"

#import "NSObject+YYModel.h"
#import "MJRefresh.h"
#import "Masonry.h"
#import <SVProgressHUD/SVProgressHUD.h>

#import "NetworkManager+HomePageRequest.h"
#import "NetworkManager+RecipeRequest.h"
#import "NetworkManager+HomePageAd1Request.h"
#import "NetworkManager+HomePageAd2Request.h"
#import "NetworkManager+YearKeyword.h"
#import "NetworkManager+HourKeyword.h"

#import "HomePageCellManager.h"

#import "HomePageModel.h"
#import "HomePageAdModel.h"
#import "HomePageRecipeModel.h"

#import "KeywordModel.h"

#define kHeaderInSectionBackgroundColor [UIColor colorWithRed:245/255.0f green:245/255.0f blue:236/255.0f alpha:1];

extern NSString * const kRecipeCollectionsCellID;
extern NSString * const kRecipeItemCellID;
extern NSString * const kArticleOfFoodCellID;
extern NSString * const kCreativePhotoCellID;
extern NSString * const kPublicSeparatorCellID;
extern NSString * const kRecipeSectionHeaderCellID;
extern NSString * const kHomeIssueItemTPL6TableViewCellID;


static NSString *const kRecipeInitialControllerStoryboardID = @"kRecipeInitialControllerID";
static NSString * const kRecipeCreatedStoryboardName = @"RecipeCreated";


@interface HomePageController ()<UIViewControllerTransitioningDelegate, UISearchBarDelegate>
{
    RecipeInfo           *info;
    AdContent            *ad1Content;
    AdContent            *ad2Content;
    HomePageContentModel *navContent;
    KeywordContent *yearKeyword;
    KeywordContent *hourKeyword;
}
@property(nonatomic, strong) NSMutableArray *recipeContents;

@end

@implementation HomePageController
- (NSMutableArray *)recipeContents
{
    if (_recipeContents == nil) {
        _recipeContents = [NSMutableArray array];
    }
    return _recipeContents;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [NSThread sleepForTimeInterval:3];
    
    for (UITabBarItem *item in self.tabBarController.tabBar.items)
    {
        UIImage *image = item.selectedImage;
        UIImage *originalImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.selectedImage = originalImage;
    }
    
    [self setupHomePageNavBar];
    
    [self setupTableView];
    
    [self registerNibForCell];
    
    [self fetchDataFromNetwork];
}

#pragma mark - private methods
- (void)setupHomePageNavBar
{
    //设置导航栏左侧按钮
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"homepageCreateRecipeButton"] style:UIBarButtonItemStylePlain target:self action:@selector(createRecipe)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    //设置导航栏右侧按钮
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"buylistButtonImage"] style:UIBarButtonItemStylePlain target:self action:@selector(goToBuyList)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    //设置搜索栏
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 240, 40)];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:titleView.bounds];
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchBar.placeholder = @"菜谱、食材";
    searchBar.delegate = self;
    searchBar.tintColor = [UIColor blackColor];
    [titleView addSubview:searchBar];
    self.navigationItem.titleView = titleView;
}

- (void)createRecipe
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:kRecipeCreatedStoryboardName bundle:nil];
    RecipeInitialEntryController *recipeInitialEntryController = [storyBoard instantiateViewControllerWithIdentifier:kRecipeInitialControllerStoryboardID];

    [self.navigationController pushViewController:recipeInitialEntryController animated:YES];
}

- (void)goToBuyList
{
    
}

- (void)setupTableView
{
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)registerNibForCell
{
    [self.tableView registerNib:[UINib nibWithNibName:@"KitchenRecipeCollectionsCell" bundle:nil] forCellReuseIdentifier:kRecipeCollectionsCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"KitchenRecipeCell" bundle:nil] forCellReuseIdentifier:kRecipeItemCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"KitchenArticleOfFoodCell" bundle:nil] forCellReuseIdentifier:kArticleOfFoodCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"KitchenCreativePhotoCell" bundle:nil] forCellReuseIdentifier:kCreativePhotoCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"PublicSeparatorCell" bundle:nil] forCellReuseIdentifier:kPublicSeparatorCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"RecipeSectionHeaderCell" bundle:nil] forCellReuseIdentifier:kRecipeSectionHeaderCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeIssueItemTPL6TableViewCell" bundle:nil] forCellReuseIdentifier:kHomeIssueItemTPL6TableViewCellID];
}

- (void)fetchDataFromNetwork
{
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    [NetworkManager getRecipeInfoWithSuccBlock:^(BaseEntity *entity) {
        HomePageRecipeResponse *response = (HomePageRecipeResponse *)entity;
        info = response.content;
        [self.recipeContents addObject:info];
        dispatch_group_leave(group);
    } andFailBlock:^(BaseEntity *entity) {
        dispatch_group_leave(group);
    } atDate:nil];
    
    dispatch_group_enter(group);
    [NetworkManager getHomePageInfoWithSuccBlock:^(BaseEntity *entity) {
        HomePageResponse *response = (HomePageResponse *)entity;
        navContent = response.content;
        dispatch_group_leave(group);
    } withFailedBlock:^(BaseEntity *entity) {
        [SVProgressHUD showErrorWithStatus:@"加载数据失败"];
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [NetworkManager getAd1ContentWithSuccBlock:^(BaseEntity *entity) {
        HomePageAdResponse *response = (HomePageAdResponse *)entity;
        ad1Content = response.content;
        dispatch_group_leave(group);
        
    } withFailBlock:^(BaseEntity *entity) {
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [NetworkManager getAd2ContentWithSuccBlock:^(BaseEntity *entity) {
        HomePageAdResponse *response = (HomePageAdResponse *)entity;
        ad2Content = response.content;
        dispatch_group_leave(group);
    } withFailBlock:^(BaseEntity *entity) {
        dispatch_group_leave(group);
    }];

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
    [NetworkManager getYearKeywordsWithSuccBlock:^(BaseEntity *entity) {
        KeywordResponse *response = (KeywordResponse *)entity;
        yearKeyword = response.content;
    } OrFailedBlock:^(BaseEntity *entity) {
        
    }];
    
    [NetworkManager getHourKeywordsWithSuccBlock:^(BaseEntity *entity) {
        KeywordResponse *response = (KeywordResponse *)entity;
        hourKeyword = response.content;
    } OrFailedBlock:^(BaseEntity *entity) {
        
    }];
}

#pragma mark - MJRefresh CallBack
- (void)loadMoreData
{
    if (info.cursor.has_next)
    {
        __weak typeof(self) weakself = self;

        [NetworkManager getRecipeInfoWithSuccBlock:^(BaseEntity *entity) {
            HomePageRecipeResponse *response = (HomePageRecipeResponse *)entity;
            info = response.content;
            [weakself.recipeContents addObject:info];
            [weakself.tableView reloadData];
            [weakself.tableView.mj_footer endRefreshing];
            
        } andFailBlock:^(BaseEntity *entity) {
            
        } atDate:@"2016-03-10"];
    }
    
}

- (void)refreshData
{
    
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"RecipeSearchResults" bundle:nil];
    RecipeSearchController *searchController = [storyboard instantiateInitialViewController];
    searchController.hourKeyword = hourKeyword;
    searchController.yearKeyword = yearKeyword;
    [self.navigationController pushViewController:searchController animated:YES];
    return NO;
}

#pragma mark - UITableView DataSource && Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.recipeContents.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0){
        return 5;
    }else
    {
        info = self.recipeContents[section - 1];
        RecipeIssue *issue = info.issues[0];
        return issue.itemsCount * 2 + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0:
            case 1:
            case 4:
            {
                UITableViewCell *cell = [HomePageCellManager cellWithTableView:tableView withItem:navContent withIndexPath:indexPath];
                return cell;
            }
                break;
            case 2:
            {
                UITableViewCell *cell = [HomePageCellManager cellWithTableView:tableView withItem:ad1Content withIndexPath:indexPath];
                return cell;
            }
                break;
            case 3:
            {
                UITableViewCell *cell = [HomePageCellManager cellWithTableView:tableView withItem:ad2Content withIndexPath:indexPath];
                return cell;
            }
                break;
            default:
                break;
        }
        
    }else
    {
        info = self.recipeContents[indexPath.section - 1];
        RecipeIssue *issue = info.issues[0];

        if (indexPath.row == 0) {
            UITableViewCell *cell = [HomePageCellManager cellWithTableView:tableView withItem:issue withIndexPath:indexPath];
            
            
            return cell;
        }
        if (indexPath.row % 2 != 0) {
            UITableViewCell *cell = [HomePageCellManager cellWithTableView:tableView withItem:issue.items[(indexPath.row - 1) / 2] withIndexPath:indexPath];
            return cell;
        }else
        {
            UITableViewCell *cell = [HomePageCellManager cellWithTableView:tableView withItem:nil withIndexPath:indexPath];
            return cell;
        }
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight = 0.0f;
    cellHeight = [HomePageCellManager heightOFCellWithIndexPath:indexPath withRecipeInfo:info OrAdcontent:ad2Content];
    return cellHeight;
}

@end
