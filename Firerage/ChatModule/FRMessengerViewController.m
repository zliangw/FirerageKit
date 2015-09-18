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
@property (nonatomic, strong) UIView *separatorView;
@property (nonatomic, strong) HPGrowingTextView *messageInputView;
@property (nonatomic, assign , readwrite) BOOL inputting;
@property (nonatomic, assign) CGRect keyboardFrameInView;
@property (nonatomic, strong) MASConstraint *contentViewConstraint;

@end

@implementation FRMessengerViewController

@synthesize inputContainerSeparatorColor = _inputContainerSeparatorColor;
@synthesize inputViewBorderColor = _inputViewBorderColor;
@synthesize inputViewFont = _inputViewFont;
@synthesize inputViewTextColor = _inputViewTextColor;
@synthesize inputViewPlaceholderColor = _inputViewPlaceholderColor;

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
    _inputContainerView.backgroundColor = self.inputContainerBackgroundColor;
    [self.contentView addSubview:_inputContainerView];
    
    [_inputContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(CGRectGetHeight(self.inputContainerView.frame)));
        make.left.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
    }];
    
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _inputContainerView.frame.size.width, .5f)];
    separatorView.backgroundColor = self.inputContainerSeparatorColor;
    [_inputContainerView addSubview:separatorView];
    [separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(.5f));
        make.left.equalTo(self.inputContainerView);
        make.top.equalTo(self.inputContainerView);
        make.right.equalTo(self.inputContainerView);
    }];
    self.separatorView = separatorView;
    
    _messageInputView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(5, 5, CGRectGetWidth(self.view.bounds) - 10, _inputContainerView.bounds.size.height - 10)];
    _messageInputView.clipsToBounds = YES;
    _messageInputView.contentInset = UIEdgeInsetsMake(5, 5, 0, 5);
    _messageInputView.minNumberOfLines = 1;
    _messageInputView.maxNumberOfLines = 5;
    _messageInputView.returnKeyType = UIReturnKeySend;
    _messageInputView.font = self.inputViewFont;
    _messageInputView.textColor = self.inputViewTextColor;
    _messageInputView.delegate = self;
    _messageInputView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    _messageInputView.backgroundColor = [UIColor clearColor];
    _messageInputView.internalTextView.enablesReturnKeyAutomatically = YES;
    _messageInputView.layer.borderColor = self.inputViewBorderColor.CGColor;
    _messageInputView.layer.borderWidth = .5f;
    _messageInputView.layer.cornerRadius = 5.f;
    
    [_inputContainerView addSubview:_messageInputView];
    _inputContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.keyboardTriggerOffset = _inputContainerView.bounds.size.height;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewDidTapped:)];
    
    __weak typeof(self) weakSelf = self;
    [self.view addKeyboardPanningWithActionHandler:^(CGRect keyboardFrameInView, BOOL opening, BOOL closing) {
        weakSelf.keyboardFrameInView = keyboardFrameInView;
        
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

- (void)setInputContainerBackgroundColor:(UIColor *)inputContainerColor
{
    _inputContainerBackgroundColor = inputContainerColor;
    _inputContainerView.backgroundColor = _inputContainerBackgroundColor;
}

- (void)setInputContainerSeparatorColor:(UIColor *)inputContainerSeparatorColor
{
    _inputContainerSeparatorColor = inputContainerSeparatorColor;
    self.separatorView.backgroundColor = _inputContainerSeparatorColor;
}

- (UIColor *)inputContainerSeparatorColor
{
    if (!_inputContainerSeparatorColor) {
        _inputContainerSeparatorColor = [UIColor lightGrayColor];
    }
    return _inputContainerSeparatorColor;
}

- (void)setInputViewPlaceholder:(NSString *)placeholder
{
    _inputViewPlaceholder = [placeholder copy];
    _messageInputView.placeholder = _inputViewPlaceholder;
}

- (UIColor *)inputViewBorderColor
{
    if (!_inputViewBorderColor) {
        _inputViewBorderColor = [UIColor lightGrayColor];
    }
    
    return _inputViewBorderColor;
}

- (void)setInputViewBorderColor:(UIColor *)inputViewBorderColor
{
    _inputViewBorderColor = inputViewBorderColor;
    self.messageInputView.layer.borderColor = _inputViewBorderColor.CGColor;
}

- (void)setInputViewFont:(UIFont *)inputViewFont
{
    _inputViewFont = inputViewFont;
    self.messageInputView.font = inputViewFont;
}

- (UIFont *)inputViewFont
{
    if (!_inputViewFont) {
        _inputViewFont = [UIFont systemFontOfSize:15.0f];
    }
    return _inputViewFont;
}

- (void)setInputViewTextColor:(UIColor *)inputViewTextColor
{
    _inputViewTextColor = inputViewTextColor;
    self.messageInputView.textColor = _inputViewTextColor;
}

- (void)setInputViewPlaceholderColor:(UIColor *)inputViewPlaceholderColor
{
    _inputViewPlaceholderColor = inputViewPlaceholderColor;
    self.messageInputView.placeholderColor = _inputViewPlaceholderColor;
}

- (void)setInputViewTintColor:(UIColor *)inputViewTintColor
{
    _inputViewTintColor = inputViewTintColor;
    self.messageInputView.internalTextView.tintColor = _inputViewTintColor;

}

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
    
    [_inputContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(CGRectGetHeight(self.inputContainerView.frame)));
        make.left.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
    }];
    
    _messageContentView.frame = CGRectMake(_messageContentView.frame.origin.x, _messageContentView.frame.origin.y, _messageContentView.frame.size.width, _messageContentView.frame.size.height + diff);
    UIEdgeInsets padding = UIEdgeInsetsMake(0, 0, CGRectGetHeight(_inputContainerView.frame), 0);
    [_messageContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(padding);
    }];
    
    [UIView animateWithDuration:1.0 animations:^{
        [self.view layoutIfNeeded];
        if (self.delegate && [self.delegate respondsToSelector:@selector(messengerViewControllerWillChangeInputViewHeight:)]) {
            [self.delegate messengerViewControllerWillChangeInputViewHeight:self];
        }
    }];
}

- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
{
    [self sendMessage:_messageInputView.text];
    return NO;
}

- (void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(messengerViewControllerDidBeginInputting:)]) {
        [self.delegate messengerViewControllerDidBeginInputting:self];
    }
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
