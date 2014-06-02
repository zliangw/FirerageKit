//
//  UIViewController+FRProgressHUD.h
//  FirerageKit
//
//  Created by Aidian on 14-6-2.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import <UIKit/UIKit.h>

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

@interface UIViewController (FRProgressHUD)

@property (nonatomic, copy) NSString *successedHUDImageName;
@property (nonatomic, copy) NSString *failedHUDImageName;

- (void)showProgressWithLabelText:(NSString *)labelText;
- (void)showProgressWithLabelText:(NSString *)labelText customView:(UIView *)customView;;
- (void)showProgressOnNavigationWithLabelText:(NSString *)labelText;
- (void)showProgressOnWindowWithLabelText:(NSString *)labelText;
- (void)changeProgressStateWithMode:(FRProgressHUDMode)hudMode labelText:(NSString *)labelText customView:(UIView *)customView;

- (void)hideProgress;
- (void)hideProgressAfterDelay:(NSTimeInterval)delay;

- (void)showToast:(NSString *)toast;
- (void)showToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay;
- (void)showToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay withCustomView:(UIView *)customView;
- (void)showSuccessedToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay;
- (void)showfailedToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay;

@end
