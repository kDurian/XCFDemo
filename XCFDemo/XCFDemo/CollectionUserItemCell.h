//
//  CollectionUserItemCell.h
//  XCFDemo
//
//  Created by Durian on 5/6/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UniversalSearchModel.h"

@interface CollectionUserItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property(nonatomic, strong) Item *userItem;

@end
