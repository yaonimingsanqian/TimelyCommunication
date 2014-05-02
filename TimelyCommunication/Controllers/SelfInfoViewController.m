//
//  SelfInfoViewController.m
//  TimelyCommunication
//
//  Created by zhao on 14-3-9.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "SelfInfoViewController.h"
#import "CommonData.h"
#import "SMClient.h"
#import "Config.h"
#import "iPhoneXMPPAppDelegate.h"
#import "LoginViewController.h"
#import "MBProgressHUD.h"
#import "ConversationMgr.h"
#import "AddFriendMgr.h"
#import "DataStorage.h"
#import "ContactsMgr.h"
#import "Conversation.h"
#import "CommonData.h"
#import "NavigationControllerTitle.h"
@interface SelfInfoViewController ()

@end

@implementation SelfInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)logout:(UIButton *)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[SMClient defaultClient] logoutOnSuccess:^(NSDictionary *result) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kXMPPmyJID];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kXMPPmyPassword];
        iPhoneXMPPAppDelegate *delegate = (iPhoneXMPPAppDelegate*)[[UIApplication sharedApplication] delegate];
        [delegate logout];
        [[ConversationMgr sharedInstance] destoryData];
        [[ContactsMgr sharedInstance] destoryData];
        [[CommonData sharedCommonData] destoryData];
        [DataStorage destory];
        delegate.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[[LoginViewController alloc]init]];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } onFailure:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"退出失败" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
         [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.name.text = [CommonData sharedCommonData].curentUser.username;
    self.address.text = [CommonData sharedCommonData].curentUser.address;
    self.age.text = [CommonData sharedCommonData].curentUser.age;
    [NavigationControllerTitle showInView:self.navigationController.navigationBar :@"个人资料"];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [NavigationControllerTitle hide:self.navigationController.navigationBar];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    NSLog(@"SelfInfoViewController dealloc");
}
@end
