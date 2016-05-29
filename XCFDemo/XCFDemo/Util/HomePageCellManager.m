//
//  HomePageCellManager.m
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 1/18/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "HomePageCellManager.h"

#import "KitchenTopCell.h"
#import "KitchenNavCell.h"
#import "KitchenBannerAd1Cell.h"
#import "KitchenBannerAd2Cell.h"
#import "KitchenPopEventsCell.h"

#import "KitchenRecipeCell.h"
#import "KitchenArticleOfFoodCell.h"
#import "KitchenRecipeCollectionsCell.h"
#import "KitchenCreativePhotoCell.h"
#import "HomeIssueItemTPL6TableViewCell.h"

#import "RecipeSectionHeaderCell.h"
#import "PublicSeparatorCell.h"

#import "HomePageRecipeModel.h"
#import "HomePageAdModel.h"
#import "HomePageModel.h"


typedef NS_ENUM(NSInteger, HomePageIssueItemCellStyle)
{
    TPL1ArticleOfFoodCellStyle      = 1,
    TPL2RecipeCollectionsCellStyle  = 2,
    TPL3UnDefinedCellStyle          = 3,
    TPL4CreativePhotoCellStyle      = 4,
    TPL5RecipeCellStyle             = 5,
    TPL6UnKnownCellStyle            = 6
};


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



@implementation HomePageCellManager

+ (CGFloat)heightOFCellWithIndexPath:(NSIndexPath *)indexPath withRecipeInfo:(RecipeInfo *)info OrAdcontent:(AdContent *)content
{
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0:
                return kKitchenTopCellHeight;
                break;
            case 1:
                return kKitchenNavCellHeight;
                break;
            case 2:
                if (content.adType == 0) {
                    return 0.0f;
                }else
                {
                    return kKitchenBannerAd1CellHeight;
                }
                break;
            case 3:
            {
                if (content.adType == 0) {
                    return 0.0f;
                }else
                {
                    return kKitchenBannerAd2CellHeight;
                }
            }
                break;
            case 4:
                return kKitchenPopEventsCellHeight;
                break;
                
            default:
                break;
        }
    }else
    {
        RecipeIssue *issue = ((RecipeInfo *)info).issues[0];
        
        if (indexPath.row == 0) {
            return kRecipeSectionHeaderCellHeight;
        }
        
        if (indexPath.row % 2 == 0)
        {
            return kPublicSeparatorCellHeight;
        }else
        {
            RecipeItem *item = issue.items[(indexPath.row - 1) / 2];
            switch (item.cellTemplate) {
                case 1:
                {
                    return kArticleOfFoodCellHeight;
                }
                    break;
                case 2:
                {
                    return kRecipeCollectionsCellHeight;
                }
                    break;
                case 4:
                {
                    return kCreativePhotoCellHeight;
                }
                    break;
                case 5:
                {
                    return kRecipeItemCellHeight;
                }
                    break;
                    
                default:
                    break;
            }

        }
        
    }
    
    return 0.0f;
}


+ (UITableViewCell *)cellWithTableView:(UITableView *)tableView
                              withItem:(id)item
                         withIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        switch (indexPath.row) {
            case 0:
            {
                KitchenTopCell *cell = (KitchenTopCell *)[tableView dequeueReusableCellWithIdentifier:kKitchenTopCellID];
                [cell cellBindHomePageNavContent:item];
                return cell;
            }
                break;
            case 1:
            {
                KitchenNavCell *cell = (KitchenNavCell *)[tableView dequeueReusableCellWithIdentifier:kKitchenNavCellID];
                [cell cellBindHomePageNavContent:item];
                return cell;
            }
                break;
            case 2:
            {
                KitchenBannerAd1Cell *cell = (KitchenBannerAd1Cell *)[tableView dequeueReusableCellWithIdentifier:kKitchenBannerAd1CellID];
                [cell cellBindHomePageBannerAdContent:item];
                return cell;
            }
                break;
            case 3:
            {
                KitchenBannerAd2Cell *cell = (KitchenBannerAd2Cell *)[tableView dequeueReusableCellWithIdentifier:kKitchenBannerAd2CellID];
                [cell cellBindHomePageBannerAd2Content:item];
                return cell;
            }
            case 4:
            {
                KitchenPopEventsCell *cell = (KitchenPopEventsCell *)[tableView dequeueReusableCellWithIdentifier:kKitchenPopEventsCellID];
                [cell cellBindHomePageNavContent:item];
                return cell;
            }
            default:
                break;
        }
    }else
    {
        
        if (indexPath.row == 0) {
            RecipeSectionHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecipeSectionHeaderCellID];
            return cell;
        } 
        
        if (indexPath.row % 2 == 0)
        {
            PublicSeparatorCell *cell = [tableView dequeueReusableCellWithIdentifier:kPublicSeparatorCellID];
            return cell;
        }else
        {
            RecipeItem *recipeItem = (RecipeItem *)item;
            switch (recipeItem.cellTemplate) {
                case TPL1ArticleOfFoodCellStyle:
                {
                    KitchenArticleOfFoodCell *cell = [tableView dequeueReusableCellWithIdentifier:kArticleOfFoodCellID];
                    [cell articleOfFoodCellBindRecipeItem:item];
                    return cell;
                }
                    break;
                case TPL2RecipeCollectionsCellStyle:
                {
                    KitchenRecipeCollectionsCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecipeCollectionsCellID];
                    [cell recipeCollectionsCellBindRecipeItem:item];
                    return cell;
                }
                    break;
                case TPL4CreativePhotoCellStyle:
                {
                    KitchenCreativePhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:kCreativePhotoCellID];
                    [cell creativePhotoCellBindRecipeItem:item];
                    return cell;
                }
                    break;
                case TPL5RecipeCellStyle:
                {
                    KitchenRecipeCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecipeItemCellID];
                    [cell recipeCellBindRecipeItem:item];
                    return cell;
                }
                case TPL6UnKnownCellStyle:
                {
                    HomeIssueItemTPL6TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHomeIssueItemTPL6TableViewCellID];
                    [cell homeIssueItemTPL6TableViewCellBindRecipeItem:item];
                    return cell;
                }
                default:
                    break;
            }

        }
        
    }
    
    return nil;
}

@end
