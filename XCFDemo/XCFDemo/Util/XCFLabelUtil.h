//
//  XCFLabelUtil.h
//  XCFDemo
//
//  Created by Durian on 6/3/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTTAttributedLabel.h"

@interface XCFLabelUtil : NSObject

+ (NSDictionary *)tttAttributeLabelLinkAttributes;

+ (void)label:(TTTAttributedLabel *)label addLinkWithRangeArray:(NSMutableArray *)rangeArray andTransitInfoKey:(NSString *)key;

@end
