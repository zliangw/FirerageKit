//
//  NSArray+FRUtils.h
//  Tamatrix
//
//  Created by Aidian on 14/12/10.
//  Copyright (c) 2014年 Winfires. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (FRUtils)

- (NSArray *)filteredWithFormat:(NSString *)format;
- (NSArray *)removeObject:(NSObject *)obj;
- (NSArray *)addObject:(NSObject *)obj;

@end
