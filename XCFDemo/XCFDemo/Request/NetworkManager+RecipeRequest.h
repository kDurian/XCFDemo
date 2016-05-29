//
//  NetworkManager+RecipeRequest.h
//  Demo_GotoKitchen
//  description:食谱请求接口
//  Created by 阳小东 on 16/1/26.
//  Copyright © 2016年 durian. All rights reserved.
//

#import "NetworkManager.h"

@interface NetworkManager (RecipeRequest)

+ (AFHTTPRequestOperation *)getRecipeInfoWithSuccBlock:(RequestCallbackBlock)succBlock andFailBlock:(RequestCallbackBlock)failBlock atDate:(NSString *)cursorDate;

@end
