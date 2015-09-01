//
//  FRTextViewTableViewCell.m
//  FirerageKit
//
//  Created by Aidian on 14-5-25.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import "FRTextViewTableViewCell.h"

@interface FRTextViewTableViewCell () <UITextViewDelegate>

@end

@implementation FRTextViewTableViewCell

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
#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    if (_delegate && [_delegate respondsToSelector:@selector(textViewTableViewCell:didReturnText:)]) {
        [_delegate textViewTableViewCell:self didReturnText:textView.text];
    }
}

@end
