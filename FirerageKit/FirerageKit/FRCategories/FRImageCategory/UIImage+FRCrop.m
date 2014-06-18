//
//  UIImage+FRCrop.m
//  FirerageKit
//
//  Created by Aidian.Tang on 14-5-29.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "UIImage+FRCrop.h"

@implementation UIImage (FRCrop)

- (UIImage *)cropWithProportion:(CGFloat)proportion type:(FRCropType)cropType
{
    CGSize imageSize = self.size;
    float screenWidth = imageSize.width;
    float screenHeight = imageSize.height;
	
    int x=0, y=0, w=0, h=0;
    float ppt = screenWidth / screenHeight;
    if (ppt == proportion) {
        return self;
    }
    
    switch (cropType) {
        case FRCropTopType:
        {
            if (ppt > proportion) {        // w > h
                y = 0;
                h = screenHeight;
                w = proportion * h;
                x = (screenWidth - w) / 2;
            }else {
                x = 0;
                w = screenWidth;
                h = w / proportion;
				y = screenHeight - h;
            }
            break;
        }
        case FRCropCenterType:
        {
            if (ppt > proportion) {        // w > h
                y = 0;
                h = screenHeight;
                w = proportion * h;
				x = (screenWidth - w) / 2;
            }else {
                x = 0;
                w = screenWidth;
                h = w / proportion;
				y = (screenHeight - h) / 2;
            }
            break;
        }
    }
	CGImageRef imageRef = self.CGImage;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 w,
                                                 h,
                                                 8,
                                                 CGImageGetWidth(imageRef) * 4,
                                                 //系统只支持RGB
                                                 colorSpace,
                                                 // 使得系统不需要做额外的显示
                                                 kCGBitmapByteOrder32Little |kCGImageAlphaNoneSkipLast);//|kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little
    CGColorSpaceRelease(colorSpace);
    if (!context) return nil;
	
	CGRect cg = CGRectMake(-x, -y, screenWidth, screenHeight);
    CGContextDrawImage(context, cg, imageRef);
    CGImageRef decompressedImageRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
	
    UIImage *decompressedImage = [[UIImage alloc] initWithCGImage:decompressedImageRef];
    CGImageRelease(decompressedImageRef);
    return decompressedImage ;
}

#pragma mark -
#pragma mark - Face

- (CGRect) rectWithFaces {
    // Get a CIIImage
    CIImage* image = self.CIImage;
    
    // If now available we create one using the CGImage
    if (!image) {
        image = [CIImage imageWithCGImage:self.CGImage];
    }
    
    // create a face detector - since speed is not an issue we'll use a high accuracy detector
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil
                                              options:@{CIDetectorAccuracy:CIDetectorAccuracyLow}];
    
    // create an array containing all the detected faces from the detector
    NSArray* features = [detector featuresInImage:image];
    
    // we'll iterate through every detected face. CIFaceFeature provides us
    // with the width for the entire face, and the coordinates of each eye
    // and the mouth if detected.
    CGRect totalFaceRects = CGRectMake(self.size.width/2.0, self.size.height/2.0, 0, 0);
    
    if (features.count > 0) {
        //We get the CGRect of the first detected face
        totalFaceRects = ((CIFaceFeature*)[features objectAtIndex:0]).bounds;
        
        // Now we find the minimum CGRect that holds all the faces
        for (CIFaceFeature* faceFeature in features) {
            totalFaceRects = CGRectUnion(totalFaceRects, faceFeature.bounds);
        }
    }
    
    //So now we have either a CGRect holding the center of the image or all the faces.
    return totalFaceRects;
}

