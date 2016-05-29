//
//  HomePageCellManager.h
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 1/18/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSString * const kRecipeSectionHeaderCellID = @"kRecipeSectionHeaderCellID";
static NSString * const kPublicSeparatorCellID = @"kPublicSeparatorCellID";

static NSString * const kRecipeCollectionsCellID = @"kRecipeCollectionsCellID";
static NSString * const kRecipeItemCellID = @"kRecipeItemCellID";
static NSString * const kArticleOfFoodCellID = @"kArticleOfFoodCellID";
static NSString * const kCreativePhotoCellID = @"kCreativePhotoCellID";
static NSString * const kHomeIssueItemTPL6TableViewCellID = @"kHomeIssueItemTPL6TableViewCellID";

@class RecipeInfo;
@class AdContent;

@interface HomePageCellManager : NSObject

+ (UITableViewCell *)cellWithTableView:(UITableView *)tableView withItem:(id)item withIndexPath:(NSIndexPath *)indexPath;

+ (CGFloat)heightOFCellWithIndexPath:(NSIndexPath *)indexPath withRecipeInfo:(RecipeInfo *)info OrAdcontent:(AdContent *)content;

@end
