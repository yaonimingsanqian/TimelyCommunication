//
//  DataStorage.m
//  TimelyCommunication
//
//  Created by zhao on 14-3-9.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "DataStorage.h"
#import "Config.h"

static DataStorage *sharedInyance = nil;
@implementation DataStorage

+ (DataStorage*)sharedInstance
{
    if(!sharedInyance)
        sharedInyance = [[DataStorage alloc]init];
    return sharedInyance;
}
- (id)init
{
    self = [super init];
    if(self)
    {
        msgHelper = [[MsgSaveHelper alloc]init];
        conversationHelper = [[ConversationHelper alloc]init];
    }
    return self;
}
- (void)saveConversation:(NSString *)con
{
    [conversationHelper saveConversation:con];
}
- (void)queryConversation
{
    [conversationHelper queryConversation];
}
- (void)updateConversation :(NSString*)conversationName :(BOOL)isAdd
{
    [conversationHelper updateConversation:conversationName :isAdd];
}
- (int)queryNotReadCount :(NSString*)conversationName
{
    return [conversationHelper queryNotReadCount:conversationName];
}
- (void)queryConversationWithFinished:(queryFinished)result
{
    [conversationHelper queryConversationWithFinished:result];
}


- (BOOL)saveMsg :(BaseMesage*)msg
{
    return [msgHelper saveMsg:msg];
}
- (NSArray*)loadHistoryMsg :(NSString*)conversationId
{
    return [msgHelper loadHistoryMsg:conversationId];
}
- (void)loadHistoryMsg :(NSString*)conversationId :(LoadMsgComplete)complete
{
    [msgHelper loadHistoryMsg:conversationId :complete];
}
- (TextMessage*)queryLastMsg :(NSString*)username :(NSString*)conId
{
    return [msgHelper queryLastMsg:username :conId];
}


@end
