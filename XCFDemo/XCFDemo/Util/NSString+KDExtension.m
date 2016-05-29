//
//  NSString+KDExtension.m
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 4/7/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "NSString+KDExtension.h"

@implementation NSString (KDExtension)

- (CGSize)calculateSize:(CGSize)size font:(UIFont *)font
{
    CGSize expectedLabelSize = CGSizeZero;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        
        NSDictionary *attributes = @{NSFontAttributeName : font, NSParagraphStyleAttributeName : paragraphStyle.copy};
        
        expectedLabelSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    }else {
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        
        expectedLabelSize = [self sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        
#pragma clang diagnostic pop
    }
    
    return CGSizeMake(ceil(expectedLabelSize.width), ceil(expectedLabelSize.height)); // ceil(x)返回不小于x的最小整数值（然后转换为double型）
    
    
}

@end
