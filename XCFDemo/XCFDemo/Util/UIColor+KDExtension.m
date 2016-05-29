//
//  UIColor+KDExtension.m
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 3/29/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "UIColor+KDExtension.h"
#import "Config.h"

@implementation UIColor (KDExtension)

+ (UIColor *)alertMessageViewBackgroundColor
{
    return RGB(80, 80, 80);
}

+ (UIColor *)textFieldCursorColor
{
    return RGB(93, 82, 77);
}

+ (UIColor *)textFieldTextColor{
    return RGB(93, 82, 77);
}

+ (UIColor *)navigationBarTintColor
{
    return RGB(93, 82, 77);
}

+ (UIColor *)emptyRecipeDraftPlaceHolderTextColor
{
    return RGB(93, 82, 77);
}

+ (UIColor *)feedsAttributeLabelTextColor
{
    return RGB(220, 46, 14);
}
@end
