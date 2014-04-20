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
//- (void)createLabel :(CGRect)frame :(NSString*)text
//{
//    UILabel *label = [[UILabel alloc]initWithFrame:frame];
//    label.text = text;
//    [self addSubview:label];
//}
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
    [self createLeftView:frame :address :@"地    址"];
}
- (void)createPassTextField:(CGRect)frame
{
    pass = [[UITextField alloc]initWithFrame:frame];
    pass.borderStyle = UITextBorderStyleBezel;
    pass.secureTextEntry = YES;
    [self addSubview:pass];
    [self createLeftView:frame :pass :@"密    码"];
}
- (void)createPassConfirmTextField:(CGRect)frame
{
    passConfirm = [[UITextField alloc]initWithFrame:frame];
    passConfirm.borderStyle = UITextBorderStyleBezel;
    passConfirm.secureTextEntry = YES;
    [self addSubview:passConfirm];
    [self createLeftView:frame :passConfirm :@"确    认"];
}
- (void)createGenderTextField:(CGRect)frame
{
    gender = [[UITextField alloc]initWithFrame:frame];
    gender.borderStyle = UITextBorderStyleBezel;
    [self addSubview:gender];
    [self createLeftView:frame :gender :@"性    别"];
    
}
- (void)createAgeTextField:(CGRect)frame
{
    age = [[UITextField alloc]initWithFrame:frame];
    age.borderStyle = UITextBorderStyleBezel;
    [self addSubview:age];
    [self createLeftView:frame :age :@"年    龄"];
}
- (void)createAccountTextField:(CGRect)frame
{
    account = [[UITextField alloc]initWithFrame:frame];
    account.borderStyle = UITextBorderStyleBezel;
    [self addSubview:account];
   // [self createLabel:CGRectMake(10, 20, 60, 30) :@"用户名:"];
    [self createLeftView:frame :account :@"用户名"];
}

- (void)createLeftView :(CGRect)frame :(UITextField*)field :(NSString*)text
{
    
    field.borderStyle = UITextBorderStyleRoundedRect;
    field.leftViewMode = UITextFieldViewModeAlways;
    field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 60, frame.size.height)];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.text = text;
    label.textColor = [UIColor colorWithRed:100/255.f green:100/255.f blue:100/255.f alpha:1.f];
    label.font = [UIFont systemFontOfSize:15.f];
    field.leftView = label;
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
