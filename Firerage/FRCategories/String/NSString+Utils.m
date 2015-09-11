//
//  NSString+Utils.m
//  SecretContacts
//
//  Created by Aidian on 14-8-16.
//  Copyright (c) 2014年 Winfires. All rights reserved.
//

#import "NSString+Utils.h"

@implementation NSString (Utils)

- (BOOL)isPureInt
{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

- (BOOL)isHanYu
{
    BOOL isHanYu = NO;
    
    for (NSInteger index = 0; index < self.length; index++) {
        unichar c = [self characterAtIndex:index];
        if (c >= 0x4E00 && c <= 0x9FFF) {
            isHanYu = YES;
            break;
        }
    }
    
    return isHanYu;
}

@end
