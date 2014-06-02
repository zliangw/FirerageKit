//
//  NSObject+FRBlock.h
//  FirerageKit
//
//  Created by Aidian on 14-6-2.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (FRBlock)

- (void)performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay;

@end
