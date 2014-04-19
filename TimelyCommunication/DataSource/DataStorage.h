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
#import "ContactsHelper.h"
typedef void(^CreateComplete)(void);
@interface DataStorage : NSObject
{
    MsgSaveHelper *msgHelper;
    ConversationHelper *conversationHelper;
    FMDatabaseQueue *queue;
    CreateComplete createDatabaseAndTableComplete;
    ContactsHelper *contactsHelper;
}
#pragma mark - 单例
+ (DataStorage*)sharedInstance;
#pragma mark - 建表
- (void)createDatabaseAndTables :(NSString*)databaseName :(void(^)(void))complete;
#pragma mark - 销毁
+ (void)destory;

#pragma mark - 会话相关
- (void)saveConversation :(NSString*)con :(void(^)(void))complete;
- (void)queryConversation;
- (void)updateConversation :(NSString*)conversationName :(BOOL)isAdd;
- (void)queryNotReadCount :(NSString*)conversationName :(void(^)(int count))result;
- (void)queryConversationWithFinished:(queryFinished)result;
- (void)deleteConversation:(NSString *)name :(void (^)(BOOL))finished;

#pragma mark - 消息相关
- (BOOL)saveMsg :(BaseMesage*)msg :(void(^)(void))complete;
- (void)loadHistoryMsg :(NSString*)conversationId :(void(^)(NSArray*))result;
- (void)loadMoreMsg :(NSString*)conversationId :(int)origin :(int)lenght :(void(^)(NSArray*))result;
- (void)deleteMsg :(NSString*)conId :(void(^)(BOOL isSuccess))finished;
- (void)queryLastMsg :(NSString*)username :(NSString*)conId :(void(^)(TextMessage *msg))result;

#pragma mark - 联系人相关
- (void)saveContacts :(NSArray*)contactIds :(NSArray*)types :(void(^)(BOOL isSuccess))result;
- (void)deleteContacts :(NSArray*)contactIds :(NSArray*)types :(void(^)(BOOL isSuccess))result;
- (void)queryContacts:(NSArray *)contactIds :(NSArray *)types :(void (^)(NSArray *))result;
- (void)queryAllContacts :(NSString*)type :(void (^)(NSArray *))result;


@end
