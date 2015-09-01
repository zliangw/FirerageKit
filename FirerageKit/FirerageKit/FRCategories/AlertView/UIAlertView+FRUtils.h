//
//  UIAlertView+FRUtils.h
//  FirerageKit
//
//  Created by Aidian.Tang on 14-5-29.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^FRAlertViewConfirmBlock) (UIAlertView *alertView);
typedef void (^FRAlertViewCancelBlock) (UIAlertView *alertView);
typedef void (^FRAlertViewTapBlock) (UIAlertView *alertView, NSInteger tapIndex);

@interface UIAlertView (FRUtils)

@property (copy, nonatomic) FRAlertViewConfirmBlock confirmBlock;
@property (copy, nonatomic) FRAlertViewCancelBlock cancelBlock;
@property (copy, nonatomic) FRAlertViewTapBlock tapBlock;

+ (void)showMessage:(NSString *)message withTitle:(NSString *)title confirmTitle:(NSString *)confirmTitle;
+ (void)showMessage:(NSString *)message withTitle:(NSString *)title confirmTitle:(NSString *)confirmTitle cancelTitle:(NSString *)cancelTitle confirmBlock:(FRAlertViewConfirmBlock)confirmBlock cancelBlock:(FRAlertViewCancelBlock)cancelBlock;
+ (void)showMessage:(NSString *)message withTitle:(NSString *)title cancelTitle:(NSString *)cancelTitle otherTitles:(NSArray *)otherTitles tapBlock:(FRAlertViewTapBlock)tapBlock;

@end
