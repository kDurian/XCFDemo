//
//  RecipeContent.m
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 3/19/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "Recipe.h"

@implementation RecipePracticeStep

- (instancetype)initWithNSString:(NSString *)text imageData :(NSData *)imageData
{
    self = [super init];
    if (self) {
        self.text = text;
        self.imageData = imageData;
    }
    return self;
}

@end


@implementation RecipeIngredient

- (instancetype)initWithName:(NSString *)name amount:(NSString *)amount
{
    self = [super init];
    if (self) {
        self.ingredientName = name;
        self.ingredientAmount = amount;
    }
    return self;
}

@end



@implementation Recipe
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"ingredients" : [RecipeIngredient class],
             @"practiceSteps" : [RecipePracticeStep class],
             };
}
@end

@implementation RecipeDraft

+ (NSString *)primaryKey {
    return @"kRecipeDraft";
}

@end