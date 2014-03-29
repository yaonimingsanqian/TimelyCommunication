//
//  ConversationHelper.h
//  TimelyCommunication
//
//  Created by zhao on 14-3-9.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseHelper.h"
#import "FMDatabaseQueue.h"


typedef void(^queryFinished)(NSArray *result);
@interface ConversationHelper : BaseHelper


- (void)saveConversation :(NSString*)con :(FMDatabaseQueue*)queue;
- (void)queryConversation;
- (void)queryConversationWithFinished:(queryFinished)result;
- (void)updateConversation :(NSString*)conversationName :(BOOL)isAdd;
- (int)queryNotReadCount :(NSString*)conversationName;


@end
