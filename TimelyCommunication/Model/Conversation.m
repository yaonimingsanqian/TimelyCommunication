//
//  Conversation.m
//  HLPChatVoewDemo
//
//  Created by zhao on 14-1-5.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "Conversation.h"
#import "Config.h"
#import "iPhoneXMPPAppDelegate.h"

static Conversation *sharedInstance = nil;
@implementation Conversation

+ (Conversation*)sharedInstance
{
    if(!sharedInstance)
        sharedInstance = [[Conversation alloc]init];
    return sharedInstance;
}
- (id)init
{
    self = [super init];
    if(self)
    {
        msgSaveHelper = [[MsgSaveHelper alloc]init];
    }
    return self;
}
- (void)sendMessage:(TextMessage *)message
{
    iPhoneXMPPAppDelegate *delegate = (iPhoneXMPPAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate sendMsg:message];
}
- (void)saveMsg:(BaseMesage *)message
{
    [msgSaveHelper saveMsg:message];
}
- (NSArray*)loadHistoryMsg :(NSString*)username
{
    NSArray *msgs = [msgSaveHelper loadHistoryMsg:username];
    
    return msgs;
}
@end
