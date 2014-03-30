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
- (void)saveConversation :(NSString*)con :(void(^)(void))complete;
- (void)queryConversation;
- (void)updateConversation :(NSString*)conversationName :(BOOL)isAdd;
- (void)queryNotReadCount :(NSString*)conversationName :(void(^)(int count))result;
- (void)queryConversationWithFinished:(queryFinished)result;

- (BOOL)saveMsg :(BaseMesage*)msg :(void(^)(void))complete;
- (void)loadHistoryMsg :(NSString*)conversationId :(void(^)(NSArray*))result;
- (void)queryLastMsg :(NSString*)username :(NSString*)conId :(void(^)(TextMessage *msg))result;
- (void)createDatabaseAndTables :(NSString*)databaseName :(void(^)(void))complete;

@end
