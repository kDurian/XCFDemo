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
#import "HomeIssueItemTPL6TableViewCell.h"

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

#import "HomePageModel.h"
#import "HomePageAdModel.h"
#import "HomePageRecipeModel.h"
#import "KeywordModel.h"

#define kHeaderInSectionBackgroundColor [UIColor colorWithRed:245/255.0f green:245/255.0f blue:236/255.0f alpha:1];

static const CGFloat kKitchenTopCellHeight = 110.0f;
static const CGFloat kKitchenNavCellHeight = 80.0f;
static const CGFloat kKitchenBannerAd1CellHeight = 44.0f;
static const CGFloat kKitchenBannerAd2CellHeight = 75.0f;
static const CGFloat kKitchenPopEventsCellHeight = 80.0f;

static const CGFloat kRecipeSectionHeaderCellHeight = 50.0f;
static const CGFloat kPublicSeparatorCellHeight = 10.0f;

static const CGFloat kArticleOfFoodCellHeight = 270;
static const CGFloat kRecipeCollectionsCellHeight = 255;
static const CGFloat kCreativePhotoCellHeight = 375;
static const CGFloat kRecipeItemCellHeight = 280;

static NSString * const kKitchenTopCellID = @"kKitchenTopCellID";
static NSString * const kKitchenNavCellID = @"kKitchenNavCellID";
static NSString * const kKitchenBannerAd1CellID = @"kKitchenBannerAd1CellID";
static NSString * const kKitchenBannerAd2CellID = @"kKitchenBannerAd2CellID";
static NSString * const kKitchenPopEventsCellID = @"kKitchenPopEventsCellID";

static NSString * const kRecipeSectionHeaderCellID = @"kRecipeSectionHeaderCellID";
static NSString * const kPublicSeparatorCellID = @"kPublicSeparatorCellID";

static NSString * const kRecipeCollectionsCellID = @"kRecipeCollectionsCellID";
static NSString * const kRecipeItemCellID = @"kRecipeItemCellID";
static NSString * const kArticleOfFoodCellID = @"kArticleOfFoodCellID";
static NSString * const kCreativePhotoCellID = @"kCreativePhotoCellID";
static NSString * const kHomeIssueItemTPL6TableViewCellID = @"kHomeIssueItemTPL6TableViewCellID";

static NSString * const kRecipeInitialControllerStoryboardID = @"kRecipeInitialControllerID";
static NSString * const kRecipeCreatedStoryboardName = @"RecipeCreated";

typedef NS_ENUM(NSInteger, HomePageIssueItemCellStyle)
{
    TPL1ArticleOfFoodCellStyle      = 1,
    TPL2RecipeCollectionsCellStyle  = 2,
    TPL3UnDefinedCellStyle          = 3,
    TPL4CreativePhotoCellStyle      = 4,
    TPL5RecipeCellStyle             = 5,
    TPL6UnKnownCellStyle            = 6
};

@interface HomePageController ()<UISearchBarDelegate>{
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
- (void)viewDidLoad{
    [super viewDidLoad];
    self.recipeContents = [NSMutableArray new];
    [NSThread sleepForTimeInterval:3];
    for (UITabBarItem *item in self.tabBarController.tabBar.items){
        UIImage *image = item.selectedImage;
        UIImage *originalImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.selectedImage = originalImage;
    }
    [self setNavBar];
    [self setTableView];
    [self registerNibForCell];
    [self fetchDataFromNetwork];
}

#pragma mark - private methods
- (void)setNavBar{
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

- (void)createRecipe{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:kRecipeCreatedStoryboardName bundle:nil];
    RecipeInitialEntryController *recipeInitialEntryController = [storyBoard instantiateViewControllerWithIdentifier:kRecipeInitialControllerStoryboardID];

    [self.navigationController pushViewController:recipeInitialEntryController animated:YES];
}

- (void)goToBuyList{
    
}

- (void)setTableView{
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)registerNibForCell{
    [self.tableView registerNib:[UINib nibWithNibName:@"KitchenRecipeCollectionsCell" bundle:nil] forCellReuseIdentifier:kRecipeCollectionsCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"KitchenRecipeCell" bundle:nil] forCellReuseIdentifier:kRecipeItemCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"KitchenArticleOfFoodCell" bundle:nil] forCellReuseIdentifier:kArticleOfFoodCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"KitchenCreativePhotoCell" bundle:nil] forCellReuseIdentifier:kCreativePhotoCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"PublicSeparatorCell" bundle:nil] forCellReuseIdentifier:kPublicSeparatorCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"RecipeSectionHeaderCell" bundle:nil] forCellReuseIdentifier:kRecipeSectionHeaderCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeIssueItemTPL6TableViewCell" bundle:nil] forCellReuseIdentifier:kHomeIssueItemTPL6TableViewCellID];
}

