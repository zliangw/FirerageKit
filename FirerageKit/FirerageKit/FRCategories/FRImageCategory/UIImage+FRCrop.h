//
//  UIImage+FRCrop.h
//  FirerageKit
//
//  Created by Aidian.Tang on 14-5-29.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

/**
 *  FaceAwareFill feature base UIImageView+UIImageView_FaceAwareFill
 */

#import <UIKit/UIKit.h>

typedef void (^FRCropBlock) (UIImage *image);

typedef enum {
    FRCropTopType,
    FRCropCenterType,
}FRCropType;

@interface UIImage (FRCrop)

- (UIImage *)cropWithProportion:(CGFloat)proportion type:(FRCropType)cropType;
- (void)faceAwareFillWithSize:(CGSize)size block:(FRCropBlock)cropBlock;

@end
