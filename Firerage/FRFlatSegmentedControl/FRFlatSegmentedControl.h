//
//  FRFlatSegmentedControl.h
//  FirerageKit
//
//  Created by Aidian.Tang on 14-5-28.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "AKSegmentedControl.h"

@interface FRFlatSegmentedControl : AKSegmentedControl

@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign, readonly) NSInteger selectedIndex;
@property (nonatomic, strong) NSArray *itemTitles; // items must be NSStrings
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) UIColor *itemTitleNormalColor;
@property (nonatomic, strong) UIColor *itemTitleSelectedColor;
@property (nonatomic, strong) UIFont *itemTitleFont;

@end
