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
+ (void)postWithPath:(NSString *)path parameters:(NSDictionary *)parameters  completion:(FRHttpRequestCompletion)completion;

/**
 *  HTTP POST请求
 *
 *  @param path       请求路径
 *  @param parameters 请求参数
 *  @param header     请求头
 *  @param completion 请求回调
 */
+ (void)postWithPath:(NSString *)path parameters:(NSDictionary *)parameters header:(NSDictionary *)header completion:(FRHttpRequestCompletion)completion;

/**
 *  HTTPS POST请求
 *
 *  @param path       请求路径
 *  @param parameters 请求参数
 *  @param completion 请求回调
 */
+ (void)postSecurelyWithPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(FRHttpRequestCompletion)completion;

/**
 *  HTTPS POST请求
 *
 *  @param path       请求路径
 *  @param parameters 请求参数
 *  @param header     请求头
 *  @param completion 请求回调
 */
+ (void)postSecurelyWithPath:(NSString *)path parameters:(NSDictionary *)parameters header:(NSDictionary *)header completion:(FRHttpRequestCompletion)completion;

/**
 *  GET POST请求
 *
 *  @param path       请求路径
 *  @param parameters 请求参数
 *  @param completion 请求回调
 */
+ (void)getWithPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(FRHttpRequestCompletion)completion;

/**
 *  上传文件
 *
 *  @param path       请求路径
 *  @param parameters 请求参数
 *  @param fileData   上传的文件数据
 *  @param progress   进度
 *  @param completion 回调
 */
+ (void)uploadWithPath:(NSString *)path parameters:(NSDictionary *)parameters fileData:(NSData *)fileData progress:(void(^)(float progress))progress completion:(void(^)(id JSON, NSError *error))completion;

/**
 *  上传文件
 *
 *  @param path       请求路径
 *  @param parameters 请求参数
 *  @param filePath   上传的文件路径
 *  @param progress   进度
 *  @param completion 回调
 */
+ (void)uploadWithPath:(NSString *)path parameters:(NSDictionary *)parameters filePath:(NSString *)filePath progress:(void(^)(float progress))progress completion:(FRHttpRequestCompletion)completion;

/**
 *  下载文件
 *
 *  @param URLString  文件URL
 *  @param parameters 参数
 *  @param progress   进度
 *  @param completion 回调
 */
+ (void)downloadWithURLString:(NSString *)URLString parameters:(NSDictionary *)parameters progress:(void(^)(float progress))progress completion:(FRHttpRequestCompletion)completion;

@end
