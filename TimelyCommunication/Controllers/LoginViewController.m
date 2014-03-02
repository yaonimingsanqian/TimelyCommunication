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
#import "MBProgressHUD.h"
#import "RegisterViewController.h"
#import "AppDelegate.h"
@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize loginView;
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}
#pragma mark - 私有
- (void)loginAction
{
    [MBProgressHUD showHUDAddedTo:loginView animated:YES ];
    login = [[User alloc]init];
    login.password = [loginView password];
    login.username = [loginView account];
    LoginViewController __weak *tmp = self;
    [login login:^(NSDictionary *success) {
        [MBProgressHUD hideAllHUDsForView:tmp.loginView animated:YES];
        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [delegate turnToMainPage];
    } :^(NSError *error) {
        
    }];
    
    
}
- (void)registerAction
{
    RegisterViewController *registerViewController = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:registerViewController animated:YES];
    

}
- (void)tapGestureAction
{
    [loginView resignFirstResponder];
}
#pragma mark - 系统
- (void)dealloc
{
    NSLog(@"LoginViewController dealloc");
}
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
