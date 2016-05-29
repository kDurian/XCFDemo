//
//  SecondRowTableViewCell.h
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 1/11/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HomePageModel.h"

@interface KitchenNavCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *firstButton;
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UIButton *thirdButton;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet UIButton *fourthButton;
@property (weak, nonatomic) IBOutlet UILabel *fourthLabel;

- (void)cellBindHomePageNavContent:(HomePageContentModel *)content;

@end
