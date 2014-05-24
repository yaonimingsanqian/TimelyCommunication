//
//  KeyChainHelper.h
//  TimelyCommunication
//
//  Created by zhao on 14-5-24.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainHelper : NSObject
+ (instancetype)sharedInstance;
- (void)reset;
- (void)saveAccount :(NSString*)acc;
- (void)savePass :(NSString*)pass;
- (NSString*)getAccount;
- (NSString*)getPass;
@end
