//
//  FRCameraUtils.m
//  FirerageKit
//
//  Created by Aidian.Tang on 14-5-28.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "FRCameraUtils.h"

@interface FRCameraUtils () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePicker;

@end

@implementation FRCameraUtils

static dispatch_once_t once;
static id instance;
+ (FRCameraUtils *)sharedUtils
{
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

+ (void)releaseUtils
{
    instance = nil;
    once = 0;
}

- (void)dealloc
{
    _imagePicker.delegate = nil;
}

+ (BOOL)isSupportCamera
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

+ (BOOL)isSupportPhotoLibrary
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}

+ (void)showCameraInViewController:(UIViewController *)viewController sourceType:(UIImagePickerControllerSourceType)sourceType allowsEditing:(BOOL)allowsEditing cameraDevice:(UIImagePickerControllerCameraDevice)cameraDevice willShowedBlock:(FRCameraWillShowedBlock)willShowedBlock canceledBlock:(FRCameraCanceledBlock)canceledBlock finishedBlock:(FRCameraFinishedBlock)finishedBlock
{
    [[FRCameraUtils sharedUtils] showCameraInViewController:viewController sourceType:sourceType allowsEditing:allowsEditing cameraDevice:cameraDevice willShowedBlock:willShowedBlock canceledBlock:canceledBlock finishedBlock:finishedBlock];
}

- (void)showCameraInViewController:(UIViewController *)viewController sourceType:(UIImagePickerControllerSourceType)sourceType allowsEditing:(BOOL)allowsEditing cameraDevice:(UIImagePickerControllerCameraDevice)cameraDevice willShowedBlock:(FRCameraWillShowedBlock)willShowedBlock canceledBlock:(FRCameraCanceledBlock)canceledBlock finishedBlock:(FRCameraFinishedBlock)finishedBlock
{
    NSAssert([UIImagePickerController isSourceTypeAvailable:sourceType], @"Device not support the type");
    
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.allowsEditing = allowsEditing;
        _imagePicker.sourceType = sourceType;
        _imagePicker.cameraDevice = cameraDevice;
    }
    
    self.willShowedBlock = willShowedBlock;
    self.canceledBlock = canceledBlock;
    self.finishedBlock = finishedBlock;
    
    if (willShowedBlock) {
        willShowedBlock();
    }
    
    [viewController presentViewController:_imagePicker animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    }];
}

#pragma mark -
#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_imagePicker dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        if (_canceledBlock) {
            _canceledBlock();
        }
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [_imagePicker dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        if (_finishedBlock) {
            _finishedBlock(image, editingInfo);
        }
    }];
}

//- (void)navigationController:(UINavigationController *)navigationController
//      willShowViewController:(UIViewController *)viewController
//                    animated:(BOOL)animated {
//    
//    if ([navigationController isKindOfClass:[UIImagePickerController class]] &&
//        ((UIImagePickerController *)navigationController).sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
//        [[UIApplication sharedApplication] setStatusBarHidden:NO];
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
//    }
//}

@end
