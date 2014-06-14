//
//  NSDate+FRUtils.m
//  FirerageKit
//
//  Created by Aidian.Tang on 14-6-14.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "NSDate+FRUtils.h"

@implementation NSDate (FRUtils)

+ (FRDate *)formatCurrentDate
{
    return [[self class] formatDate:[NSDate date]];
}

+ (FRDate *)formatDate:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *comps  = [calendar components:unitFlags fromDate:date];
    NSInteger year = [comps year];
    NSInteger month = [comps month];
    NSInteger hour = [comps hour];
    NSInteger min = [comps minute];
    NSInteger sec = [comps second];
    
    FRDate *fDate = [[FRDate alloc] init];
    fDate.year = year;
    fDate.month = month;
    fDate.hour = hour;
    fDate.min = min;
    fDate.sec = sec;
    
    return fDate;
}

+ (NSString *)formatDate:(NSDate *)date localeIdentifier:(NSString *)localeIdentifier dateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:localeIdentifier]];
    [dateFormatter setDateFormat:dateFormat];
    return  [dateFormatter stringFromDate:date];
}

@end
