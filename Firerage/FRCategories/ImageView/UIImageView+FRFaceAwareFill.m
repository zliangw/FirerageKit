//
//  UIImageView+FRFaceAwareFill.m
//  FirerageKit
//
//  Created by Aidian.Tang on 14-5-29.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "UIImageView+FRFaceAwareFill.h"
#import "SDImageCache.h"
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

- (void)setFaceAwareFilledImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completion:(FRImageLoadedCompletion)completion
{
    [self setImageWithURL:url placeholderImage:placeholder faceAwareFilled:YES cropProportion:self.frame.size.width / self.frame.size.height cropType:FRCropTopType completion:completion];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder faceAwareFilled:(BOOL)faceAwareFilled cropProportion:(CGFloat)proportion cropType:(FRCropType)cropType completion:(FRImageLoadedCompletion)completion
{
    [self cancelCurrentImageLoad];
    
    self.image = placeholder;
    
    if (!url) {
        if (completion) {
            completion(nil, nil);
        }
        return;
    }
    
    CGSize cropSize = CGSizeMake(self.frame.size.width * 2, self.frame.size.height * 2);
    NSString *cacheKey = [NSString stringWithFormat:@"%@cacheForSize%@faceAwareFilled%dproportion%fcropType%d", url.absoluteString, NSStringFromCGSize(cropSize), faceAwareFilled, proportion, cropType];
    __weak typeof(self) weakSelf = self;
    
    [[SDImageCache sharedImageCache] queryDiskCacheForKey:cacheKey done:^(UIImage *cacheImage, SDImageCacheType cacheType) {
        if (cacheImage) {
            weakSelf.image = cacheImage;
            if (completion) {
                completion(cacheImage, nil);
            }
        } else {
            id <SDWebImageOperation> operation = [[SDWebImageManager sharedManager] downloadImageWithURL:url options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                if (!weakSelf) return;
                dispatch_main_sync_safe(^{
                    if (!weakSelf) return;
                    if (image) {
                        if (faceAwareFilled) {
                            [image faceAwareFillWithSize:cropSize cropType:cropType block:^(UIImage *faceAwareFilledImage) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    weakSelf.image = faceAwareFilledImage;
                                });
                                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                                    [[SDImageCache sharedImageCache] storeImage:faceAwareFilledImage forKey:cacheKey];
                                });
                                if (completion && finished) {
                                    completion(faceAwareFilledImage, error);
                                }
                            }];
                        } else {
                            UIImage *cropImage = [image cropWithProportion:proportion type:cropType];
                            weakSelf.image = cropImage;
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                                [[SDImageCache sharedImageCache] storeImage:cropImage forKey:cacheKey];
                            });
                            if (completion && finished) {
                                completion(cropImage, error);
                            }
                        }
                    } else if (completion && finished) {
                        completion(image, error);
                    }
                });
            }];
            objc_setAssociatedObject(self, &operationKey, operation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }];
}

- (void)setCropImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completion:(FRImageLoadedCompletion)completion
{
    [self setCropImageWithURL:url placeholderImage:placeholder cropType:FRCropTopType completion:completion];
}

- (void)setCropImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder cropType:(FRCropType)cropType completion:(FRImageLoadedCompletion)completion
{
    [self setImageWithURL:url placeholderImage:placeholder faceAwareFilled:NO cropProportion:self.frame.size.width / self.frame.size.height cropType:cropType completion:completion];
}

@end
