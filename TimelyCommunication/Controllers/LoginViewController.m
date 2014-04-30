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
#import "iPhoneXMPPAppDelegate.h"
#import "Config.h"
#import "DataStorage.h"
@interface LoginViewController ()
{
    MBProgressHUD *waiting;
}
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
    
    if([loginView password].length <= 0 || [loginView account].length <= 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入用户名和密码" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    waiting = [MBProgressHUD showHUDAddedTo:loginView animated:YES ];
    waiting.labelText = @"请稍后";
    login = [[User alloc]init];
    login.password = [loginView password];
    login.username = [[loginView account] lowercaseString];
    [loginView resignFirstResponder];
    [login login:^(NSDictionary *success) {
        
        [MBProgressHUD hideHUDForView:loginView animated:YES];
        iPhoneXMPPAppDelegate *delegate = (iPhoneXMPPAppDelegate*)[[UIApplication sharedApplication] delegate];
        [delegate connect];
        [delegate turnToMainPage];
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccess object:nil];
    } :^(NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginFailed object:nil];
         [MBProgressHUD hideHUDForView:loginView animated:YES];
        NSDictionary *userinfo = [error userInfo];
        NSString *msg = [userinfo objectForKey:@"NSLocalizedDescription"];
       
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }];
    
    
}
- (void)registerAction
{
    RegisterViewController *registerViewController = [[RegisterViewController alloc]init];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @"返回";
    registerViewController.navigationItem.backBarButtonItem = backItem;
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
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [NavigationControllerTitle hide:self.navigationController.navigationBar];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [NavigationControllerTitle showInView:self.navigationController.navigationBar :@"即时通信"];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    loginView = [[LoginView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    [loginView createAccountField:CGRectMake(30, 110, 260, 40) :1];
    [loginView createPasswordField:CGRectMake(30, 150, 260, 40) :1];
    [loginView createLoginBtn:CGRectMake(30, 220, 260, 40) :UIButtonTypeCustom :self :@selector(loginAction) :UIControlEventTouchUpInside];
    [loginView createRegisterBtn:CGRectMake(30, 280, 260, 40) :UIButtonTypeCustom :self :@selector(registerAction) :UIControlEventTouchUpInside];
    [loginView setTextFieldDelegate:self];
    [self addTapGesture:loginView];
    loginView.backgroundColor = [UIColor colorWithRed:237.f/255.f green:237.f/255.f blue:237.f/255.f alpha:1.f];
    [self.view addSubview:loginView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
