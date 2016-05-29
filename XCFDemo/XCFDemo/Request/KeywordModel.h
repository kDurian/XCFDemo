//
//  KeywordModel.h
//  XCFDemo
//
//  Created by Durian on 5/3/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "BaseEntity.h"

@interface KeywordContent : NSObject

@property(nonatomic, strong) NSArray *keywords;

@end



@interface KeywordResponse : BaseEntity

@property(nonatomic, strong) KeywordContent *content;

@end
