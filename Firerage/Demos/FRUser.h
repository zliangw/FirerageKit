//
//  FRUser.h
//  FirerageKit
//
//  Created by Aidian on 14-5-31.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    test1
}Test;

@interface FRUser : NSObject <NSCoding>

@property (nonatomic, assign) BOOL sex;
@property (nonatomic, assign) int sex2;
@property (nonatomic, assign) NSInteger sex3;
@property (nonatomic, assign) NSUInteger sex4;
@property (nonatomic, assign) CGFloat sex5;
@property (nonatomic, assign) double sex6;
@property (nonatomic, assign) Test test;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *name2;

@property (nonatomic, assign) long memberId;
@property (nonatomic, assign) long memberId2;
@property (nonatomic, assign) long memberId12;

@property (nonatomic, assign) id sexxx;
@property (nonatomic, assign) NSTimeInterval sexx2x;

@property (nonatomic, strong) NSArray *memberIds;

@end
