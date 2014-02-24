//
//  Login.h
//  TimelyCommunication
//
//  Created by zhao on 14-2-24.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LoginSuccess)(NSDictionary *success);
typedef void(^LoginFailed)(NSError *error);
@interface Login : NSObject
{
    LoginSuccess loginSuccess;
    LoginFailed loginFailed;
}

@property (nonatomic,copy) NSString *password;
@property (nonatomic,copy) NSString *account;
- (void)login :(LoginSuccess)success :(LoginFailed)failed;
@end
