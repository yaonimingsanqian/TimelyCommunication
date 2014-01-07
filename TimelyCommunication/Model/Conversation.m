//
//  Conversation.m
//  HLPChatVoewDemo
//
//  Created by zhao on 14-1-5.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "Conversation.h"
#import "Config.h"

@implementation Conversation

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
    
}
- (void)saveMsg:(BaseMesage *)message
{
    [msgSaveHelper createDataBase:kMsgTableName];
    [msgSaveHelper saveMsg:message];
}
- (NSArray*)loadHistoryMsg
{
    NSArray *msgs = [msgSaveHelper loadHistoryMsg:@"test"];
    
    return msgs;
}
@end
