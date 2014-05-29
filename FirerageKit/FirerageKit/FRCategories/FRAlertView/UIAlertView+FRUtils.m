//
//  UIAlertView+FRUtils.m
//  FirerageKit
//
//  Created by Aidian.Tang on 14-5-29.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "UIAlertView+FRUtils.h"

#import <objc/runtime.h>

static const void *FRAlertViewOriginalDelegateKey = &FRAlertViewOriginalDelegateKey;
static const void *FRAlertViewTapBlockKey = &FRAlertViewTapBlockKey;
static const void *FRAlertViewConfirmBlockKey = &FRAlertViewConfirmBlockKey;
static const void *FRAlertViewCancelBlockKey = &FRAlertViewCancelBlockKey;

@implementation UIAlertView (FRUtils)

+ (void)showMessage:(NSString *)message withTitle:(NSString *)title confirmTitle:(NSString *)confirmTitle
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:confirmTitle otherButtonTitles:nil];
    [alertView show];
}

+ (void)showMessage:(NSString *)message withTitle:(NSString *)title confirmTitle:(NSString *)confirmTitle cancelTitle:(NSString *)cancelTitle confirmBlock:(FRAlertViewConfirmBlock)confirmBlock cancelBlock:(FRAlertViewCancelBlock)cancelBlock
{
    UIAlertView *alertView = [[self alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelTitle otherButtonTitles:confirmTitle, nil];
    alertView.confirmBlock = confirmBlock;
    alertView.cancelBlock = cancelBlock;
    [alertView show];
}

+ (void)showMessage:(NSString *)message withTitle:(NSString *)title cancelTitle:(NSString *)cancelTitle otherTitles:(NSArray *)otherTitles tapBlock:(FRAlertViewTapBlock)tapBlock
{
    UIAlertView *alertView = [[self alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelTitle otherButtonTitles:nil];
    alertView.tapBlock = tapBlock;
    
    for (NSString *otherButtonTitle in otherTitles) {
        [alertView addButtonWithTitle:otherButtonTitle];
    }
    
    [alertView show];

}

- (void)checkAlertViewDelegate {
    if (self.delegate != (id<UIAlertViewDelegate>)self) {
        objc_setAssociatedObject(self, FRAlertViewOriginalDelegateKey, self.delegate, OBJC_ASSOCIATION_ASSIGN);
        self.delegate = (id<UIAlertViewDelegate>)self;
    }
}

#pragma mark -
#pragma mark - Setter Getter

- (void)setConfirmBlock:(FRAlertViewConfirmBlock)confirmBlock
{
    [self checkAlertViewDelegate];
    objc_setAssociatedObject(self, FRAlertViewConfirmBlockKey, confirmBlock, OBJC_ASSOCIATION_COPY);
}

- (FRAlertViewConfirmBlock)confirmBlock
{
    return objc_getAssociatedObject(self, FRAlertViewConfirmBlockKey);
}

- (void)setCancelBlock:(FRAlertViewCancelBlock)cancelBlock
{
    [self checkAlertViewDelegate];
    objc_setAssociatedObject(self, FRAlertViewCancelBlockKey, cancelBlock, OBJC_ASSOCIATION_COPY);
}

- (FRAlertViewCancelBlock)cancelBlock
{
    return objc_getAssociatedObject(self, FRAlertViewCancelBlockKey);
}

- (void)setTapBlock:(FRAlertViewTapBlock)tapBlock
{
    [self checkAlertViewDelegate];
    objc_setAssociatedObject(self, FRAlertViewTapBlockKey, tapBlock, OBJC_ASSOCIATION_COPY);
}

- (FRAlertViewTapBlock)tapBlock
{
    return objc_getAssociatedObject(self, FRAlertViewTapBlockKey);
}

#pragma mark -
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if (self.cancelBlock) {
            self.cancelBlock(self);
        }
    } else {
        if (self.confirmBlock) {
            self.confirmBlock(self);
        }
    }
    if (self.tapBlock) {
        self.tapBlock(self, buttonIndex);
    }
}

@end
