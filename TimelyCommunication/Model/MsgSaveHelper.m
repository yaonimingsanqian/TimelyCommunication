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
- (BOOL)saveMsg:(BaseMesage *)msg :(FMDatabaseQueue*)queue :(void(^)(void))complete
{
    [queue inDatabase:^(FMDatabase *db) {
        NSString *insertStr = [NSString stringWithFormat:@"INSERT INTO '%@' ('type', 'from','to','msgContent','sendDate','conversationId','isIncoming') VALUES (?,?,?,?,?,?,?)",kMsgTableName];
        [db executeUpdate:insertStr,msg.type,[msg.from stringByReplacingOccurrencesOfString:@"\\40" withString:@"@"],[msg.to stringByReplacingOccurrencesOfString:@"\\40" withString:@"@"],msg.msgContent,msg.sendDate,msg.conversationId,[NSString stringWithFormat:@"%d",msg.isIncoming]];
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
- (void)loadHistoryMsg:(NSString *)conversationId :(FMDatabaseQueue*)queue :(void(^)(NSArray*))result
{
    [queue inDatabase:^(FMDatabase *db) {
        NSMutableArray *msgSet = [[NSMutableArray alloc]init];
        NSString *sql = [NSString stringWithFormat:@"select * from %@ where conversationId=?",kMsgTableName];
        FMResultSet *rs = [db executeQuery:sql,conversationId];
        while (rs.next)
        {
            BaseMesage *msg = [[BaseMesage alloc]init];
            msg.messageId = [rs stringForColumn:@"id"];
            msg.type = [rs stringForColumn:@"type"];
            msg.from = [rs stringForColumn:@"from"];
            msg.to = [rs stringForColumn:@"to"];
            msg.msgContent = [rs stringForColumn:@"msgContent"];
            msg.sendDate = [rs dateForColumn:@"sendDate"];
            msg.conversationId = [rs stringForColumn:@"conversationId"];
            msg.isIncoming = [rs intForColumn:@"isIncoming"];
            [msgSet addObject:msg];
        }
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
