//
//  BaseEntity.m
//  GMiOSClient
//
//  Created by 阳小东 on 15/11/25.
//  Copyright © 2015年 xdyang. All rights reserved.
//

#import "BaseEntity.h"

@implementation BaseEntity

- (void)encodeWithCoder:(NSCoder *)aCoder { [self yy_modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { self = [super init]; return [self yy_modelInitWithCoder:aDecoder]; }
- (id)copyWithZone:(NSZone *)zone { return [self yy_modelCopy]; }
- (NSUInteger)hash { return [self yy_modelHash]; }
- (BOOL)isEqual:(id)object { return [self yy_modelIsEqual:object]; }

@end
