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

#import "UIColor+KDExtension.h"

#import "NSDate+KDExtension.h"

#import "UIView+SDExtension.h"

static NSString *const kFeedsDishCollectionCellID = @"kFeedsDishCollectionCell";

static NSDictionary* GetAttributeLabelLinkAttributes(){
    
    UIColor *textColor = [UIColor feedsAttributeLabelTextColor];
    return  @{
                (id)kCTForegroundColorAttributeName : textColor,
                (id)kCTUnderlineStyleAttributeName : [NSNumber numberWithBool:NO]
            };
}

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
    [super prepareForReuse];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _collectionView.pagingEnabled = YES;
        _pageIndicatorView.layer.cornerRadius = 14.0;
    }
    return self;
}

- (void)setDish:(FeedDish *)dish{
    _dish = dish;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    if (dish.extra_pics.count == 0) {
        self.pageIndicatorView.hidden = YES;
        self.isHiddenPageIndicator = YES;
    }else {
        self.pageIndicatorView.hidden = NO;
        self.isHiddenPageIndicator = NO;
        self.pageIndicatorLabel.text = [NSString stringWithFormat:@"%ld/%ld", self.curPageNum, self.totalPageNum];
    }
}

#pragma mark - UICollectionViewDelegate && DataSource
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

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger indexOfPage = scrollView.contentOffset.x / self.collectionView.sd_width;
    self.curPageNum = indexOfPage + 1;
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

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
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
    NSString *_rawText;
}
- (void)prepareForReuse{
    self.descLabel.text = nil;
    [super prepareForReuse];
}
- (void)setDish:(FeedDish *)dish{
    _dish = dish;
    self.descLabel.text = dish.desc;
}

- (void)setRecipe:(FeedRecipe *)recipe{
    _recipe = recipe;
    _rawText = recipe.desc;
    NSMutableArray *rangeArray = [self rangeArrayOfStringBetweenPoundKey:_rawText];
    self.descLabel.text = _rawText;
    [self addLinkToTextWithRangeArray:rangeArray];
}

- (NSMutableArray *)rangeArrayOfStringBetweenPoundKey:(NSString *)string{
    __block NSMutableArray *rangeArray = [NSMutableArray array];
    NSString *pattern = @"#[^#]#";
    NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    [regExp enumerateMatchesInString:string options:0 range:NSMakeRange(0, string.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSRange range = [result range];
        [rangeArray addObject:[NSValue valueWithRange:range]];
    }];
    return rangeArray;
}

- (void)addLinkToTextWithRangeArray:(NSMutableArray *)rangeArray{
    [rangeArray enumerateObjectsUsingBlock:^(NSValue *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange range = obj.rangeValue;
        NSDictionary *transitInformation = @{descKeywords : [_rawText substringWithRange:range]};
        self.descLabel.linkAttributes = GetAttributeLabelLinkAttributes();
        [self.descLabel addLinkToTransitInformation:transitInformation withRange:range];
    }];
}

#pragma mark - TTTAuttributeLabelDeledate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTransitInformation:(NSDictionary *)components
{
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
    self.diggLabel.linkAttributes = GetAttributeLabelLinkAttributes();
    [self addLinkForTextAtSpecifiedRange];
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
                        [text stringByAppendingString:[NSString stringWithFormat:@"%@ 赞", diggUser.name]];
                        NSRange range = NSMakeRange(text.length, diggUser.name.length);
                        [_rangeArray addObject:[NSValue valueWithRange:range]];
                    }else {
                        [text stringByAppendingString:[NSString stringWithFormat:@"%@，", diggUser.name]];
                        NSRange nameRange = NSMakeRange(text.length, diggUser.name.length);
                        [_rangeArray addObject:[NSValue valueWithRange:nameRange]];
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

- (void)addLinkForTextAtSpecifiedRange{
    [_rangeArray enumerateObjectsUsingBlock:^(NSValue *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange range = obj.rangeValue;
        NSDictionary *transitInfo = @{ authorNameKewwords : [_rawText substringWithRange:range]};
        [self.diggLabel addLinkToTransitInformation:transitInfo withRange:range];
    }];
}

#pragma mark - TTTAttributeLabelDelegate
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

- (void)setCommment:(LastestComment *)comment{
    _rangeArray = [NSMutableArray new];
    _rawText = [NSString stringWithFormat:@"%@：%@", comment.author.name, comment.txt];
    NSRange firstRange = NSMakeRange(0, comment.author.name.length);
    [_rangeArray addObject:[NSValue valueWithRange:firstRange]];
    self.commentLabel.text = _rawText;
    self.commentLabel.linkAttributes = GetAttributeLabelLinkAttributes();
    [self calculateRangeForAtUsersInCommentTxt:comment.txt];
    [self addLinkForTextAtSpecifiedRange];
}

- (void)calculateRangeForAtUsersInCommentTxt:(NSString *)txt{
    NSString *pattern = @"(@.+\\s)|(@.+$)";
    NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    [regExp enumerateMatchesInString:txt options:0 range:NSMakeRange(0, txt.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSRange range = [result range];
        [_rangeArray addObject:[NSValue valueWithRange:range]];
    }];
}

- (void)addLinkForTextAtSpecifiedRange{
    [_rangeArray enumerateObjectsUsingBlock:^(NSValue *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange range = obj.rangeValue;
        NSDictionary *transitInfo = @{ authorNameKewwords : [_rawText substringWithRange:range] };
        [self.commentLabel addLinkToTransitInformation:transitInfo withRange:range];
    }];
}

#pragma mark - TTTAttributeLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTransitInformation:(NSDictionary *)components{
    NSString *text = components[authorNameKewwords];
    NSLog(@"%@", text);
    
    //跳转逻辑
}
@end



@implementation FeedsDishMoreCell
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self.diggButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        [self.diggButton setImage:[UIImage imageNamed:@"liked"] forState:UIControlStateSelected];
    }
    return self;
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