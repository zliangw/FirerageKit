//
//  FRPullDownRefreshView.h
//  FRPullDownRefreshView
//
//  Created by Illidan on 12-1-10.
//  Copyright 2012年 Illidan. All rights reserved.
//

// Refresh view controller show label 
#define REFRESH_LOADING_STATUS      @"Refreshing..."
#define REFRESH_PULL_DOWN_STATUS    @"Pull to refresh"
#define REFRESH_RELEASED_STATUS     @"Release to refresh"
#define REFRESH_UPDATE_TIME_PREFIX  @"最后更新: "
//#define REFRESH_HEADER_HEIGHT 60
#define REFRESH_TRIGGER_HEIGHT 45

#import <UIKit/UIKit.h>

@protocol FRPullDownRefreshViewDelegate;

@interface FRPullDownRefreshView : UIView {
    // UI
    UIImageView *_refreshArrowImageView;
    UIActivityIndicatorView *_refreshIndicator;
    UILabel *_refreshStatusLabel;
    UILabel *_refreshLastUpdatedTimeLabel;
    
    // 安装到哪个UIScrollView中
    UIScrollView *_owner;

    // control
    BOOL _isRefreshing;
    BOOL _isDragging;
    
    // 触发有效事件后的_delegate
    __unsafe_unretained id<FRPullDownRefreshViewDelegate>  _delegate;
}

@property (nonatomic,assign) BOOL enabled;
@property (nonatomic,assign,readonly) BOOL isRefreshing;
@property (nonatomic,strong,readonly) UIScrollView *owner;
@property (nonatomic,assign,readwrite)  id<FRPullDownRefreshViewDelegate> delegate;

// 初始化并安装refreshView
- (id)initWithOwner:(UIScrollView *)owner delegate:(id<FRPullDownRefreshViewDelegate>)delegate;

// 开始加载和结束加载动画
- (void)startRefreshing;
- (void)stopRefreshing;

// 拖动过程中，如果ownerDelegate为自身，以下三个方法自动调用
- (void)ownerWillBeginDragging;
- (void)ownerDidScroll;
- (void)ownerDidEndDragging;

@end

@protocol FRPullDownRefreshViewDelegate <NSObject>
// 只有向下拉时，有效的触发事件对外才是真正有用的
- (void)pullDownRefreshViewRefreshStarted:(FRPullDownRefreshView *)pullDownRefreshView;
@end
