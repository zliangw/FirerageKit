//
//  FRChatCacheManager.h
//  FirerageKit
//
//  Created by Aidian on 14-6-28.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FRChatCacheType) {
    FRChatCacheTextType = 0,
    FRChatCacheImageType = 1,
    FRChatCacheVoiceType = 2,
};

@interface FRChatCacheManager : NSObject

+ (FRChatCacheManager *)sharedChatManager;

+ (NSString *)pathWithKey:(NSString *)key type:(FRChatCacheType)type fromUserID:(NSString *)fromUserID toUserID:(NSString *)toUserID;

- (void)storeVoice:(NSData *)voiceData key:(NSString *)key fromUserID:(NSString *)fromUserID toUserID:(NSString *)toUserID;

- (NSData *)getVoiceDataWithKey:(NSString *)key fromUserID:(NSString *)fromUserID toUserID:(NSString *)toUserID;

- (void)deleteVoiceDataWithKey:(NSString *)key fromUserID:(NSString *)fromUserID toUserID:(NSString *)toUserID;

- (void)cleanCacheWithCompletionBlock:(void (^)())completionBlock;

@end
