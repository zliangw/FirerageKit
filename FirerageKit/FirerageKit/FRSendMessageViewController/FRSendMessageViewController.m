//
//  FRSendMessageViewController.m
//  FirerageKit
//
//  Created by Aidian on 14-5-24.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "FRSendMessageViewController.h"
#import "HPGrowingTextView.h"
#import "DAKeyboardControl.h"

@interface FRSendMessageViewController () <HPGrowingTextViewDelegate>

@property (strong, nonatomic) UIView *textViewContainerView;
@property (strong, nonatomic) HPGrowingTextView *textView;

@end

@implementation FRSendMessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    if (_textViewContainerView) {
        return;
    }
    
    static CGFloat inputHeight = 44;
    if (_inputViewHeight < inputHeight) {
        self.inputViewHeight = inputHeight;
    }
    
    if (_contentView == nil) {
        self.contentView = [[UIView alloc] initWithFrame:[self mainBoundsMinusHeight:_inputViewHeight]];
    }
    [self.view addSubview:_contentView];
    
    self.textViewContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_contentView.frame), CGRectGetWidth(self.view.bounds), _inputViewHeight)];
    _textViewContainerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_textViewContainerView];
    
	_textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(5, 3, CGRectGetWidth(self.view.bounds) - 10, _textViewContainerView.bounds.size.height)];
    _textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
	_textView.minNumberOfLines = 1;
	_textView.maxNumberOfLines = 2;
	_textView.returnKeyType = UIReturnKeySend;
	_textView.font = [UIFont systemFontOfSize:15.0f];
	_textView.delegate = self;
    _textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    _textView.backgroundColor = [UIColor clearColor];
    _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [_textViewContainerView addSubview:_textView];
    _textViewContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    UIImageView *messageTextViewBg = [[UIImageView alloc] initWithFrame:CGRectMake(_textView.frame.origin.x, _textView.frame.origin.y - 3, _textView.frame.size.width, _textView.frame.size.height + 7)];
    messageTextViewBg.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [messageTextViewBg setImage:[[UIImage imageNamed:@"SendTextViewBkg.png"] stretchableImageWithLeftCapWidth:25 topCapHeight:15]];
    [_textViewContainerView insertSubview:messageTextViewBg belowSubview:_textView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.keyboardTriggerOffset = _textViewContainerView.bounds.size.height;
    __weak typeof(self) weakSelf = self;
    [self.view addKeyboardPanningWithActionHandler:^(CGRect keyboardFrameInView, BOOL opening, BOOL closing) {
        CGRect toolBarFrame = weakSelf.textViewContainerView.frame;
        toolBarFrame.origin.y = keyboardFrameInView.origin.y - toolBarFrame.size.height;
        weakSelf.textViewContainerView.frame = toolBarFrame;
        
        CGRect tableViewFrame = weakSelf.contentView.frame;
        tableViewFrame.size.height = toolBarFrame.origin.y;
        weakSelf.contentView.frame = tableViewFrame;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setter

- (void)setContentView:(UIView *)contentView
{
    if (_contentView) {
        [_contentView removeFromSuperview];
    }
    _contentView = contentView;
    _contentView.frame = [self mainBoundsMinusHeight:_inputViewHeight];
}

#pragma mark - Private Methods

- (CGRect)mainBoundsMinusHeight:(CGFloat)minus
{
    CGFloat navigationBarHeight = self.navigationController.navigationBarHidden ? 0 : self.navigationController.navigationBar.bounds.size.height;
    CGFloat tabBarHeight = self.hidesBottomBarWhenPushed ? 0 : self.tabBarController.tabBar.bounds.size.height;
    CGFloat bottomToolbarHeight = self.navigationController.toolbarHidden ? 0 : self.navigationController.toolbar.bounds.size.height;
    return CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - [[UIApplication sharedApplication] statusBarFrame].size.height - navigationBarHeight - tabBarHeight - bottomToolbarHeight - minus);
}

- (void)sendMessage
{
    if (_sendMessageDelegate && [_sendMessageDelegate respondsToSelector:@selector(sendMessageViewController:didSentMessage:)]) {
        [_sendMessageDelegate sendMessageViewController:self didSentMessage:_textView.text];
    }
    _textView.text =@"";
    [_textView refreshHeight];
}

#pragma mark - Btn Action

- (void)doneBtnDidPressed:(id)sender
{
    [self sendMessage];
}

#pragma mark - HPGrowingTextViewDelegate

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect r = _textViewContainerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	_textViewContainerView.frame = r;
}

- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
{
    [self sendMessage];
    return YES;
}

@end
