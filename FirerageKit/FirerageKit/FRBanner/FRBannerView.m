//
//  FRBannerView.m
//  FirerageKit
//
//  Created by Aidian.Tang on 14-5-22.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "FRBannerView.h"
#import "UIImageView+WebCache.h"

static CGFloat AutoRollingDefaultDelayTime = 2.;

@interface FRBannerView () <UIScrollViewDelegate>
{
    NSInteger _totalPage;
    NSInteger _totalCount;
}

@property (nonatomic, assign, readwrite) BOOL autoRolling;
@property (nonatomic, assign) FRBannerViewDirection direction;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation FRBannerView

- (id)initWithFrame:(CGRect)frame direction:(FRBannerViewDirection)direction bannerItems:(NSArray *)bannerItems
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initView];
        [self setDefaultDatas];
        self.direction = direction;
        self.bannerItems = bannerItems;
        [self reloadData];
    }
    return self;
}

- (void)setDefaultDatas
{
    _totalPage = _bannerItems.count;
    _totalCount = _totalPage;
    _curPage = 1;
    self.autoRoolEnabled = YES;
    self.autoRollingDelayTime = AutoRollingDefaultDelayTime;
    self.pageControlStyle = FRBannerViewPageControlMiddleStyle;
}

- (void)awakeFromNib
{
    [self initView];
    [self setDefaultDatas];
}

- (void)initView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    if(_direction == RBannerViewDefaultDirection || _direction == RBannerViewLandscapeDirection)
    {
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * 3,
                                            _scrollView.frame.size.height);
    }
    else if(_direction == RBannerViewPortaitDirection)
    {
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width,
                                            _scrollView.frame.size.height * 3);
    }
    
    for (NSInteger i = 0; i < 3; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:_scrollView.bounds];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i+1;
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bannerItemDidTaped:)];
        [imageView addGestureRecognizer:singleTap];
        
        if(_direction == RBannerViewDefaultDirection || _direction == RBannerViewLandscapeDirection)
        {
            imageView.frame = CGRectOffset(imageView.frame, _scrollView.frame.size.width * i, 0);
        }
        else if(_direction == RBannerViewPortaitDirection)
        {
            imageView.frame = CGRectOffset(imageView.frame, 0, _scrollView.frame.size.height * i);
        }
        
        [_scrollView addSubview:imageView];
    }
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(5, self.bounds.size.height-15, 60, 15)];
    self.pageControl.numberOfPages = self.bannerItems.count;
    [self addSubview:self.pageControl];
    self.pageControl.currentPage = 0;
}

#pragma mark -
#pragma mark - Setter Methods

- (void)setAutoRoolEnabled:(BOOL)autoRoolEnabled
{
    _autoRoolEnabled = autoRoolEnabled;
    if (_autoRoolEnabled && !_autoRolling) {
        [self startRolling];
    } else if (!_autoRoolEnabled && _autoRolling) {
        [self stopRolling];
    }
}

- (void)setCurPage:(NSInteger)curPage
{
    _curPage = [self getPageIndex:curPage];
    [self refreshScrollView];
    if (self.autoRoolEnabled)
    {
        [self performSelector:@selector(rollingScrollAction) withObject:nil afterDelay:self.autoRollingDelayTime];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(bannerView:didRollItemAtIndex:)]) {
        [_delegate bannerView:self didRollItemAtIndex:_curPage-1];
    }
}

- (void)setBannerItems:(NSArray *)bannerItems
{
    _bannerItems = bannerItems;
    self.pageControl.numberOfPages = self.bannerItems.count;
}

- (void)setPageControlStyle:(FRBannerViewPageControlStyle)pageControlStyle
{
    if (pageControlStyle == FRBannerViewPageControlLeftStyle)
    {
        [self.pageControl setFrame:CGRectMake(5, self.bounds.size.height-15, 60, 15)];
    }
    else if (pageControlStyle == FRBannerViewPageControlRightStyle)
    {
        [self.pageControl setFrame:CGRectMake(self.bounds.size.width-5-60, self.bounds.size.height-15, 60, 15)];
    }
    else if (pageControlStyle == FRBannerViewPageControlMiddleStyle || pageControlStyle == FRBannerViewPageControlDefaultStyle)
    {
        [self.pageControl setFrame:CGRectMake((self.bounds.size.width-60)/2, self.bounds.size.height-15, 60, 15)];
    }
    else if (pageControlStyle == FRBannerViewPageControlNoneStyle)
    {
        [self.pageControl setHidden:YES];
    }
}

#pragma mark -
#pragma mark - Private Methods

- (NSArray *)getDisplayItemsWithPageIndex:(NSInteger)page
{
    NSInteger pre = [self getPageIndex:_curPage-1];
    NSInteger last = [self getPageIndex:_curPage+1];

    NSMutableArray *images = [NSMutableArray arrayWithCapacity:0];
    [images addObject:[_bannerItems objectAtIndex:pre-1]];
    [images addObject:[_bannerItems objectAtIndex:_curPage-1]];
    [images addObject:[_bannerItems objectAtIndex:last-1]];
    
    return images;
}

