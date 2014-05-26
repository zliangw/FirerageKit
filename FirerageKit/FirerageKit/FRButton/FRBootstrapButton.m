//
//  FRBootstrapButton.m
//  FirerageKit
//
//  Created by Aidian.Tang on 14-5-26.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "FRBootstrapButton.h"

@implementation FRBootstrapButton

- (void)setColor:(UIColor *)color
{
    [super setColor:color];
    if (_normalTitleColor) {
        [self setTitleColor:_normalTitleColor forState:UIControlStateNormal];
    }
    if (_highlightedTitleColor) {
        [self setTitleColor:_highlightedTitleColor forState:UIControlStateHighlighted];
    }
}

- (void)setNormalTitleColor:(UIColor *)normalTitleColor
{
    _normalTitleColor = normalTitleColor;
    [self setTitleColor:normalTitleColor forState:UIControlStateNormal];
}

- (void)setHighlightedTitleColor:(UIColor *)highlightedTitleColor
{
    _highlightedTitleColor = highlightedTitleColor;
    [self setTitleColor:highlightedTitleColor forState:UIControlStateHighlighted];
}

@end
