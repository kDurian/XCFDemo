//
//  FeedsCommentCell.m
//  XCFDemo
//
//  Created by Durian on 6/1/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "FeedsCommentCell.h"
#import "TTTAttributedLabel.h"
#import "XCFStringUtil.h"
#import "XCFLabelUtil.h"

static NSString *authorNameKey = @"authorName";

@interface FeedsCommentCell()<TTTAttributedLabelDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@end

@implementation FeedsCommentCell{
    NSString *_rawText;
    NSMutableArray *_rangeArray;
}
- (void)awakeFromNib{
    self.avatarImageView.layer.cornerRadius = CGRectGetWidth(self.avatarImageView.bounds) / 2;
}

- (void)setComment:(LatestComment *)comment{
    _rangeArray = [NSMutableArray new];
    _rawText = [NSString stringWithFormat:@"%@：%@", comment.author.name, comment.txt];
    NSRange firstRange = NSMakeRange(0, comment.author.name.length);
    [_rangeArray addObject:[NSValue valueWithRange:firstRange]];
    self.titleLabel.delegate = self;
    self.titleLabel.text = _rawText;
    self.titleLabel.linkAttributes = [XCFLabelUtil tttAttributeLabelLinkAttributes];
    [_rangeArray addObjectsFromArray:[XCFStringUtil calculateRangeForAtUsersInCommentTxt:_rawText]];
    [XCFLabelUtil label:self.titleLabel addLinkWithRangeArray:_rangeArray andTransitInfoKey:authorNameKey];
}

//跳转逻辑
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTransitInformation:(NSDictionary *)components{
    
}
@end
