//
//  UIViewController+FRCustomNavigationBarItem.m
//  FirerageKit
//
//  Created by Aidian on 14-5-24.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "UIViewController+FRCustomNavigationBarItem.h"
#import <objc/runtime.h>

static const void *FRBackBarButtonItemNormalImageNameKey = &FRBackBarButtonItemNormalImageNameKey;
static const void *FRBackBarButtonItemHighlightedImageNameKey = &FRBackBarButtonItemHighlightedImageNameKey;
static const void *FRBackBarButtonItemTitleKey = &FRBackBarButtonItemTitleKey;

@implementation UIViewController (FRCustomNavigationBarItem)

#pragma mark -
#pragma mark - Setter Getter

- (void)setBackBarButtonItemNormalImageName:(NSString *)backBarButtonItemNormalImageName
{
    objc_setAssociatedObject(self, FRBackBarButtonItemNormalImageNameKey, backBarButtonItemNormalImageName, OBJC_ASSOCIATION_COPY);
}

- (void)setBackBarButtonItemHighlightedImageName:(NSString *)backBarButtonItemHighlightedImageName
{
    objc_setAssociatedObject(self, FRBackBarButtonItemHighlightedImageNameKey, backBarButtonItemHighlightedImageName, OBJC_ASSOCIATION_COPY);
}

- (void)setBackBarButtonItemTitle:(NSString *)backBarButtonItemTitle
{
    objc_setAssociatedObject(self, FRBackBarButtonItemTitleKey, backBarButtonItemTitle, OBJC_ASSOCIATION_COPY);
}

- (NSString *)backBarButtonItemNormalImageName
{
    return objc_getAssociatedObject(self, FRBackBarButtonItemNormalImageNameKey);
}

- (NSString *)backBarButtonItemHighlightedImageName
{
    return objc_getAssociatedObject(self, FRBackBarButtonItemHighlightedImageNameKey);
}

- (NSString *)backBarButtonItemTitle
{
    return objc_getAssociatedObject(self, FRBackBarButtonItemTitleKey);
}

#pragma mark -
#pragma mark - Member

- (void)addIOS7BackBarButtonItemAutomatically
{
    if (self.navigationController.viewControllers.count > 1) {
        [self addIOS7BackBarButtonItemWithTitle:self.backBarButtonItemTitle normalImageName:self.backBarButtonItemNormalImageName highlightedImageName:self.backBarButtonItemHighlightedImageName];
    }
}

- (void)addIOS7BackBarButtonItemWithTitle:(NSString *)title normalImageName:(NSString *)normalImageName highlightedImageName:(NSString *)highlightedImageName
{
    [self addBarButtonItemWithTarget:self title:title normalImageName:normalImageName highlightedImageName:highlightedImageName isLeft:YES selector:@selector(iOS7BackBarButtonItemDidPressed:)];
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.) {
        UIButton *lBtn = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
        lBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        lBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    }
}

- (void)iOS7BackBarButtonItemDidPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addLeftBarButtonItemWithTarget:(id)target title:(NSString *)title normalImageName:(NSString *)normalImageName highlightedImageName:(NSString *)highlightedImageName selector:(SEL)selctor
{
    [self addBarButtonItemWithTarget:self title:title normalImageName:normalImageName highlightedImageName:highlightedImageName isLeft:YES selector:selctor];
}

- (void)addRightBarButtonItemWithTarget:(id)target title:(NSString *)title normalImageName:(NSString *)normalImageName highlightedImageName:(NSString *)highlightedImageName selector:(SEL)selctor
{
    [self addBarButtonItemWithTarget:self title:title normalImageName:normalImageName highlightedImageName:highlightedImageName isLeft:NO selector:selctor];
}

- (void)addBarButtonItemWithTarget:(id)target title:(NSString *)title normalImageName:(NSString *)normalImageName highlightedImageName:(NSString *)highlightedImageName isLeft:(BOOL)isLeft selector:(SEL)selctor
{
    UIButton *rBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rBtn setTitle:title forState:UIControlStateNormal];
    rBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    CGSize titleSize = [title sizeWithFont:rBtn.titleLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, self.navigationController.navigationBar.frame.size.height)];
    CGSize imageSize = CGSizeZero;
    
    UIImage *nImage = [UIImage imageNamed:normalImageName];
    UIImage *hImage = [UIImage imageNamed:highlightedImageName];
    if (nImage) {
        imageSize = nImage.size;
    }
    
    if (normalImageName.length > 0) {
        [rBtn setImage:nImage forState:UIControlStateNormal];
    }
    if (highlightedImageName.length > 0) {
        [rBtn setImage:hImage forState:UIControlStateHighlighted];
    }
    
    rBtn.frame = CGRectMake(0, 0, titleSize.width + imageSize.width, MAX(titleSize.height, imageSize.height));
    
    [rBtn addTarget:self action:selctor forControlEvents:UIControlEventTouchUpInside];
    if (isLeft) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rBtn];
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rBtn];
    }
}

@end
