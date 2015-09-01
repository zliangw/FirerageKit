//
//  FRDevice.m
//  FirerageKit
//
//  Created by Aidian.Tang on 14-5-26.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "FRDevice.h"

@implementation FRDevice

+ (CGFloat)getSystemVersionFloatValue
{
    return [FRDevice currentDevice].systemVersion.floatValue;
}

+ (BOOL)isRetinaSupported
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) {
        return YES;
    }
    return NO;
}

@end
