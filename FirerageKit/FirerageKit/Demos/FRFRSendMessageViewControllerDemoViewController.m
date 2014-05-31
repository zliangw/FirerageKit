//
//  FRFRSendMessageViewControllerDemoViewController.m
//  FirerageKit
//
//  Created by Aidian on 14-5-24.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "FRFRSendMessageViewControllerDemoViewController.h"
#import "FRSendMessageViewController.h"

@interface FRFRSendMessageViewControllerDemoViewController () <UITableViewDataSource, UITableViewDelegate, FRSendMessageViewControllerDelegate, FRLoadDataViewControllerDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end

@implementation FRFRSendMessageViewControllerDemoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.backgroundColor = [UIColor redColor];
    self.inputContainerColor = [UIColor purpleColor];
    self.sendMessageDelegate = self;
    self.loadDataDelegate = self;
    self.scrollView = self.tableView;
    self.loadMoreAllowed = YES;
    self.hasLoadMoreCompleted = NO;
    self.placeholder = @"inputting...";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark -
#pragma mark - Override SendMessage

- (void)sendMessage:(NSString *)message
{
    [super sendMessage:message];
}

#pragma mark -
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *dequeueReusableCellWithIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dequeueReusableCellWithIdentifier];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
    
    return cell;
}

#pragma mark -
#pragma mark - FRSendMessageViewControllerDelegate

- (void)sendMessageViewController:(FRSendMessageViewController *)sendMessageViewController didSentMessage:(NSString *)message
{
    
}

- (void)sendMessageViewControllerDidBeginInputting:(FRSendMessageViewController *)sendMessageViewController
{
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:39 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)sendMessageViewControllerDidEndInputting:(FRSendMessageViewController *)sendMessageViewController withMessage:(NSString *)message
{
    
}

#pragma mark -
#pragma mark - FRLoadDataViewControllerDelegate

- (void)loadDataTableViewControllerDidStartRefreshing:(FRLoadDataViewController *)loadDataTableViewController
{
    
}

- (void)loadDataTableViewControllerDidStartLoadMore:(FRLoadDataViewController *)loadDataTableViewController
{
    
}

- (void)loadDataTableViewControllerDidScroll:(FRLoadDataViewController *)loadDataTableViewController
{
    //[self resignInputViewFirstResponder];
}

@end
