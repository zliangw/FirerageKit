//
//  UIView+UIImage.m
//  FirerageKit
//
//  Created by Aidian.Tang on 14-5-21.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "UIView+FRImage.h"

@implementation UIView (FRImage)

- (UIImage *)toImage
{
    UIGraphicsBeginImageContext(self.frame.size);
    [[self layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshot;
}

@end
