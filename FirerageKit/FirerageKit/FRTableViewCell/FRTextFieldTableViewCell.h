//
//  FRTextFieldTableViewCell.h
//  FirerageKit
//
//  Created by Aidian on 14-5-25.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FRTextFieldTableViewCellDelegate;

@interface FRTextFieldTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet id<FRTextFieldTableViewCellDelegate> delegate;
@property (nonatomic, strong) IBOutlet UITextField *textField;

@end

@protocol FRTextFieldTableViewCellDelegate <NSObject>

- (void)textFieldTableViewCell:(FRTextFieldTableViewCell *)textFieldTableViewCell didReturnText:(NSString *)text;

@end
