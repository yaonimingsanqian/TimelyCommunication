//
//  Login.h
//  TimelyCommunication
//
//  Created by zhao on 14-2-24.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMClient.h"
#import "SMRequestOptions.h"

typedef void(^LoginSuccess)(NSDictionary *success);
typedef void(^LoginFailed)(NSError *error);
typedef void(^RegisterFailed)(NSError *error);
typedef void(^RegisterSuccess)(NSDictionary *success);
@interface User : NSObject
{
    LoginSuccess loginSuccess;
    LoginFailed loginFailed;
    RegisterFailed registerFailed;
    RegisterSuccess registerSuccess;
}

@property (nonatomic,copy) NSString *password;
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *age;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *gender;

- (void)login :(LoginSuccess)success :(LoginFailed)failed;
- (void)registerUser :(RegisterSuccess)success :(RegisterFailed)failed;
@end
