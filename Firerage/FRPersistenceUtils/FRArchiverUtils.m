//
//  FRPersistenceUtils.m
//  FirerageKit
//
//  Created by Aidian.Tang on 14-5-30.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "FRArchiverUtils.h"

@implementation FRArchiverUtils

+ (NSString *)defaultArchiverDirectoryOfObject:(Class)objectClass
{
    return [[FRFileManager documentsDirectory] stringByAppendingPathComponent:NSStringFromClass(objectClass)];
}

+ (NSString *)defaultArchiverFileNameOfObject:(Class)objectClass
{
    return [[[self class] defaultArchiverDirectoryOfObject:objectClass] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.archiver", NSStringFromClass(objectClass)]];
}

+ (NSString *)defaultArchiverKeyOfObject:(Class)objectClass
{
    return NSStringFromClass(objectClass);
}

+ (NSError *)archiveObject:(id)object
{
    NSError *error = nil;
    Class objectClass = [object class];
    
    NSString *directoryPath = [[self class] defaultArchiverDirectoryOfObject:objectClass];
    error = [FRFileManager createDirectoryAtPath:directoryPath];
    
    if (!error) {
        NSString *fileName = [[self class] defaultArchiverFileNameOfObject:objectClass];
        NSString *key = [[self class] defaultArchiverKeyOfObject:[object class]];
        error = [FRArchiverUtils archiveObject:object withKey:key fileName:fileName];
    }
    
    return error;
}

+ (id)unArchiveObjectByClass:(Class)objClass
{
    NSString *fileName = [[self class] defaultArchiverFileNameOfObject:objClass];
    NSString *key = [[self class] defaultArchiverKeyOfObject:objClass];
    return [FRArchiverUtils unArchiveWithKey:key fileName:fileName];
}

+ (NSError *)archiveObject:(id)object withKey:(NSString *)key fileName:(NSString *)fileName
{
    NSError *error = nil;
    if (object && key.length > 0 && fileName.length > 0) {
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:object forKey:key];
        [archiver finishEncoding];
        [data writeToFile:fileName options:NSDataWritingAtomic error:&error];
    }
    return error;
}

+ (id)unArchiveWithKey:(NSString *)key fileName:(NSString *)fileName
{
    id object = nil;
    if (key.length > 0 && fileName.length > 0) {
        NSData *data = [[NSMutableData alloc] initWithContentsOfFile:fileName];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        object = [unarchiver decodeObjectForKey:key] ;
        [unarchiver finishDecoding];
    }
    return object;
}

@end
