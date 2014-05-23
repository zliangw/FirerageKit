//
//  FRFRBannerViewDemoViewController.m
//  FirerageKit
//
//  Created by Aidian.Tang on 14-5-22.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "FRFRBannerViewDemoViewController.h"
#import "FRBannerView.h"
#import "UIView+FRLayout.h"

@interface FRFRBannerViewDemoViewController ()

@property (nonatomic, strong) IBOutlet FRBannerView *bannerView1;

@end

@implementation FRFRBannerViewDemoViewController

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
    NSMutableArray *bannerItems = [NSMutableArray array];
    
    [bannerItems addObject:[FRBannerItem bannerItemWithImageName:nil imageURL:@"http://pic05.babytreeimg.com/foto3/photos/2014/0124/88/2/4170109a13aca59db86761_b.png" placeholderImageName:nil]];
    [bannerItems addObject:[FRBannerItem bannerItemWithImageName:nil imageURL:@"http://pic01.babytreeimg.com/foto3/photos/2014/0124/18/3/4170109a253ca5b0d88192_b.png" placeholderImageName:nil]];
    [bannerItems addObject:[FRBannerItem bannerItemWithImageName:nil imageURL:@"http://pic05.babytreeimg.com/foto3/photos/2014/0124/88/2/4170109a13aca59db86761_b.png" placeholderImageName:nil]];
    [bannerItems addObject:[FRBannerItem bannerItemWithImageName:nil imageURL:@"http://pic01.babytreeimg.com/foto3/photos/2014/0124/18/3/4170109a253ca5b0d88192_b.png" placeholderImageName:nil]];
    
    _bannerView1.bannerItems = bannerItems;
    [_bannerView1 reloadData];
    
    FRBannerView *bannerView2 = [[FRBannerView alloc] initWithFrame:CGRectMake(0, _bannerView1.bottom + 30, 320, 70) direction:RBannerViewDefaultDirection bannerItems:bannerItems];
    bannerView2.autoRollingDelayTime = 4;
    [self.view addSubview:bannerView2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
