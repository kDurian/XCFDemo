//
//  FeedsController.m
//  XCFDemo
//
//  Created by Durian on 5/22/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "FeedsController.h"
#import "NetworkManager+Feeds.h"
#import "Feeds.h"
#import "FeedsCell.h"
#import "UITableView+FDTemplateLayoutCell.h"

typedef NS_ENUM(NSUInteger, FeedsKind) {
    FeedsKindRecipe = 1005,
    FeedsKindDish = 1001
};

static NSString * const kFeedsDishPhotosCellID = @"kFeedsDishPhotosCell";
static NSString * const kFeedsRecipePhotoCellID = @"kFeedsRecipePhotoCell";
static NSString * const kFeedsInfoCellID = @"kFeedsInfoCell";
static NSString * const kFeedsDescCellID = @"kFeedsDescCell";
static NSString * const kFeedsDishDiggCellID = @"kFeedsDishDiggCell";
static NSString * const kFeedsDishCommentNumCellID = @"kFeedsDishCommentNumCell";
static NSString * const kFeedsDishCommentCellID = @"kFeedsDishCommentCell";
static NSString * const kFeedsDishMoreCellID = @"kFeedsDishMoreCell";
static NSString * const kFeedsRecipeMoreCellID = @"kFeedsRecipeMoreCell";

@interface FeedsController ()
@property(nonatomic, strong) NSMutableArray *feeds;
@property(nonatomic, strong) FeedDish *curDish;
@property(nonatomic, strong) FeedRecipe *curRecipe;
@end

@implementation FeedsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.feeds = [NSMutableArray new];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self setNavBar];
    [self getData];
}

#pragma mark -
- (void)setNavBar
{
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]
                                          initWithImage:[UIImage imageNamed:@"backStretchBackgroundNormal"]
                                          style:UIBarButtonItemStylePlain
                                          target:self
                                          action:@selector(backToPreviousPage)];
    
    UIBarButtonItem *rightBarButtonItem1 = [[UIBarButtonItem alloc]
                                            initWithImage:[UIImage imageNamed:@"creatdishicon"]
                                            style:UIBarButtonItemStylePlain
                                            target:self
                                            action:@selector(uploadRecipe)];
    
    UIBarButtonItem *rightBarButtonItem2 = [[UIBarButtonItem alloc]
                                            initWithImage:[UIImage imageNamed:@"notification"]
                                            style:UIBarButtonItemStylePlain
                                            target:self
                                            action:@selector(showNotification)];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.rightBarButtonItems = @[rightBarButtonItem1, rightBarButtonItem2];
    self.navigationItem.title = @"关注动态";
}

- (void)backToPreviousPage
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)uploadRecipe
{
    
}

- (void)showNotification
{
    
}

