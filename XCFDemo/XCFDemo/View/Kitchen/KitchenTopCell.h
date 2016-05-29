//
//  FirstRowTableViewCell.h
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 1/11/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageModel.h"

@interface KitchenTopCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UILabel *rightNotificationLabel;

@property (weak, nonatomic) IBOutlet UILabel *rightTitleLabel;



- (void)cellBindHomePageNavContent:(HomePageContentModel *)content;

@end
