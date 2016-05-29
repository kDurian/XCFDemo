//
//  RecipeEditedPageCellManager.m
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 3/19/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "RecipeEditedPageCellManager.h"

#import "UITableView+FDTemplateLayoutCell.h"

#import "XCFRecipeCoverCell.h"
#import "XCFRecipeNameCell.h"
#import "XCFRecipeDescAddCell.h"
#import "XCFRecipeIngsTitleCell.h"
#import "XCFRecipeIngsAddCell.h"
#import "XCFRecipeStepTitleCell.h"
#import "XCFRecipePicStepCell.h"
#import "XCFRecipeTextStepAddCell.h"
#import "XCFRecipeStepAdjustCell.h"
#import "XCFRecipeTipsAddCell.h"
#import "XCFRecipeUpdateTimeCell.h"
#import "XCFRecipeFileFateCell.h"

#import "XCFRecipeDescCell.h"
#import "XCFRecipeIngsCell.h"
#import "XCFRecipeTextStepCell.h"
#import "XCFRecipeTipsCell.h"

#import "XCFRecipeStepCell.h"

#import "NSString+KDExtension.h"

static NSString * const kRecipeCoverCellID = @"kRecipeCoverCellID";
static NSString * const kRecipeNameCellID = @"kRecipeNameCellID";
static NSString * const kRecipeDescAddCellID = @"kRecipeDescAddCellID";
static NSString * const kRecipeIngsTitleCellID = @"kRecipeIngsTitleCellID";
static NSString * const kRecipeIngsAddCellID = @"kRecipeIngsAddCellID";
static NSString * const kRecipeStepTitleCellID = @"kRecipeStepTitleCellID";
static NSString * const kRecipePicStepCellID = @"kRecipePicStepCellID";
static NSString * const kRecipeTextStepAddCellID = @"kRecipeTextStepAddCellID";
static NSString * const kRecipeStepAdjustCellID = @"kRecipeStepAdjustCellID";
static NSString * const kRecipeTipsAddCellID = @"kRecipeTipsAddCellID";
static NSString * const kRecipeUpdateTimeCellID = @"kRecipeUpdateTimeCellID";
static NSString * const kRecipeFileFateCellID = @"kRecipeFileFateCellID";


static const CGFloat kRecipeCoverCellHeight = 220.0f;
static const CGFloat kRecipeDescAddCellHeight = 22.0f;
static const CGFloat kRecipeIngsTitleCellHeight = 90.0f;
static const CGFloat kRecipeIngsAddCellHeight = 32.0f;
static const CGFloat kRecipeStepTitleCellHeight = 90.0f;
static const CGFloat kRecipePicStepCellHeight = 190.0f;
static const CGFloat kRecipeTextStepAddCellHeight = 70.0f;
static const CGFloat kRecipeStepAdjustCellHeight = 120.0f;
static const CGFloat kRecipeTipsAddCellHeight = 80.0f;
static const CGFloat kRecipeUpdateTimeCellHeight = 90.0f;
static const CGFloat kRecipeFileFateCellHeight = 214.0f;

static const CGFloat kRecipeIngsCellHeight = 50.0f;


@interface RecipeEditedPageCellManager ()

@property(nonatomic, strong) NSMutableDictionary *recipeContent;

@end

@implementation RecipeEditedPageCellManager
+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withRecipe:(Recipe *)recipe
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                return kRecipeCoverCellHeight;
                break;
            }
            case 1:
            {

                return [tableView fd_heightForCellWithIdentifier:kRecipeNameCellID cacheByIndexPath:indexPath configuration:^(id cell) {
                    XCFRecipeNameCell *recipeNameCell = (XCFRecipeNameCell *)cell;
                    recipeNameCell.recipe = recipe;
                }];
                break;
            }
            case 2:
            {
                if (recipe.desc.length == 0) {
                    return kRecipeDescAddCellHeight;
                 }else {
                     return [tableView fd_heightForCellWithIdentifier:kRecipeDescCellID cacheByIndexPath:indexPath configuration:^(id cell) {
                         XCFRecipeDescCell *recipeDescCell = (XCFRecipeDescCell *)cell;
                         recipeDescCell.recipe = recipe;
                     }];
                }
                break;
            }
            default:
                break;
        }

    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return kRecipeIngsTitleCellHeight;
        }else {
            if (recipe.ingredients.count == 0) {
                return kRecipeIngsAddCellHeight;
            }else {
                return kRecipeIngsCellHeight;
            }
        }
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            return kRecipeStepTitleCellHeight;
        }else {
            if (recipe.practiceSteps.count > indexPath.row - 1) {
                RecipePracticeStep *parcticeStep = recipe.practiceSteps[indexPath.row - 1];
                if (parcticeStep.text.length == 0) {
                    return kRecipePicStepCellHeight + kRecipeTextStepAddCellHeight;
                }else {
                    return [tableView fd_heightForCellWithIdentifier:kRecipeStepCellID cacheByIndexPath:indexPath configuration:^(id cell) {
                        XCFRecipeStepCell *recipeStepCell = (XCFRecipeStepCell *)cell;
                        recipeStepCell.practiceStep = parcticeStep;
                    }];
                }
            }
        }
    }
    
    if (indexPath.section == 3) {
        switch (indexPath.row) {
            case 0:
            {
                return kRecipeStepAdjustCellHeight;
                break;
            }
            case 1:
            {
                if (recipe.tips.length == 0) {
                    return kRecipeTipsAddCellHeight;
                }else {
                    return [tableView fd_heightForCellWithIdentifier:kRecipeTipsCellID cacheByIndexPath:indexPath configuration:^(id cell) {
                        XCFRecipeTipsCell *recipeTipsCell = (XCFRecipeTipsCell *)cell;
                        recipeTipsCell.recipe = recipe;
                    }];
                }
                break;
            }
            case 2:
            {
                return kRecipeUpdateTimeCellHeight;
                break;
            }
            case 3:
            {
                return kRecipeFileFateCellHeight;
                break;
            }
            default:
                break;
        }
    }
    return 0.0f;
}

