//
//  NSString+FRSize.h
//  Tamatrix
//
//  Created by Aidian on 14/11/23.
//  Copyright (c) 2014年 Winfires. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (FRSize)

- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;

- (CGSize)sizeWithFont:(UIFont *)font;

@end
