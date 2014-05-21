//
//  PEPullRefreshTableBottomView.h
//  PAECSS_iPhone
//
//  Created by Aidian on 12-3-9.
//  Copyright (c) 2012年 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{
	SWPullRefreshPulling = 0,
	SWPullRefreshNormal,
	SWPullRefreshLoading,	
} SWPullRefreshState;

@protocol FRPullUpLoadMoreViewDelegate;

@interface FRPullUpLoadMoreView : UIView {
	SWPullRefreshState _state;
    
	UILabel *_statusLabel;
	CALayer *_arrowImage;
}

@property (nonatomic,weak) id<FRPullUpLoadMoreViewDelegate> delegate;
@property (nonatomic,assign) SWPullRefreshState state;
@property (nonatomic,strong) UIScrollView *owner;

- (id)initWithOwner:(UIScrollView *)owner delegate:(id<FRPullUpLoadMoreViewDelegate>)delegate;

- (void)stopLoading;

// 拖动过程中，如果ownerDelegate为自身，以下2个方法自动调用
- (void)ownerDidScroll;
- (void)ownerDidEndDragging;

@end

@protocol FRPullUpLoadMoreViewDelegate <NSObject>

@optional
- (BOOL)pullUpLoadMoreViewShouldLoading:(FRPullUpLoadMoreView*)pullUpLoadMoreView;
- (void)pullUpLoadMoreViewLoadingStarted:(FRPullUpLoadMoreView*)pullUpLoadMoreView;

@end

