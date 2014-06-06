//
//  NSString+FRUtils.m
//  FirerageKit
//
//  Created by Aidian.Tang on 14-6-6.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "NSString+FRUtils.h"

@implementation NSString (FRUtils)

+ (NSString *)nullToEmptyString:(NSString *)string
{
    if (!string || [string isKindOfClass:[NSNull class]]) {
        return @"";
    }
    return string;
}

@end
