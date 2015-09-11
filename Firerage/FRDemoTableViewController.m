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
#import "NSString+Utils.h"

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
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(0, 0, 200, 300);
//    [self.view addSubview:btn];
//    [btn setImage:[UIImage imageWithColor:[UIColor redColor] size:CGSizeMake(200, 300) andRoundSize:0] forState:UIControlStateNormal];
//    
//    [btn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
//        for (NSInteger i = 0; i < 5; i++) {
//            if (i % 2 == 0) {
//                [btn setImageWithURLString:@"http://e.hiphotos.baidu.com/baike/w%3D268/sign=a81bc317caef76093c0b9e9916dfa301/95eef01f3a292df544116b9fbd315c6035a8736e.jpg" placeholderImage:[UIImage imageWithColor:[UIColor yellowColor]] forState:UIControlStateNormal];
//            } else {
//                [btn setImageWithURLString:@"http://e.hiphotos.baidu.com/baike/w%3D268/sign=a81bc317caef76093c0b9e9916dfa301/95eef01f3a292df544116b9fbd315c6035a8736e.jpg" placeholderImage:[UIImage imageWithColor:[UIColor yellowColor]] forState:UIControlStateNormal];
//            }
//        }
//    }];
    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 300)];
//    [self.view addSubview:imageView];
////    imageView.image = [UIImage imageWithColor:[UIColor grayColor]];
//    [imageView setImageWithURLString:@"http://www.huabian.com/uploadfile/2014/1229/20141229044200228.jpg" placeholderImage:[UIImage imageWithColor:[UIColor grayColor]]];
    
//    BOOL isHanYu = [@"12s#@我sdf" isHanYu];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
