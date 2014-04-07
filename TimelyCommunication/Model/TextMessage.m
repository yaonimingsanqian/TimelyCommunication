//
//  TextMessage.m
//  HLPChatVoewDemo
//
//  Created by zhao on 14-1-5.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "TextMessage.h"
#import "ConversationMgr.h"
#import "Config.h"
#import "Conversation.h"
#import "DataStorage.h"
#import "ContactsMgr.h"

@implementation TextMessage

- (BOOL)isFromUserMyFriend :(NSString*)from
{
    return [[ContactsMgr sharedInstance] isContactExist:from];
}
- (void)doSelfThing
{
    
   
    
    NSString *fromwhere = [[self.from componentsSeparatedByString:@"@"] objectAtIndex:0];
    BOOL isFriendExist = [self isFromUserMyFriend:fromwhere];
    if(!isFriendExist)
    {
        [[DataStorage sharedInstance] deleteConversation:fromwhere :^(BOOL isSuccess) {
            [[DataStorage sharedInstance] deleteMsg:fromwhere :nil];
        }];
        [[Conversation sharedInstance] pushReject:fromwhere];
        return;
    }
    
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:kNewTextMsg,kRefreshtype,fromwhere,kMsgFrom, nil];
 
    BOOL isExcute = [[ConversationMgr sharedInstance] isConversationExist:fromwhere];
    if(!isExcute)
    {
        [[ConversationMgr sharedInstance].conversations addObject:self.conversationId];
    }
    [[DataStorage sharedInstance] saveMsg:self :^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kNewTextMsg object:info];
    }];
}
- (void)postLocalNotifaction
{
    UILocalNotification *noti = [[UILocalNotification alloc]init];
    noti.alertBody = [NSString stringWithFormat:@"%@:发来消息",[[self.from componentsSeparatedByString:@"@"] objectAtIndex:0]];
    noti.soundName = @"crunch.wav";//通知声音
    [[UIApplication sharedApplication] presentLocalNotificationNow:noti];
}
@end
