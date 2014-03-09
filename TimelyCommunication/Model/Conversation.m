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
#import "CommonData.h"
#import "AgreenApplyMessage.h"
static Conversation *sharedInstance = nil;
@implementation Conversation

+ (void)destory
{
    sharedInstance = nil;
}
+ (Conversation*)sharedInstance
{
    if(!sharedInstance)
        sharedInstance = [[Conversation alloc]init];
    return sharedInstance;
}
- (void)sendMessage:(TextMessage *)message
{
    iPhoneXMPPAppDelegate *delegate = (iPhoneXMPPAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate sendMsg:message];
}
- (void)pushAgreen:(NSString *)uname
{
    AgreenApplyMessage *message = [[AgreenApplyMessage alloc]init];
    message.msgContent = @"我已经添加你为好友了";
    message.type = MessageText;
    message.sendDate = [NSDate date];
    message.conversationId = uname;
    message.to = uname;
    message.from = [CommonData sharedCommonData].curentUser.username;
    message.isIncoming = NO;
    iPhoneXMPPAppDelegate *delegate = (iPhoneXMPPAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate pushAgreenMsg:message];
    
    
}
@end
