//
//  UIViewController+FRCustomNavigationBarItem.m
//  FirerageKit
//
//  Created by Aidian on 14-5-24.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "UIViewController+FRCustomNavigationBarItem.h"

@implementation UIViewController (FRCustomNavigationBarItem)

- (void)addIOS7BackLeftBarButtonItem
{
    [self addBarButtonItemWithTarget:self normalImageName:@"zt_webview_left" highlightedImageName:nil isLeft:YES selector:@selector(leftBtnDidPressed:)];
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.) {
        UIButton *lBtn = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
        lBtn.imageEdgeInsets  = UIEdgeInsetsMake(0, -20, 0, 0);
    }
}

- (void)leftBtnDidPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addLeftBarButtonItemWithTarget:(id)target normalImageName:(NSString *)normalImageName highlightedImageName:(NSString *)highlightedImageName selector:(SEL)selctor
{
    [self addBarButtonItemWithTarget:self normalImageName:@"back.png" highlightedImageName:@"backHilighted.png" isLeft:YES selector:selctor];
}

- (void)addRightBarButtonItemWithTarget:(id)target normalImageName:(NSString *)normalImageName highlightedImageName:(NSString *)highlightedImageName selector:(SEL)selctor
{
    [self addBarButtonItemWithTarget:self normalImageName:@"back.png" highlightedImageName:@"backHilighted.png" isLeft:NO selector:selctor];
}

- (void)addBarButtonItemWithTarget:(id)target normalImageName:(NSString *)normalImageName highlightedImageName:(NSString *)highlightedImageName isLeft:(BOOL)isLeft selector:(SEL)selctor
{
    UIButton *rBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rBtn.frame = CGRectMake(0, 0, 40, 40);
    if (normalImageName.length > 0) {
        [rBtn setImage:[UIImage imageNamed:normalImageName] forState:UIControlStateNormal];
    }
    if (highlightedImageName.length > 0) {
        [rBtn setImage:[UIImage imageNamed:highlightedImageName] forState:UIControlStateHighlighted];
    }
    [rBtn addTarget:self action:selctor forControlEvents:UIControlEventTouchUpInside];
    if (isLeft) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rBtn];
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rBtn];
    }
}

@end
