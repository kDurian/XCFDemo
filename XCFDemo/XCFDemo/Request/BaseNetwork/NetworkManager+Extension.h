//
//  NetworkManager+Extension.h
//  XCFDemo
//
//  Created by Durian on 5/4/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "NetworkManager.h"

@interface NetworkManager (Extension)

//添加基本请求参数
+ (NSMutableDictionary *)appendBaseParamWith:(NSDictionary *)param;

//对参数进行签名
+ (NSDictionary *)SignatureWithPara:(NSDictionary *)param;

@end
