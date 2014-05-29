//
//  UIImageView+FRFaceAwareFill.m
//  FirerageKit
//
//  Created by Aidian.Tang on 14-5-29.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "UIImageView+FRFaceAwareFill.h"
#import "objc/runtime.h"

static char operationKey;

@implementation UIImageView (FRFaceAwareFill)

- (void)cancelCurrentImageLoad {
    // Cancel in progress downloader from queue
    id <SDWebImageOperation> operation = objc_getAssociatedObject(self, &operationKey);
    if (operation) {
        [operation cancel];
        objc_setAssociatedObject(self, &operationKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder faceAwareFilled:(BOOL)faceAwareFilled cropProportion:(CGFloat)proportion cropType:(FRCropType)cropType completed:(SDWebImageCompletedBlock)completedBlock
{
    [self cancelCurrentImageLoad];
    
    self.image = placeholder;
    
    if (url) {
        __weak UIImageView *wself = self;
        id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadWithURL:url options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
            if (!wself) return;
            dispatch_main_sync_safe(^{
                if (!wself) return;
                if (image) {
                    UIImage *newImage = [image cropWithProportion:proportion type:cropType];
                    if (faceAwareFilled) {
                        [newImage faceAwareFillWithBlock:^(UIImage *faceAwareFilledImage) {
                            wself.image = faceAwareFilledImage;
                            [wself setNeedsLayout];
                        }];
                    } else {
                        wself.image = newImage;
                        [wself setNeedsLayout];
                    }
                }
                if (completedBlock && finished) {
                    completedBlock(image, error, cacheType);
                }
            });
        }];
        objc_setAssociatedObject(self, &operationKey, operation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

@end
