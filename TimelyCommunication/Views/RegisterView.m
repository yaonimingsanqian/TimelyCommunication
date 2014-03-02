//
//  RegisterView.m
//  TimelyCommunication
//
//  Created by zhao on 14-2-24.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "RegisterView.h"

@implementation RegisterView
@synthesize account,address,age,passConfirm,pass,gender,registerBtn;
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
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)createAddressTextField:(CGRect)frame
{
    address = [[UITextField alloc]initWithFrame:frame];
    address.borderStyle = UITextBorderStyleBezel;
    [self addSubview:address];
    [self createLabel:CGRectMake(10, 170,60, 30) :@"地    址:"];
}
- (void)createPassTextField:(CGRect)frame
{
    pass = [[UITextField alloc]initWithFrame:frame];
    pass.borderStyle = UITextBorderStyleBezel;
    [self addSubview:pass];
    [self createLabel:CGRectMake(10, 70,60, 30) :@"密    码:"];
}
- (void)createPassConfirmTextField:(CGRect)frame
{
    passConfirm = [[UITextField alloc]initWithFrame:frame];
    passConfirm.borderStyle = UITextBorderStyleBezel;
    [self addSubview:passConfirm];
    [self createLabel:CGRectMake(10, 120,60, 30) :@"确    认:"];
}
- (void)createGenderTextField:(CGRect)frame
{
    gender = [[UITextField alloc]initWithFrame:frame];
    gender.borderStyle = UITextBorderStyleBezel;
    [self addSubview:gender];
    [self createLabel:CGRectMake(10, 270,60, 30) :@"性    别:"];
    
}
- (void)createAgeTextField:(CGRect)frame
{
    age = [[UITextField alloc]initWithFrame:frame];
    age.borderStyle = UITextBorderStyleBezel;
    [self addSubview:age];
    [self createLabel:CGRectMake(10, 220,60, 30) :@"年    龄:"];
}
- (void)createAccountTextField:(CGRect)frame
{
    account = [[UITextField alloc]initWithFrame:frame];
    account.borderStyle = UITextBorderStyleBezel;
    [self addSubview:account];
    [self createLabel:CGRectMake(10, 20, 60, 30) :@"用户名:"];
}
- (void)hideKeyboard
{
    [age resignFirstResponder];
    [address resignFirstResponder];
    [pass resignFirstResponder];
    [passConfirm resignFirstResponder];
    [gender resignFirstResponder];
    [account resignFirstResponder];
    
}
@end
