//
//  Login.h
//  TimelyCommunication
//
//  Created by zhao on 14-2-24.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginView : UIView
{
    UIButton *login;
    UIButton *registerBtn;
    UITextField *password;
    UITextField *account;
}
- (void)createLoginBtn :(CGRect)frame :(UIButtonType)type :(id)target :(SEL)action :(UIControlEvents)event;
- (void)createRegisterBtn:(CGRect)frame :(UIButtonType)type :(id)target :(SEL)action :(UIControlEvents)event;
- (void)createPasswordField :(CGRect)frame :(int)tag;
- (void)createAccountField :(CGRect)frmae  :(int)tag;
- (void)resignFirstResponder;
- (BOOL)setTextFieldDelegate:(id<UITextFieldDelegate>)pTextFieldDelegate;
- (NSString*)password;
- (NSString*)account;
@end
