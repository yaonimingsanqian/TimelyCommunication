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

- (void)updateMgsStatus :(FMDatabase*)db :(NSString*)msgId :(NSString*)status :(void(^)(BOOL isSuccess))finished
{
    NSString *updateSql = [NSString stringWithFormat:@"update %@ set isSendSuccess=? where msgId=?",kMsgTableName];
    BOOL isSuccess = [db executeUpdate:updateSql,status,msgId];
    if(finished)
    {
        MAIN(^{
            finished(isSuccess);
        });
    }
}
- (void)deleteMSg:(NSString *)conId :(FMDatabaseQueue *)queue :(void (^)(BOOL))finished
{
    [queue inDatabase:^(FMDatabase *db) {
        
        NSString *deleteStr = [NSString stringWithFormat:@"delete from %@ where conversationId=?",kMsgTableName];
        BOOL isSuccess = [db executeUpdate:deleteStr,conId];
        if(finished)
        {
            MAIN(^{
                finished(isSuccess);
            });
        }
    }];
}
- (void)markedAsSend:(NSString *)msgId :(FMDatabaseQueue *)queue :(void (^)(BOOL))finished
{
    [queue inDatabase:^(FMDatabase *db) {
        
        [self updateMgsStatus:db :msgId :@"3" :finished];
    }];
}
- (void)markedAsFailed:(NSString *)msgId :(FMDatabaseQueue *)queue :(void (^)(BOOL))finished
{
    [queue inDatabase:^(FMDatabase *db) {
        
        [self updateMgsStatus:db :msgId :@"2" :finished];
    }];
}
- (void)markedAsReceived:(NSString *)msgId :(FMDatabaseQueue *)queue :(void (^)(BOOL))finished
{
    [queue inDatabase:^(FMDatabase *db) {
        
        [self updateMgsStatus:db :msgId :@"1" :finished];
    }];
}
- (BOOL)saveMsg:(BaseMesage *)msg :(FMDatabaseQueue*)queue :(void(^)(void))complete
{
    [queue inDatabase:^(FMDatabase *db) {
        NSString *insertStr = [NSString stringWithFormat:@"INSERT INTO '%@' ('type', 'from','to','msgContent','sendDate','conversationId','isIncoming','msgId','isSendSuccess') VALUES (?,?,?,?,?,?,?,?,?)",kMsgTableName];
        [db executeUpdate:insertStr,msg.type,[msg.from stringByReplacingOccurrencesOfString:@"\\40" withString:@"@"],[msg.to stringByReplacingOccurrencesOfString:@"\\40" withString:@"@"],msg.msgContent,msg.sendDate,msg.conversationId,[NSString stringWithFormat:@"%d",msg.isIncoming],msg.messageId,@"0"];
        if(complete)
        {
            MAIN(^{
                complete();
            });
        }
    }];
   
    return YES;
    
}

- (void)queryLastMsg:(NSString *)username :(NSString*)conId :(FMDatabaseQueue*)queue :(void(^)(TextMessage *last))result
{
    [queue inDatabase:^(FMDatabase *db) {
        
        
        NSString *queryStr = [NSString stringWithFormat:@"SELECT * FROM %@ where conversationId=? ORDER BY id DESC limit 0,1",kMsgTableName];
        FMResultSet *rs = [db executeQuery:queryStr,conId];
        TextMessage *msg = [[TextMessage alloc]init];
        while (rs.next)
        {
            msg.messageId = [rs stringForColumn:@"id"];
            msg.type = [rs stringForColumn:@"type"];
            msg.from = [rs stringForColumn:@"from"];
            msg.to = [rs stringForColumn:@"to"];
            msg.msgContent = [rs stringForColumn:@"msgContent"];
            msg.sendDate = [rs dateForColumn:@"sendDate"];
            msg.conversationId = [rs stringForColumn:@"conversationId"];
            msg.isIncoming = [rs intForColumn:@"isIncoming"];
        }
        [db closeOpenResultSets];
        if(result)
        {
            MAIN(^{
                result(msg);
            });
        }
    }];
    
    
}
- (NSMutableArray*)creageMsg :(FMResultSet*)rs
{
     NSMutableArray *msgSet = [[NSMutableArray alloc]init];
    while (rs.next)
    {
        BaseMesage *msg = [[BaseMesage alloc]init];
        msg.messageId = [rs stringForColumn:@"msgId"];
        msg.type = [rs stringForColumn:@"type"];
        msg.from = [rs stringForColumn:@"from"];
        msg.to = [rs stringForColumn:@"to"];
        msg.msgContent = [rs stringForColumn:@"msgContent"];
        msg.sendDate = [rs dateForColumn:@"sendDate"];
        msg.conversationId = [rs stringForColumn:@"conversationId"];
        msg.isIncoming = [rs intForColumn:@"isIncoming"];
        msg.status = [rs intForColumn:@"isSendSuccess"];
        [msgSet addObject:msg];
    }
    return msgSet;
}
- (void)loadMore:(NSString *)conversationId :(int)origin :(int)length :(FMDatabaseQueue *)queue :(void (^)(NSArray *))result
{
    [queue inDatabase:^(FMDatabase *db) {
        
        NSString *sql = [NSString stringWithFormat:@"select * from %@ where conversationId=? order by id desc limit %d,%d",kMsgTableName,origin,length];
        FMResultSet *rs = [db executeQuery:sql,conversationId];
        NSMutableArray *msgSet = [self creageMsg:rs];
        if(result)
        {
            NSArray* reversedArray = [[msgSet reverseObjectEnumerator] allObjects];
            MAIN(^{
                result(reversedArray);
            });
        }
        [db closeOpenResultSets];
        
    }];
}
- (void)loadHistoryMsg:(NSString *)conversationId :(FMDatabaseQueue*)queue :(void(^)(NSArray*))result
{
    [queue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"select * from %@ where conversationId=?",kMsgTableName];
        FMResultSet *rs = [db executeQuery:sql,conversationId];
        NSMutableArray *msgSet = [self creageMsg:rs];
        if(result)
        {
            MAIN(^{
                result(msgSet);
            });
        }
        [db closeOpenResultSets];
    }];
}
@end
