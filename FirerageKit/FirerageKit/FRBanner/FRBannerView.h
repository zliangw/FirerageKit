//
//  FRBannerView.h
//  FirerageKit
//
//  Created by Aidian.Tang on 14-5-22.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

/**
 *  FRBannerView Implemente base HMBannerView Created by Dennis
 */

#import <UIKit/UIKit.h>
#import "FRBannerItem.h"

typedef NS_ENUM(NSInteger, FRBannerViewDirection) {
    // Default direction is 'RBannerViewLandscapeDirection'
    RBannerViewDefaultDirection,
    RBannerViewLandscapeDirection,
    RBannerViewPortaitDirection
};

typedef NS_ENUM(NSInteger, FRBannerViewPageControlStyle)
{
    // Default FRBannerViewPageStyle is 'FRBannerViewPageMiddleStyle'
    FRBannerViewPageControlDefaultStyle,
    FRBannerViewPageControlNoneStyle,
    FRBannerViewPageControlLeftStyle,
    FRBannerViewPageControlRightStyle,
    FRBannerViewPageControlMiddleStyle
};

@protocol FRBannerViewDelegate;

@interface FRBannerView : UIView

@property (nonatomic, weak) id<FRBannerViewDelegate> delegate;
@property (nonatomic, assign) FRBannerViewPageControlStyle pageControlStyle;
@property (nonatomic, assign) NSTimeInterval autoRollingDelayTime; //Default is 2m
@property (nonatomic, assign) BOOL autoRolling;
@property (nonatomic, strong) NSArray *bannerItems;

- (instancetype)initWithFrame:(CGRect)frame direction:(FRBannerViewDirection)direction bannerItems:(NSArray *)bannerItems;
- (void)reloadData;

@end

@protocol FRBannerViewDelegate <NSObject>

- (void)bannerView:(FRBannerView *)bannerView didSelectItemAtIndex:(NSInteger)index;

@end
