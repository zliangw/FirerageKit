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

@interface UIImageView (FRFaceAwareFill)

- (void)setFaceAwareFilledImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletedBlock)completedBlock;

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder faceAwareFilled:(BOOL)faceAwareFilled cropProportion:(CGFloat)proportion cropType:(FRCropType)cropType completed:(SDWebImageCompletedBlock)completedBlock;

- (void)setCropImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletedBlock)completedBlock;
- (void)setCropImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder cropType:(FRCropType)cropType completed:(SDWebImageCompletedBlock)completedBlock;

@end
