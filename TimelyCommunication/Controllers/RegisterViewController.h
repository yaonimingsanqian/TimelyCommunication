//
//  RegisterViewController.h
//  TimelyCommunication
//
//  Created by zhao on 14-2-24.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterView.h"
#import "User.h"
@interface RegisterViewController : UIViewController<UITextFieldDelegate>
{
    RegisterView *registerView;
    User *user;
}
@end
