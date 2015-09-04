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

- (void)setFaceAwareFilledImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder forState:(UIControlState)state;

- (void)setFaceAwareFilledImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder forState:(UIControlState)state completion:(FRImageDownLoadCompletion)completion;

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder forState:(UIControlState)state;

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder forState:(UIControlState)state completion:(FRImageDownLoadCompletion)completion;

- (void)setFaceAwareFilledBackgroundImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder forState:(UIControlState)state;

- (void)setFaceAwareFilledBackgroundImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder forState:(UIControlState)state completion:(FRImageDownLoadCompletion)completion;

- (void)setBackgroundImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder forState:(UIControlState)state;

- (void)setBackgroundImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder forState:(UIControlState)state completion:(FRImageDownLoadCompletion)completion;

@end
