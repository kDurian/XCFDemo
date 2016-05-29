//
//  RecipeContent.h
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 3/19/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import <Realm/Realm.h>

@interface RecipePracticeStep : RLMObject
@property(nonatomic, strong) NSData *imageData;
@property(nonatomic, copy) NSString *text;
- (instancetype)initWithNSString:(NSString *)text imageData:(NSData *)imageData;
@end
RLM_ARRAY_TYPE(RecipePracticeStep)


@interface RecipeIngredient : RLMObject
@property(nonatomic, strong) NSString *ingredientName;
@property(nonatomic, strong) NSString *ingredientAmount;
- (instancetype)initWithName:(NSString *)name amount:(NSString *)amount;
@end
RLM_ARRAY_TYPE(RecipeIngredient)


@interface Recipe : RLMObject
@property(nonatomic, strong) NSData *coverImageData;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *desc;
@property(nonatomic, strong) RLMArray<RecipeIngredient *><RecipeIngredient> *ingredients;
@property(nonatomic, strong) RLMArray<RecipePracticeStep *><RecipePracticeStep> *practiceSteps;
@property(nonatomic, strong) NSString *updateTime;
@property(nonatomic, copy) NSString *tips;
@end
RLM_ARRAY_TYPE(Recipe)


@interface RecipeDraft : RLMObject
@property(nonatomic, assign) NSString *kRecipeDraft ;
@property(nonatomic, strong) RLMArray<Recipe *><Recipe> *recipes;
@end
