//
//  FeedsCell.m
//  XCFDemo
//
//  Created by Durian on 5/24/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "FeedsCell.h"
#import "UIImageView+WebCache.h"
#import "FeedsDishCollectionCell.h"
#import "NSDate+KDExtension.h"
#import "UIView+SDExtension.h"
#import "XCFLabelUtil.h"
#import "XCFStringUtil.h"

static NSString *const kFeedsDishCollectionCellID = @"kFeedsDishCollectionCell";


@implementation FeedsCell
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
@end


@implementation FeedsNotificationCell
- (void)awakeFromNib{
    self.avatarImageView.layer.cornerRadius = CGRectGetWidth(self.avatarImageView.bounds) / 2;
}

- (void)setContent:(NotificationContent *)content{
    _content = content;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:content.avatar]];
    self.notificationLabel.text = [NSString stringWithFormat:@"%ld条未读消息", content.number];
}
@end

@implementation FeedsRecipePhotoCell
- (void)prepareForReuse
{
    self.coverImageView.image = nil;
    [super prepareForReuse];
}

- (void)setRecipe:(FeedRecipe *)recipe
{
    _recipe = recipe;
    if (recipe.photo.length > 0) {
        NSURL *url = [NSURL URLWithString:recipe.photo];
        [self.coverImageView sd_setImageWithURL:url];
    }
}
@end


@implementation FeedsDishPhotosCell
- (void)prepareForReuse{
    self.pageIndicatorView.hidden = YES;
    self.isHiddenPageIndicator = YES;
    self.pageIndicatorLabel.text = nil;
    [super prepareForReuse];
}

- (void)awakeFromNib{
//    NSLog(@"%@", self.collectionView);
//    NSLog(@"%@", self.pageIndicatorLabel);
    _collectionView.pagingEnabled = YES;
    _pageIndicatorView.layer.cornerRadius = CGRectGetWidth(_pageIndicatorView.bounds) / 2;
}

- (void)setDish:(FeedDish *)dish{
    _dish = dish;
    self.curPageNum = 1;
    self.totalPageNum = 1 + dish.extra_pics.count;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    flowLayout.itemSize = CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetWidth(self.bounds));
    [self.collectionView reloadData];
    if (dish.extra_pics.count == 0) {
        self.pageIndicatorView.hidden = YES;
        self.isHiddenPageIndicator = YES;
    }else {
        self.pageIndicatorView.hidden = NO;
        self.isHiddenPageIndicator = NO;
        [self setPageIndicatorLabelText];
    }
}

- (void)setPageIndicatorLabelText{
    self.pageIndicatorLabel.text = [NSString stringWithFormat:@"%ld/%ld", self.curPageNum, self.totalPageNum];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dish.extra_pics.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FeedsDishCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFeedsDishCollectionCellID forIndexPath:indexPath];
    if (indexPath.row == 0) {
        [cell.coverImageView sd_setImageWithURL:[NSURL URLWithString:self.dish.main_pic.pic_280]];
    }else {
        if (self.dish.extra_pics.count > (indexPath.row - 1)) {
            DishPic *dishPic = self.dish.extra_pics[indexPath.row - 1];
            [cell.coverImageView sd_setImageWithURL:[NSURL URLWithString:dishPic.pic_280]];
        }
    }
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat width = self.collectionView.sd_width;
    CGFloat contentOffset_x = scrollView.contentOffset.x;
    self.curPageNum = (contentOffset_x + width * 0.5) / width + 1;
    [self setPageIndicatorLabelText];
}
@end


@implementation FeedsInfoCell{
    NSString *_dateFormat;
}
- (void)prepareForReuse{
    self.avatarImageView.image = nil;
    self.authorNameLabel.text = nil;
    self.typeLabel.text = nil;
    self.timeLabel.text = nil;
    self.recipeNameLabel.text = nil;
    [super prepareForReuse];
}

- (void)awakeFromNib{
    self.avatarImageView.layer.cornerRadius = CGRectGetWidth(self.avatarImageView.bounds) / 2;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    return self;
}

