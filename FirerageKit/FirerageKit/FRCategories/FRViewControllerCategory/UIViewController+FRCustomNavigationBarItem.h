//
//  UIViewController+FRCustomNavigationBarItem.h
//  FirerageKit
//
//  Created by Aidian on 14-5-24.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (FRCustomNavigationBarItem)

@property (nonatomic, copy) NSString *backBarButtonItemNormalImageName;
@property (nonatomic, copy) NSString *backBarButtonItemHighlightedImageName;
@property (nonatomic, copy) NSString *backBarButtonItemTitle;

- (void)addIOSBackBarButtonItemAutomatically;
- (void)addIOS7BackBarButtonItemWithTitle:(NSString *)title normalImageName:(NSString *)normalImageName highlightedImageName:(NSString *)highlightedImageName;
- (void)addLeftBarButtonItemWithTarget:(id)target title:(NSString *)title normalImageName:(NSString *)normalImageName highlightedImageName:(NSString *)highlightedImageName selector:(SEL)selctor;
- (void)addRightBarButtonItemWithTarget:(id)target title:(NSString *)title normalImageName:(NSString *)normalImageName highlightedImageName:(NSString *)highlightedImageName selector:(SEL)selctor;

@end
