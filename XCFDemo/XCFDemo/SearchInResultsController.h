//
//  SearchInResultsController.h
//  XCFDemo
//
//  Created by Durian on 5/18/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipesFiltersModel.h"

@class SearchInResultsController;

typedef NS_ENUM(NSUInteger, ModalSelectCellType) {
    ModalSelectCellTypeAll,
    ModalSelectCellTypeScore,
    ModalSelectCellTypeMaked,
    ModalSelectCellTypeGoods,
    ModalSelectCellTypeUser,
    ModalSelectCellTypeMenu
};

@protocol SearchInResultsControllerDelegate<NSObject>
- (void)searchInResultsControllerDidClickedDismissButton:(SearchInResultsController *)viewController;
- (void)searchInResultsControllerDidSelectRowWithType:(ModalSelectCellType)type;
@end

@interface SearchInResultsController : UITableViewController
@property(nonatomic, strong) RecipesFiltersContent *content;
@property(nonatomic, assign) NSInteger totalRecipesCount;
@property(nonatomic, assign) ModalSelectCellType curCellType;
@property(nonatomic, weak) id<SearchInResultsControllerDelegate> delegate;
@end
