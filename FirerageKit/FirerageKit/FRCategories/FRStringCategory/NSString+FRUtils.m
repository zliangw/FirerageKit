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

+ (NSString *)toLegalString:(NSString *)string
{
    if ([string isKindOfClass:[NSString class]] || !string) {
        string = string;
    } else if ([string isKindOfClass:[NSNull class]]) {
        string = nil;
    } else {
        string = [NSString stringWithFormat:@"%@", string];
    }
    return string;
}

- (NSString *)nullToEmptyString
{
    return [NSString nullToEmptyString:self];
}

- (NSString *)toLegalString
{
    return [NSString toLegalString:self];
}

@end
