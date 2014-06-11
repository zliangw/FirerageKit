//
//  UIButton+FRFaceAwareFill.h
//  FirerageKit
//
//  Created by Aidian.Tang on 14-5-29.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageCompat.h"
#import "SDWebImageManager.h"
#import "UIImage+FRCrop.h"

@interface UIButton (FRFaceAwareFill)

- (void)setFaceAwareFilledBackgroundImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder state:(UIControlState)state completed:(SDWebImageCompletedBlock)completedBlock;

- (void)setBackgroundImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder faceAwareFilled:(BOOL)faceAwareFilled cropProportion:(CGFloat)proportion cropType:(FRCropType)cropType state:(UIControlState)state completed:(SDWebImageCompletedBlock)completedBlock;

@end
