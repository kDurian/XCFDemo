//
//  SearchesHeaderView.h
//  XCFDemo
//
//  Created by Durian on 4/27/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopSearchRecipesHeaderView : UICollectionReusableView


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;



+ (CGFloat)viewWidth;

+ (CGFloat)viewHeight;

@end
