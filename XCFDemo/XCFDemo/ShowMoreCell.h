//
//  ShowMoreCell.h
//  XCFDemo
//
//  Created by Durian on 5/6/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowMoreCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

+ (CGFloat)cellHeight;

@end
