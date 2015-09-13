//
//  FRChatViewController.m
//  FirerageKit
//
//  Created by Aidian.Tang on 14-5-21.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "FRChatViewController.h"
#import "UIBubbleTableViewDataSource.h"
#import "UIBubbleTableViewDelegate.h"
#import "UIView+FRLayout.h"

@interface FRChatViewController () <UIBubbleTableViewDataSource, UIBubbleTableViewDelegate, FRMessengerViewControllerDelegate>

@property (strong, nonatomic, readwrite) UIBubbleTableView *bubbleTable;

@end

@implementation FRChatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{

}

- (void)loadView
{
    [super loadView];
    
    if (!self.bubbleTable) {
        self.bubbleTable = [[UIBubbleTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        if (self.edgesForExtendedLayout & UIRectEdgeTop) {
            self.bubbleTable.contentInset = UIEdgeInsetsMake(self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height, 0.0f, [UIApplication sharedApplication].statusBarFrame.size.height, 0.0f);
        } else {
            self.bubbleTable.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, [UIApplication sharedApplication].statusBarFrame.size.height, 0.0f);
        }
        self.messageContentView = _bubbleTable;
        super.delegate = self;
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

- (void)setBubbleDatas:(NSArray *)bubbleDatas
{
    _bubbleDatas = bubbleDatas;
    [_bubbleTable reloadData];
}

#pragma mark -
#pragma mark - Private Methods


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
#pragma mark - FRMessengerViewControllerDelegate

- (void)messengerViewController:(FRMessengerViewController *)messengerViewController didSentMessage:(NSString *)message
{
    
}

- (void)messengerViewControllerDidBeginInputting:(FRMessengerViewController *)messengerViewController
{
    [_bubbleTable scrollsToBottomAnimated:NO];
}

- (void)messengerViewControllerDidEndInputting:(FRMessengerViewController *)messengerViewController withMessage:(NSString *)message
{
    
}

- (void)messengerViewControllerWillChangeInputViewHeight:(FRMessengerViewController *)messengerViewController
{
    [_bubbleTable scrollsToBottomAnimated:NO];
}

@end
