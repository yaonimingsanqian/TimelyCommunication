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
    textField.borderStyle = UITextBorderStyleLine;
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
    address.borderStyle = UITextBorderStyleLine;
    [self addSubview:address];
    address.placeholder = @"请输入地址";
    [self createLeftView:frame :address :@"地    址"];
}
- (void)createPassTextField:(CGRect)frame
{
    pass = [[UITextField alloc]initWithFrame:frame];
    pass.borderStyle = UITextBorderStyleLine;
    pass.secureTextEntry = YES;
    [self addSubview:pass];
    [self createLeftView:frame :pass :@"密    码"];
    pass.placeholder = @"请输入密码";
}
- (void)createPassConfirmTextField:(CGRect)frame
{
    passConfirm = [[UITextField alloc]initWithFrame:frame];
    passConfirm.borderStyle = UITextBorderStyleLine;
    passConfirm.secureTextEntry = YES;
    passConfirm.placeholder = @"请再次输入密码";
    [self addSubview:passConfirm];
    [self createLeftView:frame :passConfirm :@"确    认"];
}
- (void)createGenderTextField:(CGRect)frame
{
    gender = [[UITextField alloc]initWithFrame:frame];
    gender.borderStyle = UITextBorderStyleLine;
    gender.placeholder = @"请输入性别";
    [self addSubview:gender];
    [self createLeftView:frame :gender :@"性    别"];
    
}
- (void)createAgeTextField:(CGRect)frame
{
    age = [[UITextField alloc]initWithFrame:frame];
    age.borderStyle = UITextBorderStyleLine;
    [self addSubview:age];
    age.placeholder = @"请输入年龄";
    [self createLeftView:frame :age :@"年    龄"];
}
- (void)createAccountTextField:(CGRect)frame
{
    account = [[UITextField alloc]initWithFrame:frame];
    account.borderStyle = UITextBorderStyleLine;
    [self addSubview:account];
   // [self createLabel:CGRectMake(10, 20, 60, 30) :@"用户名:"];
    account.placeholder = @"请输入用户名";
    [self createLeftView:frame :account :@"用户名"];
}

- (void)createLeftView :(CGRect)frame :(UITextField*)field :(NSString*)text
{
    
    //field.borderStyle = UITextBorderStyleRoundedRect;
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
- (void)createRegisterBtn :(CGRect)frame :(id)target :(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor colorWithRed:53/255.f green:99/255.f blue:25/255.f alpha:1.f];
    [btn setTitle:@"注册" forState:UIControlStateNormal];
    btn.titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:btn];
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
