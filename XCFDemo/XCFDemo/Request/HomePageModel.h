//
//  HomePageModel.h
//  Demo_GotoKitchen
//
//  Created by 阳小东 on 16/1/26.
//  Copyright © 2016年 durian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseEntity.h"

@interface HomePageDishModel : NSObject

@property (nonatomic)NSString *thumbnail_280;

@end

@interface HomePageEvent : NSObject

@property (nonatomic)NSInteger n_dishes;
@property (nonatomic)NSString *customization;
@property (nonatomic)NSString *eventID;
@property (nonatomic)NSString *name;
@property (nonatomic)NSArray *dishes;

@end

@interface HomePagePopEventsModel : NSObject

@property (nonatomic)NSInteger count;
@property (nonatomic)NSArray *events;

@end

@interface HomePageNavsModel : NSObject

@property (nonatomic)NSString *url;
@property (nonatomic)NSString *name;
@property (nonatomic)NSString *picurl;

@end

@interface HomePageContentModel : NSObject

@property (nonatomic)HomePagePopEventsModel *pop_events;   //包含HomePagePopEventsModel
@property (nonatomic)NSArray *navs;         //HomePageNavsModel
@property (nonatomic)NSString *pop_recipe_picurl;

@end

@interface HomePageResponse : BaseEntity

@property (nonatomic)HomePageContentModel *content;

@end
