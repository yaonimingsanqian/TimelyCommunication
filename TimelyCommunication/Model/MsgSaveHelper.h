//
//  MsgSaveHelper.h
//  HLPChatVoewDemo
//
//  Created by zhao on 14-1-5.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "BaseMesage.h"
#import "TextMessage.h"
#import "FMDatabaseQueue.h"
typedef void(^LoadMsgComplete)(NSArray* msgArray);
@interface MsgSaveHelper : NSObject
- (BOOL)saveMsg :(BaseMesage*)msg :(FMDatabaseQueue*)queue :(void(^)(void))complete;
- (void)markedAsReceived :(NSString*)msgId :(FMDatabaseQueue*)queue :(void(^)(BOOL isSuccess))finished;
- (void)markedAsFailed :(NSString*)msgId :(FMDatabaseQueue*)queue :(void(^)(BOOL isSuccess))finished;
- (void)loadHistoryMsg :(NSString*)conversationId :(FMDatabaseQueue*)queue :(void(^)(NSArray *))result;
- (void)loadHistoryMsg :(NSString*)conversationId :(LoadMsgComplete)complete;
- (void)queryLastMsg :(NSString*)username :(NSString*)conId :(FMDatabaseQueue*)queue :(void(^)(TextMessage *last))result;
- (void)deleteMSg :(NSString*)conId :(FMDatabaseQueue*)queue :(void(^)(BOOL isSuccess))finished;
- (void)loadMore:(NSString *)conversationId :(int)origin :(int)length :(FMDatabaseQueue *)queue :(void (^)(NSArray *))result;
@end
