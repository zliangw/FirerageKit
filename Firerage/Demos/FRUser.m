//
//  FRUser.m
//  FirerageKit
//
//  Created by Aidian on 14-5-31.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "FRUser.h"
#import "MJExtension.h"

@implementation FRUser

- (void)encodeWithCoder:(NSCoder *)coder
{
//    [coder encodeBool:_sex forKey:@"sex"];
//    [coder encodeObject:_name forKey:@"name"];
    [self encode:coder];
    
//    [coder encodeInt:self.memberId3 forKey:@"memberId3"];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
//        self.sex = [coder decodeBoolForKey:@"sex"];
//        self.name = [coder decodeObjectForKey:@"name"];
        [self decode:coder];
//        self.memberId3 = [coder decodeIntForKey:@"memberId3"];
    }
    return self;
}

//-(void)setNilValueForKey:(NSString *)key
//{
//    if ([key isEqualToString:@"memberId2"]) {
//        [self setValue:@0 forKey:key];
//    }
//    else
//    {
//        [super setNilValueForKey:key];
//    }
//}

@end
