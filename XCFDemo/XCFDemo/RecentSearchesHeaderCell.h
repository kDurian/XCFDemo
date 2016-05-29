//
//  RecentSearchesHeaderCell.h
//  XCFDemo
//
//  Created by Durian on 4/29/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecentSearchesHeaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *closeButton;

+ (CGFloat)cellHeight;

@end
