//
//  UIViewController+FRProgressHUD.m
//  FirerageKit
//
//  Created by Aidian on 14-6-2.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "UIViewController+FRProgressHUD.h"

@implementation UIViewController (FRProgressHUD)

#pragma mark -
#pragma mark - Show HUD Methods

- (void)showProgress
{
    [self.view showProgressWithLabelText:nil];
}

- (void)showProgressWithLabelText:(NSString *)labelText
{
    [self.view showProgressWithLabelText:labelText];
}

- (void)showProgressWithLabelText:(NSString *)labelText customView:(UIView *)customView
{
    [self.view showProgressWithLabelText:labelText customView:customView];
}

- (void)showToast:(NSString *)toast
{
    [self.view showToast:toast hideAfterDelay:2.];
}

- (void)showToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay
{
    [self.view showToast:toast hideAfterDelay:delay withCustomView:nil];
}

- (void)showToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay withCustomView:(UIView *)customView
{
    [self.view showToast:toast hideAfterDelay:delay withCustomView:customView];
}

- (void)showSuccessedToast:(NSString *)toast
{
    [self.view showSuccessedToast:toast hideAfterDelay:2.];
}

- (void)showSuccessedToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay
{
    [self.view showToast:toast hideAfterDelay:delay];
}

- (void)showfailedToast:(NSString *)toast
{
    [self.view showfailedToast:toast hideAfterDelay:2.];
}

- (void)showfailedToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay
{
    [self.view showfailedToast:toast hideAfterDelay:delay];
}

- (void)showProgressOnNavigationWithLabelText:(NSString *)labelText
{
    [self.navigationController.view showProgressWithLabelText:labelText];
}

- (void)showProgressOnWindowWithLabelText:(NSString *)labelText
{
    [[[[UIApplication sharedApplication] delegate] window] showProgressWithLabelText:labelText];
}

- (void)showBarProgress
{
    [self.view showBarProgress];
}

- (void)changeProgressStateWithMode:(FRProgressHUDMode)hudMode labelText:(NSString *)labelText customView:(UIView *)customView
{
    [self.view changeProgressStateWithMode:hudMode labelText:labelText customView:customView];
}

#pragma mark -
#pragma mark - Hide HUD Methods

- (void)hideProgress
{
    [self.view hideProgress];
    [[[[UIApplication sharedApplication] delegate] window] hideProgress];
    [self.navigationController.view hideProgress];
}

- (void)hideProgressAfterDelay:(NSTimeInterval)delay
{
    [self.view hideProgressAfterDelay:delay];
    [[[[UIApplication sharedApplication] delegate] window] hideProgressAfterDelay:delay];
    [self.navigationController.view hideProgressAfterDelay:delay];
}

@end
