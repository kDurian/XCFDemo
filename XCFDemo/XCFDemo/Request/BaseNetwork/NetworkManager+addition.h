//
//  NetworkManager+addition.h
//  GMiOSClient
//  description:增加网络库的功能，提供一些工具
//  Created by 阳小东 on 15/11/26.
//  Copyright © 2015年 xdyang. All rights reserved.
//

#import "NetworkManager.h"

@interface NetworkManager (addition)

//添加基本请求参数
+ (NSMutableDictionary *)appendBaseParamWith:(NSDictionary *)param;

//对参数进行签名
+ (NSDictionary *)SignatureWithPara:(NSDictionary *)param;


@end
