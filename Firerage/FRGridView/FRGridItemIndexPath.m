//
//  FRGridItemIndexPath.m
//  FirerageKit
//
//  Created by Aidian on 14-5-20.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "FRGridItemIndexPath.h"

@interface FRGridItemIndexPath ()

@property (nonatomic, assign, readwrite) NSUInteger row;
@property (nonatomic, assign, readwrite) NSUInteger column;

@end

@implementation FRGridItemIndexPath

+ (instancetype)indexPathWithRow:(NSUInteger)row column:(NSUInteger)column
{
    FRGridItemIndexPath *gridItemIndexPath = [[FRGridItemIndexPath alloc] initWithRow:row column:column];
    
    return gridItemIndexPath;
}

- (instancetype)initWithRow:(NSUInteger)row column:(NSUInteger)column
{
    self = [super init];
    if (self) {
        self.row = row;
        self.column = column;
    }
    return self;
}

@end
