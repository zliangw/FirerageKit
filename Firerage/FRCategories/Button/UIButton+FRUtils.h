//
//  UIButton+FRUtils.h
//  Firerage
//
//  Created by Aidian on 15/9/4.
//  Copyright (c) 2015年 Illidan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FRImageDownLoadCompletion)(UIImage *image, NSError *error);

@interface UIButton (FRUtils)

- (void)setFaceAwareFilledImageWithURLString:(NSString *)URLString placeholderImage:(UIImage *)placeholder forState:(UIControlState)state;

- (void)setFaceAwareFilledImageWithURLString:(NSString *)URLString placeholderImage:(UIImage *)placeholder forState:(UIControlState)state completion:(FRImageDownLoadCompletion)completion;

- (void)setImageWithURLString:(NSString *)URLString placeholderImage:(UIImage *)placeholder forState:(UIControlState)state;

- (void)setImageWithURLString:(NSString *)URLString placeholderImage:(UIImage *)placeholder forState:(UIControlState)state completion:(FRImageDownLoadCompletion)completion;

- (void)setFaceAwareFilledBackgroundImageWithURLString:(NSString *)URLString placeholderImage:(UIImage *)placeholder forState:(UIControlState)state;

- (void)setFaceAwareFilledBackgroundImageWithURLString:(NSString *)URLString placeholderImage:(UIImage *)placeholder forState:(UIControlState)state completion:(FRImageDownLoadCompletion)completion;

- (void)setBackgroundImageWithURLString:(NSString *)URLString placeholderImage:(UIImage *)placeholder forState:(UIControlState)state;

- (void)setBackgroundImageWithURLString:(NSString *)URLString placeholderImage:(UIImage *)placeholder forState:(UIControlState)state completion:(FRImageDownLoadCompletion)completion;

@end
