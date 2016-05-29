//
//  XCFRecipeUpdateTimeCell.h
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 3/19/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Recipe;

@interface XCFRecipeUpdateTimeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property(nonatomic, strong) Recipe *recipe;


@end
