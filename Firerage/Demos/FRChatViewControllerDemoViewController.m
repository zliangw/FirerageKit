//
//  FRChatViewControllerDemoViewController.m
//  FirerageKit
//
//  Created by Aidian on 14-5-24.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "FRChatViewControllerDemoViewController.h"
#import "MJRefresh.h"

@interface FRChatViewControllerDemoViewController ()

@end

@implementation FRChatViewControllerDemoViewController

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
    self.inputViewBorderColor = [UIColor clearColor];
    self.inputContainerSeparatorColor = [UIColor redColor];
    self.inputViewFont = [UIFont systemFontOfSize:14];
    self.inputViewPlaceholder = @"请输入文字";
    self.inputViewTintColor = [UIColor redColor];
    
    __weak typeof(self) weakSelf = self;
    [self.bubbleTable addLegendHeaderWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.bubbleTable.header endRefreshing];
        });
    }];
    
    
    NSBubbleData *heyBubble = [NSBubbleData dataWithText:@"Hey, halloween is soon" date:[NSDate dateWithTimeIntervalSinceNow:1] type:BubbleTypeSomeoneElse];
    heyBubble.avatar = [UIImage imageNamed:@"avatar"];
    
    NSBubbleData *photoBubble = [NSBubbleData dataWithImage:[UIImage imageNamed:@"avatar"] date:[NSDate dateWithTimeIntervalSinceNow:2] type:BubbleTypeSomeoneElse];
    
    NSBubbleData *replyBubble = [NSBubbleData dataWithText:@"Wow.. Really cool picture out there. iPhone 5 has really nice camera, yeah?" date:[NSDate dateWithTimeIntervalSinceNow:5] type:BubbleTypeMine];
    
    NSBubbleData *replyBubble2 = [NSBubbleData dataWithText:@"Wow.. Really cool picture out there. iPhone 5 has really nice camera, yeah?" date:[NSDate dateWithTimeIntervalSinceNow:10] type:BubbleTypeMine];
    
    
    NSBubbleData *replyBubble3 = [NSBubbleData dataWithText:@"Wow.. Really cool picture out there. iPhone 5 has really nice camera, yeah?" date:[NSDate dateWithTimeIntervalSinceNow:20] type:BubbleTypeMine];
    
    NSBubbleData *replyBubble4 = [NSBubbleData dataWithText:@"Wow.. Really cool picture out there. iPhone 5 has really nice camera, yeah?" date:[NSDate dateWithTimeIntervalSinceNow:30] type:BubbleTypeMine];
    
    NSBubbleData *replyBubble5 = [NSBubbleData dataWithText:@"Wow.. Really cool picture out there. iPhone 5 has really nice camera, yeah?" date:[NSDate dateWithTimeIntervalSinceNow:40] type:BubbleTypeMine];
    
    NSBubbleData *replyBubble6 = [NSBubbleData dataWithText:@"Wow.. Really cool picture out there. iPhone 5 has really nice camera, yeah?" date:[NSDate dateWithTimeIntervalSinceNow:44] type:BubbleTypeMine];
    
    NSMutableArray *bubbleDatas = [[NSMutableArray alloc] initWithObjects:heyBubble, photoBubble, replyBubble, replyBubble2, replyBubble3, replyBubble4, replyBubble5, replyBubble6, nil];
    
    self.bubbleDatas = bubbleDatas;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
