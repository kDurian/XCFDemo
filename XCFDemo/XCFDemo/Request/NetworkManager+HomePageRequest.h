//
//  NetworkManager+HomePageRequest.h
//  Demo_GotoKitchen
//  description:首页请求接口
//  Created by 阳小东 on 16/1/26.
//  Copyright © 2016年 durian. All rights reserved.
//

#import "NetworkManager.h"


@interface NetworkManager (HomePageRequest)

//获取首页数据
+ (AFHTTPRequestOperation *)getHomePageInfoWithSuccBlock:(RequestCallbackBlock)succBlock withFailedBlock:(RequestCallbackBlock)failedBlock;

@end
