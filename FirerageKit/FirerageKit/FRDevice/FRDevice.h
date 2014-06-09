//
//  FRDevice.h
//  FirerageKit
//
//  Created by Aidian.Tang on 14-5-26.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRDevice : UIDevice

+ (CGFloat)getSystemVersionFloatValue;

+ (BOOL)isRetinaSupported;

@end
