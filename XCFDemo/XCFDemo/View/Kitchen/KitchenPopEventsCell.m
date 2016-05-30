//
//  HomePagePopEventCell.m
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 1/15/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "KitchenPopEventsCell.h"
#import "PopEventsView.h"

@implementation KitchenPopEventsCell
- (void)setContent:(HomePageContentModel *)content{
    _content = content;
    NSInteger count = content.pop_events.count;
    NSMutableArray *imageURLStrings = [NSMutableArray array];
    NSMutableArray *titles = [NSMutableArray array];
    NSMutableArray *counts = [NSMutableArray array];
    for (int i = 0; i < count; i++){
        HomePagePopEventsModel *popEvents = content.pop_events;
        HomePageEvent *model = popEvents.events[i];
        HomePageDishModel *dish = model.dishes[0];
        [imageURLStrings addObject:dish.thumbnail_280];
        NSString *title = [NSString stringWithFormat:@"— %@ —", [model.name substringWithRange:NSMakeRange(0, 2)]];
        [titles addObject:title];
        [counts addObject:[NSNumber numberWithInteger:model.n_dishes]];
    }
    PopEventsView *scrollView = [PopEventsView cycleScrollViewWithFrame:self.bounds delegate:nil];
    scrollView.imageURLs = imageURLStrings;
    scrollView.titles = titles;
    scrollView.counts = counts;
    [self addSubview:scrollView];
}
@end
