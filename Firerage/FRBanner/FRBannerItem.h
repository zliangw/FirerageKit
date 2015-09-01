//
//  FRBannerItem.h
//  FirerageKit
//
//  Created by Aidian.Tang on 14-5-22.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FRBannerItem : NSObject

@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, copy) NSString *placeholderImageName;

+ (instancetype)bannerItemWithImageName:(NSString *)imageName imageURL:(NSString *)imageURL placeholderImageName:(NSString *)placeholderImageName;
- (instancetype)initWithImageName:(NSString *)imageName imageURL:(NSString *)imageURL placeholderImageName:(NSString *)placeholderImageName;

@end
