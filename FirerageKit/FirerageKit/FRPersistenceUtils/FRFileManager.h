//
//  FRFileManager.h
//  FirerageKit
//
//  Created by Aidian.Tang on 14-5-30.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FRFileManager : NSObject

+ (NSDirectoryEnumerator *)enumeratorAthPath:(NSString *)path includingPropertiesForKeys:(NSArray *)resourceKeys;
+ (NSDirectoryEnumerator *)enumeratorAthPath:(NSString *)path;
+ (NSDictionary *)attributesOfItemAtPath:(NSString *)path;

+ (NSString *)documentsDirectory;
+ (NSString *)cachesDirectory;
+ (NSString *)tempDirectory;

+ (BOOL)fileExistsAtPath:(NSString *)path;
+ (NSError *)createDirectoryAtPath:(NSString *)path;
+ (void)createFileAtPath:(NSString *)path data:(NSData *)data;
+ (NSError *)deleteFileAtPath:(NSString *)path;
+ (NSError *)deleteFileAtURL:(NSURL *)fileURL;

@end
