//
//  FRBannerItem.m
//  FirerageKit
//
//  Created by Aidian.Tang on 14-5-22.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "FRBannerItem.h"

@implementation FRBannerItem

+ (instancetype)bannerItemWithImageName:(NSString *)imageName imageURL:(NSString *)imageURL placeholderImageName:(NSString *)placeholderImageName
{
    return [[FRBannerItem alloc] initWithImageName:imageName imageURL:imageURL placeholderImageName:placeholderImageName];
}

- (instancetype)initWithImageName:(NSString *)imageName imageURL:(NSString *)imageURL placeholderImageName:(NSString *)placeholderImageName
{
    self = [super init];
    if (self) {
        self.imageName = imageName;
        self.imageURL = imageURL;
        self.placeholderImageName = placeholderImageName;
    }
    return self;
}

@end
