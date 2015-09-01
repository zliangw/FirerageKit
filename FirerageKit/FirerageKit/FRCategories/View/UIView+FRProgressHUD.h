//
//  UIView+FRProgressHUD.h
//  FirerageKit
//
//  Created by Aidian on 15/9/1.
//  Copyright (c) 2015年 Illidan.Firerage. All rights reserved.
//

typedef enum {
    /** Progress is shown using an UIActivityIndicatorView. This is the default. */
    FRProgressHUDModeIndeterminate,
    /** Progress is shown using a round, pie-chart like, progress view. */
    FRProgressHUDModeDeterminate,
    /** Progress is shown using a horizontal progress bar */
    FRProgressHUDModeDeterminateHorizontalBar,
    /** Progress is shown using a ring-shaped progress view. */
    FRProgressHUDModeAnnularDeterminate,
    /** Shows a custom view */
    FRProgressHUDModeCustomView,
    /** Shows only labels */
    FRProgressHUDModeText
} FRProgressHUDMode;

#import <UIKit/UIKit.h>

@interface UIView (FRProgressHUD)

@property (nonatomic, copy) NSString *successedHUDImageName;
@property (nonatomic, copy) NSString *failedHUDImageName;

@property (nonatomic, assign) CGFloat hudProgress;

- (void)showProgress;
- (void)showProgressWithLabelText:(NSString *)labelText;
- (void)showProgressWithLabelText:(NSString *)labelText customView:(UIView *)customView;;
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
