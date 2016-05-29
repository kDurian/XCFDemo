//
//  FifthTableViewCell.m
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 1/13/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "KitchenRecipeCell.h"
#import "YYWebImage.h"
#import "UIView+SDExtension.h"
#import "Masonry.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+KDExtension.h"


@implementation KitchenRecipeCell

- (void)awakeFromNib {
    
    self.authorAvatarImageView.layer.cornerRadius = 20;
    self.authorAvatarImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)recipeCellBindRecipeItem:(RecipeItem *)item
{
    
    RecipeItemContents *contents = item.contents;
    
    //缓存原始图片
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:contents.image.url]];
    UIImage *image = [UIImage imageWithData:imageData];
    
    CGSize size = [KitchenRecipeCell downloadImageSizeWithURL:contents.image.url];
    
    CGRect finalRect = CGRectMake(0, (size.height - 380) / 2, size.width, 380);
    
    self.recipeImageView.image = [image getSubImage:finalRect];
    
    NSLog(@"image size: %@", NSStringFromCGSize(size));
    
    self.authorAvatarImageView.yy_imageURL = [NSURL URLWithString:contents.author.photoURL];
    
    self.recipeTitleLabel.text             = contents.title;
    
    self.recipeSummaryLabel.text           = contents.desc;
    
    self.authorIDLabel.text                = contents.author.name;
    
    [self setTextOfLabel:self.scoreAndCookedLabel withItemContents:contents];
}

- (void)setTextOfLabel:(UILabel *)label withItemContents:(RecipeItemContents *)contents
{
    NSString *cookedNumberString = [NSString stringWithFormat:@"%ld人做过", contents.n_cooked];
    NSString *combinedString = nil;
    if (contents.score.length > 0)
    {
        if (contents.score.length < 2)
        {
            combinedString = [NSString stringWithFormat:@"%@分 • %@", contents.score, cookedNumberString];
        }else
        {
            NSString *substringOfScore = [contents.score substringWithRange:NSMakeRange(0, 3)];
            combinedString = [NSString stringWithFormat:@"%@分 • %@", substringOfScore, cookedNumberString];
        }
        
        label.text = combinedString;
    }else
    {
        label.text = cookedNumberString;
    }
}


+(CGSize)downloadImageSizeWithURL:(id)imageURL
{
    NSURL* URL = nil;
    if([imageURL isKindOfClass:[NSURL class]]){
        URL = imageURL;
    }
    if([imageURL isKindOfClass:[NSString class]]){
        URL = [NSURL URLWithString:imageURL];
    }
    if(URL == nil)
        return CGSizeZero;
    
    NSString* absoluteString = URL.absoluteString;
    
#ifdef dispatch_main_sync_safe
    if([[SDImageCache sharedImageCache] diskImageExistsWithKey:absoluteString])
    {
        UIImage* image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:absoluteString];
        if(!image)
        {
            NSData* data = [[SDImageCache sharedImageCache] performSelector:@selector(diskImageDataBySearchingAllPathsForKey:) withObject:URL.absoluteString];
            image = [UIImage imageWithData:data];
        }
        if(image)
        {
            return image.size;
        }
    }
#endif
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    NSString* pathExtendsion = [URL.pathExtension lowercaseString];
    
    CGSize size = CGSizeZero;
    if([pathExtendsion isEqualToString:@"png"]){
        size =  [self downloadPNGImageSizeWithRequest:request];
    }
    else if([pathExtendsion isEqual:@"gif"])
    {
        size =  [self downloadGIFImageSizeWithRequest:request];
    }
    else{
        size = [self downloadJPGImageSizeWithRequest:request];
    }
    if(CGSizeEqualToSize(CGSizeZero, size))
    {
        __block NSData *imageData = nil;
        
        NSURLSessionDataTask *task = [[NSURLSession alloc] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            imageData = data;
        }];
        
        [task resume];

        UIImage* image = [UIImage imageWithData:imageData];
        if(image)
        {
#ifdef dispatch_main_sync_safe
            [[SDImageCache sharedImageCache] storeImage:image recalculateFromImage:YES imageData:imageData forKey:URL.absoluteString toDisk:YES];
#endif
            size = image.size;
        }
    }
    return size;
}
+(CGSize)downloadPNGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
    __block NSData *imageData = nil;
    
    NSURLSessionDataTask *task = [[NSURLSession alloc] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        imageData = data;
    }];
    
    [task resume];
    if(imageData.length == 8)
    {
        int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
        [imageData getBytes:&w1 range:NSMakeRange(0, 1)];
        [imageData getBytes:&w2 range:NSMakeRange(1, 1)];
        [imageData getBytes:&w3 range:NSMakeRange(2, 1)];
        [imageData getBytes:&w4 range:NSMakeRange(3, 1)];
        int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
        int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
        [imageData getBytes:&h1 range:NSMakeRange(4, 1)];
        [imageData getBytes:&h2 range:NSMakeRange(5, 1)];
        [imageData getBytes:&h3 range:NSMakeRange(6, 1)];
        [imageData getBytes:&h4 range:NSMakeRange(7, 1)];
        int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}

+(CGSize)downloadGIFImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=6-9" forHTTPHeaderField:@"Range"];
    __block NSData *data = nil;
    
    NSURLSessionDataTask *task = [[NSURLSession alloc] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable imageData, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        data = imageData;
    }];
    
    [task resume];
    if(data.length == 4)
    {
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        short w = w1 + (w2 << 8);
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(2, 1)];
        [data getBytes:&h2 range:NSMakeRange(3, 1)];
        short h = h1 + (h2 << 8);
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}

+(CGSize)downloadJPGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
    
    __block NSData *data = nil;
    
    NSURLSessionDataTask *task = [[NSURLSession alloc] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable imageData, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        data = imageData;
    }];
    
    [task resume];
    
    if ([data length] <= 0x58) {
        return CGSizeZero;
    }
    
    if ([data length] < 210) {// 肯定只有一个DQT字段
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        short w = (w1 << 8) + w2;
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        short h = (h1 << 8) + h2;
        return CGSizeMake(w, h);
    } else {
        short word = 0x0;
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        if (word == 0xdb) {
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) {// 两个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            } else {// 一个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            }
        } else {
            return CGSizeZero;
        }
    }
}

-(id)diskImageDataBySearchingAllPathsForKey:(id)key
{
    return nil;
}

@end
