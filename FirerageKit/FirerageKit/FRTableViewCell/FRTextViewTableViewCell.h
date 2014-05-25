//
//  FRTextViewTableViewCell.h
//  FirerageKit
//
//  Created by Aidian on 14-5-25.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCPlaceholderTextView.h"

@protocol FRTextViewTableViewCellDelegate;

@interface FRTextViewTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet id<FRTextViewTableViewCellDelegate> delegate;
@property (nonatomic, strong) IBOutlet GCPlaceholderTextView *textView;

@end

@protocol FRTextViewTableViewCellDelegate <NSObject>

- (void)textViewTableViewCell:(FRTextViewTableViewCell *)textViewTableViewCell didReturnText:(NSString *)text;

@end