- (void)setRecipe:(FeedRecipe *)recipe{
    _recipe = recipe;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:recipe.author.photo60]];
    self.authorNameLabel.text = recipe.author.name;
    self.typeLabel.text = @"创建菜谱";
    self.timeLabel.text = [NSDate timeInternalSinceTime:recipe.create_time withDateFormat:_dateFormat];
    self.recipeNameLabel.text = recipe.name;
}

- (void)setDish:(FeedDish *)dish{
    _dish = dish;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:dish.author.photo60]];
    self.authorNameLabel.text = dish.author.name;
    self.typeLabel.text = @"做法";
    self.timeLabel.text = [NSDate timeInternalSinceTime:dish.create_time withDateFormat:_dateFormat];
    self.recipeNameLabel.text = dish.name;
}
@end


static NSString *descKeywords = @"keywords";
@implementation FeedsDescCell{
    NSMutableArray *_rangeArray;
    NSString *_rawText;
}

- (void)prepareForReuse{
    self.descLabel.text = nil;
    [super prepareForReuse];
}

- (void)setDish:(FeedDish *)dish{
    _dish = dish;
    _rawText = [self generateRowTextWithDish:dish];
    _rangeArray = [NSMutableArray new];
    self.descLabel.text = _rawText;
    self.descLabel.linkAttributes = [XCFLabelUtil tttAttributeLabelLinkAttributes];
    _rangeArray = [XCFStringUtil calculateRangeForKeywordsInDescTxt:_rawText];
    [XCFLabelUtil label:self.descLabel addLinkWithRangeArray:_rangeArray andTransitInfoKey:descKeywords];
}

- (void)setRecipe:(FeedRecipe *)recipe{
    _recipe = recipe;
    _rawText = recipe.desc;
    _rangeArray = [NSMutableArray new];
    self.descLabel.delegate = self;
    self.descLabel.text = _rawText;
    self.descLabel.linkAttributes = [XCFLabelUtil tttAttributeLabelLinkAttributes];
    _rangeArray = [XCFStringUtil calculateRangeForKeywordsInDescTxt:_rawText];
    [XCFLabelUtil label:self.descLabel addLinkWithRangeArray:_rangeArray andTransitInfoKey:descKeywords];
}

