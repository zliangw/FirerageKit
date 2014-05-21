//
//  FRLoadDataTableViewController.m
//  FRLoadDataTableViewController
//
//  Created by Aidian Tang on 9/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FRLoadDataTableViewController.h"

@interface FRLoadDataTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, assign) BOOL isLoadMore;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, retain) FRPullDownRefreshView *refreshView;
@property (nonatomic, retain) FRPullUpLoadMoreView *loadMoreView;

@end

@implementation FRLoadDataTableViewController

@synthesize isLoadMore = _isLoadMore;
@synthesize isRefresh = _isRefresh;
@synthesize refreshView = _refreshView;
@synthesize loadMoreView = _loadMoreView;

@synthesize loadDataDelegate = _loadDataDelegate;
@synthesize hasLoadMoreCompleted = _hasLoadMoreCompleted;

- (void)dealloc
{

}

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        _loadMoreAllowed = YES;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.refreshView = [[FRPullDownRefreshView alloc] initWithOwner:self.tableView delegate:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
        _loadMoreView = [[FRPullUpLoadMoreView alloc] initWithOwner:self.tableView delegate:self];
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

- (void)startLoadMore
{
    if (!_isLoadMore) {
        [self lockRefresh:YES];
        _isLoadMore = YES;
        if (_loadDataDelegate && [_loadDataDelegate respondsToSelector:@selector(loadDataTableViewControllerDidStartLoadMore:)]) {
            [_loadDataDelegate loadDataTableViewControllerDidStartLoadMore:self];
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
        if (_loadDataDelegate && [_loadDataDelegate respondsToSelector:@selector(loadDataTableViewControllerDidStartRefreshing:)]) {
            [_loadDataDelegate loadDataTableViewControllerDidStartRefreshing:self];
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

- (void)setHasLoadMoreCompleted:(BOOL)hasLoadMoreCompleted
{
    if (!_loadMoreAllowed) {
        return;
    }
    
    _hasLoadMoreCompleted = hasLoadMoreCompleted;
    if (!_hasLoadMoreCompleted) {
        [self addLoadMoreView];
        self.tableView.tableFooterView = nil;
    } else {
        if (_loadMoreView) {
            [self removeLoadMoreView];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), self.tableView.rowHeight)];
            label.textAlignment = UITextAlignmentCenter;
            label.text = NSLocalizedString(@"加载完成", nil);
            label.font = [UIFont systemFontOfSize:12.];
            label.textColor = [UIColor lightGrayColor];
            label.backgroundColor = [UIColor clearColor];
            self.tableView.tableFooterView = label;
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

#pragma mark - scrollVieDelegte methods

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
    
}

// 拖动结束后
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y  > 0 && _loadMoreView) {
        [_loadMoreView ownerDidEndDragging];
    }else if (scrollView.contentOffset.y  < 0){
        [_refreshView ownerDidEndDragging];
    }
}

#pragma mark - SWPullDownRefreshViewDelegate

- (void)pullDownRefreshViewRefreshStarted:(FRPullDownRefreshView *)pullDownRefreshView
{
    [self startRefreshing];
}

#pragma mark - SWPullUpLoadMoreViewDelegate Methods

- (BOOL)pullUpLoadMoreViewShouldLoading:(FRPullUpLoadMoreView*)pullUpLoadMoreView
{
    return YES;
}

- (void)pullUpLoadMoreViewLoadingStarted:(FRPullUpLoadMoreView*)pullUpLoadMoreView
{
    [self startLoadMore];
}

#pragma mark -
#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    return cell;
}

@end
