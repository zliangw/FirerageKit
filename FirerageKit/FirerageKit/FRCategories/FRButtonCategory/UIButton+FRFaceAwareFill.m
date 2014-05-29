//
//  UIButton+FRFaceAwareFill.m
//  FirerageKit
//
//  Created by Aidian.Tang on 14-5-29.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "UIButton+FRFaceAwareFill.h"
#import "objc/runtime.h"

static char operationKey;

@implementation UIButton (FRFaceAwareFill)

- (void)setBackgroundImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder faceAwareFilled:(BOOL)faceAwareFilled cropProportion:(CGFloat)proportion cropType:(FRCropType)cropType state:(UIControlState)state completed:(SDWebImageCompletedBlock)completedBlock
{
    [self cancelCurrentImageLoad];
    
    [self setBackgroundImage:placeholder forState:state];
    
    if (url) {
        __weak UIButton *wself = self;
        id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadWithURL:url options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
            if (!wself) return;
            dispatch_main_sync_safe(^{
                __strong UIButton *sself = wself;
                if (!sself) return;
                if (image) {
                    UIImage *newImage = [image cropWithProportion:proportion type:cropType];
                    if (faceAwareFilled) {
                        [newImage faceAwareFillWithBlock:^(UIImage *faceAwareFilledImage) {
                            [sself setBackgroundImage:faceAwareFilledImage forState:state];
                        }];
                    } else {
                        [sself setBackgroundImage:newImage forState:state];
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

- (void)cancelCurrentImageLoad {
    // Cancel in progress downloader from queue
    id <SDWebImageOperation> operation = objc_getAssociatedObject(self, &operationKey);
    if (operation) {
        [operation cancel];
        objc_setAssociatedObject(self, &operationKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

@end
