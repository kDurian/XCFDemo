//
//  SearchResultRecipeItemCell.m
//  XCFDemo
//
//  Created by Durian on 5/6/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "SearchResultRecipeItemCell.h"
#import "UIImageView+WebCache.h"

@implementation SearchResultRecipeItemCell

- (void)awakeFromNib
{
    self.exclusiveMarkLabel.hidden = YES;
}
- (void)prepareForReuse
{
    self.exclusiveMarkLabel.hidden = YES;
    _coverImageView.image = nil;
    _reciepIngLabel.text = nil;
    _recipeNameLabel.text = nil;
    _authorNameLabel.text = nil;
    [super prepareForReuse];
}

- (void)setRecipeItem:(Item *)recipeItem
{
    _recipeItem = recipeItem;
    
    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:recipeItem.itemObject.thumb]];
    _recipeNameLabel.text = recipeItem.itemObject.name;
    _reciepIngLabel.text = [self transformRecipeIngToString:recipeItem.itemObject.ingredient];
    _scoreAndCookedNumLabel.text = [self connectItemScoreAndDishesNum:recipeItem];
    _authorNameLabel.text = recipeItem.itemObject.author.name;
    if (recipeItem.itemObject.is_exclusive) {
        self.exclusiveMarkLabel.hidden = NO;
    }

}

- (NSString *)transformRecipeIngToString:(NSArray *)ingredient
{
    NSString *recipeIngString = @"";
    for (NSInteger index = 0; index < ingredient.count; ++index) {
        Ingredient *ing = ingredient[index];
        recipeIngString = [recipeIngString stringByAppendingString:ing.name];
        if (index < ingredient.count - 1) {
            recipeIngString = [recipeIngString stringByAppendingString:@" "];
        }
    }
    return recipeIngString;
}

- (NSString *)connectItemScoreAndDishesNum:(Item *)item
{
    NSString *scoreAndDishesNumString = @"";
    NSString *score = item.itemObject.score;
    NSInteger n_dishes = item.itemObject.stats.n_dishes;
    if (score.length == 0) {
        scoreAndDishesNumString = [NSString stringWithFormat:@"%ld人做过", n_dishes];
    }else {
        scoreAndDishesNumString = [NSString stringWithFormat:@"%@分 %ld人做过", score, n_dishes];
    }
    return scoreAndDishesNumString;
}
@end
