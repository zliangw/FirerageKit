//
//  FRFileManager.m
//  FirerageKit
//
//  Created by Aidian.Tang on 14-5-30.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "FRFileManager.h"

@implementation FRFileManager

+ (NSDirectoryEnumerator *)enumeratorAthPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *fileEnumerator = [fileManager enumeratorAtPath:path];
    return fileEnumerator;
}

+ (NSDirectoryEnumerator *)enumeratorAthPath:(NSString *)path  includingPropertiesForKeys:(NSArray *)resourceKeys
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *diskCacheURL = [NSURL fileURLWithPath:path isDirectory:YES];
    
    NSDirectoryEnumerator *fileEnumerator = [fileManager enumeratorAtURL:diskCacheURL
       includingPropertiesForKeys:resourceKeys
                          options:NSDirectoryEnumerationSkipsHiddenFiles
                     errorHandler:NULL];
    
    return fileEnumerator;
}

+ (NSDictionary *)attributesOfItemAtPath:(NSString *)path
{
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    return attrs;
}

+ (NSString *)documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

+ (NSString *)cachesDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    return cachesDir;
}

+ (NSString *)tempDirectory
{
    return NSTemporaryDirectory();
}

+ (BOOL)fileExistsAtPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:path];
}

+ (NSError *)createDirectoryAtPath:(NSString *)path
{
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![[self class] fileExistsAtPath:path])
    {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    }
    return error;
}

+ (void)createFileAtPath:(NSString *)path data:(NSData *)data
{
    if (path.length == 0 || !data) {
        return;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createFileAtPath:path contents:data attributes:nil];
}

+ (NSError *)deleteFileAtPath:(NSString *)path
{
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:path error:&error];
    return error;
}

+ (NSError *)deleteFileAtURL:(NSURL *)fileURL
{
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtURL:fileURL error:&error];
    return error;
}

@end
