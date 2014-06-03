//
//  FRLoadDataTableViewController.h
//  FirerageKit
//
//  Created by Aidian.Tang on 14-6-3.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRRefreshAndLoadMoreView.h"

@interface FRLoadDataTableViewController : UITableViewController

@property (nonatomic, assign) BOOL loadMoreShowed;
@property (nonatomic, strong, readonly) FRRefreshAndLoadMoreView *refreshAndLoadMoreView;

@end
