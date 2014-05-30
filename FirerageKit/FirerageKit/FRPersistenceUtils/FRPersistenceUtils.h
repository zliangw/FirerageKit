//
//  FRPersistenceUtils.h
//  FirerageKit
//
//  Created by Aidian.Tang on 14-5-30.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FRFileManager.h"

@interface FRPersistenceUtils : NSObject

+ (NSString *)defaultArchiverPathOfObject:(id)object;

+ (BOOL)archiverObject:(id)object;
+ (id)unArchiverObject:(id)object;

+ (BOOL)archiverObject:(id)object withKey:(NSString *)key path:(NSString *)path;
+ (id)unArchiverWithKey:(NSString *)key path:(NSString *)path;

@end
