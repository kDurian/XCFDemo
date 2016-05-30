//
//  SecondRowTableViewCell.m
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 1/11/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "KitchenNavCell.h"
#import "YYWebImage.h"

@implementation KitchenNavCell
- (void)setContent:(HomePageContentModel *)content{
    _content = content;
    HomePageNavsModel *model1 = content.navs[0];
    [self.firstButton yy_setImageWithURL:[NSURL URLWithString:model1.picurl] forState:UIControlStateNormal options:YYWebImageOptionUseNSURLCache];
    self.firstLabel.text = model1.name;
    
    HomePageNavsModel *model2 = content.navs[1];
    [self.secondButton yy_setImageWithURL:[NSURL URLWithString:model2.picurl] forState:UIControlStateNormal options:YYWebImageOptionUseNSURLCache];
    self.secondLabel.text = model2.name;
    
    HomePageNavsModel *model3 = content.navs[2];
    [self.thirdButton yy_setImageWithURL:[NSURL URLWithString:model3.picurl] forState:UIControlStateNormal options:YYWebImageOptionUseNSURLCache];
    self.thirdLabel.text = model3.name;
    
    HomePageNavsModel *model4 = content.navs[3];
    [self.fourthButton yy_setImageWithURL:[NSURL URLWithString:model4.picurl] forState:UIControlStateNormal options:YYWebImageOptionUseNSURLCache];
    self.fourthLabel.text = model4.name;
}
@end
