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
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) CGFloat inputViewHeight;// Default is 44

@end

@protocol FRSendMessageViewControllerDelegate <NSObject>

@optional
- (void)sendMessageViewController:(FRSendMessageViewController *)sendMessageViewController didSentMessage:(NSString *)message;

@end
