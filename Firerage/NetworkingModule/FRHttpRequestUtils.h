//
//  FRHttpRequestUtils.h
//  Firerage
//
//  Created by Illidan.Tang on 15/9/1.
//  Copyright (c) 2015年 Illidan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^FRHttpRequestCompletion)(id JSON, NSError *error);

@interface FRHttpRequestUtils : NSObject

/**
 *  HTTP POST请求
 *
 *  @param path       请求路径
 *  @param parameters 请求参数
 *  @param completion 请求回调
 */
+ (void)postWithPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(FRHttpRequestCompletion)completion;

/**
 *  HTTPS POST请求
 *
 *  @param path       请求路径
 *  @param parameters 请求参数
 *  @param completion 请求回调
 */
+ (void)postSecurelyWithPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(FRHttpRequestCompletion)completion;

/**
 *  GET POST请求
 *
 *  @param path       请求路径
 *  @param parameters 请求参数
 *  @param completion 请求回调
 */
+ (void)getWithPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(FRHttpRequestCompletion)completion;

@end
