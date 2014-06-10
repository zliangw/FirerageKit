//
//  UIButton+FRFaceAwareFill.m
//  FirerageKit
//
//  Created by Aidian.Tang on 14-5-29.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "UIButton+FRFaceAwareFill.h"
#import "SDImageCache.h"
#import "objc/runtime.h"

static char operationKey;

@implementation UIButton (FRFaceAwareFill)

- (void)setBackgroundImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder faceAwareFilled:(BOOL)faceAwareFilled cropProportion:(CGFloat)proportion cropType:(FRCropType)cropType state:(UIControlState)state completed:(SDWebImageCompletedBlock)completedBlock
{
    [self cancelCurrentImageLoad];
    
    [self setBackgroundImage:placeholder forState:state];
    
    if (url) {
        CGSize cropSize = CGSizeMake(self.frame.size.width * 2, self.frame.size.height * 2);
        NSString *cacheKey = [NSString stringWithFormat:@"%@cacheForSize%@faceAwareFilled%dproportion%fcropType%d", url.absoluteString, NSStringFromCGSize(cropSize), faceAwareFilled, proportion, cropType];
        UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:cacheKey];
        if (cacheImage) {
            [self setBackgroundImage:cacheImage forState:state];
            if (completedBlock) {
                completedBlock(cacheImage, nil, SDImageCacheTypeDisk);
            }
        } else {
            __weak UIButton *wself = self;
            id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadWithURL:url options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                if (!wself) return;
                dispatch_main_sync_safe(^{
                    __strong UIButton *sself = wself;
                    if (!sself) return;
                    if (image) {
                        UIImage *newImage = [image cropWithProportion:proportion type:cropType];
                        if (faceAwareFilled) {
                            [newImage faceAwareFillWithSize:cropSize cropType:cropType block:^(UIImage *faceAwareFilledImage) {
                                [sself setBackgroundImage:faceAwareFilledImage forState:state];
                                [[SDImageCache sharedImageCache] storeImage:faceAwareFilledImage forKey:cacheKey];
                                if (completedBlock && finished) {
                                    completedBlock(faceAwareFilledImage, error, cacheType);
                                }
                            }];
                        } else {
                            UIImage *cropImage = [image cropWithProportion:proportion type:cropType];
                            [sself setBackgroundImage:cropImage forState:state];
                            [[SDImageCache sharedImageCache] storeImage:cropImage forKey:cacheKey];
                            if (completedBlock && finished) {
                                completedBlock(cropImage, error, cacheType);
                            }
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
