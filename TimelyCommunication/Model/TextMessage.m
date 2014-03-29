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
@implementation TextMessage

- (void)doSelfThing
{
    BOOL isExcute = NO;
    for (NSString *con in [ConversationMgr sharedInstance].conversations)
    {
        if([con isEqualToString:self.conversationId])
        {
            isExcute = YES;
            break;
        }
    }
    if(!isExcute)
        [[ConversationMgr sharedInstance].conversations addObject:self.conversationId];
    [[DataStorage sharedInstance] saveMsg:self];
    
    NSString *fromwhere = [[self.from componentsSeparatedByString:@"@"] objectAtIndex:0];
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:kNewTextMsg,kRefreshtype,fromwhere,kMsgFrom, nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNewTextMsg object:info];
}
- (void)postLocalNotifaction
{
    UILocalNotification *noti = [[UILocalNotification alloc]init];
    noti.alertBody = [NSString stringWithFormat:@"%@:发来消息",[[self.from componentsSeparatedByString:@"@"] objectAtIndex:0]];
    noti.soundName = @"crunch.wav";//通知声音
    [[UIApplication sharedApplication] presentLocalNotificationNow:noti];
}
@end
