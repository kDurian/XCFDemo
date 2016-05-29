//
//  RelatedSearchCell.h
//  XCFDemo
//
//  Created by Durian on 5/6/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RelatedSearchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *fistLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourthLabel;

+ (CGFloat)cellHeight;

@end
