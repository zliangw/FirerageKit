//
//  FRDemoTableViewController.m
//  FirerageKit
//
//  Created by Aidian on 14-5-20.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "FRDemoTableViewController.h"
//#import "FRHttpHostUtils.h"
//#import "FRHttpRequestUtils.h"
//#import "NSDate+FRUtils.h"
#import "UIButton+FRUtils.h"
#import "UIImage+FRColor.h"
#import "UIControl+FRUtils.h"
#import "UIImageView+FRUtils.h"

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
//    [FRHttpHostUtils configWithDefaultHost:@"www.baidu.com" backupHosts:nil];
//    [FRHttpRequestUtils postWithPath:nil parameters:nil completion:^(id JSON, NSError *error) {
//        
//    }];
    
//    [[NSDate date] isLastYear];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 200, 300);
    [self.view addSubview:btn];
    [btn setImage:[UIImage imageWithColor:[UIColor redColor] size:CGSizeMake(200, 300) andRoundSize:0] forState:UIControlStateNormal];
    
    [btn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        for (NSInteger i = 0; i < 5; i++) {
            if (i % 2 == 0) {
                [btn setImageWithURL:[NSURL URLWithString:@"http://www.gouzd.com/images/5159-37.jpg"] placeholderImage:[UIImage imageWithColor:[UIColor yellowColor]] forState:UIControlStateNormal];
            } else {
                [btn setImageWithURL:[NSURL URLWithString:@"http://www.huabian.com/uploadfile/2014/1229/20141229044200228.jpg"] placeholderImage:[UIImage imageWithColor:[UIColor yellowColor]] forState:UIControlStateNormal];
            }
        }
    }];
    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 300)];
//    [self.view addSubview:imageView];
////    imageView.image = [UIImage imageWithColor:[UIColor grayColor]];
//    [imageView setImageWithURL:[NSURL URLWithString:@"http://www.huabian.com/uploadfile/2014/1229/20141229044200228.jpg"] placeholderImage:[UIImage imageWithColor:[UIColor grayColor]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
