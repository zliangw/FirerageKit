//
//  FRFileCache.m
//  FirerageKit
//
//  Created by Aidian on 14-6-28.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "FRFileCache.h"
#import "FRFileManager.h"
#import <CommonCrypto/CommonDigest.h>

static const NSInteger kDefaultCacheMaxCacheAge = 60 * 60 * 24 * 7; // 1 week

@interface FRFileCache ()

@property (strong, nonatomic) NSCache *memCache;
@property (strong, nonatomic) NSString *diskCachePath;
@property (strong, nonatomic) NSMutableArray *customPaths;
@property (FRDispatchQueueSetterSementics, nonatomic) dispatch_queue_t ioQueue;

@end

@implementation FRFileCache

+ (FRFileCache *)sharedFileCache
{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [[self new] initWithNamespace:@"default"];
    });
    return instance;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    FRDispatchQueueRelease(_ioQueue);
}

- (id)initWithNamespace:(NSString *)ns {
    if ((self = [super init])) {
        NSString *fullNamespace = [@"com.illidan.firerage.FRFileCache." stringByAppendingString:ns];
        
        // Create IO serial queue
        _ioQueue = dispatch_queue_create("com.illidan.firerage.FRFileCache", DISPATCH_QUEUE_SERIAL);
        
        // Init default values
        _maxCacheAge = kDefaultCacheMaxCacheAge;
        
        // Init the memory cache
        _memCache = [[NSCache alloc] init];
        _memCache.name = fullNamespace;
        
        // Init the disk cache
        NSString *cachesDirectory = [FRFileManager cachesDirectory];
        _diskCachePath = [cachesDirectory stringByAppendingPathComponent:fullNamespace];
        
#if TARGET_OS_IPHONE
        // Subscribe to app events
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearMemory)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(cleanDisk)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(backgroundCleanDisk)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
#endif
    }
    
    return self;
}

#pragma mark -
#pragma mark - Observer Methods

