//
//  HomePageAdModel.h
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 1/27/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseNetwork/BaseEntity.h"

@interface AdImageModel : NSObject

@property(nonatomic, copy) NSString *url;
@property(nonatomic, assign) NSInteger width;
@property(nonatomic, assign) NSInteger height;

@end

@interface AdInfoModel : NSObject

@property(nonatomic, copy) NSString *url;
@property(nonatomic, strong) AdImageModel *image;
@property(nonatomic, copy) NSString *picurl;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, assign) CGFloat displayTime;
@property(nonatomic, assign) CGFloat displayInterval;

@end


@interface AdContent : NSObject

@property(nonatomic, copy) NSString *startTime;
@property(nonatomic, assign) NSInteger adType;
@property(nonatomic, copy) NSString *expose_tracking_url;
@property(nonatomic, copy) NSString *endTime;
@property(nonatomic, copy) NSString *click_tracking_url;
@property(nonatomic, strong) AdInfoModel *adInfo;

@end

@interface HomePageAdResponse : BaseEntity

@property(nonatomic, strong) AdContent *content;

@end
