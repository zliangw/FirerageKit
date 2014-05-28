//
//  UIView+FRTouchBlock.h
//  FirerageKit
//
//  Created by Aidian.Tang on 14-5-28.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^FRViewSingleTapBlock) (UIView *view);

@interface UIView (FRTouchBlock)

@property (copy, nonatomic) FRViewSingleTapBlock singleTapBlock;

- (void)addSingleTapWithBlock:(FRViewSingleTapBlock)block;

@end