- (void)backgroundCleanDisk {
    UIApplication *application = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        // Clean up any unfinished task business by marking where you
        // stopped or ending the task outright.
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    // Start the long-running task and return immediately.
    [self cleanDiskWithCompletionBlock:^{
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
}

#pragma mark -
#pragma mark - Setter Getter

- (void)setMaxMemoryCost:(NSUInteger)maxMemoryCost {
    self.memCache.totalCostLimit = maxMemoryCost;
}

- (NSUInteger)maxMemoryCost {
    return self.memCache.totalCostLimit;
}

#pragma mark -
#pragma mark - Member Methods Cache Path

- (BOOL)diskFileExistsWithKey:(NSString *)key
{
    __block BOOL exists = NO;
    dispatch_sync(_ioQueue, ^{
        exists = [FRFileManager fileExistsAtPath:[self defaultCachePathForKey:key]];
    });
    
    return exists;
}

- (void)addReadOnlyCachePath:(NSString *)path {
    if (!self.customPaths) {
        self.customPaths = [NSMutableArray new];
    }
    
    if (![self.customPaths containsObject:path]) {
        [self.customPaths addObject:path];
    }
}

#pragma mark -
#pragma mark - Private Methods

- (NSString *)cachePathForKey:(NSString *)key inPath:(NSString *)path {
    NSString *filename = [self cachedFileNameForKey:key];
    return [path stringByAppendingPathComponent:filename];
}

- (NSString *)defaultCachePathForKey:(NSString *)key {
    return [self cachePathForKey:key inPath:self.diskCachePath];
}

- (NSString *)cachedFileNameForKey:(NSString *)key {
    const char *str = [key UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return filename;
}

- (NSData *)diskFileBySearchingAllPathsForKey:(NSString *)key {
    NSString *defaultPath = [self defaultCachePathForKey:key];
    NSData *data = [NSData dataWithContentsOfFile:defaultPath];
    if (data) {
        return data;
    }
    
    for (NSString *path in self.customPaths) {
        NSString *filePath = [self cachePathForKey:key inPath:path];
        NSData *file = [NSData dataWithContentsOfFile:filePath];
        if (file) {
            return file;
        }
    }
    
    return nil;
}

- (NSData *)diskFileForKey:(NSString *)key {
    NSData *data = [self diskFileBySearchingAllPathsForKey:key];
    return data;
}

#pragma mark -
#pragma mark - Member Method Store

- (void)storeFile:(NSData *)file forKey:(NSString *)key toDisk:(BOOL)toDisk {
    if (!file || !key) {
        return;
    }
    
    [self.memCache setObject:file forKey:key cost:file.length];
    
    if (toDisk) {
        dispatch_async(self.ioQueue, ^{
            if (file) {
                NSError *error = nil;
                if (![FRFileManager fileExistsAtPath:_diskCachePath]) {
                    error = [FRFileManager createDirectoryAtPath:_diskCachePath];
                }
                if (!error) {
                    [FRFileManager createFileAtPath:[self defaultCachePathForKey:key] data:file];
                }
            }
        });
    }
}

- (void)storeFile:(NSData *)file forKey:(NSString *)key {
    [self storeFile:file forKey:key toDisk:YES];
}

#pragma mark -
#pragma mark - Member Method Query

- (NSOperation *)queryDiskCacheForKey:(NSString *)key done:(FRFileQueryCompletedBlock)doneBlock
{
    NSOperation *operation = [NSOperation new];
    
    if (!doneBlock) return nil;
    
    if (!key) {
        doneBlock(nil, FRFileCacheTypeNone);
        return nil;
    }
    
    // First check the in-memory cache...
    NSData *file = [self fileFromMemoryCacheForKey:key];
    if (file) {
        doneBlock(file, FRFileCacheTypeMemory);
        return nil;
    }
    
    dispatch_async(self.ioQueue, ^{
        if (operation.isCancelled) {
            return;
        }
        
        @autoreleasepool {
            NSData *diskFile = [self diskFileForKey:key];
            if (diskFile) {
                [self.memCache setObject:diskFile forKey:key cost:file.length];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                doneBlock(diskFile, FRFileCacheTypeDisk);
            });
        }
    });
    
    return operation;
}

- (NSData *)fileFromMemoryCacheForKey:(NSString *)key
{
    return [self.memCache objectForKey:key];
}

- (NSData *)fileFromDiskCacheForKey:(NSString *)key
{
    // First check the in-memory cache...
    NSData *file = [self fileFromMemoryCacheForKey:key];
    if (file) {
        return file;
    }
    
    // Second check the disk cache...
    NSData *diskFile = [self diskFileForKey:key];
    if (diskFile) {
        [self.memCache setObject:diskFile forKey:key cost:file.length];
    }
    
    return diskFile;
}

#pragma mark -
#pragma mark - Member Method Delete

- (void)deleteFileForKey:(NSString *)key
{
    [self deleteFileForKey:key fromDisk:YES];
}

- (void)deleteFileForKey:(NSString *)key fromDisk:(BOOL)fromDisk
{
    if (key == nil) {
        return;
    }
    
    [self.memCache removeObjectForKey:key];
    
    if (fromDisk) {
        dispatch_async(self.ioQueue, ^{
            [FRFileManager deleteFileAtPath:[self defaultCachePathForKey:key]];
        });
    }
}

- (void)clearMemory {
    [self.memCache removeAllObjects];
}

- (void)clearDiskOnCompletion:(void (^)())completion
{
    dispatch_async(self.ioQueue, ^{
        [FRFileManager deleteFileAtPath:self.diskCachePath];
        [FRFileManager createDirectoryAtPath:self.diskCachePath];
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion();
            });
        }
    });
}

- (void)clearDisk {
    [self clearDiskOnCompletion:nil];
}

