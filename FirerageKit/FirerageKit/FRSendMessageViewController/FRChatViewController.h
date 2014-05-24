//
//  FRSendMessageTableViewController.h
//  FirerageKit
//
//  Created by Aidian.Tang on 14-5-21.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "FRLoadDataViewController.h"

@protocol FRChatViewControllerDelegate;

@interface FRChatViewController : FRLoadDataViewController

@property (nonatomic, weak) IBOutlet id<FRChatViewControllerDelegate> delegate;
@property (nonatomic, strong, readonly) UITableView *messageTableView;

@end

@protocol FRChatViewControllerDelegate <NSObject>

@optional
- (void)chatViewController:(FRChatViewController *)chatViewController didSentMessage:(NSString *)message;

@required
- (NSInteger)chatViewController:(FRChatViewController *)chatViewController numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)chatViewController:(FRChatViewController *)chatViewController cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end