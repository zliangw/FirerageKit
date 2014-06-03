//
//  FRRefreshAndLoadMoreView.h
//  FirerageKit
//
//  Created by Aidian.Tang on 14-6-3.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FRRefreshAndLoadMoreViewDelegate;

@interface FRRefreshAndLoadMoreView : UIView

@property (nonatomic, assign) id<FRRefreshAndLoadMoreViewDelegate> loadDataDelegate;
@property (nonatomic, assign) BOOL hasLoadMoreCompleted;
@property (nonatomic, assign) BOOL loadMoreAllowed;
@property (nonatomic, strong) UIScrollView *scrollView;

- (instancetype)initWithScrollView:(UIScrollView *)scrollView;

- (void)startRefreshing;
- (void)startLoadMore;

- (void)stopRefreshing;
- (void)stopLoadMore;

@end

@protocol FRRefreshAndLoadMoreViewDelegate <NSObject>

@optional
- (void)refreshAndLoadMoreViewDidStartRefreshing:(FRRefreshAndLoadMoreView *)refreshAndLoadMoreView;
- (void)refreshAndLoadMoreViewDidStartLoadMore:(FRRefreshAndLoadMoreView *)refreshAndLoadMoreView;

// Override UIScrollViewDelegate
- (void)refreshAndLoadMoreViewDidScroll:(FRRefreshAndLoadMoreView *)refreshAndLoadMoreView;

// Override UITableViewDelegate
- (CGFloat)refreshAndLoadMoreView:(FRRefreshAndLoadMoreView *)refreshAndLoadMoreView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)refreshAndLoadMoreView:(FRRefreshAndLoadMoreView *)refreshAndLoadMoreView heightForHeaderInSection:(NSInteger)section;
- (CGFloat)refreshAndLoadMoreView:(FRRefreshAndLoadMoreView *)refreshAndLoadMoreView heightForFooterInSection:(NSInteger)section;

- (UIView *)refreshAndLoadMoreView:(FRRefreshAndLoadMoreView *)refreshAndLoadMoreView viewForHeaderInSection:(NSInteger)section;
- (UIView *)refreshAndLoadMoreView:(FRRefreshAndLoadMoreView *)refreshAndLoadMoreView viewForFooterInSection:(NSInteger)section;

- (void)refreshAndLoadMoreView:(FRRefreshAndLoadMoreView *)refreshAndLoadMoreView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)refreshAndLoadMoreView:(FRRefreshAndLoadMoreView *)refreshAndLoadMoreView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
