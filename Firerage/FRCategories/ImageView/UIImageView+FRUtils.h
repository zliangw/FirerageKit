//
//  UIImageView+FRUtils.h
//  Firerage
//
//  Created by Aidian on 15/9/4.
//  Copyright (c) 2015年 Illidan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FRImageLoadedCompletion)(UIImage *image, NSError *error);

@interface UIImageView (FRUtils)

- (void)setFaceAwareFilledImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

- (void)setFaceAwareFilledImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completion:(FRImageLoadedCompletion)completion;

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completion:(FRImageLoadedCompletion)completion;

@end
