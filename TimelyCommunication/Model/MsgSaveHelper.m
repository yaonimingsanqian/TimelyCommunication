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

@implementation MsgSaveHelper

#pragma mark - 私有
#pragma mark - 接口
- (BOOL)createDataBase:(NSString *)tableName
{
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH([CommonData sharedCommonData].curentUser.account)];
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
    
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH([CommonData sharedCommonData].curentUser.account)];
    [db open];
    NSString *insertStr = [NSString stringWithFormat:@"INSERT INTO '%@' ('type', 'from','to','msgContent','sendDate','conversationId','isIncoming') VALUES (?,?,?,?,?,?,?)",kMsgTableName];
    ;
    
    BOOL isWorked = [db executeUpdate:insertStr,[NSString stringWithFormat:@"%d",msg.type],[msg.from stringByReplacingOccurrencesOfString:@"\\40" withString:@"@"],[msg.to stringByReplacingOccurrencesOfString:@"\\40" withString:@"@"],msg.msgContent,msg.sendDate,msg.conversationId,[NSString stringWithFormat:@"%d",msg.isIncoming]];
    [db close];
    return isWorked;
    
}
- (NSArray*)loadHistoryMsg:(NSString *)conversationId
{
    NSMutableArray *msgSet = [[NSMutableArray alloc]init];
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where conversationId=?",kMsgTableName];
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH([CommonData sharedCommonData].curentUser.account)];
    [db open];
    FMResultSet *rs = [db executeQuery:sql,conversationId];
    while (rs.next)
    {
        BaseMesage *msg = [[BaseMesage alloc]init];
        msg.messageId = [rs stringForColumn:@"messageId"];
        msg.type = [rs intForColumn:@"type"];
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
