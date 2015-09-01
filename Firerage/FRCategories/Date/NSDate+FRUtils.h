//
//  NSDate+FRUtils.h
//  Tamatrix
//
//  Created by Aidian on 14/11/30.
//  Copyright (c) 2014年 Winfires. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    SWDateFormatterTypeDefault,
    SWDateFormatterTypeDay,
    SWDateFormatterTypeHour,
    SWDateFormatterTypeMinute,
    SWDateFormatterTypeMillisecond,
} SWDateFormatterType;

@interface NSDate (FRUtils)

- (NSString *)toStringWithDateFormatterType:(SWDateFormatterType)dateFormatterType;
- (NSString *)toStringWithDateFormatter:(NSDateFormatter *)dateFormatter;
- (NSString *)toTimestampSince1970;

@end
