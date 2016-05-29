//
//  PopEventsScrollView.m
//  Demo_GotoKitchen
//
//  Created by 刘金涛 on 1/19/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "PopEventsView.h"
#import "PopEventCollectionViewCell.h"

#import "YYWebImage.h"
#import "Masonry.h"
#import "UIView+SDExtension.h"

static NSString * const PopEventsCollectionViewCellID = @"PopEventCell";

#define CURRENT_PAGE_INDICATOR_TINT_COLOR [UIColor colorWithRed:204 / 255.0f green:48 / 255.0f blue:30 / 255.0f alpha:1];
#define PAGE_INDICATOR_TINT_COLOR [UIColor colorWithRed:225/255.0f green:222/255.0f blue:218/255.0f alpha:1];

@interface PopEventsView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic, strong) UIPageControl *pageControl;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, assign) NSInteger totalItemscount;

@property(nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@end

@implementation PopEventsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
        [self setupMainView];
    }
    return self;
}

- (void)initialization
{
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
    _flowLayout.itemSize = self.frame.size;
}

#pragma mark - Private methods
- (void)setupPageControl
{
    
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.numberOfPages = self.totalItemscount;
    self.pageControl.currentPageIndicatorTintColor = CURRENT_PAGE_INDICATOR_TINT_COLOR;
    self.pageControl.pageIndicatorTintColor = PAGE_INDICATOR_TINT_COLOR;
    
    [self addSubview:self.pageControl];
    
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).with.offset(8.0f);
    }];
    
    if (self.totalItemscount == 1)
    {
        self.pageControl.hidden = YES;
    }
    
}

- (void)setupMainView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _flowLayout = flowLayout;
    _flowLayout.itemSize = self.frame.size;
    
    UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    mainView.backgroundColor = [UIColor clearColor];
    mainView.pagingEnabled = YES;
    mainView.showsHorizontalScrollIndicator = NO;
    mainView.showsVerticalScrollIndicator = NO;
    
//    [mainView registerClass:[PopEventCollectionViewCell class] forCellWithReuseIdentifier:PopEventsCollectionViewCellID];
    [mainView registerNib:[UINib nibWithNibName:@"PopEventCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:PopEventsCollectionViewCellID];
    
    mainView.dataSource = self;
    mainView.delegate = self;
    
    [self addSubview:mainView];
    _collectionView = mainView;
}

#pragma mark - Public methods

+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame delegate:(id<PopEventsScrollViewDelegate>)delegate
{
    PopEventsView *view = [[self alloc] initWithFrame:frame];
    view.delegate = delegate;
    return view;
}

#pragma mark - Setter

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    
}

- (void)setImageURLs:(NSArray *)imageURLs
{
    _imageURLs = imageURLs;
    
    _totalItemscount = _imageURLs.count;
    
    [self setupPageControl];
    
    [self.collectionView reloadData];
}

#pragma mark - UICollectionView dataSource & delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageURLs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PopEventCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PopEventsCollectionViewCellID forIndexPath:indexPath];
    
    NSInteger itemIndex = indexPath.item;
    
    NSString *imageURL = self.imageURLs[itemIndex];

    cell.illImageView.yy_imageURL = [NSURL URLWithString:imageURL];
    
    cell.titleLabel.text = self.titles[itemIndex];
    
    NSNumber *count = self.counts[itemIndex];
    NSInteger number = count.integerValue;
    
    cell.countLabel.text = [NSString stringWithFormat:@"%ld 作品", number];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(cycleSrcollView:didSelectItemAtIndex:)]) {
        [self.delegate cycleSrcollView:self didSelectItemAtIndex:indexPath.item];
    }
}

#pragma mark - UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int indexOfPageControl = (scrollView.contentOffset.x + self.collectionView.sd_width * 0.5) / self.collectionView.sd_width;
    
    self.pageControl.currentPage = indexOfPageControl;
}

@end
