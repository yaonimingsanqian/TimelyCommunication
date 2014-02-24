//
//  Login.m
//  TimelyCommunication
//
//  Created by zhao on 14-2-24.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "Login.h"
#import "SMClient.h"

@implementation Login

- (void)login:(LoginSuccess)success :(LoginFailed)failed
{
    loginSuccess = success;
    loginFailed = failed;
    [[SMClient defaultClient]loginWithUsername:self.account password:self.password onSuccess:^(NSDictionary *result) {
        loginSuccess(result);
    } onFailure:^(NSError *error) {
        loginFailed(error);
    }];
}
@end