- (NSInteger)getPageIndex:(NSInteger)index
{
    if (index == 0) {
        index = _totalPage;
    }
    
    if (index == _totalPage + 1) {
        index = 1;
    }
    
    return index;
}

- (void)startRolling
{
    if (_bannerItems.count <= 2) {
        return;
    }
    
    [self stopRolling];
    
    self.autoRolling = YES;
    [self performSelector:@selector(rollingScrollAction) withObject:nil afterDelay:self.autoRollingDelayTime];
}

- (void)stopRolling
{
    self.autoRolling = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(rollingScrollAction) object:nil];
}

- (void)rollingScrollAction
{
    [UIView animateWithDuration:0.25 animations:^{
        if(_direction == RBannerViewDefaultDirection || _direction == RBannerViewLandscapeDirection)
        {
            _scrollView.contentOffset = CGPointMake(1.99*_scrollView.frame.size.width, 0);
        }
        else if(_direction == RBannerViewPortaitDirection)
        {
            _scrollView.contentOffset = CGPointMake(0, 1.99*_scrollView.frame.size.height);
        }
    } completion:^(BOOL finished) {
        self.curPage = _curPage+1;
    }];
}

- (void)refreshScrollView
{
    NSArray *curDisplayItems = [self getDisplayItemsWithPageIndex:_curPage];
    
    for (NSInteger i = 0; i < 3; i++)
    {
        UIImageView *imageView = (UIImageView *)[_scrollView viewWithTag:i+1];
        FRBannerItem *bannerItem = [curDisplayItems objectAtIndex:i];
        if (bannerItem.imageName.length > 0) {
            [imageView setImage:[UIImage imageNamed:bannerItem.imageName]];
        } else if (bannerItem.imageURL.length > 0) {
            [imageView setImageWithURL:[NSURL URLWithString:bannerItem.imageURL] placeholderImage:[UIImage imageNamed:bannerItem.placeholderImageName]];
        }
    }
    
    if (_direction == RBannerViewDefaultDirection || _direction == RBannerViewLandscapeDirection)
    {
        _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width, 0);
    }
    else if (_direction == RBannerViewPortaitDirection)
    {
        _scrollView.contentOffset = CGPointMake(0, _scrollView.frame.size.height);
    }
    
    self.pageControl.currentPage = _curPage-1;
}

#pragma mark -
#pragma mark - Member Methods

- (void)reloadData
{
    [self stopRolling];
    _totalPage = _bannerItems.count;
    _totalCount = _totalPage;
    _curPage = 1;
    [self refreshScrollView];
    [self startRolling];
}

#pragma mark -
#pragma mark - UITapGestureRecognizer

- (void)bannerItemDidTaped:(UITapGestureRecognizer *)tap
{
    if ([_delegate respondsToSelector:@selector(bannerView:didSelectItemAtIndex:)])
    {
        [_delegate bannerView:self didSelectItemAtIndex:_curPage-1];
    }
}

#pragma mark -
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    NSInteger x = aScrollView.contentOffset.x;
    NSInteger y = aScrollView.contentOffset.y;

    if (self.autoRoolEnabled)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(rollingScrollAction) object:nil];
    }
    
    if(_direction == RBannerViewDefaultDirection || _direction == RBannerViewLandscapeDirection)
    {
        if (x >= 2 * _scrollView.frame.size.width)
        {
            _curPage = [self getPageIndex:_curPage+1];
            [self refreshScrollView];
            if (_delegate && [_delegate respondsToSelector:@selector(bannerView:didRollItemAtIndex:)]) {
                [_delegate bannerView:self didRollItemAtIndex:_curPage-1];
            }
        }
        
        if (x <= 0)
        {
            _curPage = [self getPageIndex:_curPage-1];
            [self refreshScrollView];
            if (_delegate && [_delegate respondsToSelector:@selector(bannerView:didRollItemAtIndex:)]) {
                [_delegate bannerView:self didRollItemAtIndex:_curPage-1];
            }
        }
    }
    else if(_direction == RBannerViewPortaitDirection)
    {
        if (y >= 2 * _scrollView.frame.size.height)
        {
            _curPage = [self getPageIndex:_curPage+1];
            [self refreshScrollView];
            if (_delegate && [_delegate respondsToSelector:@selector(bannerView:didRollItemAtIndex:)]) {
                [_delegate bannerView:self didRollItemAtIndex:_curPage-1];
            }
        }
        
        if (y <= 0)
        {
            _curPage = [self getPageIndex:_curPage-1];
            [self refreshScrollView];
            if (_delegate && [_delegate respondsToSelector:@selector(bannerView:didRollItemAtIndex:)]) {
                [_delegate bannerView:self didRollItemAtIndex:_curPage-1];
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView
{
    if (_direction == RBannerViewDefaultDirection || _direction == RBannerViewLandscapeDirection)
    {
        _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width, 0);
    }
    else if (_direction == RBannerViewPortaitDirection)
    {
        _scrollView.contentOffset = CGPointMake(0, _scrollView.frame.size.height);
    }
    
    if (self.autoRolling)
    {
        [self performSelector:@selector(rollingScrollAction) withObject:nil afterDelay:self.autoRollingDelayTime];
    }
}

@end
