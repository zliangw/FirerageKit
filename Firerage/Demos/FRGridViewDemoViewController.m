//
//  FRGridViewDemoViewController.m
//  FirerageKit
//
//  Created by Aidian.Tang on 14-5-21.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "FRGridViewDemoViewController.h"
#import "FRGridView.h"
#import "UIViewController+FRCustomNavigationBarItem.h"

@interface FRGridViewDemoViewController () <FRGridViewDelegate, FRGridViewDataSource>

@property (nonatomic, strong) IBOutlet FRGridView *gridView;

@end

@implementation FRGridViewDemoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addIOS7BackBarButtonItemAutomatically];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - FRGridViewDataSource

- (NSInteger)numberOfRowsInGridView:(FRGridView *)gridView
{
    return 10;
}

- (NSInteger)numberOfColumnsInGridView:(FRGridView *)gridView
{
    return 3;
}

- (FRGridViewItem *)gridView:(FRGridView *)gridView itemAtIndexPath:(FRGridItemIndexPath *)indexPath
{
    FRGridViewItem *gridViewItem = [[FRGridViewItem alloc] initWithSize:CGSizeMake(50, 80) indexPath:indexPath];
    gridViewItem.backgroundColor = [UIColor redColor];
    return gridViewItem;
}

#pragma mark - FRGridViewDelegate

- (UIEdgeInsets)gridViewEdgeInsets
{
    return UIEdgeInsetsMake(100, 40, 0, 0);
}

- (CGFloat)gridView:(FRGridView *)gridView heightForRow:(NSInteger)row
{
    return 100;
}

- (CGFloat)gridViewWidthForAllItems:(FRGridView *)gridView
{
    return 50;
}

- (void)gridView:(FRGridView *)gridView didSelectItemAtIndexPath:(FRGridItemIndexPath *)indexPath
{
    
}

@end
