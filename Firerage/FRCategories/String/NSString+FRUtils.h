//
//  NSString+Utils.h
//  SecretContacts
//
//  Created by Aidian on 14-8-16.
//  Copyright (c) 2014年 Winfires. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utils)

/**
 *  判断是不是数字
 *
 *  @return jude result
 */
- (BOOL)isPureInt;

/**
 *  是否是汉字
 *
 *  @return jude result
 */
- (BOOL)isHanYu;

@end
