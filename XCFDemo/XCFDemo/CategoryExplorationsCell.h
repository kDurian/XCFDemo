//
//  CategoryExplorationsCell.h
//  XCFDemo
//
//  Created by Durian on 5/6/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryExplorationsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

+ (CGFloat)cellHeight;
@end
