//
//  UIButton+FRUtils.m
//  Firerage
//
//  Created by Aidian on 15/9/4.
//  Copyright (c) 2015年 Illidan. All rights reserved.
//

#import "UIButton+FRUtils.h"
#import "UIImage+FRCrop.h"
#import "UIView+WebCacheOperation.h"

typedef NS_ENUM(NSInteger, FRButtonImageType) {
    FRButtonImageTypeDefault,
    FRButtonBackgroundImageType
};

@implementation UIButton (FRUtils)

#pragma mark -
#pragma mark - Private Methods

- (void)cancelImageLoadForState:(UIControlState)state buttonImageType:(FRButtonImageType)buttonImageType {
    if (buttonImageType == FRButtonImageTypeDefault) {
        [self sd_cancelImageLoadOperationWithKey:[NSString stringWithFormat:@"UIButtonImageOperation%@", @(state)]];
    } else {
        [self sd_cancelImageLoadOperationWithKey:[NSString stringWithFormat:@"UIButtonBackgroundImageOperation%@", @(state)]];
    }
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state buttonImageType:(FRButtonImageType)buttonImageType
{
    CABasicAnimation *crossFade = [CABasicAnimation animationWithKeyPath:@"contents"];
    crossFade.duration = 0.5;
    if (buttonImageType == FRButtonImageTypeDefault) {
        crossFade.fromValue = (id)[self imageForState:state].CGImage;
    } else {
        crossFade.fromValue = (id)[self backgroundImageForState:state].CGImage;
    }
    crossFade.toValue = (id)image.CGImage;
    crossFade.removedOnCompletion = NO;
    crossFade.fillMode = kCAFillModeForwards;
    [self.imageView.layer addAnimation:crossFade forKey:@"animateContents"];
    
    //Make sure to add Image normally after so when the animation
    //is done it is set to the new Image
    if (buttonImageType == FRButtonImageTypeDefault) {
        [self setImage:image forState:state];
    } else {
        [self setBackgroundImage:image forState:state];
    }
}

- (void)sd_setImageLoadOperation:(id<SDWebImageOperation>)operation forState:(UIControlState)state buttonImageType:(FRButtonImageType)buttonImageType {
    if (buttonImageType == FRButtonImageTypeDefault) {
       [self sd_setImageLoadOperation:operation forKey:[NSString stringWithFormat:@"UIButtonImageOperation%@", @(state)]];
    } else {
        [self sd_setImageLoadOperation:operation forKey:[NSString stringWithFormat:@"UIButtonBackgroundImageOperation%@", @(state)]];
    }
}

- (CGSize)cropSize
{
    return CGSizeMake(CGRectGetWidth(self.frame) * [UIScreen mainScreen].scale, CGRectGetHeight(self.frame) * [UIScreen mainScreen].scale);
}

- (NSString *)cacheKeyWithURL:(NSURL *)url buttonImageType:(FRButtonImageType)buttonImageType faceAwareFilled:(BOOL)faceAwareFilled forState:(UIControlState)state
{
    NSString *cacheKey = [NSString stringWithFormat:@"%@faceAwareFilled%d%ld%lu%@", url.absoluteString, faceAwareFilled, (long)buttonImageType, (unsigned long)state, NSStringFromCGSize([self cropSize])];
    return cacheKey;
}

- (void)loadImageWithURL:(NSURL *)url buttonImageType:(FRButtonImageType)buttonImageType faceAwareFilled:(BOOL)faceAwareFilled forState:(UIControlState)state completion:(FRImageDownLoadCompletion)completion
{
    __weak UIButton *wself = self;
    id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadImageWithURL:url options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (!wself) {
            if (completion) {
                completion(nil, error);
            }
            return;
        }
        dispatch_main_sync_safe(^{
            __strong UIButton *sself = wself;
            if (!sself || !image) {
                if (completion) {
                    completion(nil, error);
                }
                return;
            }
            
            NSString *cacheKey = [self cacheKeyWithURL:url buttonImageType:buttonImageType faceAwareFilled:faceAwareFilled forState:state];
            if (faceAwareFilled) {
                [image faceAwareFillWithSize:[sself cropSize] cropType:FRCropTopType block:^(UIImage *faceAwareFilledImage) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [sself setImage:faceAwareFilledImage forState:state buttonImageType:buttonImageType];
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
                [sself setImage:cropImage forState:state buttonImageType:buttonImageType];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    [[SDImageCache sharedImageCache] storeImage:cropImage forKey:cacheKey];
                });
                
                if (completion && finished) {
                    completion(cropImage, error);
                }
            }
        });
    }];
    [self sd_setImageLoadOperation:operation forState:state buttonImageType:buttonImageType];
}

