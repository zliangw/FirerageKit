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
#import "NSBubbleData.h"
#import "HPGrowingTextView.h"
#import "DAKeyboardControl.h"

@interface FRChatViewController () <UIBubbleTableViewDataSource, HPGrowingTextViewDelegate>

@property (strong, nonatomic) UIBubbleTableView *bubbleTable;
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) HPGrowingTextView *textView;
@property (strong, nonatomic) NSMutableArray *bubbleData;

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
    [self.view removeKeyboardControl];
}

- (void)loadView
{
    [super loadView];
    
    CGFloat inputHeight = 44;
    
    self.bubbleTable = [[UIBubbleTableView alloc] initWithFrame:[self mainBoundsMinusHeight:inputHeight] style:UITableViewStylePlain];
    [self.view addSubview:_bubbleTable];
    self.scrollView = _bubbleTable;
    
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_bubbleTable.frame), CGRectGetWidth(self.view.bounds), inputHeight)];
    _containerView.backgroundColor = [UIColor purpleColor];
	_textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(6, 3, 240, _containerView.bounds.size.height)];
    _textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
	_textView.minNumberOfLines = 1;
	_textView.maxNumberOfLines = 6;
	_textView.returnKeyType = UIReturnKeyGo; //just as an example
	_textView.font = [UIFont systemFontOfSize:15.0f];
	_textView.delegate = self;
    _textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    _textView.backgroundColor = [UIColor whiteColor];
    
    // textView.text = @"test\n\ntest";
	// textView.animateHeightChange = NO; //turns off animation
    [self.view addSubview:_containerView];
	
    UIImage *rawEntryBackground = [UIImage imageNamed:@"MessageEntryInputField.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
    entryImageView.frame = CGRectMake(5, 0, 248, 40);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UIImage *rawBackground = [UIImage imageNamed:@"MessageEntryBackground.png"];
    UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
    imageView.frame = CGRectMake(0, 0, _containerView.frame.size.width, _containerView.frame.size.height);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    // view hierachy
    [_containerView addSubview:imageView];
    [_containerView addSubview:_textView];
    [_containerView addSubview:entryImageView];
    
    UIImage *sendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    UIImage *selectedSendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    
	UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	doneBtn.frame = CGRectMake(_containerView.frame.size.width - 69, 8, 63, 27);
    doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
	[doneBtn setTitle:@"Done" forState:UIControlStateNormal];
    
    [doneBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
    doneBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
    doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[doneBtn addTarget:self action:@selector(resignTextView) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setBackgroundImage:sendBtnBackground forState:UIControlStateNormal];
    [doneBtn setBackgroundImage:selectedSendBtnBackground forState:UIControlStateSelected];
	[_containerView addSubview:doneBtn];
    
    _containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    NSBubbleData *heyBubble = [NSBubbleData dataWithText:@"Hey, halloween is soon" date:[NSDate dateWithTimeIntervalSinceNow:-300] type:BubbleTypeSomeoneElse];
    NSBubbleData *photoBubble = [NSBubbleData dataWithImage:[UIImage imageNamed:@"halloween.png"] date:[NSDate dateWithTimeIntervalSinceNow:-290] type:BubbleTypeSomeoneElse];
    
    NSBubbleData *replyBubble = [NSBubbleData dataWithText:@"Wow.. Really cool picture out there. iPhone 5 has really nice camera, yeah?" date:[NSDate dateWithTimeIntervalSinceNow:-5] type:BubbleTypeMine];
    
    NSBubbleData *replyBubble2 = [NSBubbleData dataWithText:@"Wow.. Really cool picture out there. iPhone 5 has really nice camera, yeah?" date:[NSDate dateWithTimeIntervalSinceNow:-500] type:BubbleTypeMine];
    
    self.bubbleData = [[NSMutableArray alloc] initWithObjects:heyBubble, photoBubble, replyBubble, replyBubble2, nil];
    
    _bubbleTable.bubbleDataSource = self;
    _bubbleTable.snapInterval = 120;
    _bubbleTable.typingBubble = NSBubbleTypingTypeNobody;
    _bubbleTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.view.keyboardTriggerOffset = _containerView.bounds.size.height;
    __weak FRChatViewController *target = self;
    [self.view addKeyboardPanningWithActionHandler:^(CGRect keyboardFrameInView, BOOL opening, BOOL closing) {
        CGRect toolBarFrame = target.containerView.frame;
        toolBarFrame.origin.y = keyboardFrameInView.origin.y - toolBarFrame.size.height;
        target.containerView.frame = toolBarFrame;
        
        CGRect tableViewFrame = target.bubbleTable.frame;
        tableViewFrame.size.height = toolBarFrame.origin.y;
        target.bubbleTable.frame = tableViewFrame;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGRect)mainBoundsMinusHeight:(CGFloat)minus
{
    CGFloat navigationBarHeight = self.navigationController.navigationBarHidden ? 0 : self.navigationController.navigationBar.bounds.size.height;
    CGFloat tabBarHeight = self.hidesBottomBarWhenPushed ? 0 : self.tabBarController.tabBar.bounds.size.height;
    CGFloat bottomToolbarHeight = self.navigationController.toolbarHidden ? 0 : self.navigationController.toolbar.bounds.size.height;
    return CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - [[UIApplication sharedApplication] statusBarFrame].size.height - navigationBarHeight - tabBarHeight - bottomToolbarHeight - minus);
}

- (void)resignTextView
{
    [_textView resignFirstResponder];
    
    NSBubbleData *replyBubble = [NSBubbleData dataWithText:_textView.text date:[NSDate date] type:BubbleTypeMine];
    [_bubbleData addObject:replyBubble];
	
}

#pragma mark - UIBubbleTableViewDataSource implementation

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    return [_bubbleData count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    return [_bubbleData objectAtIndex:row];
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect r = _containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	_containerView.frame = r;
}

@end
