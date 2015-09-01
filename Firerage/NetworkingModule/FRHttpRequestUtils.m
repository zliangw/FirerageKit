//
//  FRHttpRequestUtils.m
//  Firerage
//
//  Created by Illidan.Tang on 15/9/1.
//  Copyright (c) 2015年 Illidan. All rights reserved.
//

#import "FRHttpRequestUtils.h"
#import "FRHttpHostUtils.h"
#import "AFNetworking.h"

@implementation FRHttpRequestUtils

#pragma mark - Private Methods

+ (NSString *)getHttpURLStringWithPath:(NSString *)path error:(NSError **)error securityActived:(BOOL)securityActived
{
    NSString *URLString = nil;
    NSString *host = [FRHttpHostUtils getHostWithError:error];
    if (!*error) {
        NSString *requestProtocol = @"http";
        if (securityActived) {
            requestProtocol = @"https";
        }
        if (path.length > 0) {
            URLString = [NSString stringWithFormat:@"%@://%@/%@", requestProtocol, host, path];
        } else {
            URLString = [NSString stringWithFormat:@"%@://%@", requestProtocol, host];
        }
    }
    
    return URLString;
}

+ (NSString *)getHttpURLStringWithPath:(NSString *)path error:(NSError **)error
{
    return [self getHttpURLStringWithPath:path error:error securityActived:NO];
}

+ (NSString *)getHttpsURLStringWithPath:(NSString *)path error:(NSError **)error
{
    return [self getHttpURLStringWithPath:path error:error securityActived:YES];
}

+ (void)postWithPath:(NSString *)path parameters:(NSDictionary *)parameters securityActived:(BOOL)securityActived completion:(FRHttpRequestCompletion)completion
{
    NSError *error = nil;
    
    NSString *URLString = [self getHttpURLStringWithPath:path error:&error securityActived:securityActived];
    
    if (error) {
        if (completion) {
            completion(nil,error);
        }
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    if (securityActived) {
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        securityPolicy.allowInvalidCertificates = YES;
        manager.securityPolicy = securityPolicy;
    }
    
    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion) {
            completion(responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
}

#pragma mark - Member Methods

+ (void)postWithPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(FRHttpRequestCompletion)completion
{
    [self postWithPath:path parameters:parameters securityActived:NO completion:completion];
}

+ (void)postSecurelyWithPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(FRHttpRequestCompletion)completion
{
    [self postWithPath:path parameters:parameters securityActived:YES completion:completion];
}

+ (void)getWithPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(FRHttpRequestCompletion)completion
{
    NSError *error = nil;
    
    NSString *URLString = [self getHttpURLStringWithPath:path error:&error securityActived:NO];
    
    if (error) {
        if (completion) {
            completion(nil,error);
        }
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion) {
            completion(responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
}

@end
