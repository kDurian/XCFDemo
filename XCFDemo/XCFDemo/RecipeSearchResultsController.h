//
//  RecipeResultsTableController.h
//  XCFDemo
//
//  Created by Durian on 4/28/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecipeSearchResultsController : UITableViewController

@property(nonatomic, copy) NSString *searchName;

@property(nonatomic, strong) NSArray *recipeResults;

@end
