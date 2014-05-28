//
//  FRLoadDataTableViewController.h
//  FRLoadDataTableViewController
//
//  Created by Aidian Tang on 9/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRPullDownRefreshView.h"
#import "FRPullUpLoadMoreView.h"

@class FRLoadDataViewController;

@protocol FRLoadDataTableViewControllerDelegate <NSObject>

@optional
- (void)loadDataTableViewControllerDidStartRefreshing:(FRLoadDataViewController *)loadDataTableViewController;
- (void)loadDataTableViewControllerDidStartLoadMore:(FRLoadDataViewController *)loadDataTableViewController;
- (void)loadDataTableViewControllerDidScroll:(FRLoadDataViewController *)loadDataTableViewController;

@end

@interface FRLoadDataViewController : UIViewController <FRPullDownRefreshViewDelegate, FRPullUpLoadMoreViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) id<FRLoadDataTableViewControllerDelegate> loadDataDelegate;
@property (nonatomic, assign) BOOL hasLoadMoreCompleted;
@property (nonatomic, assign) BOOL loadMoreAllowed;

- (void)startRefreshing;
- (void)startLoadMore;

- (void)stopRefreshing;
- (void)stopLoadMore;

@end
