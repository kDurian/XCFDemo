//
//  RelatedMenuCell.h
//  XCFDemo
//
//  Created by Durian on 5/6/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UniversalSearchModel.h"

@interface RelatedMenuCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *recipeNumAndAuthorNameLabel;

@property(nonatomic, strong) Item *relatedMenuItem;
@end
