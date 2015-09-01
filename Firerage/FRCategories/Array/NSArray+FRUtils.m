//
//  NSArray+FRUtils.m
//  Tamatrix
//
//  Created by Aidian on 14/12/10.
//  Copyright (c) 2014年 Winfires. All rights reserved.
//

#import "NSArray+FRUtils.h"

@implementation NSArray (FRUtils)

- (NSArray *)filteredWithFormat:(NSString *)format
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:format];
    return [self filteredArrayUsingPredicate:pre];
}

- (NSArray *)removeObject:(NSObject *)obj
{
    if (obj == nil || self.count == 0) {
        return [NSMutableArray arrayWithArray:self];
    }
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self];
    [arr removeObject:obj];
    return [NSArray arrayWithArray:arr];
}

- (NSArray *)addObject:(NSObject *)obj{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self];
    [arr addObject:obj];
    return [NSArray arrayWithArray:arr];
}

@end
