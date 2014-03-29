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
#import "FMDataBaseQueue.h"
typedef void(^CreateComplete)(void);
@interface DataStorage : NSObject
{
    MsgSaveHelper *msgHelper;
    ConversationHelper *conversationHelper;
    FMDatabaseQueue *queue;
    CreateComplete createDatabaseAndTableComplete;
}
+ (DataStorage*)sharedInstance;
+ (void)destory;
- (void)saveConversation :(NSString*)con;
- (void)queryConversation;
- (void)updateConversation :(NSString*)conversationName :(BOOL)isAdd;
- (int)queryNotReadCount :(NSString*)conversationName;
- (void)queryConversationWithFinished:(queryFinished)result;

- (BOOL)saveMsg :(BaseMesage*)msg;
- (NSArray*)loadHistoryMsg :(NSString*)conversationId;
- (void)loadHistoryMsg :(NSString*)conversationId :(LoadMsgComplete)complete;
- (TextMessage*)queryLastMsg :(NSString*)username :(NSString*)conId;
- (void)createDatabaseAndTables :(NSString*)databaseName :(void(^)(void))complete;

@end
