//
//  BaseEntity.h
//  GMiOSClient
//  description:基础实体(Model)
//  Created by 阳小东 on 15/11/25.
//  Copyright © 2015年 xdyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"

@interface BaseEntity : NSObject<NSCoding, NSCopying>

@property (nonatomic)NSString *status;

 //只请求失败返回
@property (nonatomic)NSInteger code;
@property (nonatomic)NSString *msg;

@end
