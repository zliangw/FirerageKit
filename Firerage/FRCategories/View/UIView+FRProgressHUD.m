//
//  UIView+FRProgressHUD.m
//  FirerageKit
//
//  Created by Aidian on 15/9/1.
//  Copyright (c) 2015年 Illidan.Firerage. All rights reserved.
//

#import "UIView+FRProgressHUD.h"
#import "MBProgressHUD.h"
#import <objc/runtime.h>

static const void *FRProgressHUDKey = &FRProgressHUDKey;
static const void *FRSuccessedHUDImageNameKey = &FRSuccessedHUDImageNameKey;
static const void *FRFailedHUDImageNameKey = &FRFailedHUDImageNameKey;

@interface UIViewController (FRProgressHUDPrivate)

@property (nonatomic, strong) MBProgressHUD *progressHUD;

@end

@implementation UIView (FRProgressHUD)

@dynamic hudProgress;

#pragma mark -
#pragma mark - Setter Getter

- (void)setProgressHUD:(MBProgressHUD *)progressHUD
{
    objc_setAssociatedObject(self, FRProgressHUDKey, progressHUD, OBJC_ASSOCIATION_RETAIN);
}

- (MBProgressHUD *)progressHUD
{
    return objc_getAssociatedObject(self, FRProgressHUDKey);
}

- (void)setSuccessedHUDImageName:(NSString *)successedHUDImageName
{
    objc_setAssociatedObject(self, FRSuccessedHUDImageNameKey, successedHUDImageName, OBJC_ASSOCIATION_COPY);
}

- (NSString *)successedHUDImageName
{
    return objc_getAssociatedObject(self, FRSuccessedHUDImageNameKey);
}

- (void)setFailedHUDImageName:(NSString *)failedHUDImageName
{
    objc_setAssociatedObject(self, FRFailedHUDImageNameKey, failedHUDImageName, OBJC_ASSOCIATION_COPY);
}

- (NSString *)failedHUDImageName
{
    return objc_getAssociatedObject(self, FRFailedHUDImageNameKey);
}

- (void)setHudProgress:(CGFloat)hudProgress
{
    if (self.progressHUD && self.progressHUD.mode == MBProgressHUDModeDeterminateHorizontalBar) {
        self.progressHUD.progress = hudProgress;
    }
}

#pragma mark -
#pragma mark - Show HUD Methods

- (void)showProgress
{
    [self showProgressWithLabelText:nil];
}

- (void)showProgressWithLabelText:(NSString *)labelText
{
    if (!self.progressHUD) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        hud.detailsLabelText = labelText;
        self.progressHUD = hud;
    } else {
        [self changeProgressStateWithMode:FRProgressHUDModeIndeterminate labelText:labelText customView:nil];
    }
    if (self.progressHUD.alpha == 0.0f) {
        [self.progressHUD show:YES];
    }
}

- (void)showProgressWithLabelText:(NSString *)labelText customView:(UIView *)customView
{
    if (!self.progressHUD) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        hud.detailsLabelText = labelText;
        hud.customView = customView;
        hud.mode = MBProgressHUDModeCustomView;
        self.progressHUD = hud;
    } else {
        [self changeProgressStateWithMode:FRProgressHUDModeIndeterminate labelText:labelText customView:customView];
    }
    if (self.progressHUD.alpha == 0.0f) {
        [self.progressHUD show:YES];
    }
}

- (void)showToast:(NSString *)toast
{
    [self showToast:toast hideAfterDelay:2.];
}

- (void)showToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay
{
    [self showToast:toast hideAfterDelay:delay withCustomView:nil];
}

- (void)showToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay withCustomView:(UIView *)customView
{
    if (self.progressHUD == nil) {
        self.progressHUD = [MBProgressHUD showHUDAddedTo:self animated:YES];
        if (customView) {
            self.progressHUD.customView = customView;
            self.progressHUD.mode = MBProgressHUDModeCustomView;
        } else {
            self.progressHUD.mode = MBProgressHUDModeText;
        }
        self.progressHUD.detailsLabelText = toast;
    } else {
        if (customView) {
            [self changeProgressStateWithMode:FRProgressHUDModeCustomView labelText:toast customView:customView];
        } else {
            [self changeProgressStateWithMode:(FRProgressHUDMode)MBProgressHUDModeText labelText:toast customView:customView];
        }
    }
    if (self.progressHUD.alpha == 0.0f) {
        [self.progressHUD show:YES];
    }
    [self hideProgressAfterDelay:delay];
}

- (void)showSuccessedToast:(NSString *)toast
{
    [self showSuccessedToast:toast hideAfterDelay:2.];
}

- (void)showSuccessedToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay
{
    UIImage *image = [UIImage imageNamed:self.successedHUDImageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [self showToast:toast hideAfterDelay:delay withCustomView:imageView];
}

- (void)showfailedToast:(NSString *)toast
{
    [self showfailedToast:toast hideAfterDelay:2.];
}

- (void)showfailedToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay
{
    UIImage *image = [UIImage imageNamed:self.failedHUDImageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [self showToast:toast hideAfterDelay:delay withCustomView:imageView];
}

- (void)showBarProgress
{
    if (!self.progressHUD) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
        hud.dimBackground = YES;
        self.progressHUD = hud;
    } else {
        [self changeProgressStateWithMode:FRProgressHUDModeIndeterminate labelText:nil customView:nil];
    }
    if (self.progressHUD.alpha == 0.0f) {
        [self.progressHUD show:YES];
    }
}

- (void)changeProgressStateWithMode:(FRProgressHUDMode)hudMode labelText:(NSString *)labelText customView:(UIView *)customView
{
    self.progressHUD.customView = customView;
    self.progressHUD.mode = (MBProgressHUDMode)hudMode;
    self.progressHUD.detailsLabelText = labelText;
    [self.progressHUD setNeedsLayout];
    [self.progressHUD setNeedsDisplay];
}

#pragma mark -
#pragma mark - Hide HUD Methods

- (void)hideProgress
{
    [self.progressHUD hide:YES];
    self.progressHUD = nil;
}

- (void)hideProgressAfterDelay:(NSTimeInterval)delay
{
    [self.progressHUD hide:YES afterDelay:delay];
    self.progressHUD = nil;
}

@end
