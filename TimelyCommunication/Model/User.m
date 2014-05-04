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
    User __weak *tmp = self;
    [[SMClient defaultClient]loginWithUsername:self.username password:self.password onSuccess:^(NSDictionary *result) {
        [self createUser:result];
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccess object:nil];
        [[NSUserDefaults standardUserDefaults] setObject:[tmp.username stringByAppendingString:[NSString stringWithFormat:@"@%@",kServerName]] forKey:kXMPPmyJID];
        //[[NSUserDefaults standardUserDefaults] setObject:tmp.password forKey:kXMPPmyPassword];
        
        KeychainItemWrapper *wapper = [[KeychainItemWrapper alloc]initWithIdentifier:@"openfireZhao" accessGroup:nil];
        [wapper setObject:[tmp.username stringByAppendingString:[NSString stringWithFormat:@"@%@",kServerName]] forKey:(__bridge id)(kSecAttrAccount)];
        [wapper setObject:tmp.password forKey:(__bridge id)(kSecValueData)];
       
        if([DataStorage sharedInstance].isDatabaseReady == NO)
        {
            [[DataStorage sharedInstance] createDatabaseAndTables:self.username :^{
                loginSuccess(result);
                NSArray *friendsInfo = [result objectForKey:@"friends"];
                [[DataStorage sharedInstance] saveContacts:friendsInfo :nil :nil];
            }];
        }else
        {
            loginSuccess(result);
            NSArray *friendsInfo = [result objectForKey:@"friends"];
            [[DataStorage sharedInstance] saveContacts:friendsInfo :nil :nil];
        }
       
        
    } onFailure:^(NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginFailed object:nil];
        loginFailed(error);
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
    SMRequestOptions *option = [SMRequestOptions optionsWithHTTPS];
    NSMutableDictionary *user = [[NSMutableDictionary alloc]init];
    [user setValue:self.username forKey:@"username"];
    [user setValue:self.password forKey:@"password"];
    [user setValue:self.gender forKey:@"gender"];
    [user setValue:self.address forKey:@"address"];
    [user setValue:self.age forKey:@"age"];
    [user setValue:[NSArray arrayWithObject:@"admin"] forKey:@"friends"];
    [user setValue:nil forKey:@"addme"];
    [user setValue:nil forKey:@"addothers"];
    [user setValue:nil forKey:@"blacklis"];
    registerSuccess = success;
    registerFailed = pFailed;
    User __weak *tmp = self;
    [[[SMClient defaultClient]dataStore] createObject:user inSchema:@"user" options:option onSuccess:^(NSDictionary *object, NSString *schema_) {
        [[NSUserDefaults standardUserDefaults] setObject:[tmp.username stringByAppendingString:[NSString stringWithFormat:@"@%@",kServerName]] forKey:kXMPPmyJID];
        
        KeychainItemWrapper *wapper = [[KeychainItemWrapper alloc]initWithIdentifier:@"openfireZhao" accessGroup:nil];
        [wapper setObject:[tmp.username stringByAppendingString:[NSString stringWithFormat:@"@%@",kServerName]] forKey:(__bridge id)(kSecAttrAccount)];
        [wapper setObject:tmp.password forKey:(__bridge id)(kSecValueData)];
        
       // NSString *kSecAccount =  [wapper objectForKey:(__bridge id)(kSecAttrAccount)];
       // NSString *kSecPassword =  [wapper objectForKey:(__bridge id)(kSecValueData)];
        
        iPhoneXMPPAppDelegate *delegate = (iPhoneXMPPAppDelegate*)[[UIApplication sharedApplication] delegate];
        [delegate anonymousConnection];
        [[NSNotificationCenter defaultCenter] addObserver:tmp selector:@selector(registerSuccess) name:kRegisterSuccess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:tmp selector:@selector(registerUnSuccess) name:kRegisterFailed object:nil];
        
    } onFailure:^(NSError *error, NSDictionary *object, NSString *schema_) {
        pFailed(error);
    }];
}
@end
