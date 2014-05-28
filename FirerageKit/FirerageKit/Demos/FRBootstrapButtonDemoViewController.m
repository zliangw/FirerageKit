//
//  FRBootstrapButtonDemoViewController.m
//  FirerageKit
//
//  Created by Aidian.Tang on 14-5-26.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "FRBootstrapButtonDemoViewController.h"
#import "FRBootstrapButton.h"
#import "UILabel+FRFitSize.h"
#import "FRFlatSegmentedControl.h"

@interface FRBootstrapButtonDemoViewController ()

@property (nonatomic, strong) IBOutlet UILabel *label;

@end

@implementation FRBootstrapButtonDemoViewController

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
    [[FRBootstrapButton appearance] setButtonCornerRadius:[NSNumber numberWithFloat:0.0f]];
    [[FRBootstrapButton appearance] setBootstrapV3BorderWidth:0.1];
    
    _label.text = @"sdfjsalkfjlsdakfjlksdjflkdsjfklsdfjdskfjlsfjsadklfjdslkfjsaljdskfjslfjsdlkfjdksljfklds";
    //[_label constrainedToSize:CGSizeMake(40, 100)];
    
    FRFlatSegmentedControl *flatSegmentedControl = [[FRFlatSegmentedControl alloc] initWithFrame:CGRectMake(50, 100, 200, 30)];
    flatSegmentedControl.itemTitles = [NSArray arrayWithObjects:@"Stream", @"Mixer", nil];
    [self.view addSubview:flatSegmentedControl];
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
