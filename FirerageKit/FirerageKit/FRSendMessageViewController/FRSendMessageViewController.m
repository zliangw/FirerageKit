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

@property (nonatomic, strong) UIView *inputContainerView;
@property (nonatomic, strong) HPGrowingTextView *messageInputView;
@property (nonatomic, assign , readwrite) BOOL inputting;

@end

@implementation FRSendMessageViewController

- (void)dealloc
{
    self.messageInputView.delegate = nil;
    self.sendMessageDelegate = nil;
    [self.messageInputView resignFirstResponder];
    [self.view removeKeyboardControl];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.sendMessageDelegate = nil;
}

- (void)loadView
{
    [super loadView];
    
    if (_inputContainerView) {
        return;
    }
    
    static CGFloat inputHeight = 44;
    if (_inputViewHeight < inputHeight) {
        self.inputViewHeight = inputHeight;
    }
    
    if (_messageContentView == nil) {
        self.messageContentView = [[UIView alloc] initWithFrame:[self mainBoundsMinusHeight:_inputViewHeight]];
    }
    _messageContentView.frame = [self mainBoundsMinusHeight:_inputViewHeight];
    [self.view addSubview:_messageContentView];
    
    self.inputContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_messageContentView.frame), CGRectGetWidth(self.view.bounds), _inputViewHeight)];
    if (!_inputContainerColor) {
        _inputContainerColor = [UIColor clearColor];
    }
    _inputContainerView.backgroundColor = _inputContainerColor;
    [self.view addSubview:_inputContainerView];
    
    _messageInputView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(5, 5, CGRectGetWidth(self.view.bounds) - 8.5, _inputContainerView.bounds.size.height)];
    _messageInputView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    _messageInputView.minNumberOfLines = 1;
    _messageInputView.maxNumberOfLines = 2;
    _messageInputView.returnKeyType = UIReturnKeySend;
    _messageInputView.font = [UIFont systemFontOfSize:15.0f];
    _messageInputView.delegate = self;
    _messageInputView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    _messageInputView.backgroundColor = [UIColor clearColor];
    _messageInputView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _messageInputView.internalTextView.enablesReturnKeyAutomatically = YES;
    
    [_inputContainerView addSubview:_messageInputView];
    _inputContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    UIImageView *messageTextViewBg = [[UIImageView alloc] initWithFrame:CGRectMake(_messageInputView.frame.origin.x - 2, _messageInputView.frame.origin.y - 3, _messageInputView.frame.size.width + 2, _messageInputView.frame.size.height + 7)];
    messageTextViewBg.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [messageTextViewBg setImage:[[UIImage imageNamed:@"SendTextViewBkg.png"] stretchableImageWithLeftCapWidth:25 topCapHeight:15]];
    [_inputContainerView insertSubview:messageTextViewBg belowSubview:_messageInputView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.keyboardTriggerOffset = _inputContainerView.bounds.size.height;
    __weak typeof(self) weakSelf = self;
    [self.view addKeyboardPanningWithActionHandler:^(CGRect keyboardFrameInView, BOOL opening, BOOL closing) {

        CGRect toolBarFrame = weakSelf.inputContainerView.frame;
        toolBarFrame.origin.y = keyboardFrameInView.origin.y - toolBarFrame.size.height;
        CGRect tableViewFrame = weakSelf.messageContentView.frame;
        tableViewFrame.size.height = toolBarFrame.origin.y;
        if (opening) {
            weakSelf.inputContainerView.frame = toolBarFrame;
            weakSelf.messageContentView.frame = tableViewFrame;
            
            if (weakSelf.sendMessageDelegate && [weakSelf.sendMessageDelegate respondsToSelector:@selector(sendMessageViewControllerDidBeginInputting:)]) {
                [weakSelf.sendMessageDelegate sendMessageViewControllerDidBeginInputting:weakSelf];
            }
        } else if (closing) {
            weakSelf.inputContainerView.frame = toolBarFrame;
            weakSelf.messageContentView.frame = tableViewFrame;
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setter

- (void)setMessageContentView:(UIView *)contentView
{
    if (_messageContentView) {
        [_messageContentView removeFromSuperview];
    }
    _messageContentView = contentView;
    _messageContentView.autoresizingMask = UIViewAutoresizingNone;
    _messageContentView.frame = [self mainBoundsMinusHeight:_inputViewHeight];
}

- (void)setInputContainerColor:(UIColor *)inputContainerColor
{
    if (_inputContainerColor) {
        _inputContainerColor = inputContainerColor;
        _inputContainerView.backgroundColor = _inputContainerColor;
    }
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    _messageInputView.placeholder = _placeholder;
}

#pragma mark - Private Methods

- (CGRect)mainBoundsMinusHeight:(CGFloat)minus
{
    CGFloat navigationBarHeight = self.navigationController.navigationBarHidden ? 0 : self.navigationController.navigationBar.bounds.size.height;
    CGFloat tabBarHeight = self.hidesBottomBarWhenPushed ? 0 : self.tabBarController.tabBar.bounds.size.height;
    CGFloat bottomToolbarHeight = self.navigationController.toolbarHidden ? 0 : self.navigationController.toolbar.bounds.size.height;
    return CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - [[UIApplication sharedApplication] statusBarFrame].size.height - navigationBarHeight - tabBarHeight - bottomToolbarHeight - minus);
}

#pragma mark -
#pragma mark - Member Methods

- (void)sendMessage:(NSString *)message
{
    if (_sendMessageDelegate && [_sendMessageDelegate respondsToSelector:@selector(sendMessageViewController:didSentMessage:)]) {
        [_sendMessageDelegate sendMessageViewController:self didSentMessage:message];
    }
}

- (void)clearMessageInputView
{
    _messageInputView.text =@"";
    [_messageInputView refreshHeight];
}

- (void)resignInputViewFirstResponder
{
    [_messageInputView.internalTextView resignFirstResponder];
}

#pragma mark - Btn Action

- (void)doneBtnDidPressed:(id)sender
{
    [self sendMessage:_messageInputView.text];
}

#pragma mark - HPGrowingTextViewDelegate

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect r = _inputContainerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	_inputContainerView.frame = r;
    
    CGRect tableViewFrame = self.messageContentView.frame;
    tableViewFrame.size.height = _inputContainerView.frame.origin.y;
    self.messageContentView.frame = tableViewFrame;
}

- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
{
    [self sendMessage:_messageInputView.text];
    [self clearMessageInputView];
    
    return NO;
}

- (void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView
{
    self.inputting = YES;
}

- (void)growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView
{
    if (_sendMessageDelegate && [_sendMessageDelegate respondsToSelector:@selector(sendMessageViewControllerDidEndInputting:withMessage:)]) {
        [_sendMessageDelegate sendMessageViewControllerDidEndInputting:self withMessage:_messageInputView.text];
    }
    self.inputting = NO;
}

@end
