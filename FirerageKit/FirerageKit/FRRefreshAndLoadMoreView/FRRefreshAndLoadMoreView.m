//
//  FRRefreshAndLoadMoreView.m
//  FirerageKit
//
//  Created by Aidian.Tang on 14-6-3.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "FRRefreshAndLoadMoreView.h"
#import "FRPullDownRefreshView.h"
#import "FRPullUpLoadMoreView.h"

@interface FRRefreshAndLoadMoreView () <UIScrollViewDelegate, UITableViewDelegate, FRPullDownRefreshViewDelegate, FRPullUpLoadMoreViewDelegate>

@property (nonatomic, assign) BOOL isLoadMore;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, strong) FRPullDownRefreshView *refreshView;
@property (nonatomic, strong) FRPullUpLoadMoreView *loadMoreView;

@end

@implementation FRRefreshAndLoadMoreView

- (instancetype)initWithScrollView:(UIScrollView *)scrollView
{
    self = [super initWithFrame:scrollView.frame];
    if (self) {
        // Initialization code
        self.scrollView = scrollView;
    }
    return self;
}

#pragma mark -
#pragma mark - Priavte Methods

- (void)removeRefreshView
{
    if (_refreshView) {
        [_refreshView stopRefreshing];
        _refreshView.delegate = nil;
        [_refreshView removeFromSuperview];
        _refreshView = nil;
    }
}

- (void)removeLoadMoreView
{
    if (_loadMoreView) {
        [_loadMoreView stopLoading];
        _loadMoreView.delegate = nil;
        [_loadMoreView removeFromSuperview];
        _loadMoreView = nil;
    }
}

- (void)addLoadMoreView
{
    if (_loadMoreAllowed && !_loadMoreView) {
        _loadMoreView = [[FRPullUpLoadMoreView alloc] initWithOwner:self.scrollView delegate:self];
        _loadMoreView.backgroundColor = [UIColor clearColor];
    }
}

- (void)lockRefresh:(BOOL)isLock
{
    _refreshView.enabled = !isLock;
}

- (void)lockLoadMore:(BOOL)isLock
{
    if (isLock) {
        [self removeLoadMoreView];
    } else {
        [self addLoadMoreView];
    }
}

#pragma mark -
#pragma mark - Setter

- (void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    _scrollView.delegate = self;
    [self removeRefreshView];
    self.refreshView = [[FRPullDownRefreshView alloc] initWithOwner:self.scrollView delegate:self];
}

- (void)setHasLoadMoreCompleted:(BOOL)hasLoadMoreCompleted
{
    if (!_loadMoreAllowed) {
        return;
    }
    
    UITableView *tableView = nil;
    if ([_scrollView isKindOfClass:[UITableView class]]) {
        tableView = (UITableView *)_scrollView;
    } else {
        return;
    }
    
    
    _hasLoadMoreCompleted = hasLoadMoreCompleted;
    if (!_hasLoadMoreCompleted) {
        [self addLoadMoreView];
        tableView.tableFooterView = nil;
    } else {
        if (_loadMoreView) {
            [self removeLoadMoreView];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), tableView.rowHeight)];
            label.textAlignment = UITextAlignmentCenter;
            label.text = NSLocalizedString(@"加载完成", nil);
            label.font = [UIFont systemFontOfSize:12.];
            label.textColor = [UIColor lightGrayColor];
            label.backgroundColor = [UIColor clearColor];
            tableView.tableFooterView = label;
        }
    }
}

- (void)setLoadMoreAllowed:(BOOL)loadMoreAllowed
{
    _loadMoreAllowed = loadMoreAllowed;
    if (!_loadMoreAllowed) {
        [self removeLoadMoreView];
    }
}

#pragma mark -
#pragma mark - UIScrollViewDelegate

// 刚拖动的时候
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y <= 0) {
        [_refreshView ownerWillBeginDragging];
    }
}

// 拖动过程中
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y  > 0 && _loadMoreView) {
        [_loadMoreView ownerDidScroll];
    }else if (scrollView.contentOffset.y  < 0){
        [_refreshView ownerDidScroll];
    }
    if (_loadDataDelegate && [_loadDataDelegate respondsToSelector:@selector(refreshAndLoadMoreViewDidScroll:)]) {
        [_loadDataDelegate refreshAndLoadMoreViewDidScroll:self];
    }
}

// 拖动结束后
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y  > 0 && _loadMoreView) {
        [_loadMoreView ownerDidEndDragging];
    }else if (scrollView.contentOffset.y  < 0){
        [_refreshView ownerDidEndDragging];
    }
}

