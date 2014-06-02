//
//  NSObject+FRBlock.m
//  FirerageKit
//
//  Created by Aidian on 14-6-2.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "NSObject+FRBlock.h"

@implementation NSObject (FRBlock)

- (void)performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}

@end
