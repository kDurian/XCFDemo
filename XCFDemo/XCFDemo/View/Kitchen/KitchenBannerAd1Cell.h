//
//  KitchenCouponAdCell.h
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 1/15/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageAdModel.h"

@interface KitchenBannerAd1Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *adImageView;
@property(nonatomic, strong) AdContent *content;
@end
