//
//  FRBootstrapButtonDemoViewController.m
//  FirerageKit
//
//  Created by Aidian.Tang on 14-5-26.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "FRBootstrapButtonDemoViewController.h"
#import "BButton.h"
#import "UILabel+FRFitSize.h"
#import "FRFlatSegmentedControl.h"
#import "UIView+FRTouchBlock.h"
#import "FRCameraUtils.h"
#import "UIAlertView+FRUtils.h"
#import "FRDevice.h"
#import "FRPersistenceUtils.h"
#import "FRUser.h"
#import "UIViewController+FRProgressHUD.h"
#import "NSObject+FRBlock.h"

@interface FRBootstrapButtonDemoViewController ()

@property (nonatomic, strong) IBOutlet UILabel *label;

@end

@implementation FRBootstrapButtonDemoViewController

- (void)dealloc
{
    [FRCameraUtils releaseUtils];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[BButton appearance] setButtonCornerRadius:[NSNumber numberWithFloat:0.0f]];
    [[BButton appearance] setBootstrapV3BorderWidth:[NSNumber numberWithFloat:0]];
    
    _label.text = @"sdfjsalkfjlsdakfjlksdjflkdsjfklsdfjdskfjlsfjsadklfjdslkfjsaljdskfjslfjsdlkfjdksljfklds";
    //[_label constrainedToSize:CGSizeMake(40, 100)];
    
    FRFlatSegmentedControl *flatSegmentedControl = [[FRFlatSegmentedControl alloc] initWithFrame:CGRectMake(50, 100, 200, 30)];
    flatSegmentedControl.itemTitles = [NSArray arrayWithObjects:@"Stream", @"Mixer", nil];
    [self.view addSubview:flatSegmentedControl];
    
    __weak typeof(self) weakSelf = self;
    [self.view addSingleTapWithBlock:^(UIView *view) {
//        [FRCameraUtils showCameraInViewController:weakSelf sourceType:UIImagePickerControllerSourceTypeCamera allowsEditing:NO cameraDevice:UIImagePickerControllerCameraDeviceFront willShowedBlock:^{
//            
//        } canceledBlock:^{
//            
//        } finishedBlock:^(UIImage *image, NSDictionary *editingInfo) {
//            
//        }];
        
//        [UIAlertView showMessage:@"hello" withTitle:@"title" confirmTitle:@"ok" cancelTitle:@"cancel" confirmBlock:^(UIAlertView *alertView) {
//            
//        } cancelBlock:^(UIAlertView *alertView) {
//            
//        }];
//        
//        [UIAlertView showMessage:@"hello" withTitle:@"title" cancelTitle:@"cancel" otherTitles:[NSArray arrayWithObjects:@"1", @"2", nil] tapBlock:^(UIAlertView *alertView, NSInteger tapIndex) {
//            
//        }];
        
        
    }];
    
//    [FRDevice isDevice5];
    
    FRUser *user = [[FRUser alloc] init];
    user.sex = YES;
    user.name = @"MR";
    [FRPersistenceUtils archiveObject:user];
    
    FRUser *user2 = [FRPersistenceUtils unArchiveObjectByClass:[FRUser class]];
    NSLog(@"%d, %@", user2.sex, user2.name);
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

- (IBAction)testBtn:(id)sender
{
    self.successedHUDImageName = @"37x-Checkmark.png";
    
//    [self showHUDWithLabelText:@"Loading..."];
    
    [self showSuccessedToast:@"Complete" hideAfterDelay:4.];
    
    __weak typeof(self) weakSelf = self;
    [self performBlock:^{
//        UIImageView *imageView;
//        UIImage *image = [UIImage imageNamed:@"37x-Checkmark.png"];
//        imageView = [[UIImageView alloc] initWithImage:image];
//        [weakSelf changeHUDStateWithMode:FRProgressHUDModeCustomView labelText:@"Complete" customView:imageView];
        [weakSelf showSuccessedToast:@"Complete" hideAfterDelay:4.];
    } afterDelay:2.];
}

@end
