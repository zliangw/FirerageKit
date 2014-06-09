//
//  UIViewController+FRProgressHUD.m
//  FirerageKit
//
//  Created by Aidian on 14-6-2.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "UIViewController+FRProgressHUD.h"
#import "MBProgressHUD.h"
#import <objc/runtime.h>

static const void *FRProgressHUDKey = &FRProgressHUDKey;
static const void *FRSuccessedHUDImageNameKey = &FRSuccessedHUDImageNameKey;
static const void *FRFailedHUDImageNameKey = &FRFailedHUDImageNameKey;

@interface UIViewController (FRProgressHUDPrivate)

@property (nonatomic, strong) MBProgressHUD *progressHUD;

@end

@implementation UIViewController (FRProgressHUD)

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

#pragma mark -
#pragma mark - Show HUD Methods

- (void)showProgressWithLabelText:(NSString *)labelText
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = labelText;
    self.progressHUD = hud;
}

- (void)showProgressWithLabelText:(NSString *)labelText customView:(UIView *)customView
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = labelText;
    hud.customView = customView;
    hud.mode = MBProgressHUDModeCustomView;
    self.progressHUD = hud;
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
        self.progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        if (customView) {
            self.progressHUD.customView = customView;
            self.progressHUD.mode = MBProgressHUDModeCustomView;
        } else {
            self.progressHUD.mode = MBProgressHUDModeText;
        }
        self.progressHUD.labelText = toast;
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

- (void)showSuccessedToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay
{
    UIImage *image = [UIImage imageNamed:self.successedHUDImageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [self showToast:toast hideAfterDelay:delay withCustomView:imageView];
}

- (void)showfailedToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay
{
    UIImage *image = [UIImage imageNamed:self.failedHUDImageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [self showToast:toast hideAfterDelay:delay withCustomView:imageView];
}

- (void)showProgressOnNavigationWithLabelText:(NSString *)labelText
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = labelText;
    self.progressHUD = hud;
}

- (void)showProgressOnWindowWithLabelText:(NSString *)labelText
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.labelText = labelText;
    self.progressHUD = hud;
}

- (void)changeProgressStateWithMode:(FRProgressHUDMode)hudMode labelText:(NSString *)labelText customView:(UIView *)customView
{
    self.progressHUD.customView = customView;
    self.progressHUD.mode = (MBProgressHUDMode)hudMode;
	self.progressHUD.labelText = labelText;
    [self.progressHUD setNeedsLayout];
    [self.progressHUD setNeedsDisplay];
}

#pragma mark -
#pragma mark - Hide HUD Methods

- (void)hideProgress
{
    [self.progressHUD hide:YES];
}

- (void)hideProgressAfterDelay:(NSTimeInterval)delay
{
    [self.progressHUD hide:YES afterDelay:delay];
}

@end