- (void)cleanDiskWithCompletionBlock:(void (^)())completionBlock
{
    dispatch_async(self.ioQueue, ^{
        NSArray *resourceKeys = @[NSURLIsDirectoryKey, NSURLContentModificationDateKey, NSURLTotalFileAllocatedSizeKey];
        
        // This enumerator prefetches useful properties for our cache files.
        NSDirectoryEnumerator *fileEnumerator = [FRFileManager enumeratorAthPath:self.diskCachePath includingPropertiesForKeys:resourceKeys];
        
        NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:-self.maxCacheAge];
        NSMutableDictionary *cacheFiles = [NSMutableDictionary dictionary];
        NSUInteger currentCacheSize = 0;
        
        // Enumerate all of the files in the cache directory.  This loop has two purposes:
        //
        //  1. Removing files that are older than the expiration date.
        //  2. Storing file attributes for the size-based cleanup pass.
        for (NSURL *fileURL in fileEnumerator) {
            NSDictionary *resourceValues = [fileURL resourceValuesForKeys:resourceKeys error:NULL];
            
            // Skip directories.
            if ([resourceValues[NSURLIsDirectoryKey] boolValue]) {
                continue;
            }
            
            // Remove files that are older than the expiration date;
            NSDate *modificationDate = resourceValues[NSURLContentModificationDateKey];
            if ([[modificationDate laterDate:expirationDate] isEqualToDate:expirationDate]) {
                [FRFileManager deleteFileAtURL:fileURL];
                continue;
            }
            
            // Store a reference to this file and account for its total size.
            NSNumber *totalAllocatedSize = resourceValues[NSURLTotalFileAllocatedSizeKey];
            currentCacheSize += [totalAllocatedSize unsignedIntegerValue];
            [cacheFiles setObject:resourceValues forKey:fileURL];
        }
        
        // If our remaining disk cache exceeds a configured maximum size, perform a second
        // size-based cleanup pass.  We delete the oldest files first.
        if (self.maxCacheSize > 0 && currentCacheSize > self.maxCacheSize) {
            // Target half of our maximum cache size for this cleanup pass.
            const NSUInteger desiredCacheSize = self.maxCacheSize / 2;
            
            // Sort the remaining cache files by their last modification time (oldest first).
            NSArray *sortedFiles = [cacheFiles keysSortedByValueWithOptions:NSSortConcurrent
                                                            usingComparator:^NSComparisonResult(id obj1, id obj2) {
                                                                return [obj1[NSURLContentModificationDateKey] compare:obj2[NSURLContentModificationDateKey]];
                                                            }];
            
            // Delete files until we fall below our desired cache size.
            for (NSURL *fileURL in sortedFiles) {
                if (![FRFileManager deleteFileAtURL:fileURL]) {
                    NSDictionary *resourceValues = cacheFiles[fileURL];
                    NSNumber *totalAllocatedSize = resourceValues[NSURLTotalFileAllocatedSizeKey];
                    currentCacheSize -= [totalAllocatedSize unsignedIntegerValue];
                    
                    if (currentCacheSize < desiredCacheSize) {
                        break;
                    }
                }
            }
        }
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock();
            });
        }
    });
}

- (void)cleanDisk
{
    [self cleanDiskWithCompletionBlock:nil];
}

#pragma mark -
#pragma mark - Member Methods Size

- (NSUInteger)getSize {
    __block NSUInteger size = 0;
    dispatch_sync(self.ioQueue, ^{
        NSDirectoryEnumerator *fileEnumerator = [FRFileManager enumeratorAthPath:self.diskCachePath];
        for (NSString *fileName in fileEnumerator) {
            NSString *filePath = [self.diskCachePath stringByAppendingPathComponent:fileName];
            NSDictionary *attrs = [FRFileManager attributesOfItemAtPath:filePath];
            size += [attrs fileSize];
        }
    });
    return size;
}

- (int)getDiskCount {
    __block int count = 0;
    dispatch_sync(self.ioQueue, ^{
        NSDirectoryEnumerator *fileEnumerator = [FRFileManager enumeratorAthPath:self.diskCachePath];
        for (__unused NSString *fileName in fileEnumerator) {
            count += 1;
        }
    });
    return count;
}

- (void)calculateSizeWithCompletionBlock:(void (^)(NSUInteger fileCount, NSUInteger totalSize))completionBlock {
    dispatch_async(self.ioQueue, ^{
        NSUInteger fileCount = 0;
        NSUInteger totalSize = 0;
        
        NSDirectoryEnumerator *fileEnumerator = [FRFileManager enumeratorAthPath:self.diskCachePath includingPropertiesForKeys:@[NSFileSize]];
        for (NSURL *fileURL in fileEnumerator) {
            NSNumber *fileSize;
            [fileURL getResourceValue:&fileSize forKey:NSURLFileSizeKey error:NULL];
            totalSize += [fileSize unsignedIntegerValue];
            fileCount += 1;
        }
        
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(fileCount, totalSize);
            });
        }
    });
}

@end
