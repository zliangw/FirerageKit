//
//  NSString+FRAttributedString.h
//  ZAChatKit
//
//  Created by Aidian.Tang on 14-6-29.
//  Copyright (c) 2014年 Aidian.Tang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import <UIKit/UIKit.h>

@interface NSString (FRAttributedString)

- (NSMutableAttributedString *)createAttributedStringWithDefaultColor:(UIColor *)defaultColor foregroundColor:(UIColor *)foregroundColor range:(NSRange)range defaultFont:(UIFont *)defaultFont;

- (NSMutableAttributedString *)createAttributedStringWithDefaultColor:(UIColor *)defaultColor foregroundColor:(UIColor *)foregroundColor range:(NSRange)range defaultFont:(UIFont *)defaultFont foregroundFont:(UIFont *)foregroundFont;

- (NSMutableAttributedString *)createAttributedStringWithDefaultColor:(UIColor *)defaultColor foregroundColor:(UIColor *)foregroundColor ranges:(NSArray *)ranges defaultFont:(UIFont *)defaultFont;

- (NSMutableAttributedString *)createAttributedStringWithDefaultColor:(UIColor *)defaultColor foregroundColor:(UIColor *)foregroundColor ranges:(NSArray *)ranges defaultFont:(UIFont *)defaultFont foregroundFont:(UIFont *)foregroundFont;

@end
