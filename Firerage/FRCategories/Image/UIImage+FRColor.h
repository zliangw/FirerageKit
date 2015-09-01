//
//  UIImage+FRColor.h
//  FirerageKit
//
//  Created by Aidian.Tang on 14-5-28.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (FRColor)

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size andRoundSize:(CGFloat)roundSize;

- (UIColor *)colorAtPoint:(CGPoint)point;

@end
