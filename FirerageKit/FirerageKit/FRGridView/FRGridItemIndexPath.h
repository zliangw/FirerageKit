//
//  FRGridItemIndexPath.h
//  FirerageKit
//
//  Created by Aidian on 14-5-20.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FRGridItemIndexPath : NSObject

@property (nonatomic, assign, readonly) NSUInteger row;
@property (nonatomic, assign, readonly) NSUInteger column;

+ (instancetype)indexPathWithRow:(NSUInteger)row column:(NSUInteger)column;
- (instancetype)initWithRow:(NSUInteger)row column:(NSUInteger)column;

@end
