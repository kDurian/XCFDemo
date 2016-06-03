//
//  XCFStringUtil.h
//  XCFDemo
//
//  Created by Durian on 6/3/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCFStringUtil : NSObject
+ (NSMutableArray *)calculateRangeForAtUsersInCommentTxt:(NSString *)txt;

+ (NSMutableArray *)calculateRangeForKeywordsInDescTxt:(NSString *)txt;
@end
