//
//  FRSendMessageViewController.h
//  FirerageKit
//
//  Created by Aidian on 14-5-24.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "FRLoadDataViewController.h"

@protocol FRSendMessageViewControllerDelegate;

@interface FRSendMessageViewController : FRLoadDataViewController

@property (nonatomic, weak) IBOutlet id<FRSendMessageViewControllerDelegate> sendMessageDelegate;
@property (nonatomic, assign) CGFloat inputViewHeight;// Default is 44
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, strong) IBOutlet UIView *messageContentView;
@property (nonatomic, strong) UIColor *inputContainerColor;

- (void)clearMessageInputView;
- (void)resignInputViewFirstResponder;
- (void)sendMessage:(NSString *)message;

@end

@protocol FRSendMessageViewControllerDelegate <NSObject>

@optional
- (void)sendMessageViewController:(FRSendMessageViewController *)sendMessageViewController didSentMessage:(NSString *)message;
- (void)sendMessageViewControllerDidBeginInputting:(FRSendMessageViewController *)sendMessageViewController;
- (void)sendMessageViewControllerDidEndInputting:(FRSendMessageViewController *)sendMessageViewController withMessage:(NSString *)message;

@end
