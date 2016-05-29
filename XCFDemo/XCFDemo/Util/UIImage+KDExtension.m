//
//  UIImage+KDExtension.m
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 3/10/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "UIImage+KDExtension.h"

@implementation UIImage (KDExtension)
-(UIImage*)getSubImage:(CGRect)rect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return smallImage;
}

@end
