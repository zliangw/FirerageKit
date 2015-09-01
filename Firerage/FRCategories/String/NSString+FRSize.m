//
//  NSString+FRSize.m
//  Tamatrix
//
//  Created by Aidian on 14/11/23.
//  Copyright (c) 2014年 Winfires. All rights reserved.
//

#import "NSString+FRSize.h"

@implementation NSString (FRSize)

- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    NSString *versionString = [UIDevice currentDevice].systemVersion;
    CGFloat sysVersion = [versionString floatValue];
    if (sysVersion < 7.0) {
        return [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
    } else {
        CGRect rect = [self boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:@{NSFontAttributeName:font}
                                         context:nil];
        rect.size.width = ceilf(rect.size.width);
        rect.size.height = ceilf(rect.size.height);
        
        return rect.size;
    }
}


- (CGSize)sizeWithFont:(UIFont *)font
{
    NSString *versionString = [UIDevice currentDevice].systemVersion;
    CGFloat sysVersion = [versionString floatValue];
    if (sysVersion < 7.0) {
        return [self sizeWithFont:font];
    }
    else
    {
        return  [self sizeWithAttributes:@{NSFontAttributeName: font}];
    }
}

@end
