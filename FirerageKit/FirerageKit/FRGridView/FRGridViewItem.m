//
//  FRGridViewItem.m
//  FirerageKit
//
//  Created by Aidian on 14-5-20.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "FRGridViewItem.h"

@interface FRGridViewItem ()

@property (nonatomic, strong, readwrite) FRGridItemIndexPath *indexPath;

@end

@implementation FRGridViewItem

- (instancetype)initWithSize:(CGSize)size indexPath:(FRGridItemIndexPath *)indexPath
{
    self = [super initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    if (self) {
        // Initialization code
        self.indexPath = indexPath;
    }
    return self;
}

@end
