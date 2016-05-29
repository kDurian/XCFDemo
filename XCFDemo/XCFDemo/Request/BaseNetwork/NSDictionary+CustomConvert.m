//
//  NSDictionary+CustomConvert.m
//  GMiOSClient
//
//  Created by 阳小东 on 16/1/9.
//  Copyright © 2016年 xdyang. All rights reserved.
//

#import "NSDictionary+CustomConvert.h"

@implementation NSDictionary (CustomConvert)

+ (NSDictionary *)getDicWithCustomString:(NSString *)customString withSepString:(NSString *)sepString
{
    if (customString.length <= 0 || sepString.length <= 0){
        return nil;
    }
    
    NSArray *array = [customString componentsSeparatedByString:sepString];
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
    for (NSString *itemString in array){
        NSArray *keyValueArray  = [itemString componentsSeparatedByString:@"="];
        if (keyValueArray.count != 2){
            continue;
        }
        NSString *key = keyValueArray[0];
        key = [key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *value = keyValueArray[1];
        value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (key.length <= 0 || value.length <= 0){
            continue;
        }
        resultDic[key] = value;
    }
    if (resultDic.count > 0){
        return resultDic;
    }
    
    return nil;
}

+ (NSDictionary *)convertAllValueToString:(NSDictionary *)dic
{
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
    for(id key in dic.allKeys)
    {
        id value = [dic objectForKey:key];
        NSString *stringValue = nil;
        if ([value isKindOfClass:[NSString class]]){
            stringValue = (NSString *)value;
        }else if ([value respondsToSelector:@selector(stringValue)]){
            stringValue = [value stringValue];
        }
        if (stringValue.length <= 0){
            continue;
        }
        resultDic[key] = stringValue;
    }
    
    if (resultDic.count <= 0){
        return nil;
    }
    
    return resultDic;
}

- (NSDictionary *)convertAllKeyWithString:(NSString *)originalKey toString:(NSString *)toKey
{
    if (originalKey.length <= 0 || !toKey){
        return nil;
    }
    
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
    for (NSString *key in self.allKeys){
        NSObject *value = self[key];
        if ([key rangeOfString:originalKey].location == NSNotFound){
            resultDic[key] = value;
            continue;
        }
        NSString *replaceKey = [key stringByReplacingOccurrencesOfString:originalKey withString:toKey];
        resultDic[replaceKey] = value;
    }
    
    return resultDic;
}

@end
