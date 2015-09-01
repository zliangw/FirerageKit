//
//  NSDate+FRUtils.m
//  Tamatrix
//
//  Created by Aidian on 14/11/30.
//  Copyright (c) 2014年 Winfires. All rights reserved.
//

#import "NSDate+FRUtils.h"

@implementation NSDate (FRUtils)

- (NSString *)toStringWithDateFormatterType:(SWDateFormatterType)dateFormatterType
{
    NSString *dateFormatterStr = nil;
    switch (dateFormatterType) {
        case SWDateFormatterTypeDefault:
            dateFormatterStr = [NSString stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
            break;
        case SWDateFormatterTypeDay:
            dateFormatterStr = [NSString stringWithFormat:@"yyyy-MM-dd"];
            break;
        case SWDateFormatterTypeHour:
            dateFormatterStr = [NSString stringWithFormat:@"yyyy-MM-dd HH"];
            break;
        case SWDateFormatterTypeMinute:
            dateFormatterStr = [NSString stringWithFormat:@"yyyy-MM-dd HH:mm"];
            break;
        case SWDateFormatterTypeMillisecond:
            dateFormatterStr = [NSString stringWithFormat:@"yyyy-MM-dd HH:mm:ss.FFF"];
            break;
        default:
            break;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormatterStr];
    
    return [self toStringWithDateFormatter:dateFormatter];
}

- (NSString *)toStringWithDateFormatter:(NSDateFormatter *)dateFormatter
{
    return [dateFormatter stringFromDate:self];
}

- (NSString *)toTimestampSince1970
{
    NSTimeInterval timeInterval = [self timeIntervalSince1970];
    NSNumber *timeNum = [NSNumber numberWithDouble:timeInterval];
    return [timeNum stringValue];
}

@end
