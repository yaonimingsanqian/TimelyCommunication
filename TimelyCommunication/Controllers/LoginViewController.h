//
//  LoginViewController.h
//  TimelyCommunication
//
//  Created by zhao on 14-2-24.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Login.h"
#import "LoginView.h"
@interface LoginViewController : UIViewController<UITextFieldDelegate>
{
    Login *login;
    LoginView *loginView;
}
@end
