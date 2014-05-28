//
//  UILabel+FRFitSize.m
//  FirerageKit
//
//  Created by Aidian.Tang on 14-5-26.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "UILabel+FRFitSize.h"
#import "UIView+FRLayout.h"
#import "FRDevice.h"

@implementation UILabel (FRFitSize)

- (void)constrainedToSize:(CGSize)size
{
    [self setNumberOfLines:0];
    self.lineBreakMode = UILineBreakModeWordWrap;
    CGSize labelsize = CGSizeZero;
    //if ([FRDevice getSystemVersionFloatValue] <= 7) {
        [self.text sizeWithFont:self.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
//    } else {
//        [self.text boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine attributes:nil context:nil];
//    }
    self.frame = CGRectMake(self.left, self.top, labelsize.width, labelsize.height);
}

@end
