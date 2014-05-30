//
//  FRPersistenceUtils.m
//  FirerageKit
//
//  Created by Aidian.Tang on 14-5-30.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "FRPersistenceUtils.h"

@implementation FRPersistenceUtils

+ (NSString *)defaultArchiverPathOfObject:(id)object
{
    return [[FRFileManager documentsDirectory] stringByAppendingPathComponent:NSStringFromClass([object class])];
}

+ (BOOL)archiverObject:(id)object
{
    BOOL result = NO;
    NSString *path = [[self class] defaultArchiverPathOfObject:object];
    NSError *error = [FRFileManager createDirectoryAtPath:path];
    if (!error) {
        result = [FRPersistenceUtils archiverObject:object withKey:NSStringFromClass([object class]) path:path];
    }
    return result;
}

+ (id)unArchiverObject:(id)object
{
    NSString *path = [[self class] defaultArchiverPathOfObject:object];
    return [FRPersistenceUtils unArchiverWithKey:NSStringFromClass([object class]) path:path];
}

+ (BOOL)archiverObject:(id)object withKey:(NSString *)key path:(NSString *)path
{
    BOOL result = NO;
    if (object && key.length > 0 && path.length > 0) {
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:object forKey:key];
        [archiver finishEncoding];
        result = [data writeToFile:path atomically:YES];
    }
    return result;
}

+ (id)unArchiverWithKey:(NSString *)key path:(NSString *)path
{
    id object = nil;
    if (key.length > 0 && path.length > 0) {
        NSData *data = [[NSMutableData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        object = [unarchiver decodeObjectForKey:key] ;
        [unarchiver finishDecoding];
    }
    return object;
}

@end
