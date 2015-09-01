//
//  FRFileCache.h
//  FirerageKit
//
//  Created by Aidian on 14-6-28.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import <Foundation/Foundation.h>

#if OS_OBJECT_USE_OBJC
#undef FRDispatchQueueRelease
#undef FRDispatchQueueSetterSementics
#define FRDispatchQueueRelease(q)
#define FRDispatchQueueSetterSementics strong
#else
#undef FRDispatchQueueRelease
#undef FRDispatchQueueSetterSementics
#define FRDispatchQueueRelease(q) (dispatch_release(q))
#define FRDispatchQueueSetterSementics assign
#endif

typedef NS_ENUM(NSInteger, FRFileCacheType) {
    /**
     * The file wasn't available the SDWebImage caches, but was downloaded from the web.
     */
    FRFileCacheTypeNone,
    /**
     * The file was obtained from the disk cache.
     */
    FRFileCacheTypeDisk,
    /**
     * The file was obtained from the memory cache.
     */
    FRFileCacheTypeMemory
};

typedef void(^FRFileQueryCompletedBlock)(NSData *file, FRFileCacheType cacheType);

@interface FRFileCache : NSObject

/**
 * The maximum "total cost" of the in-memory image cache. The cost function is the number of pixels held in memory.
 */
@property (assign, nonatomic) NSUInteger maxMemoryCost;

/**
 * The maximum length of time to keep an image in the cache, in seconds
 */
@property (assign, nonatomic) NSInteger maxCacheAge;

/**
 * The maximum size of the cache, in bytes.
 */
@property (assign, nonatomic) NSUInteger maxCacheSize;

/**
 * Returns global shared cache instance
 *
 * @return FRFileCache global instance
 */
+ (FRFileCache *)sharedFileCache;

/**
 * Init a new cache store with a specific namespace
 *
 * @param ns The namespace to use for this cache store
 */
- (id)initWithNamespace:(NSString *)ns;

/**
 * Add a read-only cache path to search for images pre-cached by SDImageCache
 * Useful if you want to bundle pre-loaded images with your app
 *
 * @param path The path to use for this read-only cache path
 */
- (void)addReadOnlyCachePath:(NSString *)path;

/**
 * Store an data into memory and disk cache at the given key.
 *
 * @param file The data to store
 * @param key The unique image cache key, usually it's image absolute URL
 */
- (void)storeFile:(NSData *)file forKey:(NSString *)key;

/**
 * Store an data into memory and optionally disk cache at the given key.
 *
 * @param file The data to store
 * @param key The unique data cache key, usually it's image absolute URL
 * @param toDisk Store the data to disk cache if YES
 */
- (void)storeFile:(NSData *)file forKey:(NSString *)key toDisk:(BOOL)toDisk;

/**
 * Query the disk cache asynchronously.
 *
 * @param key The unique key used to store the wanted file
 */
- (NSOperation *)queryDiskCacheForKey:(NSString *)key done:(FRFileQueryCompletedBlock)doneBlock;

/**
 * Query the memory cache synchronously.
 *
 * @param key The unique key used to store the wanted file
 */
- (NSData *)fileFromMemoryCacheForKey:(NSString *)key;

/**
 * Query the disk cache synchronously after checking the memory cache.
 *
 * @param key The unique key used to store the wanted file
 */
- (NSData *)fileFromDiskCacheForKey:(NSString *)key;

/**
 * Delete the image from memory and disk cache synchronously
 *
 * @param key The unique file cache key
 */
- (void)deleteFileForKey:(NSString *)key;

/**
 * Delete the file from memory and optionally disk cache synchronously
 *
 * @param key The unique file cache key
 * @param fromDisk Also remove cache entry from disk if YES
 */
- (void)deleteFileForKey:(NSString *)key fromDisk:(BOOL)fromDisk;

/**
 * Clear all memory cached images
 */
- (void)clearMemory;

/**
 * Clear all disk cached files. Non-blocking method - returns immediately.
 * @param completionBlock An block that should be executed after cache expiration completes (optional)
 */
- (void)clearDiskOnCompletion:(void (^)())completion;

/**
 * Clear all disk cached files
 * @see clearDiskOnCompletion:
 */
- (void)clearDisk;

/**
 * Remove all expired cached file from disk. Non-blocking method - returns immediately.
 * @param completionBlock An block that should be executed after cache expiration completes (optional)
 */
- (void)cleanDiskWithCompletionBlock:(void (^)())completionBlock;

/**
 * Remove all expired cached file from disk
 * @see cleanDiskWithCompletionBlock:
 */
- (void)cleanDisk;

/**
 * Get the size used by the disk cache
 */
- (NSUInteger)getSize;

/**
 * Get the number of images in the disk cache
 */
- (int)getDiskCount;

/**
 * Asynchronously calculate the disk cache's size.
 */
- (void)calculateSizeWithCompletionBlock:(void (^)(NSUInteger fileCount, NSUInteger totalSize))completionBlock;

/**
 * Check if file exists in cache already
 */
- (BOOL)diskFileExistsWithKey:(NSString *)key;

@end
