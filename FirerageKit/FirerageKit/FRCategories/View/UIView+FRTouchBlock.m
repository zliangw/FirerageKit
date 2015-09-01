//
//  UIView+FRTouchBlock.m
//  FirerageKit
//
//  Created by Aidian.Tang on 14-5-28.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "UIView+FRTouchBlock.h"

#import <objc/runtime.h>

static const void *FRViewSingleTapBlockKey = &FRViewSingleTapBlockKey;

@implementation UIView (FRTouchBlock)

- (void)addSingleTapWithBlock:(FRViewSingleTapBlock)block
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidSingleTaped:)];
    [self addGestureRecognizer:tap];
    self.singleTapBlock = block;
}

- (void)viewDidSingleTaped:(UITapGestureRecognizer *)tapGes
{
    FRViewSingleTapBlock block = self.singleTapBlock;
    
    if (block) {
        block(self);
    }
}

- (void)setSingleTapBlock:(FRViewSingleTapBlock)singleTapBlock
{
    objc_setAssociatedObject(self, FRViewSingleTapBlockKey, singleTapBlock, OBJC_ASSOCIATION_COPY);
}

- (FRViewSingleTapBlock)singleTapBlock
{
    return objc_getAssociatedObject(self, FRViewSingleTapBlockKey);
}

@end
