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

@class FRLoadDataTableViewController;

@protocol FRLoadDataTableViewControllerDelegate <NSObject>

@optional
- (void)loadDataTableViewControllerDidStartRefreshing:(FRLoadDataTableViewController *)loadDataTableViewController;
- (void)loadDataTableViewControllerDidStartLoadMore:(FRLoadDataTableViewController *)loadDataTableViewController;

@end

@interface FRLoadDataTableViewController : UIViewController <FRPullDownRefreshViewDelegate, FRPullUpLoadMoreViewDelegate>

@property (nonatomic, retain, readonly) UITableView *tableView;
@property (nonatomic, assign) id<FRLoadDataTableViewControllerDelegate> loadDataDelegate;
@property (nonatomic, assign) BOOL hasLoadMoreCompleted;
@property (nonatomic, assign) BOOL loadMoreAllowed;

- (void)startRefreshing;
- (void)startLoadMore;

- (void)stopRefreshing;
- (void)stopLoadMore;

@end
