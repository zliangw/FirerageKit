//
//  FRHttpHostUtils.h
//  Firerage
//
//  Created by Illidan.Tang on 15/9/1.
//  Copyright (c) 2015年 Illidan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ZAHttpHostErrorCode) {
    FRHttpHostErrorCode_Network, //网络错误
    FRHttpHostErrorCode_HostResolution, //域名解析错误
};

@interface FRHttpHostUtils : NSObject

/**
 *  配置默认HOST和备用HOST
 *
 *  @param defaultHost 默认HOST
 *  @param backupHosts 备用HOST数组
 */
+ (void)configWithDefaultHost:(NSString *)defaultHost backupHosts:(NSArray *)backupHosts;

/**
 *  自动判定当前域名是否可用，不可用则返回可用的备用域名，如果备用域名也不可用则返回错误
 *
 *  @param error      错误
 *
 *  @return HOST
 */
+ (NSString *)getHostWithError:(NSError **)error;

@end
