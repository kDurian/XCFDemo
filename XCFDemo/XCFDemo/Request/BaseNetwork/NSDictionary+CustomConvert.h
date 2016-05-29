//
//  NSDictionary+CustomConvert.h
//  GMiOSClient
//
//  Created by 阳小东 on 16/1/9.
//  Copyright © 2016年 xdyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (CustomConvert)

//将形如countryCode=CN&areaCode=11101010的字符串装换为字典,会去掉key value首位的空白字符
+ (NSDictionary *)getDicWithCustomString:(NSString *)customString withSepString:(NSString *)sepString;

//装换所有value为字符串类型
+ (NSDictionary *)convertAllValueToString:(NSDictionary *)dic;

//将key中的originalKey转变为toKey
- (NSDictionary *)convertAllKeyWithString:(NSString *)originalKey toString:(NSString *)toKey;

@end
