//
//  XCFStringUtil.m
//  XCFDemo
//
//  Created by Durian on 6/3/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "XCFStringUtil.h"

@implementation XCFStringUtil
+ (NSMutableArray *)calculateRangeForAtUsersInCommentTxt:(NSString *)txt{
    NSMutableArray *rangeArray = [NSMutableArray new];
    NSString *pattern = @"(@.+\\s)|(@.+$)";
    NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    [regExp enumerateMatchesInString:txt options:0 range:NSMakeRange(0, txt.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSRange range = [result range];
        [rangeArray addObject:[NSValue valueWithRange:range]];
    }];
    return rangeArray;
}

+ (NSMutableArray *)calculateRangeForKeywordsInDescTxt:(NSString *)txt{
    NSMutableArray *rangeArray = [NSMutableArray new];
    NSString *pattern = @"#[^#]+#";
    NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    [regExp enumerateMatchesInString:txt options:0 range:NSMakeRange(0, txt.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSRange range = [result range];
        [rangeArray addObject:[NSValue valueWithRange:range]];
    }];
    return rangeArray;
}

@end
