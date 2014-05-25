//
//  FRTextFieldTableViewCell.m
//  FirerageKit
//
//  Created by Aidian on 14-5-25.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "FRTextFieldTableViewCell.h"

@interface FRTextFieldTableViewCell () <UITextFieldDelegate>

@end

@implementation FRTextFieldTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (_delegate && [_delegate respondsToSelector:@selector(textFieldTableViewCell:didReturnText:)]) {
        [_delegate textFieldTableViewCell:self didReturnText:textField.text];
    }
    [textField resignFirstResponder];
    return YES;
}

@end
