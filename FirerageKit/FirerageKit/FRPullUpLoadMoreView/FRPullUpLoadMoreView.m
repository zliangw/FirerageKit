//
//  PEPullRefreshTableBottomView.m
//  PAECSS_iPhone
//
//  Created by Aidian on 12-3-9.
//  Copyright (c) 2012年 . All rights reserved.
//

#import "FRPullUpLoadMoreView.h"
#define  RefreshViewHight 55.0f

#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f


@interface FRPullUpLoadMoreView (Private)

- (void)setState:(SWPullRefreshState)aState;

@end

@implementation FRPullUpLoadMoreView

#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	[_owner removeObserver:self forKeyPath:@"contentSize"];
    
	_delegate=nil;
    _statusLabel = nil;
}

- (id)initWithOwner:(UIScrollView *)owner delegate:(id<FRPullUpLoadMoreViewDelegate>)delegate
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.owner = owner;
        [_owner addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew |NSKeyValueObservingOptionOld | NSKeyValueObservingOptionInitial context:(__bridge void *)(self->_owner)];
        
        CGRect frame = self.frame;
        frame.size.width = _owner.bounds.size.width;
        if (_owner.contentSize.height > _owner.bounds.size.height) {
            frame.origin.y = _owner.contentSize.height;
        } else {
            frame.origin.y = _owner.bounds.size.height;
        }
        self.frame = frame;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        self.delegate =delegate;
		
		_statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, RefreshViewHight - 38.0f, self.frame.size.width, 20.0f)];
		_statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		_statusLabel.font = [UIFont boldSystemFontOfSize:13.0f];
		_statusLabel.textColor = TEXT_COLOR;
		_statusLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		_statusLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		_statusLabel.backgroundColor = [UIColor clearColor];
		_statusLabel.textAlignment = UITextAlignmentCenter;
		[self addSubview:_statusLabel];

		[self setState:SWPullRefreshNormal];
		
        [owner insertSubview:self atIndex:0];
    }
	
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == (__bridge void *)(self->_owner)) {
        if ([keyPath isEqualToString:@"contentSize"]) {
            CGRect frame = self.frame;
            if (_owner.contentSize.height > _owner.bounds.size.height) {
                frame.origin.y = _owner.contentSize.height;
            } else {
                frame.origin.y = _owner.bounds.size.height;
            }
            self.frame = frame;
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark -
#pragma mark Setters

- (void)setState:(SWPullRefreshState)aState{
	
	switch (aState) {
		case SWPullRefreshPulling:
			_statusLabel.text = NSLocalizedString(@"松开即可加载...", @"松开即可加载...");
			break;
		case SWPullRefreshNormal:
			_statusLabel.text = NSLocalizedString(@"上拉即可加载...", @"上拉即可加载...");
			break;
		case SWPullRefreshLoading:
			_statusLabel.text = NSLocalizedString(@"加载中...", @"加载中...");
			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

//手指屏幕上不断拖动调用此方法
- (void)ownerDidScroll {	
	if (_state == SWPullRefreshLoading) {
		_owner.contentInset = UIEdgeInsetsMake(0.0, 0.0f, RefreshViewHight, 0.0f);
	} else if (_owner.isDragging) {
		BOOL shouldLoading = YES;
		if (_delegate && [_delegate respondsToSelector:@selector(pullUpLoadMoreViewShouldLoading:)]) {
			shouldLoading = [_delegate pullUpLoadMoreViewShouldLoading:self];
		}
		
		if (_state == SWPullRefreshPulling && _owner.contentOffset.y + (_owner.frame.size.height) < _owner.contentSize.height + RefreshViewHight && _owner.contentOffset.y > 0.0f && shouldLoading) {
			[self setState:SWPullRefreshNormal];
		} else if (_state == SWPullRefreshNormal && _owner.contentOffset.y + (_owner.frame.size.height) > _owner.contentSize.height + RefreshViewHight && shouldLoading) {
			[self setState:SWPullRefreshPulling];
		}
		
		if (_owner.contentInset.bottom != 0) {
			_owner.contentInset = UIEdgeInsetsZero;
		}
	}
}

//当用户停止拖动，并且手指从屏幕中拿开的的时候调用此方法
- (void)ownerDidEndDragging {
	BOOL shouldLoading = YES;
	if (_delegate && [_delegate respondsToSelector:@selector(pullUpLoadMoreViewShouldLoading:)]) {
		shouldLoading = [_delegate pullUpLoadMoreViewShouldLoading:self];
	}
	
	if (_state != SWPullRefreshLoading && _owner.contentOffset.y + (_owner.frame.size.height) > _owner.contentSize.height + RefreshViewHight && shouldLoading) {
		
        [self setState:SWPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		_owner.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, RefreshViewHight, 0.0f);
		[UIView commitAnimations];
        
        if (_delegate && [_delegate respondsToSelector:@selector(pullUpLoadMoreViewLoadingStarted:)]) {
			[_delegate pullUpLoadMoreViewLoadingStarted:self];
		}
	}
}

//结束加载状态;
- (void)stopLoading {
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[_owner setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[self setState:SWPullRefreshNormal];
}

#pragma mark - scrollVieDelegte methods

// 拖动过程中
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y  > 0) {
        [self ownerDidScroll];
    }
}

// 拖动结束后
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y  > 0) {
        [self ownerDidEndDragging];
    }
}

@end