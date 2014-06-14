//
//  NSDate+FRUtils.h
//  FirerageKit
//
//  Created by Aidian.Tang on 14-6-14.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FRDate.h"

@interface NSDate (FRUtils)

+ (FRDate *)formatCurrentDate;

+ (FRDate *)formatDate:(NSDate *)date;

+ (NSString *)formatDate:(NSDate *)date localeIdentifier:(NSString *)localeIdentifier dateFormat:(NSString *)dateFormat;

@end
