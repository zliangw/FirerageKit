//
//  FRGridView.m
//  FirerageKit
//
//  Created by Aidian on 14-5-20.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "FRGridView.h"

@interface FRGridView ()

@property (nonatomic, strong) UITableView *itemTableView;

@end

@implementation FRGridView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initView];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initView];
}

- (void)initView
{
    self.itemTableView = [[UITableView alloc] initWithFrame:self.bounds];
}

- (void)reloadData
{
    
}

@end
