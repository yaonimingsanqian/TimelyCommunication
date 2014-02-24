//
//  LoginViewController.m
//  TimelyCommunication
//
//  Created by zhao on 14-2-24.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "LoginViewController.h"
#import "SMRequestOptions.h"
#import "SMClient.h"
@interface LoginViewController ()

@end

@implementation LoginViewController
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}
#pragma mark - 私有
- (void)loginAction
{
    [[SMClient defaultClient]loginWithUsername:[loginView account] password:[loginView password] onSuccess:^(NSDictionary *result) {
        NSLog(@"登陆成功");
    } onFailure:^(NSError *error) {
        NSLog(@"登陆失败");
    }];
}
- (void)registerAction
{
    SMRequestOptions *option = [SMRequestOptions optionsWithHTTPS];
    NSDictionary *user = [NSDictionary dictionaryWithObjectsAndKeys:[loginView account],@"username",[loginView password],@"password", nil];
    [[[SMClient defaultClient]dataStore] createObject:user inSchema:@"user" options:option onSuccess:^(NSDictionary *object, NSString *schema_) {
        NSLog(@"注册成功");
    } onFailure:^(NSError *error, NSDictionary *object, NSString *schema_) {
        NSLog(@"error");
    }];
}
- (void)tapGestureAction
{
    [loginView resignFirstResponder];
}
#pragma mark - 系统
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)addTapGesture :(UIView*)view
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction)];
    [view addGestureRecognizer:tap];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    loginView = [[LoginView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    [loginView createAccountField:CGRectMake(60, 100, 200, 30) :1];
    [loginView createPasswordField:CGRectMake(60, 160, 200, 30) :1];
    [loginView createLoginBtn:CGRectMake(80, 220, 60, 30) :UIButtonTypeCustom :self :@selector(loginAction) :UIControlEventTouchUpInside];
    [loginView createRegisterBtn:CGRectMake(170, 220, 60, 30) :UIButtonTypeCustom :self :@selector(registerAction) :UIControlEventTouchUpInside];
    [loginView setTextFieldDelegate:self];
    [self addTapGesture:loginView];
    [self.view addSubview:loginView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
