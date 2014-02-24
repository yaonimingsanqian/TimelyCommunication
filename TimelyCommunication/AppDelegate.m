//
//  AppDelegate.m
//  HLPChatVoewDemo
//
//  Created by zhao on 14-1-5.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "AppDelegate.h"
//#import "MainPageViewController.h"
//#import "ConversationListVC.h"
#import "LoginViewController.h"

@implementation AppDelegate

- (UIViewController*)createVCAccordingTag :(int)tag
{
    UIViewController *controller = nil;
    switch (tag)
    {
        case 100:
            controller = [[UIViewController alloc]init];
            break;
            
        default:
            controller = [[UIViewController alloc]init];
            break;
    }
    return controller;
}
- (UINavigationController*)createTabBarItem :(NSString*)title :(NSString*)imageName :(int)tag
{
    UIViewController *conversationList = [self createVCAccordingTag:tag];
    
    conversationList.view.backgroundColor=[UIColor whiteColor];
    conversationList.tabBarItem=[[UITabBarItem alloc]initWithTitle:title image:[UIImage imageNamed:imageName] tag:tag];
    
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:conversationList];
    UILabel *naviTitle = [[UILabel alloc]initWithFrame:CGRectMake(140, 10, 100, 20)];
    naviTitle.text = title;
   // navi.navigationBar.tintColor = [UIColor blackColor];
    [navi.navigationBar addSubview:naviTitle];
    return navi;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
 //   UITabBarController *tabBarController=[[UITabBarController alloc] init];
    
//    self.conversationNavi = [self createTabBarItem:@"会话" :@"chat.png" :100];
//    self.contactNavi = [self createTabBarItem:@"通讯录" :@"contact.png" :101];
//    self.searchNavi = [self createTabBarItem:@"发现" :@"search.png" :102];
//    self.meNavi = [self createTabBarItem:@"我" :@"me.png" :103];
//    
//    NSMutableArray *controllers=[[NSMutableArray alloc]initWithObjects:self.conversationNavi,self.self.contactNavi,self.searchNavi,self.meNavi,nil];
//    [tabBarController setViewControllers:controllers];
//    tabBarController.delegate=self;
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[LoginViewController alloc]init];
    [self.window makeKeyAndVisible];
    // Assuming your variable is declared SMClient *client;
    self.client = [[SMClient alloc] initWithAPIVersion:@"0" publicKey:@"516d1971-6d5e-40c1-995b-27e9034f94bc"];

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
