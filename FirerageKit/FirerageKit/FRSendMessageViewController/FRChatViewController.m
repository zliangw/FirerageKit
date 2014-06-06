//
//  FRSendMessageTableViewController.m
//  FirerageKit
//
//  Created by Aidian.Tang on 14-5-21.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "FRChatViewController.h"
#import "UIBubbleTableView.h"
#import "UIBubbleTableViewDataSource.h"
#import "UIBubbleTableViewDelegate.h"
#import "UIView+FRLayout.h"

@interface FRChatViewController () <UIBubbleTableViewDataSource, UIBubbleTableViewDelegate, FRSendMessageViewControllerDelegate>

@property (strong, nonatomic) UIBubbleTableView *bubbleTable;

@end

@implementation FRChatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)dealloc
{

}

- (void)loadView
{
    [super loadView];
    
    CGFloat inputHeight = 44;
    if (!self.bubbleTable) {
        self.bubbleTable = [[UIBubbleTableView alloc] initWithFrame:[self mainBoundsMinusHeight:inputHeight] style:UITableViewStylePlain];
        [self.view addSubview:_bubbleTable];
        self.messageContentView = _bubbleTable;
        self.sendMessageDelegate = self;
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_bubbleTable reloadData];
    [_bubbleTable scrollsToBottomAnimated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _bubbleTable.bubbleDataSource = self;
    _bubbleTable.bubbleDelegate = self;
    _bubbleTable.snapInterval = 120;
    _bubbleTable.showAvatar = YES;
    _bubbleTable.typingBubble = NSBubbleTypingTypeNobody;
    _bubbleTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Setters

- (void)setBubbleData:(NSMutableArray *)bubbleData
{
    _bubbleDatas = bubbleData;
    [_bubbleTable reloadData];
}

#pragma mark -
#pragma mark - Private Methods

- (CGRect)mainBoundsMinusHeight:(CGFloat)minus
{
    CGFloat navigationBarHeight = self.navigationController.navigationBarHidden ? 0 : self.navigationController.navigationBar.bounds.size.height;
    CGFloat tabBarHeight = self.hidesBottomBarWhenPushed ? 0 : self.tabBarController.tabBar.bounds.size.height;
    CGFloat bottomToolbarHeight = self.navigationController.toolbarHidden ? 0 : self.navigationController.toolbar.bounds.size.height;
    return CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - [[UIApplication sharedApplication] statusBarFrame].size.height - navigationBarHeight - tabBarHeight - bottomToolbarHeight - minus);
}

#pragma mark - UIBubbleTableViewDataSource implementation

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    return [_bubbleDatas count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    return [_bubbleDatas objectAtIndex:row];
}

#pragma mark -
#pragma mark - UIBubbleTableViewDelegate

- (void)bubbleTableViewWillBeginDragging:(UIBubbleTableView *)bubbleTableView
{
    if (self.inputting) {
        [self resignInputViewFirstResponder];
    }
}

#pragma mark -
#pragma mark - FRSendMessageViewControllerDelegate

- (void)sendMessageViewController:(FRSendMessageViewController *)sendMessageViewController didSentMessage:(NSString *)message
{
    
}

- (void)sendMessageViewControllerDidBeginInputting:(FRSendMessageViewController *)sendMessageViewController
{
    [_bubbleTable scrollsToBottomAnimated:NO];
}

- (void)sendMessageViewControllerDidEndInputting:(FRSendMessageViewController *)sendMessageViewController withMessage:(NSString *)message
{
    
}

@end
