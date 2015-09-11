//
//  UIImageView+FRUtils.m
//  Firerage
//
//  Created by Aidian on 15/9/4.
//  Copyright (c) 2015年 Illidan. All rights reserved.
//

#import "UIImageView+FRUtils.h"
#import "UIImage+FRCrop.h"
#import "UIView+WebCacheOperation.h"

@implementation UIImageView (FRUtils)

#pragma mark -
#pragma mark - Private Methods

- (void)cancelImageLoad {
    [self sd_cancelImageLoadOperationWithKey:@"UIImageViewOperation"];
}

- (void)setCurrentImage:(UIImage *)image
{
    CABasicAnimation *crossFade = [CABasicAnimation animationWithKeyPath:@"contents"];
    crossFade.duration = 0.5;
    crossFade.fromValue = (id)self.image.CGImage;
    crossFade.toValue = (id)image.CGImage;
    crossFade.removedOnCompletion = NO;
    crossFade.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:crossFade forKey:@"animateContents"];
    
    //Make sure to add Image normally after so when the animation
    //is done it is set to the new Image
    self.image = image;
}

- (void)sd_setImageLoadOperation:(id<SDWebImageOperation>)operation {
    [self sd_setImageLoadOperation:operation forKey:@"UIImageViewOperation"];
}

- (CGSize)cropSize
{
    return CGSizeMake(CGRectGetWidth(self.frame) * [UIScreen mainScreen].scale, CGRectGetHeight(self.frame) * [UIScreen mainScreen].scale);
}

- (NSString *)cacheKeyWithURLString:(NSString *)URLString faceAwareFilled:(BOOL)faceAwareFilled
{
    NSString *cacheKey = [NSString stringWithFormat:@"%@faceAwareFilled%d%@", URLString, faceAwareFilled, NSStringFromCGSize([self cropSize])];
    return cacheKey;
}

- (void)loadImageWithURLString:(NSString *)URLString faceAwareFilled:(BOOL)faceAwareFilled completion:(FRImageLoadedCompletion)completion
{
    NSURL *url = [NSURL URLWithString:URLString];
    __weak UIImageView *wself = self;
    id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadImageWithURL:url options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (!wself) return;
        dispatch_main_sync_safe(^{
            __strong UIImageView *sself = wself;
            if (!sself) return;
            if (image) {
                NSString *cacheKey = [self cacheKeyWithURLString:URLString faceAwareFilled:faceAwareFilled];
                if (faceAwareFilled) {
                    [image faceAwareFillWithSize:[sself cropSize] cropType:FRCropTopType block:^(UIImage *faceAwareFilledImage) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [sself setCurrentImage:faceAwareFilledImage];
                        });
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                            [[SDImageCache sharedImageCache] storeImage:faceAwareFilledImage forKey:cacheKey];
                        });
                        if (completion && finished) {
                            completion(faceAwareFilledImage, error);
                        }
                    }];
                } else {
                    UIImage *cropImage = [image cropWithProportion:CGRectGetWidth(sself.frame) / CGRectGetHeight(sself.frame) type:FRCropTopType];
                    [sself setCurrentImage:cropImage];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                        [[SDImageCache sharedImageCache] storeImage:cropImage forKey:cacheKey];
                    });
                    
                    if (completion && finished) {
                        completion(cropImage, error);
                    }
                }
            }
        });
    }];
    [self sd_setImageLoadOperation:operation];
}

- (void)setImageWithURLString:(NSString *)URLString placeholderImage:(UIImage *)placeholder faceAwareFilled:(BOOL)faceAwareFilled completion:(FRImageLoadedCompletion)completion
{
    [self setCurrentImage:placeholder];
    [self cancelImageLoad];
    
    if (URLString.length == 0) {
        dispatch_main_async_safe(^{
            NSError *error = [NSError errorWithDomain:@"SDWebImageErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
            if (completion) {
                completion(nil, error);
            }
        });
        
        return;
    }
    
    NSString *cacheKey = [self cacheKeyWithURLString:URLString faceAwareFilled:faceAwareFilled];
    __weak UIImageView *wself = self;
    
    [[SDImageCache sharedImageCache] queryDiskCacheForKey:cacheKey done:^(UIImage *image, SDImageCacheType cacheType) {
        if (image) {
            [wself setCurrentImage:image];
            if (completion) {
                completion(image, nil);
            }
        } else {
            [wself loadImageWithURLString:URLString faceAwareFilled:faceAwareFilled completion:completion];
        }
    }];
}

#pragma mark -
#pragma mark - Member Methods

- (void)setFaceAwareFilledImageWithURLString:(NSString *)URLString placeholderImage:(UIImage *)placeholder
{
    [self setFaceAwareFilledImageWithURLString:URLString placeholderImage:placeholder completion:nil];
}

- (void)setFaceAwareFilledImageWithURLString:(NSString *)URLString placeholderImage:(UIImage *)placeholder completion:(FRImageLoadedCompletion)completion
{
    [self setImageWithURLString:URLString placeholderImage:placeholder faceAwareFilled:YES completion:completion];
}

- (void)setImageWithURLString:(NSString *)URLString placeholderImage:(UIImage *)placeholder
{
    [self setImageWithURLString:URLString placeholderImage:placeholder completion:nil];
}

- (void)setImageWithURLString:(NSString *)URLString placeholderImage:(UIImage *)placeholder completion:(FRImageLoadedCompletion)completion
{
    [self setImageWithURLString:URLString placeholderImage:placeholder faceAwareFilled:NO completion:completion];
}

@end
