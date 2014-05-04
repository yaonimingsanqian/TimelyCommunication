//
//  RegisterTableViewCell.m
//  TimelyCommunication
//
//  Created by zhao on 14-5-3.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "RegisterTableViewCell.h"

@implementation RegisterTableViewCell
@synthesize item=_item;
@synthesize placeHolder=_placeHolder;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _item = [[UITextField alloc]initWithFrame:CGRectMake((320-240)/2, (self.frame.size.height-30)/2.f, 240, 30)];
        _item.borderStyle = UITextBorderStyleRoundedRect;
        _item.leftViewMode = UITextFieldViewModeAlways;
        [self.contentView addSubview:_item];
    }
    return self;
}
- (void)setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder = placeHolder;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 60, 40)];
    label.text = placeHolder;
    _item.leftView = label;
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

@end
