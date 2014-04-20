//
//  Login.m
//  TimelyCommunication
//
//  Created by zhao on 14-2-24.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView


#pragma mark - 私有方法
- (void)createLabel :(CGRect)frame :(NSString*)text
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = text;
    [self addSubview:label];
}
- (void)addAccountLabel
{
   //[self createLabel:CGRectMake(20, 100, 40, 30) :@"帐户:"];
}
- (void)addpassLabel
{
   // [self createLabel:CGRectMake(20, 160, 40, 30) :@"密码:"];
}
#pragma mark - 接口
- (void)resignFirstResponder
{
    [password resignFirstResponder];
    [account resignFirstResponder];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)createBtn :(CGRect)frame :(UIButtonType)type :(id)target :(SEL)action :(UIControlEvents)event :(UIButton*)btn :(NSString*)title
{
    btn = [UIButton buttonWithType:type];
    btn.frame = frame;
    [btn addTarget:target action:action forControlEvents:event];
    btn.backgroundColor = [UIColor colorWithRed:53/255.f green:99/255.f blue:25/255.f alpha:1.f];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:btn];
}
- (void)createRegisterBtn:(CGRect)frame :(UIButtonType)type :(id)target :(SEL)action :(UIControlEvents)event
{
    [self createBtn:frame :type :target :action :event :registerBtn :@"注册"];
}
- (void)createLoginBtn:(CGRect)frame :(UIButtonType)type :(id)target :(SEL)action :(UIControlEvents)event
{
    [self createBtn:frame :type :target :action :event :login :@"登录"];
}
- (void)createAccountField:(CGRect)frmae :(int)tag
{
    account = [[UITextField alloc]initWithFrame:frmae];
    account.borderStyle = UITextBorderStyleRoundedRect;
    account.leftViewMode = UITextFieldViewModeAlways;
    account.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    account.placeholder = @"请输入用户名";
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, frmae.size.height)];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.text = @"账号";
    label.textColor = [UIColor colorWithRed:100/255.f green:100/255.f blue:100/255.f alpha:1.f];
    account.leftView = label;
    [self addSubview:account];
    [self addAccountLabel];
}
- (void)createPasswordField:(CGRect)frame :(int)tag
{
    password = [[UITextField alloc]initWithFrame:frame];
    password.borderStyle = UITextBorderStyleRoundedRect;
    password.secureTextEntry = YES;
    [self addSubview:password];
    password.placeholder = @"请输入密码";
    
    
    password.leftViewMode = UITextFieldViewModeAlways;
    password.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, frame.size.height)];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.text = @"密码";
    label.textColor = [UIColor colorWithRed:100/255.f green:100/255.f blue:100/255.f alpha:1.f];
    password.leftView = label;
}
- (BOOL)setTextFieldDelegate:(id<UITextFieldDelegate>)pTextFieldDelegate
{
    if(!password || !account)
        return NO;
    password.delegate = pTextFieldDelegate;
    account.delegate = pTextFieldDelegate;
    return YES;
}
- (NSString*)password
{
    return [password text];
}
- (NSString*)account
{
    return [account text];
}
@end
