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
    [self createLabel:CGRectMake(20, 100, 40, 30) :@"帐户:"];
}
- (void)addpassLabel
{
    [self createLabel:CGRectMake(20, 160, 40, 30) :@"密码:"];
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
    btn.backgroundColor = [UIColor greenColor];
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
    account.borderStyle = UITextBorderStyleBezel;
    [self addSubview:account];
    [self addAccountLabel];
}
- (void)createPasswordField:(CGRect)frame :(int)tag
{
    password = [[UITextField alloc]initWithFrame:frame];
    password.borderStyle = UITextBorderStyleBezel;
    password.secureTextEntry = YES;
    [self addSubview:password];
    [self addpassLabel];
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
