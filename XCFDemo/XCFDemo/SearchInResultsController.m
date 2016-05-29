//
//  SearchInResultsController.m
//  XCFDemo
//
//  Created by Durian on 5/18/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "SearchInResultsController.h"

#import "SearchInResultsTopCell.h"
#import "AllRecipesCell.h"
#import "HighScoreOrPopMakedCell.h"
#import "GoodsUserMenuGenericCell.h"

#import "CustomPresentController.h"

#import "Masonry.h"

static NSString * const kSearchInResultsTopCellID = @"kSearchInResultsTopCell";
static NSString * const kAllRecipesCellID = @"kAllRecipesCell";
static NSString * const kHighScoreOrPopMakedCellID = @"kHighScoreOrPopMakedCell";
static NSString * const kGoodsUserMenuGenericCellID = @"kGoodsUserMenuGenericCell";

static const CGFloat kSearchInResultsTopCellHeight = 45.0f;
static const CGFloat kSearchInResultsGenericCellHeight = 50.0f;

@interface SearchInResultsController ()<UIViewControllerTransitioningDelegate>
@property(nonatomic, strong) CustomPresentController *presentController;
@property(nonatomic, weak) UIViewController * presentingController;
@property(nonatomic, assign) ModalSelectCellType curType;
@property(nonatomic, strong) NSIndexPath *currentSelectIndexPath;
@end

@implementation SearchInResultsController
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:kSearchInResultsTopCellID];
}

#pragma mark - UITableViewDelegate && DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kSearchInResultsGenericCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:{
            AllRecipesCell *cell = [tableView dequeueReusableCellWithIdentifier:kAllRecipesCellID forIndexPath:indexPath];
            cell.countLabel.text = [NSString stringWithFormat:@"%ld", self.totalRecipesCount];
            cell.titleLabel.text = @"所有菜谱";
            if (self.curCellType == ModalSelectCellTypeAll) {
                cell.checkMarkImageView.hidden = NO;
            }
            return cell;
        }break;
        case 1:
        case 2:{
            HighScoreOrPopMakedCell *cell = [tableView dequeueReusableCellWithIdentifier:kHighScoreOrPopMakedCellID forIndexPath:indexPath];
            if (indexPath.row == 1) {
                cell.titleLabel.text = [NSString stringWithFormat:@"只看%.1f分以上", self.content.score.min];
                cell.countLabel.text = [NSString stringWithFormat:@"%ld", self.content.score.hits];
                if (self.curCellType == ModalSelectCellTypeScore) {
                    cell.checkMarkImageView.hidden = NO;
                }
            }else if(indexPath.row == 2){
                cell.titleLabel.text = [NSString stringWithFormat:@"只看%ld人以上做过",self.content.n_dishes.min];
                cell.countLabel.text = [NSString stringWithFormat:@"%ld", self.content.n_dishes.hits];
                if (self.curCellType == ModalSelectCellTypeMaked) {
                    cell.checkMarkImageView.hidden = NO;
                }
            }
            return cell;
        }break;
        case 3:
        case 4:
        case 5:{
            GoodsUserMenuGenericCell *cell = [tableView dequeueReusableCellWithIdentifier:kGoodsUserMenuGenericCellID forIndexPath:indexPath];
            if (indexPath.row == 3) {
                cell.titleLabel.text = @"商品";
                if (self.curCellType == ModalSelectCellTypeGoods) {
                    cell.checkMarkImageView.hidden = NO;
                }
            }else if (indexPath.row == 4) {
                cell.titleLabel.text = @"用户";
                if (self.curCellType == ModalSelectCellTypeUser) {
                    cell.checkMarkImageView.hidden = NO;
                }
            }else if (indexPath.row == 5) {
                cell.titleLabel.text = @"菜单";
                if (self.curCellType == ModalSelectCellTypeMenu) {
                    cell.checkMarkImageView.hidden = NO;
                }
            }
            return cell;
        }break;
        default:
            return nil;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kSearchInResultsTopCellID];
    headerView.contentView.backgroundColor = [UIColor whiteColor];
    
    UILabel *cancelLabel = [[UILabel alloc] init];
    cancelLabel.textColor = [UIColor colorWithRed:234 / 255.0 green:73 / 255.0 blue:52 / 255.0 alpha:1];
    cancelLabel.font = [UIFont systemFontOfSize:17.0];
    cancelLabel.textAlignment = NSTextAlignmentLeft;
    cancelLabel.text = @"取消";
    cancelLabel.userInteractionEnabled = YES;

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:17.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"搜索";
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [cancelLabel addGestureRecognizer:tapGesture];
    
    [headerView.contentView addSubview:cancelLabel];
    [headerView.contentView addSubview:titleLabel];
    
    [cancelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView);
        make.left.equalTo(headerView).with.offset(10);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(headerView);
    }];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kSearchInResultsTopCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModalSelectCellType type = 0;
    switch (indexPath.row) {
        case 0:{
            type = ModalSelectCellTypeAll;
        }break;
        case 1:{
            type = ModalSelectCellTypeScore;
        }break;
        case 2:{
            type = ModalSelectCellTypeMaked;
        }break;
        case 3:{
            type = ModalSelectCellTypeGoods;
        }break;
        case 4:{
            type = ModalSelectCellTypeUser;
        }break;
        case 5:{
            type = ModalSelectCellTypeMenu;
        }break;
        default:
            break;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchInResultsControllerDidSelectRowWithType:)]) {
        [self.delegate searchInResultsControllerDidSelectRowWithType:type];
    }
}

#pragma mark - Private Methods
- (void)dismiss
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchInResultsControllerDidClickedDismissButton:)]) {
        [self.delegate searchInResultsControllerDidClickedDismissButton:self];
    }
}

#pragma mark - UIViewControllerTransitioningDelegate
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    self.presentingController = presenting;
    self.presentController = [[CustomPresentController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    return self.presentController;
}
@end
