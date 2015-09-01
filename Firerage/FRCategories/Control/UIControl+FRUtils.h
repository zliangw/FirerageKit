//
//  UIControl+FRUtils.h
//  Lovtracker
//
//  Created by Aidian on 15/8/15.
//  Copyright (c) 2015年 Winfires. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (FRUtils)

- (void)handleControlEvent:(UIControlEvents)event withBlock:(void(^)(id sender))block;

- (void)removeHandlerForEvent:(UIControlEvents)event;

@end
