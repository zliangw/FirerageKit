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

@end
