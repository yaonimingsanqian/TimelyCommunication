//
//  DataStorage.h
//  TimelyCommunication
//
//  Created by zhao on 14-3-9.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MsgSaveHelper.h"
#import "ConversationHelper.h"

@interface DataStorage : NSObject
{
    MsgSaveHelper *msgHelper;
    ConversationHelper *conversationHelper;
}
+ (DataStorage*)sharedInstance;
- (void)saveConversation :(NSString*)con;
- (void)queryConversation;
- (void)updateConversation :(NSString*)conversationName :(BOOL)isAdd;
- (int)queryNotReadCount :(NSString*)conversationName;
- (void)queryConversationWithFinished:(queryFinished)result;

- (BOOL)saveMsg :(BaseMesage*)msg;
- (NSArray*)loadHistoryMsg :(NSString*)conversationId;
- (void)loadHistoryMsg :(NSString*)conversationId :(LoadMsgComplete)complete;
- (TextMessage*)queryLastMsg :(NSString*)username :(NSString*)conId;

@end
