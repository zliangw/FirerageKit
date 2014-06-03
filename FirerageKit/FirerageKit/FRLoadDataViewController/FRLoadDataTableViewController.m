//
//  FRLoadDataTableViewController.m
//  FirerageKit
//
//  Created by Aidian.Tang on 14-6-3.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "FRLoadDataTableViewController.h"

@interface FRLoadDataTableViewController () <FRRefreshAndLoadMoreViewDelegate>

@property (nonatomic, strong, readwrite) FRRefreshAndLoadMoreView *refreshAndLoadMoreView;

@end

@implementation FRLoadDataTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.refreshAndLoadMoreView = [[FRRefreshAndLoadMoreView alloc] initWithScrollView:self.tableView];
    self.refreshAndLoadMoreView.loadDataDelegate = self;
    self.refreshAndLoadMoreView.loadMoreAllowed = YES;
    self.loadMoreShowed = _loadMoreShowed;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Setter

- (void)setLoadMoreShowed:(BOOL)loadMoreShowed
{
    _loadMoreShowed = loadMoreShowed;
    if (_loadMoreShowed) {
        self.refreshAndLoadMoreView.hasLoadMoreCompleted = NO;
    } else {
        self.refreshAndLoadMoreView.hasLoadMoreCompleted = YES;
    }
}

#pragma mark -
#pragma mark - FRRefreshAndLoadMoreViewDelegate

- (void)refreshAndLoadMoreViewDidStartRefreshing:(FRRefreshAndLoadMoreView *)refreshAndLoadMoreView
{
    
}

- (void)refreshAndLoadMoreViewDidStartLoadMore:(FRRefreshAndLoadMoreView *)refreshAndLoadMoreView
{
    
}

- (void)refreshAndLoadMoreViewDidScroll:(FRRefreshAndLoadMoreView *)refreshAndLoadMoreView
{
    
}

@end
