//
//  FRNavigationMenuDemoViewController.m
//  FirerageKit
//
//  Created by Aidian.Tang on 14-5-22.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "FRNavigationMenuDemoViewController.h"
#import "SINavigationMenuView.h"

@interface FRNavigationMenuDemoViewController () <SINavigationMenuDelegate>

@end

@implementation FRNavigationMenuDemoViewController

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
    if (self.navigationItem) {
        CGRect frame = CGRectMake(0.0, 0.0, 40.0, self.navigationController.navigationBar.bounds.size.height);
        SINavigationMenuView *menu = [[SINavigationMenuView alloc] initWithFrame:frame title:@"Menu"];
        [menu displayMenuInView:self.navigationController.view];
        menu.items = @[@"News", @"Top Articles", @"Messages", @"Account", @"Settings", @"Top Articles", @"Messages"];
        menu.delegate = self;
        self.navigationItem.titleView = menu;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didSelectItemAtIndex:(NSUInteger)index
{
    
}

@end