- (UIImage *) scaleImageFocusingOnRect:(CGRect) facesRect fillSize:(CGSize)fillSize cropType:(FRCropType)cropType
{
    CGFloat multi1 = fillSize.width / self.size.width;
    CGFloat multi2 = fillSize.height / self.size.height;
    CGFloat multi = MAX(multi1, multi2);
    
    //We need to 'flip' the Y coordinate to make it match the iOS coordinate system one
    facesRect.origin.y = self.size.height - facesRect.origin.y - facesRect.size.height;
    
    facesRect = CGRectMake(facesRect.origin.x*multi, facesRect.origin.y*multi, facesRect.size.width*multi, facesRect.size.height*multi);
    
    CGRect imageRect = CGRectZero;
    imageRect.size.width = self.size.width * multi;
    imageRect.size.height = self.size.height * multi;
    imageRect.origin.x = MIN(0.0, MAX(-facesRect.origin.x + fillSize.width/2.0 - facesRect.size.width/2.0, -imageRect.size.width + fillSize.width));
    imageRect.origin.y = MIN(0.0, MAX(-facesRect.origin.y + fillSize.height/2.0 -facesRect.size.height/2.0, -imageRect.size.height + fillSize.height));
    
    imageRect = CGRectIntegral(imageRect);
    
    UIGraphicsBeginImageContextWithOptions(imageRect.size, YES, 2.0);
    [self drawInRect:imageRect];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    newImage = [newImage cropWithProportion:fillSize.width / fillSize.height type:cropType];
    
    return newImage;
}

- (void)faceAwareFillWithSize:(CGSize)size block:(FRCropBlock)cropBlock
{
    [self faceAwareFillWithSize:size cropType:FRCropTopType block:cropBlock];
}

- (void)faceAwareFillWithSize:(CGSize)size cropType:(FRCropType)cropType block:(FRCropBlock)cropBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CGRect facesRect = [self rectWithFaces];
        UIImage *newImage = [self scaleImageFocusingOnRect:facesRect fillSize:size cropType:cropType];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            cropBlock(newImage);
        });
    });
}

- (void)faceAwareFillWithSize:(CGSize)size cropType:(FRCropType)cropType faceBlock:(FRCropFaceBlock)cropBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CGRect facesRect = [self rectWithFaces];
        UIImage *newImage = [self scaleImageFocusingOnRect:facesRect fillSize:size cropType:cropType];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            cropBlock(newImage, facesRect);
        });
    });
}

- (UIImage *)scaleAndRotateWithResolution:(CGFloat)resolution
{
    CGImageRef imgRef = self.CGImage;
	CGFloat width = CGImageGetWidth(imgRef);
	CGFloat height = CGImageGetHeight(imgRef);
	
	CGAffineTransform transform = CGAffineTransformIdentity;
	CGRect bounds = CGRectMake(0, 0, width, height);
	if (width > resolution || height > resolution) {
		CGFloat ratio = width/height;
		if (ratio > 1) {
			bounds.size.width = resolution;
			bounds.size.height = bounds.size.width / ratio;
		} else {
			bounds.size.height = resolution;
			bounds.size.width = bounds.size.height * ratio;
		}
	}
	
	CGFloat scaleRatio = bounds.size.width / width;
	CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
	CGFloat boundHeight;
	
	UIImageOrientation orient = self.imageOrientation;
	switch(orient) {
		case UIImageOrientationUp:
			transform = CGAffineTransformIdentity;
			break;
		case UIImageOrientationUpMirrored:
			transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			break;
		case UIImageOrientationDown:
			transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
			transform = CGAffineTransformRotate(transform, M_PI);
			break;
		case UIImageOrientationDownMirrored:
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
			transform = CGAffineTransformScale(transform, 1.0, -1.0);
			break;
		case UIImageOrientationLeftMirrored:
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
		case UIImageOrientationLeft:
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
		case UIImageOrientationRightMirrored:
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeScale(-1.0, 1.0);
			transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			break;
		case UIImageOrientationRight:
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
			transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			break;
		default:
			[NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
	}
	
	UIGraphicsBeginImageContext(bounds.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
		CGContextScaleCTM(context, -scaleRatio, scaleRatio);
		CGContextTranslateCTM(context, -height, 0);
	} else {
		CGContextScaleCTM(context, scaleRatio, -scaleRatio);
		CGContextTranslateCTM(context, 0, -height);
	}
	CGContextConcatCTM(context, transform);
	CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
	UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return imageCopy;
}

@end
