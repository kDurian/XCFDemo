//
//  PopEventsScrollView.h
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 1/19/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PopEventsView;

@protocol PopEventsScrollViewDelegate <NSObject>

- (void)cycleSrcollView:(PopEventsView *)scrollView didSelectItemAtIndex:(NSInteger)index;

@end

@interface PopEventsView : UIView

@property(nonatomic, strong) NSArray *imageURLs;
@property(nonatomic, strong) NSArray *titles;
@property(nonatomic, strong) NSArray *counts;

@property(nonatomic, weak) id<PopEventsScrollViewDelegate>  delegate;

+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame delegate:(id<PopEventsScrollViewDelegate>)delegate;

@end
