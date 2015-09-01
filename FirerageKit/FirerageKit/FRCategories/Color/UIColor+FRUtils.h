//
//  UIColor+FRUtils.h
//  FirerageKit
//
//  Created by Aidian.Tang on 14-5-29.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (FRUtils)

+ (UIColor *)colorWith256Red:(NSInteger)r green:(NSInteger)g blue:(NSInteger)b;
+ (UIColor *)colorWith256Red:(NSInteger)r green:(NSInteger)g blue:(NSInteger)b alpha:(NSInteger)a;
+ (UIColor *)colorWithRGBA:(uint) hex;
+ (UIColor *)colorWithARGB:(uint) hex;
+ (UIColor *)colorWithRGB:(uint) hex;
+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity;
- (NSString *)hexString;
- (UIColor*)colorBrighterByPercent:(float) percent;
- (UIColor*)colorDarkerByPercent:(float) percent;

@property (nonatomic, readonly) CGFloat r;
@property (nonatomic, readonly) CGFloat g;
@property (nonatomic, readonly) CGFloat b;
@property (nonatomic, readonly) CGFloat a;

@end
