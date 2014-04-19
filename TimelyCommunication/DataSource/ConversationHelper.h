//
//  ConversationHelper.h
//  TimelyCommunication
//
//  Created by zhao on 14-3-9.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseQueue.h"


typedef void(^queryFinished)(NSArray *result);
@interface ConversationHelper : NSObject


- (void)saveConversation :(NSString*)con :(FMDatabaseQueue*)queue :(void(^)(void))complete;
- (void)queryConversation :(FMDatabaseQueue*)queue;
- (void)queryConversationWithFinished :(FMDatabaseQueue*)queue :(queryFinished)result;
- (void)updateConversation :(NSString*)conversationName :(BOOL)isAddv :(FMDatabaseQueue*)queue :(void(^)(int count))complete;
- (void)queryNotReadCount :(NSString*)conversationName :(FMDatabaseQueue*)queue :(void(^)(int count))result;
- (void)deleteConversation :(NSString*)name :(FMDatabaseQueue*)queue :(void(^)(BOOL isSuccess))finished;


@end
