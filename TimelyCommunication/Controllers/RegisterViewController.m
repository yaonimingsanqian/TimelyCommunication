//
//  RegisterViewController.m
//  TimelyCommunication
//
//  Created by zhao on 14-2-24.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "RegisterViewController.h"
#import "MBProgressHUD.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

#pragma mark - private
- (void)tapAction
{
    [registerView hideKeyboard];
}
- (void)addTapGesture :(UIView*)view
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [view addGestureRecognizer:tap];
}
-(void)keyboardHide :(NSNotification*)noti
{
    [registerView scrollRectToVisible:CGRectMake(0, 0, 320, 480) animated:YES];
}
- (void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)registerAction
{
    user = nil;
    user = [[User alloc]init];
    user.username = [registerView.account text];
    user.password = [registerView.pass text];
    user.age = [registerView.age text];
    user.gender = [registerView.gender text];
    user.address = [registerView.address text];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    RegisterViewController __weak *tmp = self;
    [user registerUser:^(NSDictionary *success) {
        [MBProgressHUD hideHUDForView:tmp.view animated:YES];
         [tmp.navigationController popViewControllerAnimated:YES];
    } :^(NSError *error) {
         [MBProgressHUD hideHUDForView:tmp.view animated:YES];
        [tmp.navigationController popViewControllerAnimated:YES];
    }];
    
    
}
#pragma mark - public
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)createRegisterButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(278, 0, 25, 25);
    [button setBackgroundImage:[UIImage imageNamed:@"register.png"] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
}
- (void)createBackBtn
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    registerView = [[RegisterView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    registerView.contentSize = CGSizeMake(320, 640);
    
    [registerView createAccountTextField:CGRectMake(70, 20, 200, 30)];
    
    [registerView createPassTextField:CGRectMake(70, 70, 200, 30)];
    [registerView createPassConfirmTextField:CGRectMake(70, 120, 200, 30)];
    [registerView createAddressTextField:CGRectMake(70, 170, 200, 30)];
    [registerView createAgeTextField:CGRectMake(70, 220, 200, 30)];
    [registerView createGenderTextField:CGRectMake(70, 270, 200, 30)];
    [self addTapGesture:registerView];
    [self.view addSubview:registerView];
    registerView.address.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    [self createBackBtn];
    [self createRegisterButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [registerView setContentOffset:CGPointMake(0, 40) animated:YES];
}
@end