#pragma mark -
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static CGFloat defaulthHeightForRowAtIndexPath = 44.;
    CGFloat heightForRowAtIndexPath = defaulthHeightForRowAtIndexPath;
    if (_loadDataDelegate && [_loadDataDelegate respondsToSelector:@selector(refreshAndLoadMoreView:heightForRowAtIndexPath:)]) {
        heightForRowAtIndexPath = [_loadDataDelegate refreshAndLoadMoreView:self heightForRowAtIndexPath:indexPath];
    }
    return heightForRowAtIndexPath;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat heightForHeaderInSection = 0;
    if (_loadDataDelegate && [_loadDataDelegate respondsToSelector:@selector(refreshAndLoadMoreView:heightForHeaderInSection:)]) {
        heightForHeaderInSection = [_loadDataDelegate refreshAndLoadMoreView:self heightForHeaderInSection:section];
    }
    return heightForHeaderInSection;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat heightForFooterInSection = 0;
    if (_loadDataDelegate && [_loadDataDelegate respondsToSelector:@selector(refreshAndLoadMoreView:heightForFooterInSection:)]) {
        heightForFooterInSection = [_loadDataDelegate refreshAndLoadMoreView:self heightForFooterInSection:section];
    }
    return heightForFooterInSection;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *viewForHeaderInSection = nil;
    if (_loadDataDelegate && [_loadDataDelegate respondsToSelector:@selector(refreshAndLoadMoreView:viewForHeaderInSection:)]) {
        viewForHeaderInSection = [_loadDataDelegate refreshAndLoadMoreView:self viewForHeaderInSection:section];
    }
    return viewForHeaderInSection;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *viewForFooterInSection = nil;
    if (_loadDataDelegate && [_loadDataDelegate respondsToSelector:@selector(refreshAndLoadMoreView:viewForFooterInSection:)]) {
        viewForFooterInSection = [_loadDataDelegate refreshAndLoadMoreView:self viewForFooterInSection:section];
    }
    return viewForFooterInSection;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_loadDataDelegate && [_loadDataDelegate respondsToSelector:@selector(refreshAndLoadMoreView:didSelectRowAtIndexPath:)]) {
        [_loadDataDelegate refreshAndLoadMoreView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_loadDataDelegate && [_loadDataDelegate respondsToSelector:@selector(refreshAndLoadMoreView:didDeselectRowAtIndexPath:)]) {
        [_loadDataDelegate refreshAndLoadMoreView:self didDeselectRowAtIndexPath:indexPath];
    }
}

#pragma mark -
#pragma mark - Member Methods

- (void)startLoadMore
{
    if (!_isLoadMore) {
        [self lockRefresh:YES];
        _isLoadMore = YES;
        if (_loadDataDelegate && [_loadDataDelegate respondsToSelector:@selector(refreshAndLoadMoreViewDidStartLoadMore:)]) {
            [_loadDataDelegate refreshAndLoadMoreViewDidStartLoadMore:self];
        }
    }
}

- (void)stopLoadMore
{
    if (_isLoadMore) {
        _isLoadMore = NO;
        if (_loadMoreView) {
            [_loadMoreView stopLoading];
        }
        [self lockRefresh:NO];
    }
}

- (void)startRefreshing
{
    if (!_isRefresh) {
        [self lockLoadMore:YES];
        _isRefresh = YES;
        [_refreshView startRefreshing];
        if (_loadDataDelegate && [_loadDataDelegate respondsToSelector:@selector(refreshAndLoadMoreViewDidStartRefreshing:)]) {
            [_loadDataDelegate refreshAndLoadMoreViewDidStartRefreshing:self];
        }
    }
}

- (void)stopRefreshing
{
    if (_isRefresh) {
        _isRefresh = NO;
        [_refreshView stopRefreshing];
        [self lockLoadMore:NO];
    }
}

#pragma mark -
#pragma mark - FRPullDownRefreshViewDelegate

- (void)pullDownRefreshViewRefreshStarted:(FRPullDownRefreshView *)pullDownRefreshView
{
    [self startRefreshing];
}

#pragma mark -
#pragma mark - FRPullUpLoadMoreViewDelegate

- (BOOL)pullUpLoadMoreViewShouldLoading:(FRPullUpLoadMoreView*)pullUpLoadMoreView
{
    return YES;
}

- (void)pullUpLoadMoreViewLoadingStarted:(FRPullUpLoadMoreView*)pullUpLoadMoreView
{
    [self startLoadMore];
}

@end
