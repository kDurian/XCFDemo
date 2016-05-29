//
//  RecipeSearchController.h
//  XCFDemo
//
//  Created by Durian on 4/28/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeywordModel.h"

@interface RecipeSearchController : UITableViewController

@property(nonatomic, strong) KeywordContent *yearKeyword;
@property(nonatomic, strong) KeywordContent *hourKeyword;

@end
