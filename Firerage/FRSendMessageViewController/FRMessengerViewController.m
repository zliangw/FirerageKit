//
//  FRMessengerViewController.m
//  FirerageKit
//
//  Created by Aidian on 14-5-24.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "FRMessengerViewController.h"
#import "HPGrowingTextView.h"
#import "DAKeyboardControl.h"
#import "Masonry.h"

static const CGFloat FRInputViewHeight = 44;

@interface FRMessengerViewController () <HPGrowingTextViewDelegate>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *inputContainerView;
@property (nonatomic, strong) HPGrowingTextView *messageInputView;
@property (nonatomic, assign , readwrite) BOOL inputting;

@property (nonatomic, strong) MASConstraint *contentViewConstraint;

@end

@implementation FRMessengerViewController

- (void)dealloc
{
    self.messageInputView.delegate = nil;
    self.delegate = nil;
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

- (void)loadView
{
    [super loadView];
    
    if (_inputContainerView) {
        return;
    }
    
    if (self.contentView == nil) {
        self.contentView = [[UIView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            self.contentViewConstraint = make.edges.equalTo(self.view);
        }];
    }
    
    if (_messageContentView == nil) {
        self.messageContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame) - self.inputViewHeight)];
    }
    
    self.inputContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_messageContentView.frame), CGRectGetWidth(self.view.bounds), self.inputViewHeight)];
    if (!_inputContainerColor) {
        _inputContainerColor = [UIColor clearColor];
    }
    _inputContainerView.backgroundColor = _inputContainerColor;
    [self.contentView addSubview:_inputContainerView];
    _inputContainerView.backgroundColor = [UIColor clearColor];
    
    UIView *superView = self.contentView;
    [_inputContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(self.inputViewHeight));
        make.left.equalTo(superView);
        make.bottom.equalTo(superView);
        make.right.equalTo(superView);
    }];
    
    _messageInputView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(4.8, 5, CGRectGetWidth(self.view.bounds) - 8.5, _inputContainerView.bounds.size.height)];
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
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewDidTapped:)];
    
    __weak typeof(self) weakSelf = self;
    [self.view addKeyboardPanningWithActionHandler:^(CGRect keyboardFrameInView, BOOL opening, BOOL closing) {
        if (opening) {
            UIEdgeInsets padding = UIEdgeInsetsMake(0, 0, keyboardFrameInView.size.height, 0);
            [weakSelf.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(weakSelf.contentView.superview).with.insets(padding);
            }];
            
            [weakSelf.contentView addGestureRecognizer:tapGestureRecognizer];
        } else if (closing) {
            [weakSelf.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(weakSelf.contentView.superview);
            }];
            
            [weakSelf.contentView removeGestureRecognizer:tapGestureRecognizer];
        }
        [UIView animateWithDuration:1.0 animations:^{
            [weakSelf.view layoutIfNeeded];
            if (opening) {
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(messengerViewControllerDidBeginInputting:)]) {
                    [weakSelf.delegate messengerViewControllerDidBeginInputting:weakSelf];
                }
            }
        }];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setter Getter

- (void)setMessageContentView:(UIView *)contentView
{
    if (_messageContentView) {
        [_messageContentView removeFromSuperview];
    }
    _messageContentView = contentView;
    _messageContentView.frame = self.messageContentView.bounds;
    _messageContentView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.messageContentView];
    
    UIEdgeInsets padding = UIEdgeInsetsMake(0, 0, self.inputViewHeight, 0);
    UIView *superview = self.contentView;
    
    [_messageContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superview).with.insets(padding);
    }];
}

- (CGFloat)inputViewHeight
{
    if (_inputViewHeight == 0) {
        _inputViewHeight = FRInputViewHeight;
    }
    return _inputViewHeight;
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


#pragma mark -
#pragma mark - Member Methods

- (void)sendMessage:(NSString *)message
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(messengerViewController:didSentMessage:)]) {
        [self.delegate messengerViewController:self didSentMessage:message];
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

- (void)contentViewDidTapped:(UITapGestureRecognizer *)tapGestureRecognizer
{
    if (self.inputting) {
        [self resignInputViewFirstResponder];
    }
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
    return NO;
}

- (void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView
{
    self.inputting = YES;
}

- (void)growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(messengerViewControllerDidEndInputting:withMessage:)]) {
        [self.delegate messengerViewControllerDidEndInputting:self withMessage:_messageInputView.text];
    }
    self.inputting = NO;
}

@end
