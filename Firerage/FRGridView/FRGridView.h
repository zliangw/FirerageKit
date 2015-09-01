//
//  FRGridView.h
//  FirerageKit
//
//  Created by Aidian on 14-5-20.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRGridViewItem.h"
#import "FRGridItemIndexPath.h"

@protocol FRGridViewDelegate;
@protocol FRGridViewDataSource;

@interface FRGridView : UIView

@property (nonatomic, weak) IBOutlet id<FRGridViewDelegate> delegate;
@property (nonatomic, weak) IBOutlet id<FRGridViewDataSource> dataSource;

- (void)reloadData;

@end

@protocol FRGridViewDelegate <NSObject>

@optional
- (UIEdgeInsets)gridViewEdgeInsets;
- (CGFloat)gridView:(FRGridView *)gridView heightForRow:(NSInteger)row;
- (CGFloat)gridViewWidthForAllItems:(FRGridView *)gridView;
- (void)gridView:(FRGridView *)gridView didSelectItemAtIndexPath:(FRGridItemIndexPath *)indexPath;

@end

@protocol FRGridViewDataSource <NSObject>

@required
- (NSInteger)numberOfRowsInGridView:(FRGridView *)gridView;
- (NSInteger)numberOfColumnsInGridView:(FRGridView *)gridView;
- (FRGridViewItem *)gridView:(FRGridView *)gridView itemAtIndexPath:(FRGridItemIndexPath *)indexPath;

@end
