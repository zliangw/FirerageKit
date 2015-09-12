//
//  FRMessengerViewController.h
//  FirerageKit
//
//  Created by Aidian on 14-5-24.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FRMessengerViewControllerDelegate;

@interface FRMessengerViewController : UIViewController

@property (nonatomic, weak) IBOutlet id<FRMessengerViewControllerDelegate> delegate;
@property (nonatomic, assign) CGFloat inputViewHeight;// Default is 44
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, strong) IBOutlet UIView *messageContentView;
@property (nonatomic, strong) UIColor *inputContainerColor;
@property (nonatomic, assign , readonly) BOOL inputting;

- (void)clearMessageInputView;
- (void)resignInputViewFirstResponder;
- (void)sendMessage:(NSString *)message;

@end

@protocol FRMessengerViewControllerDelegate <NSObject>

@optional
- (void)messengerViewController:(FRMessengerViewController *)messengerViewController didSentMessage:(NSString *)message;
- (void)messengerViewControllerDidBeginInputting:(FRMessengerViewController *)messengerViewController;
- (void)messengerViewControllerDidEndInputting:(FRMessengerViewController *)messengerViewController withMessage:(NSString *)message;

@end
