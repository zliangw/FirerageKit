//
//  FRGridViewItem.h
//  FirerageKit
//
//  Created by Aidian on 14-5-20.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRGridItemIndexPath.h"

@interface FRGridViewItem : UIView

@property (nonatomic, strong, readonly) FRGridItemIndexPath *indexPath;

- (instancetype)initWithSize:(CGSize)size indexPath:(FRGridItemIndexPath *)indexPath;

@end
