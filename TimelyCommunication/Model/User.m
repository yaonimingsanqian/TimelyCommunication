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
- (void)login:(LoginSuccess)success :(LoginFailed)failed
{
    loginSuccess = success;
    loginFailed = failed;
    User __weak *tmp = self;
    [[SMClient defaultClient]loginWithUsername:self.username password:self.password onSuccess:^(NSDictionary *result) {
        [self createUser:result];
        [[NSUserDefaults standardUserDefaults] setObject:[tmp.username stringByAppendingString:[NSString stringWithFormat:@"@%@",kServerName]] forKey:kXMPPmyJID];
        [[NSUserDefaults standardUserDefaults] setObject:tmp.password forKey:kXMPPmyPassword];
        iPhoneXMPPAppDelegate *delegate = (iPhoneXMPPAppDelegate*)[[UIApplication sharedApplication] delegate];
        [delegate connect];
        loginSuccess(result);
        [[ContactsMgr sharedInstance] parseFriends:result];
    } onFailure:^(NSError *error) {
        loginFailed(error);
    }];
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
    User __weak *tmp = self;
    [[[SMClient defaultClient]dataStore] createObject:user inSchema:@"user" options:option onSuccess:^(NSDictionary *object, NSString *schema_) {
        [[NSUserDefaults standardUserDefaults] setObject:[tmp.username stringByAppendingString:[NSString stringWithFormat:@"@%@",kServerName]] forKey:kXMPPmyJID];
        [[NSUserDefaults standardUserDefaults] setObject:tmp.password forKey:kXMPPmyPassword];
        
        iPhoneXMPPAppDelegate *delegate = (iPhoneXMPPAppDelegate*)[[UIApplication sharedApplication] delegate];
        [delegate anonymousConnection];
        [[NSNotificationCenter defaultCenter] addObserver:tmp selector:@selector(registerSuccess) name:kRegisterSuccess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:tmp selector:@selector(registerSuccess) name:kRegisterFailed object:nil];
        
    } onFailure:^(NSError *error, NSDictionary *object, NSString *schema_) {
        pFailed(error);
    }];
}
@end
