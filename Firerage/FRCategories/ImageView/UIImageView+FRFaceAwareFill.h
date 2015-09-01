//
//  UIImageView+FRFaceAwareFill.h
//  FirerageKit
//
//  Created by Aidian.Tang on 14-5-29.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageCompat.h"
#import "SDWebImageManager.h"
#import "UIImage+FRCrop.h"

typedef void(^FRImageLoadedCompletion)(UIImage *image, NSError *error);

@interface UIImageView (FRFaceAwareFill)

- (void)setFaceAwareFilledImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completion:(FRImageLoadedCompletion)completion;

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder faceAwareFilled:(BOOL)faceAwareFilled cropProportion:(CGFloat)proportion cropType:(FRCropType)cropType completion:(FRImageLoadedCompletion)completion;

- (void)setCropImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completion:(FRImageLoadedCompletion)completion;

- (void)setCropImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder cropType:(FRCropType)cropType completion:(FRImageLoadedCompletion)completion;

@end
