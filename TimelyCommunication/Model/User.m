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
#import "KeyChainHelper.h"
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

            
            [[KeyChainHelper sharedInstance] saveAccount:[self.username stringByAppendingString:[NSString stringWithFormat:@"@%@",kServerName]]];
            [[KeyChainHelper sharedInstance] savePass:self.password];
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
            
            PFQuery *fquery = [[PFQuery alloc]initWithClassName:@"social"];
            [fquery whereKey:@"username" equalTo:self.username];
            [fquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                PFObject *obj = [objects objectAtIndex:0];
                if([DataStorage sharedInstance].isDatabaseReady == NO)
                {
                    [[DataStorage sharedInstance] createDatabaseAndTables:self.username :^{
                        loginSuccess(nil);
                        NSArray *friendsInfo = obj[@"friends"];
                        [[DataStorage sharedInstance] saveContacts:friendsInfo :nil :nil];
                        iPhoneXMPPAppDelegate *delegate = (iPhoneXMPPAppDelegate*)[[UIApplication sharedApplication] delegate];
                        [delegate logout];
                        [delegate connect];
                    }];
                }else
                {
                    loginSuccess(nil);
                    NSArray *friendsInfo = obj[@"friends"];
                    [[DataStorage sharedInstance] saveContacts:friendsInfo :nil :nil];
                    iPhoneXMPPAppDelegate *delegate = (iPhoneXMPPAppDelegate*)[[UIApplication sharedApplication] delegate];
                    [delegate logout];
                    [delegate connect];
                }
                
            }];
            
            
        }
        else
        {
            loginFailed(error);
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
            [[KeyChainHelper sharedInstance] saveAccount:[self.username stringByAppendingString:[NSString stringWithFormat:@"@%@",kServerName]]];
            [[KeyChainHelper sharedInstance] savePass:self.password];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerSuccess) name:kRegisterSuccess object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerUnSuccess) name:kRegisterFailed object:nil];
            
           
            PFObject *obj = [[PFObject alloc]initWithClassName:@"social"];
            obj[@"username"] = self.username;
            obj[@"addme"] = [NSArray array];
            obj[@"friends"] = [NSArray arrayWithObject:@"admin"];

            [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(succeeded)
                {
                    iPhoneXMPPAppDelegate *delegate = (iPhoneXMPPAppDelegate*)[[UIApplication sharedApplication] delegate];
                    [delegate anonymousConnection];
                }else
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kRegisterFailed object:nil];
                }
            }];
            
        } else {
            pFailed(error);
        }
    }];
}
@end
