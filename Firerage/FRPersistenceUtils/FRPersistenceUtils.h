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

+ (NSString *)defaultArchiverDirectoryOfObject:(Class)objectClass;
+ (NSString *)defaultArchiverFileNameOfObject:(Class)objectClass;
+ (NSString *)defaultArchiverKeyOfObject:(Class)objectClass;

+ (NSError *)archiveObject:(id)object;
+ (id)unArchiveObjectByClass:(Class)objectClass;

+ (NSError *)archiveObject:(id)object withKey:(NSString *)key fileName:(NSString *)fileName;
+ (id)unArchiveWithKey:(NSString *)key fileName:(NSString *)fileName;

@end
