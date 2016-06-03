//
//  XCFLabelUtil.m
//  XCFDemo
//
//  Created by Durian on 6/3/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "XCFLabelUtil.h"
#import "UIColor+KDExtension.h"
#import <CoreText/CoreText.h>

static NSString *authorNameKewwords = @"authorName";

@implementation XCFLabelUtil
+ (NSDictionary *)tttAttributeLabelLinkAttributes{
    UIColor *textColor = [UIColor feedsAttributeLabelTextColor];
    return  @{
              (id)kCTForegroundColorAttributeName : textColor,
              (id)kCTUnderlineStyleAttributeName : [NSNumber numberWithBool:NO]
              };
}

+ (void)label:(TTTAttributedLabel *)label addLinkWithRangeArray:(NSMutableArray *)rangeArray andTransitInfoKey:(NSString *)key{
    NSString *rawText = label.text;
    [rangeArray enumerateObjectsUsingBlock:^(NSValue *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange range = obj.rangeValue;
        NSDictionary *transitInfo = @{ authorNameKewwords : [rawText substringWithRange:range] };
        [label addLinkToTransitInformation:transitInfo withRange:range];
    }];
}
@end