- (void)getData
{
    [NetworkManager getFeedsWithSuccBlock:^(BaseEntity *entity) {
        FeedsResponse *response = (FeedsResponse *)entity;
        self.feeds = response.content.feeds.mutableCopy;
    } OrFailedBlock:^(BaseEntity *entity) {
        NSLog(@"Failed get feeds data.");
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.feeds.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.feeds.count > section) {
        Feed *feed = self.feeds[section];
        if (feed.kind == FeedsKindRecipe) {
            FeedRecipe *recipe = feed.recipe;
            if (recipe.desc.length == 0) {
                return 3;
            }else {
                return 4;
            }
        }else if(feed.kind == FeedsKindDish) {
            FeedDish *dish = feed.dish;
            if (dish.desc.length == 0) {
                if (dish.digg_users.count == 0) {
                    if (dish.latest_comments.count == 0) {
                        return 3;
                    }else if(dish.latest_comments.count <= 2) {
                        return 3 + dish.latest_comments.count;
                    }else if (dish.latest_comments.count > 2) {
                        return 3 + 1 + 2;
                    }
                }else {
                    if (dish.latest_comments.count == 0) {
                        return 4;
                    }else if(dish.latest_comments.count <= 2) {
                        return 4 + dish.latest_comments.count;
                    }else if (dish.latest_comments.count > 2) {
                        return 4 + 1 + 2;
                    }
                }
            }else {
                if (dish.digg_users.count == 0) {
                    if (dish.latest_comments.count == 0) {
                        return 4;
                    }else if(dish.latest_comments.count <= 2) {
                        return 4 + dish.latest_comments.count;
                    }else if (dish.latest_comments.count > 2) {
                        return 4 + 1 + 2;
                    }
                }else {
                    if (dish.latest_comments.count == 0) {
                        return 5;
                    }else if(dish.latest_comments.count <= 2) {
                        return 5 + dish.latest_comments.count;
                    }else if (dish.latest_comments.count > 2) {
                        return 5 + 1 + 2;
                    }
                }
            }
        }
    }
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.feeds.count > indexPath.section) {
        Feed *feed = self.feeds[indexPath.section];
        
        switch (feed.kind) {
            case FeedsKindRecipe:
            {
                FeedRecipe *recipe = feed.recipe;
                self.curRecipe = recipe;
                if (indexPath.row == 0) {
                    FeedsRecipePhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:kFeedsRecipePhotoCellID forIndexPath:indexPath];
                    cell.recipe = recipe;
                    return cell;
                }
                if (indexPath.row == 1) {
                    FeedsInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kFeedsInfoCellID forIndexPath:indexPath];
                    cell.recipe = recipe;
                    return cell;
                }
                NSInteger lastRowNum = [tableView numberOfRowsInSection:indexPath.section] - 1;
                if (indexPath.row == lastRowNum) {
                    FeedsRecipeMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:kFeedsRecipeMoreCellID forIndexPath:indexPath];
                    [cell.showMoreButton addTarget:self action:@selector(showMoreButtonOfRecipeDidClicked) forControlEvents:UIControlEventTouchUpInside];
                    return cell;
                }
                if (recipe.desc.length > 0) {
                    if (indexPath.row == 2) {
                        FeedsDescCell *cell = [tableView dequeueReusableCellWithIdentifier:kFeedsDescCellID forIndexPath:indexPath];
                        cell.recipe = recipe;
                        return cell;
                    }
                }
            }break;
                
            case FeedsKindDish:
            {
                FeedDish *dish = feed.dish;
                self.curDish = dish;
                if (indexPath.row == 0) {
                    FeedsDishPhotosCell *cell = [tableView dequeueReusableCellWithIdentifier:kFeedsDishPhotosCellID forIndexPath:indexPath];
                    cell.dish = dish;
                    return cell;
                }
                if (indexPath.row == 1) {
                    FeedsInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kFeedsInfoCellID forIndexPath:indexPath];
                    cell.dish = dish;
                    return cell;
                }
                NSInteger lastRowNum = [tableView numberOfRowsInSection:indexPath.section] - 1;
                if (indexPath.row == lastRowNum) {
                    FeedsDishMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:kFeedsDishMoreCellID forIndexPath:indexPath];
                    [cell.diggButton addTarget:self action:@selector(diggButtonOfDishDidClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.commentButton addTarget:self action:@selector(commentButtonOfDishDidClicked) forControlEvents:UIControlEventTouchUpInside];
                    [cell.showMoreButton addTarget:self action:@selector(showMoreButtonOfDishDidClicked) forControlEvents:UIControlEventTouchUpInside];
                    return cell;
                }
                
                if (dish.desc.length == 0) { //无简介
                    if (dish.digg_users.count == 0) { //无简介，无点赞
                        return [self tableView:tableView cellForRowAtIndexPath:indexPath WithBaseNumber:2 andFeedRecipe:dish];
                    }else { //无简介，有点赞
                        if (indexPath.row == 2) {
                            FeedsDishDiggCell *cell = [tableView dequeueReusableCellWithIdentifier:kFeedsDishDiggCellID forIndexPath:indexPath];
                            cell.dish = dish;
                            return cell;
                        }
                        return [self tableView:tableView cellForRowAtIndexPath:indexPath WithBaseNumber:3 andFeedRecipe:dish];
                    }
                }else {//有简介
                    if (indexPath.row == 2) {
                        FeedsDescCell *cell = [tableView dequeueReusableCellWithIdentifier:kFeedsDescCellID forIndexPath:indexPath];
                        cell.dish = dish;
                        return cell;
                    }
                    if (dish.digg_users.count == 0) { //有简介，无点赞
                        return [self tableView:tableView cellForRowAtIndexPath:indexPath WithBaseNumber:3 andFeedRecipe:dish];
                    }else { //有简介，有点赞
                        if (indexPath.row == 3) {
                            FeedsDishDiggCell *cell = [tableView dequeueReusableCellWithIdentifier:kFeedsDishDiggCellID forIndexPath:indexPath];
                            cell.dish = dish;
                            return cell;
                        }
                        return [self tableView:tableView cellForRowAtIndexPath:indexPath WithBaseNumber:4 andFeedRecipe:dish];
                    }
                }

            }break;
            default:
                break;
        }
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView  cellForRowAtIndexPath:(NSIndexPath *)indexPath WithBaseNumber:(NSInteger)baseNumber andFeedRecipe:(FeedDish *)dish
{
    NSInteger count = dish.latest_comments.count;
    if (count > 0 && count <= 2) { //评论数小于3
        if (indexPath.row < count + baseNumber) {
            FeedsDishCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:kFeedsDishCommentCellID forIndexPath:indexPath];
            cell.commment = dish.latest_comments[indexPath.row - baseNumber];
            return cell;
        }
    }else if (count > 2) { //评论数大于2
        if (indexPath.row == baseNumber) {
            FeedsDishCommentNumCell *cell = [tableView dequeueReusableCellWithIdentifier:kFeedsDishCommentNumCellID forIndexPath:indexPath];
            cell.dish = dish;
            return cell;
        }else if (indexPath.row == baseNumber + 1) {
            FeedsDishCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:kFeedsDishCommentCellID forIndexPath:indexPath];
            cell.commment = dish.latest_comments[count-2];
            return cell;
        }else if (indexPath.row == baseNumber + 2) {
            FeedsDishCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:kFeedsDishCommentCellID forIndexPath:indexPath];
            cell.commment = dish.latest_comments[count - 1];
            return cell;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.feeds.count > indexPath.section) {
        Feed *feed = self.feeds[indexPath.section];
        switch (feed.kind) {
            case FeedsKindRecipe:{
                FeedRecipe *recipe = feed.recipe;
                if (indexPath.row == 0) {
                    return [tableView fd_heightForCellWithIdentifier:kFeedsRecipePhotoCellID cacheByIndexPath:indexPath configuration:^(FeedsRecipePhotoCell *cell) {
                        cell.recipe = recipe;
                    }];
                }
                if (indexPath.row == 1) {
                    return [tableView fd_heightForCellWithIdentifier:kFeedsInfoCellID cacheByIndexPath:indexPath configuration:^(FeedsInfoCell *cell) {
                        cell.recipe = recipe;
                    }];
                }
                NSInteger lastRowNum = [tableView numberOfRowsInSection:indexPath.section] - 1;
                if (indexPath.row == lastRowNum) {
                    return [tableView fd_heightForCellWithIdentifier:kFeedsRecipeMoreCellID cacheByIndexPath:indexPath configuration:^(FeedsRecipeMoreCell *cell) {
                    }];
                }
                if (recipe.desc.length > 0) {
                    if (indexPath.row == 2) {
                        return [tableView fd_heightForCellWithIdentifier:kFeedsDescCellID cacheByIndexPath:indexPath configuration:^(FeedsDescCell *cell) {
                            cell.recipe = recipe;
                        }];
                    }
                }
            }break;
            case FeedsKindDish:{
                FeedDish *dish = feed.dish;
                if (indexPath.row == 0) {
                    return [tableView fd_heightForCellWithIdentifier:kFeedsDishPhotosCellID cacheByIndexPath:indexPath configuration:^(FeedsDishPhotosCell *cell) {
                        cell.dish = dish;
                    }];
                }
                if (indexPath.row == 1) {
                    return [tableView fd_heightForCellWithIdentifier:kFeedsInfoCellID cacheByIndexPath:indexPath configuration:^(FeedsInfoCell *cell) {
                        cell.dish = dish;
                    }];
                }
                NSInteger lastRowNum = [tableView numberOfRowsInSection:indexPath.section] - 1;
                if (indexPath.row == lastRowNum) {
                    return [tableView fd_heightForCellWithIdentifier:kFeedsDishMoreCellID cacheByIndexPath:indexPath configuration:^(FeedsDishMoreCell *cell) {
                        cell.dish = dish;
                    }];
                }
                
                if (dish.desc.length == 0) { //无简介
                    if (dish.digg_users.count == 0) { //无简介，无点赞
                        return [self tableView:tableView heightForRowAtIndexPath:indexPath WithBaseNumber:2 andFeedDish:dish];
                    }else { //无简介，有点赞
                        if (indexPath.row == 2) {
                            return [tableView fd_heightForCellWithIdentifier:kFeedsDishDiggCellID cacheByIndexPath:indexPath configuration:^(FeedsDishDiggCell *cell) {
                                cell.dish = dish;
                            }];
                        }
                        return [self tableView:tableView heightForRowAtIndexPath:indexPath WithBaseNumber:3 andFeedDish:dish];
                    }
                }else {//有简介
                    if (indexPath.row == 2) {
                        return [tableView fd_heightForCellWithIdentifier:kFeedsDescCellID cacheByIndexPath:indexPath configuration:^(FeedsDescCell *cell) {
                            cell.dish = dish;
                        }];
                    }
                    if (dish.digg_users.count == 0) { //有简介，无点赞
                        return [self tableView:tableView heightForRowAtIndexPath:indexPath WithBaseNumber:3 andFeedDish:dish];
                    }else { //有简介，有点赞
                        if (indexPath.row == 3) {
                            return [tableView fd_heightForCellWithIdentifier:kFeedsDishDiggCellID cacheByIndexPath:indexPath configuration:^(FeedsDishDiggCell *cell) {
                                cell.dish = dish;
                            }];
                        }
                        return [self tableView:tableView heightForRowAtIndexPath:indexPath WithBaseNumber:4 andFeedDish:dish];
                    }
                }
                
            }break;
            default:
                break;
        }
    }
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath WithBaseNumber:(NSInteger)baseNumber andFeedDish:(FeedDish *)dish{
    NSInteger count = dish.latest_comments.count;
    if (count > 0 && count <= 2) { //评论数小于3
        if (indexPath.row < count + baseNumber) {
            return [tableView fd_heightForCellWithIdentifier:kFeedsDishCommentCellID cacheByIndexPath:indexPath configuration:^(FeedsDishCommentCell *cell) {
                cell.commment = dish.latest_comments[indexPath.row - baseNumber];
            }];
        }
    }else if (count > 2) { //评论数大于2
        if (indexPath.row == baseNumber) {
            return [tableView fd_heightForCellWithIdentifier:kFeedsDishCommentNumCellID cacheByIndexPath:indexPath configuration:^(FeedsDishCommentNumCell *cell) {
                cell.dish = dish;
            }];
        }else if (indexPath.row == baseNumber + 1) {
            return [tableView fd_heightForCellWithIdentifier:kFeedsDishCommentCellID cacheByIndexPath:indexPath configuration:^(FeedsDishCommentCell *cell) {
                cell.commment = dish.latest_comments[count - 2];
            }];
        }else if (indexPath.row == baseNumber + 2) {
            return [tableView fd_heightForCellWithIdentifier:kFeedsDishCommentCellID cacheByIndexPath:indexPath configuration:^(FeedsDishCommentCell *cell) {
                cell.commment = dish.latest_comments[count - 1];
            }];
        }
    }
    return 0.0;
}

#pragma mark - Dish Jump Logic
- (void)diggButtonOfDishDidClicked:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
//        NSString *id = self.curDish.id;
        // http://api.xiachufang.com/v2/dishes/116935705/digg.json
    }else {
        // http://api.xiachufang.com/v2/dishes/116935705/cancel_digg.json
    }
}

- (void)commentButtonOfDishDidClicked{
    
}

- (void)showMoreButtonOfDishDidClicked{
    
}

#pragma mark - Recipe Jump Logic
- (void)showMoreButtonOfRecipeDidClicked{
    
}
@end
