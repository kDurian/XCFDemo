//
//  Feeds.h
//  XCFDemo
//
//  Created by Durian on 5/22/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "BaseEntity.h"
#import "YYModel.h"

@class FeedAuthorOrUser;

@interface LastestComment : NSObject
@property(nonatomic, strong) FeedAuthorOrUser *author;
@property(nonatomic, strong) NSArray *at_users;
@property(nonatomic, copy) NSString *target_id;
@property(nonatomic, copy) NSString *create_time;
@property(nonatomic, copy) NSString *txt;
@property(nonatomic, assign) NSUInteger id;
@end

@interface RecipeStep : NSObject
@property(nonatomic, copy) NSString *url;
@property(nonatomic, copy) NSString *text;
@property(nonatomic, copy) NSString *step;
@property(nonatomic, copy) NSString *ident;
@property(nonatomic, copy) NSString *photo800;
@end

@interface FeedIngredient : NSObject
@property(nonatomic, copy) NSString *amount;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *cat;
@end

@interface RecipeStats : NSObject
@property(nonatomic, assign) NSInteger n_collects;
@property(nonatomic, assign) NSInteger n_comments;
@property(nonatomic, assign) NSInteger n_cooked;
@property(nonatomic, assign) NSInteger n_dishes;
@property(nonatomic, assign) BOOL cooked_by_me;
@property(nonatomic, assign) NSInteger n_cooked_last_week;
@property(nonatomic, assign) NSInteger n_pv;
@end

@interface DishEvent : NSObject
@property(nonatomic, assign) BOOL is_promoted;
@property(nonatomic, copy) NSString *id;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, strong) FeedAuthorOrUser *author;
@end

@interface DiggUsers : NSObject
@property(nonatomic, assign) NSInteger count;
@property(nonatomic, assign) NSInteger total;
@property(nonatomic, strong) NSArray *users; // FeedAuthorOrUser
@end

@interface DishPic : NSObject
@property(nonatomic, copy) NSString *pic_280;
@property(nonatomic, copy) NSString *pic_600;
@property(nonatomic, copy) NSString *ident;
@end

@interface FeedAuthorOrUser : NSObject
@property(nonatomic, copy) NSString *hometown_location;
@property(nonatomic, copy) NSString *photo60;
@property(nonatomic, copy) NSString *photo160;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *photo;
@property(nonatomic, assign) BOOL is_expert;
@property(nonatomic, copy) NSString *current_location;
@property(nonatomic, copy) NSString *mail;
@property(nonatomic, copy) NSString *id;
@end

@interface FeedRecipe : NSObject
@property(nonatomic, strong) NSArray *instruction; // RecipeStep
@property(nonatomic, copy) NSString *video_url;
@property(nonatomic, copy) NSString *photo;
@property(nonatomic, copy) NSString *friendly_create_time;
@property(nonatomic, copy) NSString *create_time;
@property(nonatomic, assign) BOOL is_exclusive;
@property(nonatomic, copy) NSString *photo140;
@property(nonatomic, copy) NSString *photo580;
@property(nonatomic, copy) NSString *id;
@property(nonatomic, copy) NSString *video_page_url;
@property(nonatomic, copy) NSString *photo90;
@property(nonatomic, strong) RecipeStats *stats;
@property(nonatomic, copy) NSString *thumb;
@property(nonatomic, strong) FeedAuthorOrUser *author;
@property(nonatomic, copy) NSString *score;
@property(nonatomic, copy) NSString *tips;
@property(nonatomic, copy) NSString *photo526;
@property(nonatomic, copy) NSString *photo640;
@property(nonatomic, strong) NSArray *ingredient; //FeedIngredient
@property(nonatomic, strong) NSArray *dish_author;
@property(nonatomic, copy) NSString *purchase_url;
@property(nonatomic, copy) NSString *ident;
@property(nonatomic, copy) NSString *photo280;
@property(nonatomic, strong) NSArray *recipe_cats;
@property(nonatomic, copy) NSString *desc;
@property(nonatomic, copy) NSString *photo80;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *url;
@property(nonatomic, copy) NSString *photo340;
@property(nonatomic, copy) NSString *summary;
@end

@interface FeedDish : NSObject
@property(nonatomic, copy) NSString *photo;
@property(nonatomic, copy) NSString *friendly_create_time;
@property(nonatomic, copy) NSString *create_time;
@property(nonatomic, assign) NSInteger npics;
@property(nonatomic, strong) NSArray *pic_tags;
@property(nonatomic, assign) NSInteger ncomments;
@property(nonatomic, copy) NSString *thumbnail_280;
@property(nonatomic, strong) FeedAuthorOrUser *author;
@property(nonatomic, strong) DishPic *main_pic;
@property(nonatomic, copy) NSString *id;
@property(nonatomic, strong) NSArray *extra_pics; // DishPic
@property(nonatomic, copy) NSString *thumbnail;
@property(nonatomic, strong) DiggUsers *digg_users;
@property(nonatomic, assign) NSInteger ndiggs;
@property(nonatomic, copy) NSString *recipe_id;
@property(nonatomic, strong) NSArray *latest_comments; // LastestComment
@property(nonatomic, copy) NSString *desc;
@property(nonatomic, assign) BOOL is_orphan;
@property(nonatomic, copy) NSString *ident;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *thumbnail_160;
@property(nonatomic, strong) NSArray *events; // DishEvent
@property(nonatomic, assign) BOOL digged_by_me;
@property(nonatomic, strong) NSArray *at_users;
@end

@interface Feed : NSObject<YYModel>
@property(nonatomic, assign) NSInteger ncomments;
@property(nonatomic, assign) NSUInteger kind;
@property(nonatomic, assign) NSUInteger id;
@property(nonatomic, strong) FeedDish *dish;  // kind = 1005
@property(nonatomic, strong) FeedRecipe *recipe; // kind = 1001
@end

@interface FeedsContent : NSObject<YYModel>
@property(nonatomic, assign) NSInteger count;
@property(nonatomic, strong) NSArray *feeds;
@end

@interface FeedsResponse : BaseEntity
@property(nonatomic, strong) FeedsContent *content;
@end
