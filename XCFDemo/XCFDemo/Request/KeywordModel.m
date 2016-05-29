//
//  KeywordModel.m
//  XCFDemo
//
//  Created by Durian on 5/3/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "KeywordModel.h"


@implementation KeywordContent

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"keywords" : [NSString class]};
}

@end



@implementation KeywordResponse

@end
