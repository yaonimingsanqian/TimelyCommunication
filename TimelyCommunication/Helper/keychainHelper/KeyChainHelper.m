//
//  KeyChainHelper.m
//  TimelyCommunication
//
//  Created by zhao on 14-5-24.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "KeyChainHelper.h"
#import "KeychainItemWrapper.h"

@implementation KeyChainHelper

SHARED_INSTANCE_GCD_USING_BLOCK(^{
    return [[self alloc]init];
})
- (void)reset
{
     KeychainItemWrapper *wapper = [[KeychainItemWrapper alloc]initWithIdentifier:@"openfireZhao" accessGroup:nil];
    [wapper resetKeychainItem];
}
- (void)saveAccount :(NSString*)acc
{
    KeychainItemWrapper *wapper = [[KeychainItemWrapper alloc]initWithIdentifier:@"openfireZhao" accessGroup:nil];
    [wapper setObject:acc forKey:(__bridge id)(kSecAttrAccount)];
}
- (void)savePass :(NSString*)pass
{
    
    KeychainItemWrapper *wapper = [[KeychainItemWrapper alloc]initWithIdentifier:@"openfireZhao" accessGroup:nil];
    [wapper setObject:pass forKey:(__bridge id)(kSecValueData)];
}
- (NSString*)getAccount
{
    KeychainItemWrapper *wapper = [[KeychainItemWrapper alloc]initWithIdentifier:@"openfireZhao" accessGroup:nil];
    return [wapper objectForKey:(__bridge id)(kSecAttrAccount)];
}
- (NSString*)getPass
{
    KeychainItemWrapper *wapper = [[KeychainItemWrapper alloc]initWithIdentifier:@"openfireZhao" accessGroup:nil];
    return [wapper objectForKey:(__bridge id)(kSecValueData)];
}
@end
