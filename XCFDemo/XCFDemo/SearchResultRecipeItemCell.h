//
//  SearchResultRecipeItemCell.h
//  XCFDemo
//
//  Created by Durian on 5/6/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UniversalSearchModel.h"

@interface SearchResultRecipeItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *exclusiveMarkLabel;

@property (weak, nonatomic) IBOutlet UILabel *recipeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *reciepIngLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreAndCookedNumLabel;

@property(nonatomic, strong) Item *recipeItem;

@end
