//
//  UIViewController+FRProgressHUD.h
//  FirerageKit
//
//  Created by Aidian on 14-6-2.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+FRProgressHUD.h"

@interface UIViewController (FRProgressHUD)

- (void)showProgress;
- (void)showProgressWithLabelText:(NSString *)labelText;
- (void)showProgressWithLabelText:(NSString *)labelText customView:(UIView *)customView;;
- (void)showProgressOnNavigationWithLabelText:(NSString *)labelText;
- (void)showProgressOnWindowWithLabelText:(NSString *)labelText;
- (void)showBarProgress;
- (void)changeProgressStateWithMode:(FRProgressHUDMode)hudMode labelText:(NSString *)labelText customView:(UIView *)customView;

- (void)hideProgress;
- (void)hideProgressAfterDelay:(NSTimeInterval)delay;

- (void)showToast:(NSString *)toast;
- (void)showToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay;
- (void)showToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay withCustomView:(UIView *)customView;
- (void)showSuccessedToast:(NSString *)toast;
- (void)showfailedToast:(NSString *)toast;
- (void)showSuccessedToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay;
- (void)showfailedToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay;

@end