+ (CGFloat)labelTextHeight:(UILabel *)label withText:(NSString *)text
{
    if (text.length > 0) {
        CGSize size = [text calculateSize:CGSizeMake(label.frame.size.width, FLT_MAX) font:label.font];
        CGFloat labelTextHeight = size.height;
        return labelTextHeight;
    }
    return 0.0f;
}

+ (UITableViewCell *)cellWithTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath withRecipe:(Recipe *)recipe
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                XCFRecipeCoverCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecipeCoverCellID forIndexPath:indexPath];
                cell.recipe = recipe;
                return cell;
                break;
            }
            case 1:
            {
                XCFRecipeNameCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecipeNameCellID forIndexPath:indexPath];
                cell.recipe = recipe;
                return cell;
                break;
            }
            case 2:
            {
                if (recipe.desc.length == 0) {
                    XCFRecipeDescAddCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecipeDescAddCellID forIndexPath:indexPath];
                    return cell;
                }else {
                    XCFRecipeDescCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecipeDescCellID forIndexPath:indexPath];
                    cell.recipe = recipe;
                    return cell;
                }
                break;
            }
            default:
                break;
        }
    }
    
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            XCFRecipeIngsTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecipeIngsTitleCellID forIndexPath:indexPath];
            return cell;
        }else
        {
            if (recipe.ingredients.count == 0) {
                XCFRecipeIngsAddCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecipeIngsAddCellID forIndexPath:indexPath];
                return cell;
            }else {
                XCFRecipeIngsCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecipeIngsCellID forIndexPath:indexPath];
                if (recipe.ingredients.count > indexPath.row - 1) {
                    cell.recipeIngredient = recipe.ingredients[indexPath.row - 1];
                }
                return cell;
            }
        }
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            XCFRecipeStepTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecipeStepTitleCellID forIndexPath:indexPath];
            return cell;
        }else {
            if (recipe.practiceSteps.count > 0) {
                RecipePracticeStep *practiceStep = recipe.practiceSteps[indexPath.row - 1];
                XCFRecipeStepCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecipeStepCellID forIndexPath:indexPath];
                cell.stepNumber = indexPath.row;
                if (practiceStep.text.length == 0) {
                    cell.practiceStep = practiceStep;
                    cell.textStepAddView.hidden = NO;
                    cell.textStepLabel.hidden = YES;
                }else
                {
                    cell.textStepAddView.hidden = YES;
                    cell.textStepLabel.hidden = NO;
                    cell.practiceStep = practiceStep;
                }
                return cell;
            }
        }
    }
    
    if(indexPath.section == 3){
        switch (indexPath.row) {
            case 0:
            {
                XCFRecipeStepAdjustCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecipeStepAdjustCellID forIndexPath:indexPath];
                return cell;
                break;
            }
            case 1:
            {
                if (recipe.tips.length == 0) {
                    XCFRecipeTipsAddCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecipeTipsAddCellID forIndexPath:indexPath];
                    return cell;
                }else {
                    XCFRecipeTipsCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecipeTipsCellID forIndexPath:indexPath];
                    cell.recipe = recipe;
                    return cell;
                }
                break;
            }
            case 2:
            {
                XCFRecipeUpdateTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecipeUpdateTimeCellID forIndexPath:indexPath];
                cell.recipe = recipe;
                return cell;
                break;
            }
            case 3:
            {
                XCFRecipeFileFateCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecipeFileFateCellID forIndexPath:indexPath];
                return cell;
                break;
            }
            default:
                break;
        }
    }
    return nil;
}
@end
