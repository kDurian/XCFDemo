//
//  UniversalSearchModel.h
//  XCFDemo
//
//  Created by Durian on 5/3/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "BaseEntity.h"
#import <UIKit/UIKit.h>

@interface FirstRecipe : NSObject
@property(nonatomic, copy) NSString *photo;
@property(nonatomic, copy) NSString *photo80;
@property(nonatomic, copy) NSString *photo90;
@property(nonatomic, copy) NSString *photo140;
@property(nonatomic, copy) NSString *photo280;
@property(nonatomic, copy) NSString *photo340;
@property(nonatomic, copy) NSString *photo526;
@property(nonatomic, copy) NSString *photo580;
@property(nonatomic, copy) NSString *photo640;
@property(nonatomic, copy) NSString *thumb;
@end


@interface MainPic : NSObject
@property(nonatomic, copy) NSString *pic240;
@property(nonatomic, copy) NSString *url;
@property(nonatomic, copy) NSString *ident;
@end


@interface Ingredient : NSObject
@property(nonatomic, copy) NSString *name;
@end


@interface Author : NSObject
@property(nonatomic, copy) NSString *photo;
@property(nonatomic, copy) NSString *photo60;
@property(nonatomic, copy) NSString *photo160;
@property(nonatomic, assign) NSUInteger id;
@property(nonatomic, copy) NSString *name;
@end


@interface Stats : NSObject
@property(nonatomic, assign) NSInteger n_dishes;
@property(nonatomic, assign) NSInteger n_cooked;
@end


@interface ItemObject: NSObject
@property(nonatomic, copy) NSString *name;
@property(nonatomic, assign) NSUInteger id;
@property(nonatomic, strong) Author *author;
@property(nonatomic, copy) NSString *desc;
@property(nonatomic, assign) BOOL is_exclusive;
@property(nonatomic, strong) Stats *stats;
//recipe related
@property(nonatomic, copy) NSString *score;
@property(nonatomic, copy) NSString *video_url;
@property(nonatomic, copy) NSString *video_page_url;
@property(nonatomic, strong) NSArray *ingredient;
@property(nonatomic, copy) NSString *photo;
@property(nonatomic, copy) NSString *thumb;
@property(nonatomic, copy) NSString *photo80;
@property(nonatomic, copy) NSString *photo90;
@property(nonatomic, copy) NSString *photo140;
@property(nonatomic, copy) NSString *photo280;
@property(nonatomic, copy) NSString *photo340;
@property(nonatomic, copy) NSString *photo526;
@property(nonatomic, copy) NSString *photo580;
@property(nonatomic, copy) NSString *photo640;
//related product
@property(nonatomic, assign) CGFloat average_rate;
@property(nonatomic, copy) NSString *display_price;
@property(nonatomic, copy) NSString *display_original_price;
@property(nonatomic, strong) MainPic *main_pic;
//related menu
@property(nonatomic, copy) NSString *url;
@property(nonatomic, assign) NSInteger nrecipes;
@property(nonatomic, strong) FirstRecipe *first_recipe;
//user
@property(nonatomic, copy) NSString *photo60;
@property(nonatomic, copy) NSString *photo160;
@property(nonatomic, assign) BOOL is_expert;
@end


@interface TrackParam : NSObject
@property(nonatomic, copy) NSString *event_id;
@property(nonatomic, copy) NSString *neighbor_url_list;
@property(nonatomic, assign) NSUInteger pos;
@property(nonatomic, copy) NSString *location;
@property(nonatomic, copy) NSString *target;
//
@property(nonatomic, copy) NSString *prob;
@property(nonatomic, assign) NSUInteger sub_pos;
@end


@interface Item : NSObject<YYModel>
@property(nonatomic, assign) NSUInteger kind;
@property(nonatomic, copy) NSString *probability;
@property(nonatomic, copy) NSString *track_host;
@property(nonatomic, copy) NSString *track_info;
@property(nonatomic, assign) NSUInteger id;
@property(nonatomic, copy) NSString *track_path;
@property(nonatomic, strong) TrackParam *trackParam;
@property(nonatomic, strong) ItemObject *itemObject;
@end


@interface ItemContent : NSObject<YYModel>
@property(nonatomic, copy) NSString *style;
@property(nonatomic, copy) NSString *type;//eg: "item", "collection"
@property(nonatomic, strong) Item *contentInfo;
@property(nonatomic, strong) NSArray *contentArray; // [ItemContent]
//collection type
@property(nonatomic, assign) BOOL has_more;
@property(nonatomic, assign) NSInteger count;
@end


@interface UniversalSearchResult : NSObject
@property(nonatomic, assign) NSInteger count;
@property(nonatomic, copy) NSString *style;
@property(nonatomic, assign) NSInteger total;
@property(nonatomic, copy) NSString *type;
@property(nonatomic, strong) NSArray *content;//ItemContent
@end


@interface SearchResultResponse : BaseEntity
@property(nonatomic, strong) UniversalSearchResult *content;
@property(nonatomic, assign) NSInteger count;
@property(nonatomic, assign) NSInteger total;
@property(nonatomic, copy) NSString *style;
@property(nonatomic, copy) NSString *type;
@end
