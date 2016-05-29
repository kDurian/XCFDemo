
//
//  Config.h
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 1/14/16.
//  Copyright © 2016 durian. All rights reserved.
//

#ifndef Config_h
#define Config_h
#import <Foundation/Foundation.h>

typedef void (^CompletionBlock)(id returnValue);
typedef void (^FailureBlock)(NSError *error) ;

#define RGB(A, B, C)    [UIColor colorWithRed:A/255.0 green:B/255.0 blue:C/255.0 alpha:1.0]


#define XCF_SCREEN_PORTRAIT_WIDTH (MIN([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height))
#define XCF_SCREEN_PORTRAIT_HEIGHT (MAX([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height))



#endif /* Config_h */
