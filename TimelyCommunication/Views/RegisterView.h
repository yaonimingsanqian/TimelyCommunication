//
//  RegisterView.h
//  TimelyCommunication
//
//  Created by zhao on 14-2-24.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterView : UIScrollView
{
    UITextField *account;
    UITextField *age;
    UITextField *address;
    UITextField *gender;
    UITextField *pass;
    UITextField *passConfirm;
}
@property (nonatomic,strong) UITextField *account;
@property (nonatomic,strong) UITextField *age;
@property (nonatomic,strong) UITextField *address;
@property (nonatomic,strong) UITextField *gender;
@property (nonatomic,strong) UITextField *pass;
@property (nonatomic,strong) UITextField *passConfirm;
@property (nonatomic,strong) UIButton *registerBtn;
- (void)createAccountTextField :(CGRect)frame;
- (void)createAgeTextField :(CGRect)frame;
- (void)createAddressTextField :(CGRect)frame;
- (void)createGenderTextField :(CGRect)frame;
- (void)createPassTextField :(CGRect)frame;
- (void)createPassConfirmTextField :(CGRect)frame;
- (void)hideKeyboard;

@end
