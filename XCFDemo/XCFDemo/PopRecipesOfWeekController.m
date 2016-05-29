//
//  PopRecipesOfWeekController.m
//  XCFDemo
//
//  Created by Durian on 5/21/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "PopRecipesOfWeekController.h"
#import "PopRecipeOfWeekCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "SeparatorCell.h"

static NSString *const kPopRecipeOfWeekCellID = @"kPopRecipeOfWeekCell";
static NSString *const kSeparatorCellID = @"kSeparatorCellID";

@interface PopRecipesOfWeekController ()
@property(nonatomic, strong) NSMutableArray *popRecipes;
@end

@implementation PopRecipesOfWeekController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:@"SeparatorCell" bundle:nil] forCellReuseIdentifier:kSeparatorCellID];
    [self setNavBar];
    [self getData];
}

#pragma mark -

- (void)getData
{
    
}

- (void)setNavBar
{
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backStretchBackgroundNormal"] style:UIBarButtonItemStylePlain target:self action:@selector(backToPreviousPage)];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"buylistButtonImage"] style:UIBarButtonItemStylePlain target:self action:@selector(showBuyList)];
    
    self.navigationItem.title = @"本周最受欢迎";
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)backToPreviousPage
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showBuyList
{
    
}

#pragma mark - 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.popRecipes.count * 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0) {
        return [tableView fd_heightForCellWithIdentifier:kPopRecipeOfWeekCellID cacheByIndexPath:indexPath configuration:^(PopRecipeOfWeekCell *cell) {
            
        }];
    }else if (indexPath.row % 2 == 1) {
        return 10.0f;
    }
    return 0.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0) {
        PopRecipeOfWeekCell *cell = [tableView dequeueReusableCellWithIdentifier:kPopRecipeOfWeekCellID forIndexPath:indexPath];
        return cell;
    }else if (indexPath.row % 2 == 1) {
        SeparatorCell *cell = [tableView dequeueReusableCellWithIdentifier:kSeparatorCellID forIndexPath:indexPath];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0) {
        
    }else if (indexPath.row % 2 == 1) {
        
    }
}
@end
