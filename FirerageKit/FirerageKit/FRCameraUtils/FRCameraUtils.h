//
//  FRCameraUtils.h
//  FirerageKit
//
//  Created by Aidian.Tang on 14-5-28.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^FRCameraWillShowedBlock) ();
typedef void (^FRCameraCanceledBlock) ();
typedef void (^FRCameraFinishedBlock) (UIImage *image ,NSDictionary *editingInfo);

@interface FRCameraUtils : NSObject

@property (nonatomic, copy) FRCameraWillShowedBlock willShowedBlock;
@property (nonatomic, copy) FRCameraCanceledBlock canceledBlock;
@property (nonatomic, copy) FRCameraFinishedBlock finishedBlock;

+ (FRCameraUtils *)sharedUtils;
+ (void)releaseUtils;

+ (BOOL)isSupportCamera;

+ (BOOL)isSupportPhotoLibrary;

+ (void)showCameraInViewController:(UIViewController *)viewController sourceType:(UIImagePickerControllerSourceType)sourceType allowsEditing:(BOOL)allowsEditing cameraDevice:(UIImagePickerControllerCameraDevice)cameraDevice willShowedBlock:(FRCameraWillShowedBlock)willShowedBlock canceledBlock:(FRCameraCanceledBlock)canceledBlock finishedBlock:(FRCameraFinishedBlock)finishedBlock;

- (void)showCameraInViewController:(UIViewController *)viewController sourceType:(UIImagePickerControllerSourceType)sourceType allowsEditing:(BOOL)allowsEditing cameraDevice:(UIImagePickerControllerCameraDevice)cameraDevice willShowedBlock:(FRCameraWillShowedBlock)willShowedBlock canceledBlock:(FRCameraCanceledBlock)canceledBlock finishedBlock:(FRCameraFinishedBlock)finishedBlock;

@end
