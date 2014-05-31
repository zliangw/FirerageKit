//
//  FRUser.m
//  FirerageKit
//
//  Created by Aidian on 14-5-31.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "FRUser.h"

@implementation FRUser

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeBool:_sex forKey:@"sex"];
    [coder encodeObject:_name forKey:@"name"];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.sex = [coder decodeBoolForKey:@"sex"];
        self.name = [coder decodeObjectForKey:@"name"];
    }
    return self;
}

@end
