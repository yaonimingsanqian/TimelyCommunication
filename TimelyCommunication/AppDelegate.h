//
//  AppDelegate.h
//  HLPChatVoewDemo
//
//  Created by zhao on 14-1-5.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *conversationNavi;
@property (strong, nonatomic) UINavigationController *contactNavi;
@property (strong, nonatomic) UINavigationController *searchNavi;
@property (strong, nonatomic) UINavigationController *meNavi;
@end