- (void)setImageWithURLString:(NSString *)URLString placeholderImage:(UIImage *)placeholder buttonImageType:(FRButtonImageType)buttonImageType faceAwareFilled:(BOOL)faceAwareFilled forState:(UIControlState)state completion:(FRImageDownLoadCompletion)completion
{
    [self setImage:placeholder forState:state buttonImageType:buttonImageType];
    [self cancelImageLoadForState:state buttonImageType:buttonImageType];
    
    NSURL *url = [NSURL URLWithString:URLString];
    if (!url) {
        dispatch_main_async_safe(^{
            NSError *error = [NSError errorWithDomain:@"SDWebImageErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
            if (completion) {
                completion(nil, error);
            }
        });
        
        return;
    }
    
    NSString *cacheKey = [self cacheKeyWithURL:url buttonImageType:buttonImageType faceAwareFilled:faceAwareFilled forState:state];
    __weak UIButton *wself = self;
    
    [[SDImageCache sharedImageCache] queryDiskCacheForKey:cacheKey done:^(UIImage *image, SDImageCacheType cacheType) {
        if (image) {
            [wself setImage:image forState:state buttonImageType:buttonImageType];
            if (completion) {
                completion(image, nil);
            }
        } else {
            [wself loadImageWithURL:url buttonImageType:buttonImageType faceAwareFilled:faceAwareFilled forState:state completion:completion];
        }
    }];
}

#pragma mark -
#pragma mark - Member Methods

- (void)setFaceAwareFilledImageWithURLString:(NSString *)URLString placeholderImage:(UIImage *)placeholder forState:(UIControlState)state
{
    [self setFaceAwareFilledImageWithURLString:URLString placeholderImage:placeholder forState:state completion:nil];
}

- (void)setFaceAwareFilledImageWithURLString:(NSString *)URLString placeholderImage:(UIImage *)placeholder forState:(UIControlState)state completion:(FRImageDownLoadCompletion)completion
{
    [self setImageWithURLString:URLString placeholderImage:placeholder buttonImageType:FRButtonImageTypeDefault faceAwareFilled:YES forState:state completion:completion];
}

- (void)setImageWithURLString:(NSString *)URLString placeholderImage:(UIImage *)placeholder forState:(UIControlState)state
{
    [self setImageWithURLString:URLString placeholderImage:placeholder forState:state completion:nil];
}

- (void)setImageWithURLString:(NSString *)URLString placeholderImage:(UIImage *)placeholder forState:(UIControlState)state completion:(FRImageDownLoadCompletion)completion
{
    [self setImageWithURLString:URLString placeholderImage:placeholder buttonImageType:FRButtonImageTypeDefault faceAwareFilled:NO forState:state completion:completion];
}

- (void)setFaceAwareFilledBackgroundImageWithURLString:(NSString *)URLString placeholderImage:(UIImage *)placeholder forState:(UIControlState)state
{
    [self setFaceAwareFilledBackgroundImageWithURLString:URLString placeholderImage:placeholder forState:state completion:nil];
}

- (void)setFaceAwareFilledBackgroundImageWithURLString:(NSString *)URLString placeholderImage:(UIImage *)placeholder forState:(UIControlState)state completion:(FRImageDownLoadCompletion)completion
{
    [self setImageWithURLString:URLString placeholderImage:placeholder buttonImageType:FRButtonBackgroundImageType faceAwareFilled:YES forState:state completion:completion];
}

- (void)setBackgroundImageWithURLString:(NSString *)URLString placeholderImage:(UIImage *)placeholder forState:(UIControlState)state
{
    [self setBackgroundImageWithURLString:URLString placeholderImage:placeholder forState:state completion:nil];
}

- (void)setBackgroundImageWithURLString:(NSString *)URLString placeholderImage:(UIImage *)placeholder forState:(UIControlState)state completion:(FRImageDownLoadCompletion)completion
{
    [self setImageWithURLString:URLString placeholderImage:placeholder buttonImageType:FRButtonBackgroundImageType faceAwareFilled:NO forState:state completion:completion];
}

@end
