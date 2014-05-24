//
//  Login.m
//  TimelyCommunication
//
//  Created by zhao on 14-2-24.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "User.h"
#import "iPhoneXMPPAppDelegate.h"
#import "Config.h"
#import "ContactsMgr.h"
#import "CommonData.h"
#import "DataStorage.h"
#import "MBProgressHUD.h"
#import "KeychainItemWrapper.h"
#import <Parse/Parse.h>
@implementation User

- (void)dealloc
{
    NSLog(@"User dealloc");
}
- (void)createUser :(NSDictionary*)userInfo
{
    User *user = [[User alloc]init];
    user.username = [userInfo objectForKey:@"username"];
    user.password = [userInfo objectForKey:@"password"];
    user.address = [userInfo objectForKey:@"address"];
    user.gender = [userInfo objectForKey:@"gender"];
    [CommonData sharedCommonData].curentUser = user;
}
- (void)handleError :(NSError*)error
{
    NSDictionary *info = [error userInfo];
    if([info isKindOfClass:[NSDictionary class]])
    {
       
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message: [info objectForKey:@"NSLocalizedDescription"]delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
   
}
- (void)login:(LoginSuccess)success :(LoginFailed)failed
{
    
    loginSuccess = success;
    loginFailed = failed;
    
    
    [PFUser logInWithUsernameInBackground:self.username password:self.password block:^(PFUser *auser, NSError *error) {
        if (auser)
        {
            KeychainItemWrapper *wapper = [[KeychainItemWrapper alloc]initWithIdentifier:@"openfireZhao" accessGroup:nil];
            [wapper setObject:[self.username stringByAppendingString:[NSString stringWithFormat:@"@%@",kServerName]] forKey:(__bridge id)(kSecAttrAccount)];
            [wapper setObject:self.password forKey:(__bridge id)(kSecValueData)];
            User *user = [[User alloc]init];
            user.username = auser[@"username"];
            user.password = auser[@"password"];
            user.address = auser[@"address"];
            user.gender = auser[@"gender"];
            [CommonData sharedCommonData].curentUser = user;
            //
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccess object:nil];
            [[NSUserDefaults standardUserDefaults] setObject:[self.username stringByAppendingString:[NSString stringWithFormat:@"@%@",kServerName]] forKey:kXMPPmyJID];
            [[NSUserDefaults standardUserDefaults] setObject:self.password forKey:kXMPPmyPassword];
            
           
            
            if([DataStorage sharedInstance].isDatabaseReady == NO)
            {
                [[DataStorage sharedInstance] createDatabaseAndTables:self.username :^{
                    loginSuccess(nil);
                    NSArray *friendsInfo = auser[@"friends"];
                    [[DataStorage sharedInstance] saveContacts:friendsInfo :nil :nil];
                }];
            }else
            {
                loginSuccess(nil);
                NSArray *friendsInfo = auser[@"friends"];
                [[DataStorage sharedInstance] saveContacts:friendsInfo :nil :nil];
            }
        }
        else
        {
            
        }
        
    }];
}
- (void)registerUnSuccess
{
    registerFailed(nil);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRegisterSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRegisterFailed object:nil];
}
- (void)registerSuccess
{
    registerSuccess(nil);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRegisterSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRegisterFailed object:nil];
}
- (void)registerFailed
{
    registerFailed(nil);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRegisterSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRegisterFailed object:nil];
}
- (void)registerUser :(RegisterSuccess)success :(RegisterFailed)pFailed
{
    
    registerSuccess = success;
    registerFailed = pFailed;
    PFUser *pfUser = [PFUser user];
    pfUser.username = self.username;
    pfUser.password = self.password;
    pfUser[@"gender"] = self.gender;
    pfUser[@"address"] = self.address;
    pfUser[@"age"] = self.age;
    pfUser[@"friends"] = [NSArray arrayWithObject:@"admin"];
    pfUser[@"addme"] = [NSArray array];
    pfUser[@"addothers"] = [NSArray array];;
    pfUser[@"blacklist"] = [NSArray array];;
    
    
    [pfUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [[NSUserDefaults standardUserDefaults] setObject:[self.username stringByAppendingString:[NSString stringWithFormat:@"@%@",kServerName]] forKey:kXMPPmyJID];
            
            KeychainItemWrapper *wapper = [[KeychainItemWrapper alloc]initWithIdentifier:@"openfireZhao" accessGroup:nil];
            [wapper setObject:[self.username stringByAppendingString:[NSString stringWithFormat:@"@%@",kServerName]] forKey:(__bridge id)(kSecAttrAccount)];
            [wapper setObject:self.password forKey:(__bridge id)(kSecValueData)];
            
            // NSString *kSecAccount =  [wapper objectForKey:(__bridge id)(kSecAttrAccount)];
            // NSString *kSecPassword =  [wapper objectForKey:(__bridge id)(kSecValueData)];
            
            iPhoneXMPPAppDelegate *delegate = (iPhoneXMPPAppDelegate*)[[UIApplication sharedApplication] delegate];
            [delegate anonymousConnection];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerSuccess) name:kRegisterSuccess object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerUnSuccess) name:kRegisterFailed object:nil];
        } else {
            pFailed(error);
        }
    }];
}
@end
