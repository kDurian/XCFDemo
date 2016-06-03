//
//  FirstRowTableViewCell.h
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 1/11/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageModel.h"
#import "Feeds.h"

@interface KitchenTopCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightNotificationLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property(nonatomic, strong) HomePageContentModel *content;
@property(nonatomic, strong) Feed *feed;
@property(nonatomic, assign) NSInteger number;
@end
