//
//  BuyBuyBuyResponse.h
//  XCFDemo
//
//  Created by Durian on 5/23/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "BaseEntity.h"
#import <UIKit/UIKit.h>

@interface CommodityGoods : NSObject
@property(nonatomic, assign) NSUInteger id;
@property(nonatomic, copy) NSString *name;
@end

@interface ReviewPhoto : NSObject
@property(nonatomic, copy) NSString *url;
@property(nonatomic, copy) NSString *ident;
@end

@interface ReviewCommodity : NSObject
@property(nonatomic, assign) NSUInteger number;
@property(nonatomic, copy) NSString *kind_name;
@property(nonatomic, strong) CommodityGoods *goods;
@end

@interface ReviewDiggUsers : NSObject<YYModel>
@property(nonatomic, assign) NSInteger count;
@property(nonatomic, assign) NSInteger total;
@property(nonatomic, strong) NSArray *users; // ReviewAuthorOrUser
@end

@interface ReviewAuthorOrUser : NSObject
@property(nonatomic, assign) BOOL is_expert;
@property(nonatomic, copy) NSString *photo60;
@property(nonatomic, copy) NSString *photo160;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *photo;
@property(nonatomic, copy) NSString *mail;
@property(nonatomic, copy) NSString *id;
@end

@interface ReviewLastestComment : NSObject<YYModel>
@property(nonatomic, assign) NSUInteger id;
@property(nonatomic, copy) NSString *target_id;
@property(nonatomic, copy) NSString *create_time;
@property(nonatomic, copy) NSString *txt;
@property(nonatomic, strong) ReviewAuthorOrUser *author;
@property(nonatomic, strong) NSArray *at_users; //ReviewAuthorOrUser
@end

@interface BuyBuyBuyReview : NSObject<YYModel>
@property(nonatomic, assign) BOOL is_essential;
@property(nonatomic, assign) BOOL is_published;
@property(nonatomic, assign) BOOL digged_by_me;
@property(nonatomic, assign) NSUInteger id;
@property(nonatomic, assign) NSUInteger goods_id;
@property(nonatomic, assign) NSUInteger type;
@property(nonatomic, assign) NSInteger ndiggs;
@property(nonatomic, assign) CGFloat rate;
@property(nonatomic, copy) NSString *additional_review;
@property(nonatomic, copy) NSString *friendly_create_time;
@property(nonatomic, copy) NSString *create_time;
@property(nonatomic, copy) NSString *url;
@property(nonatomic, copy) NSString *additional_review_create_time;
@property(nonatomic, copy) NSString *shop_reply;
@property(nonatomic, copy) NSString *review;
@property(nonatomic, strong) ReviewAuthorOrUser *author;
@property(nonatomic, strong) ReviewDiggUsers *digg_users;
@property(nonatomic, strong) ReviewCommodity *commodity;
@property(nonatomic, strong) NSArray *additional_review_photos;
@property(nonatomic, strong) NSArray *photos; //ReviewPhoto
@property(nonatomic, strong) NSArray *latest_comments; //ReviewLastestComment
@end

@interface BuyBuyBuyCursor : NSObject
@property(nonatomic, assign) BOOL has_prev;
@property(nonatomic, assign) BOOL has_next;
@property(nonatomic, copy)   NSString *prev;
@property(nonatomic, copy)   NSString *next;
@end

@interface BuyBuyBuyContent : NSObject<YYModel>
@property(nonatomic, assign) NSInteger count;
@property(nonatomic, copy)   NSString *title;
@property(nonatomic, strong) NSArray *reviews;
@property(nonatomic, strong) BuyBuyBuyCursor *cursor;
@end

@interface BuyBuyBuyResponse : BaseEntity
@property(nonatomic, strong) BuyBuyBuyContent *content;
@end
