//
//  FeedsCell.h
//  XCFDemo
//
//  Created by Durian on 5/24/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"

#import "Feeds.h"
#import "HomePageNotification.h"

@interface FeedsCell : UITableViewCell
@end

@interface FeedsNotificationCell : FeedsCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *notificationLabel;
@property(nonatomic, strong) NotificationContent *content;
@end

@interface FeedsRecipePhotoCell : FeedsCell
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property(nonatomic, strong) FeedRecipe *recipe;
@end

@interface FeedsDishPhotosCell : FeedsCell<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *pageIndicatorView;
@property (weak, nonatomic) IBOutlet UILabel *pageIndicatorLabel;
@property(nonatomic, strong) FeedDish *dish;
@property(nonatomic, assign) BOOL isHiddenPageIndicator;
@property(nonatomic, assign) NSInteger curPageNum;
@property(nonatomic, assign) NSInteger totalPageNum;
@end

@interface FeedsInfoCell : FeedsCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *recipeNameLabel;
@property(nonatomic, strong) FeedRecipe *recipe;
@property(nonatomic, strong) FeedDish *dish;
@end

@interface FeedsDescCell : FeedsCell<TTTAttributedLabelDelegate>
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *descLabel;
@property(nonatomic, strong) FeedDish *dish;
@property(nonatomic, strong) FeedRecipe *recipe;
@end

@interface FeedsDishDiggCell : FeedsCell<TTTAttributedLabelDelegate>
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *diggLabel;
@property(nonatomic, strong) FeedDish *dish;
@end

@interface FeedsDishCommentNumCell : FeedsCell
@property (weak, nonatomic) IBOutlet UILabel *commentNumLabel;
@property(nonatomic, strong) FeedDish *dish;
@end

@interface FeedsDishCommentCell : FeedsCell<TTTAttributedLabelDelegate>
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *commentLabel;
@property(nonatomic, strong) LatestComment *commment;
@end

@interface FeedsDishMoreCell : FeedsCell
@property (weak, nonatomic) IBOutlet UIButton *diggButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *showMoreButton;
@property(nonatomic, strong) FeedDish *dish;
@end

@interface FeedsRecipeMoreCell : FeedsCell
@property (weak, nonatomic) IBOutlet UIButton *showMoreButton;
@property(nonatomic, strong) FeedRecipe *recipe;
@end


