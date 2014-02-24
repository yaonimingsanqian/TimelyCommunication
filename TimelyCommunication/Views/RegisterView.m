//
//  RegisterView.m
//  TimelyCommunication
//
//  Created by zhao on 14-2-24.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "RegisterView.h"

@implementation RegisterView

#pragma mark - private
- (void)createLabel :(CGRect)frame :(NSString*)text
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = text;
    [self addSubview:label];
}
- (void)createTextField :(CGRect)frame :(UITextField*)textField
{
    textField = [[UITextField alloc]initWithFrame:frame];
    textField.borderStyle = UITextBorderStyleBezel;
    [self addSubview:textField];
}
#pragma mark - public
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
