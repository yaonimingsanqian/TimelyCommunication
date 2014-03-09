//
//  MsgSaveHelper.m
//  HLPChatVoewDemo
//
//  Created by zhao on 14-1-5.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "MsgSaveHelper.h"
#import "Config.h"
#import "CommonData.h"
#import "FMDatabaseQueue.h"

@implementation MsgSaveHelper

#pragma mark - 私有
#pragma mark - 接口
- (BOOL)createDataBase:(NSString *)tableName
{
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH([CommonData sharedCommonData].curentUser.username)];
    if(![db open])
    {
        NSLog(@"数据库打开失败");
        return NO;
    }
    NSString *sql =  [NSString stringWithFormat:@"CREATE  TABLE  IF NOT EXISTS '%@' ('messageId' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL  UNIQUE , 'type' int,'from' VARCHAR, 'to' VARCHAR, 'msgContent' VARCHAR, 'sendDate' DATETIME,'conversationId',VARCHAR,'isIncoming',int)",tableName];
    BOOL isWorked = [db executeUpdate:sql];
    [db close];
   return  isWorked;
}
- (BOOL)saveMsg:(BaseMesage *)msg
{
    [self createDataBase:kMsgTableName];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:DATABASE_PATH([CommonData sharedCommonData].curentUser.username)];
    [queue inDatabase:^(FMDatabase *db) {
        NSString *insertStr = [NSString stringWithFormat:@"INSERT INTO '%@' ('type', 'from','to','msgContent','sendDate','conversationId','isIncoming') VALUES (?,?,?,?,?,?,?)",kMsgTableName];
        ;
        
        [db executeUpdate:insertStr,msg.type,[msg.from stringByReplacingOccurrencesOfString:@"\\40" withString:@"@"],[msg.to stringByReplacingOccurrencesOfString:@"\\40" withString:@"@"],msg.msgContent,msg.sendDate,msg.conversationId,[NSString stringWithFormat:@"%d",msg.isIncoming]];
        [db close];
    }];
   
    return YES;
    
}

- (TextMessage*)queryLastMsg:(NSString *)username :(NSString*)conId
{
    NSString *queryStr = [NSString stringWithFormat:@"SELECT * FROM %@ where conversationId=? ORDER BY messageId DESC limit 0,1",kMsgTableName];
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH(username)];
    [db open];
    
    FMResultSet *rs = [db executeQuery:queryStr,conId];
    while (rs.next)
    {
        TextMessage *msg = [[TextMessage alloc]init];
        msg.messageId = [rs stringForColumn:@"messageId"];
        msg.type = [rs stringForColumn:@"type"];
        msg.from = [rs stringForColumn:@"from"];
        msg.to = [rs stringForColumn:@"to"];
        msg.msgContent = [rs stringForColumn:@"msgContent"];
        msg.sendDate = [rs dateForColumn:@"sendDate"];
        msg.conversationId = [rs stringForColumn:@"conversationId"];
        msg.isIncoming = [rs intForColumn:@"isIncoming"];
        [db close];
        return msg;
    }
    [db close];
    return nil;
    
}
- (void)loadHistoryMsg:(NSString *)conversationId :(LoadMsgComplete)complete
{
    if(![self isTableOK:kMsgTableName]) return;
    NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:kXMPPmyJID];
    user = [[user componentsSeparatedByString:@"@"] objectAtIndex:0];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:DATABASE_PATH(user)];
    [queue inDatabase:^(FMDatabase *db) {
        NSMutableArray *msgSet = [[NSMutableArray alloc]init];
        NSString *sql = [NSString stringWithFormat:@"select * from %@ where conversationId=?",kMsgTableName];
        
        FMResultSet *rs = [db executeQuery:sql,conversationId];
        while (rs.next)
        {
            BaseMesage *msg = [[BaseMesage alloc]init];
            msg.messageId = [rs stringForColumn:@"messageId"];
            msg.type = [rs stringForColumn:@"type"];
            msg.from = [rs stringForColumn:@"from"];
            msg.to = [rs stringForColumn:@"to"];
            msg.msgContent = [rs stringForColumn:@"msgContent"];
            msg.sendDate = [rs dateForColumn:@"sendDate"];
            msg.conversationId = [rs stringForColumn:@"conversationId"];
            msg.isIncoming = [rs intForColumn:@"isIncoming"];
            [msgSet addObject:msg];
        }
        [db close];
        complete(msgSet);
    }];
}
- (NSArray*)loadHistoryMsg:(NSString *)conversationId
{
    if(![self isTableOK:kMsgTableName]) return nil;
    NSMutableArray *msgSet = [[NSMutableArray alloc]init];
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where conversationId=?",kMsgTableName];
    NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:kXMPPmyJID];
    user = [[user componentsSeparatedByString:@"@"] objectAtIndex:0];
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH(user)];
    [db open];
    FMResultSet *rs = [db executeQuery:sql,conversationId];
    while (rs.next)
    {
        BaseMesage *msg = [[BaseMesage alloc]init];
        msg.messageId = [rs stringForColumn:@"messageId"];
        msg.type = [rs stringForColumn:@"type"];
        msg.from = [rs stringForColumn:@"from"];
        msg.to = [rs stringForColumn:@"to"];
        msg.msgContent = [rs stringForColumn:@"msgContent"];
        msg.sendDate = [rs dateForColumn:@"sendDate"];
        msg.conversationId = [rs stringForColumn:@"conversationId"];
        msg.isIncoming = [rs intForColumn:@"isIncoming"];
        [msgSet addObject:msg];
    }
    [db close];
    return msgSet;
}
@end
