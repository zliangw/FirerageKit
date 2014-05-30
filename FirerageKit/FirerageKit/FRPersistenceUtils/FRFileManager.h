//
//  FRFileManager.h
//  FirerageKit
//
//  Created by Aidian.Tang on 14-5-30.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FRFileManager : NSObject

+ (NSString *)documentsDirectory;
+ (NSString *)cachesDirectory;
+ (NSString *)tempDirectory;

+ (BOOL)fileExistsAtPath:(NSString *)path;
+ (NSError *)createDirectoryAtPath:(NSString *)path;
+ (NSError *)deletePath:(NSString *)path;

@end
