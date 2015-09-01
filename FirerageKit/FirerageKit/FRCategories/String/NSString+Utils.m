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

@end
