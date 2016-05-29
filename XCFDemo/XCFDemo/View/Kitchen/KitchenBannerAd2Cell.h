//
//  FouthRowTableViewCell.h
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 1/11/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageAdModel.h"

@interface KitchenBannerAd2Cell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *adImageView;

- (void)cellBindHomePageBannerAd2Content:(AdContent *)content;

@end
