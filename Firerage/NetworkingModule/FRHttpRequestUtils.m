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

+ (void)uploadWithPath:(NSString *)path parameters:(NSDictionary *)parameters file:(id)file progress:(void (^)(float))progress completion:(void (^)(id, NSError *))completion
{
    NSError *error = nil;
    NSString *URLString = [self getHttpURLStringWithPath:path error:&error securityActived:NO];
    
    if (error) {
        if (completion) {
            completion(nil,error);
        }
        return;
    }
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSError *fileError = nil;
        
        if ([file isKindOfClass:[NSData class]]) {
            [formData appendPartWithFileData:file name:@"name" fileName:@"faileName" mimeType:@"file"];
        } else {
            [formData appendPartWithFileURL:[NSURL fileURLWithPath:file] name:@"name" error:&fileError];
        }
        
        if (fileError) {
            if (completion) {
                completion(nil,fileError);
            }
            return;
        }
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        AFHTTPRequestOperation *operation =
        [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (completion) {
                completion(responseObject,nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (completion) {
                completion(nil,error);
            }
        }];
        
        if (progress) {
            [operation setUploadProgressBlock:^(NSUInteger __unused bytesWritten,long long totalBytesWritten,long long totalBytesExpectedToWrite) {
                progress((double)totalBytesWritten / (double)totalBytesExpectedToWrite);
            }];
        }
        
        [operation start];
        
    } error:&error];
    
    if (error) {
        if (completion) {
            completion(nil,error);
        }
    }
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

+ (void)uploadWithPath:(NSString *)path parameters:(NSDictionary *)parameters fileData:(NSData *)fileData progress:(void (^)(float))progress completion:(void (^)(id, NSError *))completion
{
    [self uploadWithPath:path parameters:parameters file:fileData progress:progress completion:completion];
}

+ (void)uploadWithPath:(NSString *)path parameters:(NSDictionary *)parameters filePath:(NSString *)filePath progress:(void (^)(float))progress completion:(void (^)(id, NSError *))completion
{
    [self uploadWithPath:path parameters:parameters file:filePath progress:progress completion:completion];
}

+ (void)downloadWithURLString:(NSString *)URLString parameters:(NSDictionary *)parameters progress:(void (^)(float))progress completion:(void (^)(id, NSError *))completion
{
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:URLString]]];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion) {
            completion(responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil,error);
        }
    }];
    
    if (progress) {
        [operation setUploadProgressBlock:^(NSUInteger __unused bytesWritten,long long totalBytesWritten,long long totalBytesExpectedToWrite) {
            progress((double)totalBytesWritten / (double)totalBytesExpectedToWrite);
        }];
    }
    
    [operation start];
}

@end
