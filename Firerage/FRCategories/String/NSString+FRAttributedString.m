//
//  NSString+FRAttributedString.m
//  ZAChatKit
//
//  Created by Aidian.Tang on 14-6-29.
//  Copyright (c) 2014年 Aidian.Tang. All rights reserved.
//

#import "NSString+FRAttributedString.h"

@implementation NSString (FRAttributedString)

- (NSMutableAttributedString *)stringWithDefaultColor:(UIColor *)defaultColor foregroundColor:(UIColor *)foregroundColor defaultFont:(UIFont *)defaultFont foregroundFont:(UIFont *)foregroundFont ranges:(NSArray*)ranges
{
    NSMutableAttributedString * tttstring = [[NSMutableAttributedString alloc] initWithString:self];
    
    if (defaultColor) {
        [tttstring addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[defaultColor CGColor] range:NSMakeRange(0,self.length)];
    }
    
    if (defaultFont) {
        CTFontRef deFont = CTFontCreateWithName((CFStringRef)defaultFont.fontName, defaultFont.pointSize, NULL);
        [tttstring addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)deFont range:NSMakeRange(0, self.length)];
    }
    

    CTFontRef foreFont = nil;
    if (foregroundFont) {
        foreFont = CTFontCreateWithName((CFStringRef)foregroundFont.fontName, foregroundFont.pointSize, NULL);
    }
    
    for (NSValue *value in ranges) {
        NSRange range = [value rangeValue];
        if (!NSEqualRanges(range, NSMakeRange(0, 0))) {
            if (foreFont) {
                [tttstring addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)foreFont range:range];
            }
            if (foregroundColor) {
                [tttstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[foregroundColor CGColor] range:range];
            }
        }
    }
    
    if (foreFont) {
        CFRelease(foreFont);
    }
    
    return tttstring;
}

- (NSMutableAttributedString *)createAttributedStringWithDefaultColor:(UIColor *)defaultColor foregroundColor:(UIColor *)foregroundColor range:(NSRange)range defaultFont:(UIFont *)defaultFont
{
    return [self stringWithDefaultColor:defaultColor foregroundColor:foregroundColor defaultFont:defaultFont foregroundFont:nil ranges:[NSArray arrayWithObject:[NSValue valueWithRange:range]]];
}

- (NSMutableAttributedString *)createAttributedStringWithDefaultColor:(UIColor *)defaultColor foregroundColor:(UIColor *)foregroundColor range:(NSRange)range defaultFont:(UIFont *)defaultFont foregroundFont:(UIFont *)foregroundFont
{
    return [self stringWithDefaultColor:defaultColor foregroundColor:foregroundColor defaultFont:defaultFont foregroundFont:foregroundFont ranges:[NSArray arrayWithObject:[NSValue valueWithRange:range]]];
}

- (NSMutableAttributedString *)createAttributedStringWithDefaultColor:(UIColor *)defaultColor foregroundColor:(UIColor *)foregroundColor ranges:(NSArray*)ranges defaultFont:(UIFont *)defaultFont
{
    return [self stringWithDefaultColor:defaultColor foregroundColor:foregroundColor defaultFont:defaultFont foregroundFont:nil ranges:ranges];
}

- (NSMutableAttributedString *)createAttributedStringWithDefaultColor:(UIColor *)defaultColor foregroundColor:(UIColor *)foregroundColor ranges:(NSArray *)ranges defaultFont:(UIFont *)defaultFont foregroundFont:(UIFont *)foregroundFont
{
    return [self stringWithDefaultColor:defaultColor foregroundColor:foregroundColor defaultFont:defaultFont foregroundFont:foregroundFont ranges:ranges];
}

@end
