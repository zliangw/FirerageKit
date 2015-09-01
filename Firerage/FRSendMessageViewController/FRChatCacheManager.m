//
//  FRChatCacheManager.m
//  FirerageKit
//
//  Created by Aidian on 14-6-28.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "FRChatCacheManager.h"
#import "FRFileCache.h"
#import "FRFileManager.h"

@interface FRChatCacheManager ()

@property (nonatomic, strong) FRFileCache *chatFileCache;

@end

@implementation FRChatCacheManager

+ (FRChatCacheManager *)sharedChatManager
{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

+ (NSString *)pathWithKey:(NSString *)key type:(FRChatCacheType)type fromUserID:(NSString *)fromUserID toUserID:(NSString *)toUserID
{
    if (fromUserID.length == 0 || toUserID.length == 0) {
        return nil;
    }
    return [[FRFileManager documentsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%d%@%@", key, type, fromUserID, toUserID]];
}

- (FRFileCache *)chatFileCache
{
    if (!_chatFileCache) {
        _chatFileCache = [[FRFileCache alloc] initWithNamespace:NSStringFromClass([self class])];
    }
    return _chatFileCache;
}

- (void)storeVoice:(NSData *)voiceData key:(NSString *)key fromUserID:(NSString *)fromUserID toUserID:(NSString *)toUserID
{
    if (!voiceData || key.length == 0 || fromUserID.length == 0 || toUserID.length == 0) {
        return;
    }
    [self.chatFileCache storeFile:voiceData forKey:[[self class] pathWithKey:key type:FRChatCacheVoiceType fromUserID:fromUserID toUserID:toUserID]];
}

- (NSData *)getVoiceDataWithKey:(NSString *)key fromUserID:(NSString *)fromUserID toUserID:(NSString *)toUserID
{
    if (key.length == 0 || fromUserID.length == 0 || toUserID.length == 0) {
        return nil;
    }
    
    return [self.chatFileCache fileFromDiskCacheForKey:[[self class] pathWithKey:key type:FRChatCacheVoiceType fromUserID:fromUserID toUserID:toUserID]];
}

- (void)deleteVoiceDataWithKey:(NSString *)key fromUserID:(NSString *)fromUserID toUserID:(NSString *)toUserID
{
    if (key.length == 0 || fromUserID.length == 0 || toUserID.length == 0) {
        return;
    }
    
    [self.chatFileCache deleteFileForKey:[[self class] pathWithKey:key type:FRChatCacheVoiceType fromUserID:fromUserID toUserID:toUserID]];
}

- (void)cleanCacheWithCompletionBlock:(void (^)())completionBlock
{
    [self.chatFileCache clearMemory];
    [self.chatFileCache clearDiskOnCompletion:^{
        if (completionBlock) {
            completionBlock();
        }
    }];
}

@end
