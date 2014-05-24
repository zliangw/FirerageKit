//
//  UIViewController+FRCustomNavigationBarItem.h
//  FirerageKit
//
//  Created by Aidian on 14-5-24.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (FRCustomNavigationBarItem)

- (void)addIOS7BackLeftBarButtonItem;
- (void)addLeftBarButtonItemWithTarget:(id)target normalImageName:(NSString *)normalImageName highlightedImageName:(NSString *)highlightedImageName selector:(SEL)selctor;
- (void)addRightBarButtonItemWithTarget:(id)target normalImageName:(NSString *)normalImageName highlightedImageName:(NSString *)highlightedImageName selector:(SEL)selctor;

@end
