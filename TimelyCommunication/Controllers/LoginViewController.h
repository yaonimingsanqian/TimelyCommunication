//
//  LoginViewController.h
//  TimelyCommunication
//
//  Created by zhao on 14-2-24.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "LoginView.h"
@interface LoginViewController : UIViewController<UITextFieldDelegate>
{
    User *login;
    LoginView *loginView;
}
@property (nonatomic,strong) LoginView *loginView;
@end
