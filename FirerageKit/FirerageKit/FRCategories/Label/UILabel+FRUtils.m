//
//  UILabel+FRUtils.m
//  Tamatrix
//
//  Created by Aidian on 14/11/29.
//  Copyright (c) 2014年 Winfires. All rights reserved.
//

#import "UILabel+FRUtils.h"
#import "NSString+FRSize.h"
#import "UIView+FRLayout.h"

@implementation UILabel (FRUtils)

- (void)constrainedToSize:(CGSize)size
{
    self.numberOfLines = 0;
    CGSize curSize = [self.text sizeWithFont:self.font constrainedToSize:size lineBreakMode:self.lineBreakMode];
    if (curSize.width > size.width) {
        curSize = [self sizeThatFits:size];
        if (curSize.height > size.height) {
            curSize.height = size.height;
        }
    }
    
    self.size = curSize;
}

- (void)autoLine
{
    self.numberOfLines = 0;
    [self constrainedToSize:CGSizeMake(self.width, MAXFLOAT)];
}

@end