- (NSString *)generateRowTextWithDish:(FeedDish *)dish{
    NSString *desc = dish.desc;
    NSString *name = dish.name;
    NSString *rawText = @"";
    if (dish.is_orphan) {
        if ([desc containsString:name]) {
            NSString *tmp = [NSString stringWithFormat:@"#%@#", name];
            NSRange range = [desc rangeOfString:tmp];
            rawText = [desc stringByReplacingCharactersInRange:range withString:@""];
        }else {
            rawText = desc;
        }
    }else {
        rawText = desc;
    }
    return rawText;
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTransitInformation:(NSDictionary *)components{
    __block NSString *selectStr = @"";
    NSString *tmp = components[descKeywords];
    NSString *pattern = @"[^#+]";
    NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    [regExp enumerateMatchesInString:tmp options:0 range:NSMakeRange(0, tmp.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSRange range = [result range];
        selectStr = [tmp substringWithRange:range];
    }];
    
    //跳转逻辑
    
}
@end


static NSString *authorNameKewwords = @"authorName";
@implementation FeedsDishDiggCell{
    NSMutableArray *_rangeArray;
    NSString *_rawText;
}
-(void)prepareForReuse{
    self.diggLabel.text = nil;
    [super prepareForReuse];
}
- (void)setDish:(FeedDish *)dish{
    _dish = dish;
    DiggUsers *diggUsers = dish.digg_users;
    _rangeArray = [NSMutableArray new];
    [self spliceTextAndCalculateRangeWithDiggUsers:diggUsers];
    self.diggLabel.text = _rawText;
    self.diggLabel.linkAttributes = [XCFLabelUtil tttAttributeLabelLinkAttributes];
    [XCFLabelUtil label:self.diggLabel addLinkWithRangeArray:_rangeArray andTransitInfoKey:authorNameKewwords];
}

- (void)spliceTextAndCalculateRangeWithDiggUsers:(DiggUsers *)diggUsers{
    NSInteger count = diggUsers.count;
    NSInteger total = diggUsers.total;
    if (0 < count && count < 5) {//ID有可能重名
        if (count == 1) {
            FeedAuthorOrUser *user = diggUsers.users.firstObject;
            _rawText = [NSString stringWithFormat:@"%@ 赞", user.name];
            NSRange range = [_rawText rangeOfString:user.name];
            [_rangeArray addObject:[NSValue valueWithRange:range]];
        }else {
            NSString *text = @"";
            for (NSInteger i = 0; i < count; i++) {
                if (count > i) {
                    FeedAuthorOrUser *diggUser = diggUsers.users[i];
                    if (i == count - 1) {
                        NSRange range = NSMakeRange(text.length, diggUser.name.length);
                        [_rangeArray addObject:[NSValue valueWithRange:range]];
                        text = [text stringByAppendingString:[NSString stringWithFormat:@"%@ 赞", diggUser.name]];
                    }else {
                        NSRange nameRange = NSMakeRange(text.length, diggUser.name.length);
                        [_rangeArray addObject:[NSValue valueWithRange:nameRange]];
                        text = [text stringByAppendingString:[NSString stringWithFormat:@"%@，", diggUser.name]];
                    }
                }
            }
            _rawText = text;
        }
    }else {
        NSString *_linkStr = [NSString stringWithFormat:@"%ld人", total];
        _rawText = [NSString stringWithFormat:@"%@ 赞", _linkStr];
        NSRange range = [_rawText rangeOfString:_linkStr];
        [_rangeArray addObject:[NSValue valueWithRange:range]];
    }
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTransitInformation:(NSDictionary *)components{
    NSString *selectStr = components[authorNameKewwords];
    NSLog(@"%@", selectStr);
    
    //跳转逻辑
}
@end


@implementation FeedsDishCommentNumCell
- (void)prepareForReuse{
    self.commentNumLabel.text = nil;
    [super prepareForReuse];
}

- (void)setDish:(FeedDish *)dish{
    _dish = dish;
    self.commentNumLabel.text = [NSString stringWithFormat:@"全部%ld条评论", dish.latest_comments.count];
}
@end


@implementation FeedsDishCommentCell{
    NSString *_rawText;
    NSMutableArray *_rangeArray;
}
- (void)prepareForReuse{
    self.commentLabel.text = nil;
    [super prepareForReuse];
}

- (void)setCommment:(LatestComment *)comment{
    _rangeArray = [NSMutableArray new];
    _rawText = [NSString stringWithFormat:@"%@：%@", comment.author.name, comment.txt];
    NSRange firstRange = NSMakeRange(0, comment.author.name.length);
    [_rangeArray addObject:[NSValue valueWithRange:firstRange]];
    self.commentLabel.delegate = self;
    self.commentLabel.text = _rawText;
    self.commentLabel.linkAttributes = [XCFLabelUtil tttAttributeLabelLinkAttributes];
    [_rangeArray addObjectsFromArray:[XCFStringUtil calculateRangeForAtUsersInCommentTxt:_rawText]];
    [XCFLabelUtil label:self.commentLabel addLinkWithRangeArray:_rangeArray andTransitInfoKey:authorNameKewwords];
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTransitInformation:(NSDictionary *)components{
    NSString *text = components[authorNameKewwords];
    NSLog(@"%@", text);
    
    //跳转逻辑
}
@end


@implementation FeedsDishMoreCell
- (void)awakeFromNib{
    [self.diggButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    [self.diggButton setImage:[UIImage imageNamed:@"liked"] forState:UIControlStateSelected];
}

- (void)prepareForReuse{
    self.diggButton.selected = NO;
    [super prepareForReuse];
}

- (void)setDish:(FeedDish *)dish{
    _dish = dish;
    if (dish.digged_by_me) {
        self.diggButton.selected = YES;
    }else {
        self.diggButton.selected = NO;
    }
}
@end


@implementation FeedsRecipeMoreCell
@end