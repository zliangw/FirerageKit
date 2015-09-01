//
//  FRDemoTableViewController.m
//  FirerageKit
//
//  Created by Aidian on 14-5-20.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "FRDemoTableViewController.h"
#import "FRHttpHostUtils.h"
#import "FRHttpRequestUtils.h"

@interface FRDemoTableViewController ()

@end

@implementation FRDemoTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 网络请求demo
    [FRHttpHostUtils configWithDefaultHost:@"www.baidu.com" backupHosts:nil];
    [FRHttpRequestUtils postWithPath:nil parameters:nil completion:^(id JSON, NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
