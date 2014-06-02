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
#import "DeleteContactMsg.h"
#import "ApplyMsg.h"
#import "RejectMsg.h"
static Conversation *sharedInstance = nil;

typedef enum{
    DeleteContactMsgType = 0,
    AgreenMsgType,
    ApplyMsgType,
    Reject,
    Enter
}PushMsgType;
@implementation Conversation
+ (void)destory
{
    
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
- (BaseMesage*)createMsg :(PushMsgType)type :(NSString*)to
{
    BaseMesage *message = nil;
    switch (type) {
        case DeleteContactMsgType:
        {
            message = [[DeleteContactMsg alloc]init];
             message.msgContent = @"我已经添删除你了";
        }
            break;
        case AgreenMsgType:
        {
            message = [[AgreenApplyMessage alloc]init];
            message.msgContent = @"我已经添加你为好友了";
        }
            break;
        case ApplyMsgType:
        {
            message = [[ApplyMsg alloc]init];
            message.msgContent = @"我想加你为好友";
        }
            break;
        case Reject:
        {
            message = [[RejectMsg alloc]init];
            message.msgContent = @"你还不是我的好友,请先加好友";
        }
        case Enter:
        {
            message = [[RejectMsg alloc]init];
            message.msgContent = @"对方正在输入...";
        }
            break;
        default:
            break;
    }
    message.type = MessageText;
    message.sendDate = [NSDate date];
    message.conversationId = to;
    message.to = to;
    message.from = [CommonData sharedCommonData].curentUser.username;
    message.isIncoming = NO;
    return message;
}
- (void)pushDeleteContact:(NSString *)uname
{
    BaseMesage *message = [self createMsg:DeleteContactMsgType :uname];
    iPhoneXMPPAppDelegate *delegate = (iPhoneXMPPAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate pushDeleteContactMsg:message];
}
- (void)pushEnter:(NSString *)uname
{
    BaseMesage *message = [self createMsg:Enter :uname];
    iPhoneXMPPAppDelegate *delegate = (iPhoneXMPPAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate pushEnter:message];
}
- (void)pushReject:(NSString *)uname
{
    BaseMesage *message = [self createMsg:Reject :uname];
    iPhoneXMPPAppDelegate *delegate = (iPhoneXMPPAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate pushReject:message];
}
- (void)pushApply:(NSString *)uname
{
    BaseMesage *message = [self createMsg:ApplyMsgType :uname];
    iPhoneXMPPAppDelegate *delegate = (iPhoneXMPPAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate pushApplay:message];
}
- (void)pushAgreen:(NSString *)uname
{
    BaseMesage *message = [self createMsg:AgreenMsgType :uname];
    iPhoneXMPPAppDelegate *delegate = (iPhoneXMPPAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate pushAgreenMsg:message];
    
    
}
@end