- (void)fetchDataFromNetwork{
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
- (void)loadMoreData{
    if (info.cursor.has_next){
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

- (void)refreshData{
    
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"RecipeSearchResults" bundle:nil];
    RecipeSearchController *searchController = [storyboard instantiateInitialViewController];
    searchController.hourKeyword = hourKeyword;
    searchController.yearKeyword = yearKeyword;
    [self.navigationController pushViewController:searchController animated:YES];
    return NO;
}

#pragma mark - UITableView DataSource && Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.recipeContents.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0){
        return 5;
    }else{
        info = self.recipeContents[section - 1];
        RecipeIssue *issue = info.issues[0];
        return issue.itemsCount * 2 + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        switch (indexPath.row){
            case 0:{
                KitchenTopCell *cell = [tableView dequeueReusableCellWithIdentifier:kKitchenTopCellID forIndexPath:indexPath];
                cell.content = navContent;
                return cell;
            }break;
            case 1:{
                KitchenNavCell *cell = [tableView dequeueReusableCellWithIdentifier:kKitchenNavCellID forIndexPath:indexPath];
                cell.content = navContent;
                return cell;
            }break;
            case 4:{
                KitchenPopEventsCell *cell = [tableView dequeueReusableCellWithIdentifier:kKitchenPopEventsCellID forIndexPath:indexPath];
                cell.content = navContent;
                return cell;
            }break;
            case 2:{
                KitchenBannerAd1Cell *cell = [tableView dequeueReusableCellWithIdentifier:kKitchenBannerAd1CellID forIndexPath:indexPath];
                cell.content = ad1Content;
                return cell;
            }break;
            case 3:{
                KitchenBannerAd2Cell *cell = [tableView dequeueReusableCellWithIdentifier:kKitchenBannerAd2CellID forIndexPath:indexPath];
                cell.content = ad2Content;
                return cell;
            }break;
            default:
                break;
        }
    }else{
        info = self.recipeContents[indexPath.section - 1];
        RecipeIssue *issue = info.issues[0];
        if (indexPath.row == 0) {
            RecipeSectionHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecipeSectionHeaderCellID forIndexPath:indexPath];
            return cell;
        }
        if (indexPath.row % 2 == 0) {
            PublicSeparatorCell *cell = [tableView dequeueReusableCellWithIdentifier:kPublicSeparatorCellID forIndexPath:indexPath];
            return cell;
        }else{
            RecipeItem *recipeItem = issue.items[(indexPath.row - 1) / 2];
            switch (recipeItem.cellTemplate) {
                case TPL1ArticleOfFoodCellStyle:{
                    KitchenArticleOfFoodCell *cell = [tableView dequeueReusableCellWithIdentifier:kArticleOfFoodCellID forIndexPath:indexPath];
                    cell.item = recipeItem;
                    return cell;
                }break;
                case TPL2RecipeCollectionsCellStyle:{
                    KitchenRecipeCollectionsCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecipeCollectionsCellID forIndexPath:indexPath];
                    cell.item = recipeItem;
                    return cell;
                }break;
                case TPL4CreativePhotoCellStyle:{
                    KitchenCreativePhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:kCreativePhotoCellID forIndexPath:indexPath];
                    cell.item = recipeItem;
                    return cell;
                }break;
                case TPL5RecipeCellStyle:{
                    KitchenRecipeCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecipeItemCellID forIndexPath:indexPath];
                    cell.item = recipeItem;
                    return cell;
                }break;
                case TPL6UnKnownCellStyle:{
                    HomeIssueItemTPL6TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHomeIssueItemTPL6TableViewCellID forIndexPath:indexPath];
                    cell.item = recipeItem;
                    return cell;
                }break;
                default:
                    break;
            }
        }
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        switch (indexPath.row){
            case 0:
                return kKitchenTopCellHeight;
                break;
            case 1:
                return kKitchenNavCellHeight;
                break;
            case 2:{
                if (ad2Content.adType == 0) {
                    return 0.0f;
                }else{
                    return kKitchenBannerAd1CellHeight;
                }
            }break;
            case 3:{
                if (ad2Content.adType == 0) {
                    return 0.0f;
                }else{
                    return kKitchenBannerAd2CellHeight;
                }
            }break;
            case 4:
                return kKitchenPopEventsCellHeight;
                break;
                
            default:
                break;
        }
    }else{
        RecipeIssue *issue = info.issues[0];
        if (indexPath.row == 0) {
            return kRecipeSectionHeaderCellHeight;
        }
        if (indexPath.row % 2 == 0){
            return kPublicSeparatorCellHeight;
        }else{
            RecipeItem *item = issue.items[(indexPath.row - 1) / 2];
            switch (item.cellTemplate) {
                case 1:
                    return kArticleOfFoodCellHeight;
                    break;
                case 2:
                    return kRecipeCollectionsCellHeight;
                    break;
                case 4:
                    return kCreativePhotoCellHeight;
                    break;
                case 5:
                    return kRecipeItemCellHeight;
                    break;
                default:
                    break;
            }
        }
    }
    return 0.0f;
}
@end
