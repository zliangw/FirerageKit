//
//  FRHttpHostUtils.m
//  Firerage
//
//  Created by Illidan.Tang on 15/9/1.
//  Copyright (c) 2015年 Illidan. All rights reserved.
//

#import "FRHttpHostUtils.h"

#import "Reachability.h"

static NSString *const ZAAssistHost = @"www.baidu.com";

static NSString *const ZAHttpHostErrorDomain = @"FRHttpHostErrorDomain";

@interface FRHttpHostUtils ()

@property (nonatomic, copy) NSString *defaultHost; //默认域名
@property (nonatomic, strong) NSArray *backupHosts; //备用域名

@end

@implementation FRHttpHostUtils

+ (instancetype)sharedUtils
{
    static id sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance =  [[self alloc] init];
    });
    return sharedInstance;
}

- (BOOL)pingHost:(NSString *)host
{
    Reachability *re = [Reachability reachabilityWithHostName:host];
    return re.isReachable;
}

- (NSString *)filtOKHost
{
    NSString *host = nil;
    for (NSString *backupHost in self.backupHosts) {
        if ([self pingHost:backupHost]) {
            host = backupHost;
            break;
        }
    }
    
    return host;
}

+ (void)configWithDefaultHost:(NSString *)defaultHost backupHosts:(NSArray *)backupHosts
{
    [[self sharedUtils] configWithDefaultHost:defaultHost backupHosts:backupHosts];
}

- (void)configWithDefaultHost:(NSString *)defaultHost backupHosts:(NSArray *)backupHosts
{
    self.defaultHost = defaultHost;
    self.backupHosts = backupHosts;
}

+ (NSString *)getHostWithError:(NSError *__autoreleasing *)error
{
    return [[self sharedUtils] getHostWithError:error];
}

- (NSString *)getHostWithError:(NSError *__autoreleasing *)error
{
    // 使用默认域名
    NSString *host = self.defaultHost;
    
    // 默认域名不可用
    if (![self pingHost:self.defaultHost]) {
        NSString *backupHost = [self filtOKHost];
        if (backupHost.length > 0) {
            host = backupHost;
        } else {
            if ([self pingHost:ZAAssistHost]) {
                *error = [NSError errorWithDomain:ZAHttpHostErrorDomain code:FRHttpHostErrorCode_HostResolution userInfo:@{NSLocalizedDescriptionKey : @"域名解析错误"}];
            } else {
                *error = [NSError errorWithDomain:ZAHttpHostErrorDomain code:FRHttpHostErrorCode_Network userInfo:@{NSLocalizedDescriptionKey : @"用户无法访问网络"}];
            }
        }
    }
    
    return host;
}

@end
