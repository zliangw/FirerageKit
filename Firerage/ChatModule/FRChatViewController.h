//
//  FRChatViewController.h
//  FirerageKit
//
//  Created by Aidian.Tang on 14-5-21.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "FRMessengerViewController.h"
#import "UIBubbleTableView.h"

@protocol FRChatViewControllerDelegate;

@interface FRChatViewController : FRMessengerViewController

@property (nonatomic, weak) IBOutlet id<FRChatViewControllerDelegate> chatDelegate;
@property (strong, nonatomic, readonly) UIBubbleTableView *bubbleTable;
@property (nonatomic, strong) NSArray *bubbleDatas;

@end

@protocol FRChatViewControllerDelegate <NSObject>

@optional
- (void)chatViewController:(FRChatViewController *)chatViewController didSentMessage:(NSString *)message;

@end