//
//  FRGridView.m
//  FirerageKit
//
//  Created by Aidian on 14-5-20.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "FRGridView.h"
#import "UIView+FRLayout.h"

static float HeightForRowAtIndexPathDefault = 60.;

@interface FRGridView () <UITableViewDelegate, UITableViewDataSource> {
    NSInteger _numberOfRowsInGridView;
    NSInteger _numberOfColumnsInGridView;
}

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
    if (_itemTableView) {
        return;
    }
    
    self.itemTableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    _itemTableView.delegate = self;
    _itemTableView.dataSource = self;
    _itemTableView.backgroundColor = [UIColor clearColor];
    _itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_itemTableView];
    [self reloadData];
}

- (void)reloadData
{
    if (_dataSource && [_dataSource respondsToSelector:@selector(numberOfRowsInGridView:)] && [_dataSource respondsToSelector:@selector(numberOfColumnsInGridView:)]) {
        _numberOfRowsInGridView = [_dataSource numberOfRowsInGridView:self];
        _numberOfColumnsInGridView = [_dataSource numberOfColumnsInGridView:self];
        
        if (_delegate && [_delegate respondsToSelector:@selector(gridViewEdgeInsets)]) {
            UIEdgeInsets gridViewEdgeInsets = [_delegate gridViewEdgeInsets];
            CGSize itemTableViewSize = _itemTableView.size;
            
            itemTableViewSize.width = self.width - (gridViewEdgeInsets.left + gridViewEdgeInsets.right);
            itemTableViewSize.height = self.height - (gridViewEdgeInsets.top + gridViewEdgeInsets.bottom);
            
            _itemTableView.size = itemTableViewSize;
            [_itemTableView centerInView:self];
        }
        
        [self.itemTableView reloadData];
    }
}

#pragma mark -
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _numberOfRowsInGridView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *dequeueReusableCellWithIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dequeueReusableCellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dequeueReusableCellWithIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (_dataSource && [_dataSource respondsToSelector:@selector(gridView:itemAtIndexPath:)]) {
        CGFloat itemSpace = 0;
        if (_delegate && [_delegate respondsToSelector:@selector(gridViewWidthForAllItems:)]) {
            itemSpace = (_itemTableView.width - _numberOfColumnsInGridView * [_delegate gridViewWidthForAllItems:self]) / (_numberOfColumnsInGridView + 1);
        }
        
        [cell.contentView removeAllSubviews];
        for (NSInteger columnsInGridView = 0; columnsInGridView < _numberOfColumnsInGridView; columnsInGridView++) {
            FRGridItemIndexPath *itemIndexPath = [FRGridItemIndexPath indexPathWithRow:indexPath.row column:columnsInGridView];
            FRGridViewItem *gridViewItem = [_dataSource gridView:self itemAtIndexPath:itemIndexPath];
            gridViewItem.left = (columnsInGridView + 1) * itemSpace + columnsInGridView * gridViewItem.width;
            [cell.contentView addSubview:gridViewItem];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemDidTaped:)];
            [gridViewItem addGestureRecognizer:tap];
        }
    }
    
    return cell;
}

#pragma mark - 
#pragma mark - itemDidTaped

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate && [_delegate respondsToSelector:@selector(gridView:heightForRow:)]) {
        return [_delegate gridView:self heightForRow:indexPath.row];
    }
    return HeightForRowAtIndexPathDefault;
}

#pragma mark -
#pragma mark - itemDidTaped

- (void)itemDidTaped:(UITapGestureRecognizer *)ges
{
    if (_delegate && [_delegate respondsToSelector:@selector(gridView:didSelectItemAtIndexPath:)]) {
        FRGridViewItem *item = (FRGridViewItem *)ges.view;
        [_delegate gridView:self didSelectItemAtIndexPath:item.indexPath];
    }
}

@end
