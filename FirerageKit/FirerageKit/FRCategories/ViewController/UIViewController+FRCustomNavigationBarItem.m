//
//  UIViewController+FRCustomNavigationBarItem.m
//  FirerageKit
//
//  Created by Aidian on 14-5-24.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "UIViewController+FRCustomNavigationBarItem.h"
#import <objc/runtime.h>
#import "UIImage+FRTint.h"

@implementation ZABarButtonItem

+ (instancetype)barButtonItemWithTarget:(id)target title:(NSString *)title normalImageName:(NSString *)normalImageName highlightedImageName:(NSString *)highlightedImageName selector:(SEL)selector
{
    ZABarButtonItem *barButtonItem = [[ZABarButtonItem alloc] init];
    barButtonItem.target = target;
    barButtonItem.title = title;
    barButtonItem.normalImageName = normalImageName;
    barButtonItem.highlightedImageName = highlightedImageName;
    barButtonItem.selector = selector;
    
    return barButtonItem;
}

@end

static const void *FRBackBarButtonItemNormalImageNameKey = &FRBackBarButtonItemNormalImageNameKey;
static const void *FRBackBarButtonItemHighlightedImageNameKey = &FRBackBarButtonItemHighlightedImageNameKey;
static const void *FRBackBarButtonItemTitleKey = &FRBackBarButtonItemTitleKey;

@implementation UIViewController (FRCustomNavigationBarItem)

- (UIBarButtonItem *)createBarButtonItemWithTarget:(id)target title:(NSString *)title normalImageName:(NSString *)normalImageName highlightedImageName:(NSString *)highlightedImageName isLeft:(BOOL)isLeft selector:(SEL)selctor
{
    UIButton *rBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rBtn setTitle:title forState:UIControlStateNormal];
    [rBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [rBtn.titleLabel setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:16]];
    
    CGSize titleSize = [title sizeWithFont:rBtn.titleLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, self.navigationController.navigationBar.frame.size.height)];
    CGSize imageSize = CGSizeZero;
    
    UIImage *nImage = [UIImage imageNamed:normalImageName];
    UIImage *hImage = [UIImage imageNamed:highlightedImageName];
    if (nImage) {
        imageSize = nImage.size;
        
        if (hImage == nil) {
            hImage = [nImage imageWithTintColor:[UIColor lightGrayColor]];
        }
    }
    
    [rBtn setImage:nImage forState:UIControlStateNormal];
    [rBtn setImage:hImage forState:UIControlStateHighlighted];

    rBtn.frame = CGRectMake(0, 0, titleSize.width + imageSize.width + 22, MAX(titleSize.height, imageSize.height));
    
    [rBtn addTarget:self action:selctor forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:rBtn];
}


- (UIBarButtonItem *)createBarButtonItemWithTitle:(NSString *)title normalImageName:(NSString *)normalImageName highlightedImageName:(NSString *)highlightedImageName isLeft:(BOOL)isLeft btnClicked:(void(^)())btnClicked;
{
    UIButton *rBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rBtn setTitle:title forState:UIControlStateNormal];
    [rBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [rBtn.titleLabel setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:16]];
    
    CGSize titleSize = [title sizeWithFont:rBtn.titleLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, self.navigationController.navigationBar.frame.size.height)];
    CGSize imageSize = CGSizeZero;
    
    UIImage *nImage = [UIImage imageNamed:normalImageName];
    UIImage *hImage = [UIImage imageNamed:highlightedImageName];
    if (nImage) {
        imageSize = nImage.size;
        
        if (hImage == nil) {
            hImage = [nImage imageWithTintColor:[UIColor lightGrayColor]];
        }
    }
    
    [rBtn setImage:nImage forState:UIControlStateNormal];
    [rBtn setImage:hImage forState:UIControlStateHighlighted];
    
    rBtn.frame = CGRectMake(0, 0, titleSize.width + imageSize.width + 22, MAX(titleSize.height, imageSize.height));
    
    [rBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        if (btnClicked) {
            btnClicked();
        }
    }];
    
    return [[UIBarButtonItem alloc] initWithCustomView:rBtn];
}


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

- (void)addIOS7BackBarButtonItemAutomaticallyWithBack:(void(^)())back{
    if (self.navigationController.viewControllers.count > 1) {
        
        [self addIOS7BackBarButtonItemWithTitle:self.backBarButtonItemTitle normalImageName:self.backBarButtonItemNormalImageName highlightedImageName:self.backBarButtonItemHighlightedImageName btnClicked:^{
            if (back) {
                back();
            }
        }];
        
    }
}


- (void)addIOS7BackBarButtonItemWithTitle:(NSString *)title normalImageName:(NSString *)normalImageName highlightedImageName:(NSString *)highlightedImageName
{
    [self addBarButtonItemWithTarget:self title:title normalImageName:normalImageName highlightedImageName:highlightedImageName isLeft:YES selector:@selector(iOS7BackBarButtonItemDidPressed:)];
    UIButton *lBtn = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
    [lBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.) {
        UIButton *lBtn = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
        lBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -11, 0, +11.0f);
        lBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, -2);
    }
}

- (void)addIOS7BackBarButtonItemWithTitle:(NSString *)title normalImageName:(NSString *)normalImageName highlightedImageName:(NSString *)highlightedImageName btnClicked:(void(^)())btnClicked
{
    [self addBarButtonItemWithTitle:title normalImageName:normalImageName highlightedImageName:highlightedImageName isLeft:YES btnClicked:^{
        if (btnClicked) {
            btnClicked();
        }
    }];
    UIButton *lBtn = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
    [lBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.) {
        UIButton *lBtn = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
        lBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -11, 0, +11.0f);
        lBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, -2);
    }
}

- (void)iOS7BackBarButtonItemDidPressedCallBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    UIBarButtonItem *barButtonItem = [self createBarButtonItemWithTarget:target title:title normalImageName:normalImageName highlightedImageName:highlightedImageName isLeft:isLeft selector:selctor];
    
    if (isLeft) {
        self.navigationItem.leftBarButtonItem = barButtonItem;
    } else {
        self.navigationItem.rightBarButtonItem = barButtonItem;
    }
}

- (void)addBarButtonItemWithTitle:(NSString *)title normalImageName:(NSString *)normalImageName highlightedImageName:(NSString *)highlightedImageName isLeft:(BOOL)isLeft btnClicked:(void(^)())btnClicked;
{
    UIBarButtonItem *barButtonItem = [self createBarButtonItemWithTitle:title normalImageName:normalImageName highlightedImageName:highlightedImageName isLeft:isLeft btnClicked:btnClicked];
    
    if (isLeft) {
        self.navigationItem.leftBarButtonItem = barButtonItem;
    } else {
        self.navigationItem.rightBarButtonItem = barButtonItem;
    }
}


- (void)addLeftBarButtonItems:(NSArray *)barButtonItems
{
    NSMutableArray *barItems = [NSMutableArray array];
    for (ZABarButtonItem *item in barButtonItems) {
        UIBarButtonItem *barButtonItem = [self createBarButtonItemWithTarget:item.target title:item.title normalImageName:item.normalImageName highlightedImageName:item.highlightedImageName isLeft:YES selector:item.selector];
        [barItems addObject:barButtonItem];
    }
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithArray:barItems];
}

@end
