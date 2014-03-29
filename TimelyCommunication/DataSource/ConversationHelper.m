//
//  ConversationHelper.m
//  TimelyCommunication
//
//  Created by zhao on 14-3-9.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "ConversationHelper.h"
#import "User.h"
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"
#import "Config.h"
#import "ConversationMgr.h"

@implementation ConversationHelper

- (BOOL)createDataBase:(NSString *)tableName :(FMDatabaseQueue*)queue :(void(^)(BOOL isSuccess))complete
{
    [queue inDatabase:^(FMDatabase *db) {
        NSString *sql =  [NSString stringWithFormat:@"CREATE  TABLE  IF NOT EXISTS '%@' ('messageId' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL  UNIQUE , 'conversationName' VARCHAR,'type' VARCHAR,'notReadCount' int)",tableName];
        BOOL isWorked = [db executeUpdate:sql];
        if(complete)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(isWorked);
            });
        }
    }];
    return  YES;
}
- (void)queryConversationWithFinished:(queryFinished)result
{
    NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:kXMPPmyJID];
    user = [[user componentsSeparatedByString:@"@"] objectAtIndex:0];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:DATABASE_PATH(user)];
    [queue inDatabase:^(FMDatabase *db) {
        NSString *querySql = [NSString stringWithFormat:@"select * from %@",kConversationName];
        FMResultSet *rs = [db executeQuery:querySql];
        NSMutableArray *results = [[NSMutableArray alloc]init];
        while (rs.next)
        {
            [results addObject:[rs stringForColumn:@"conversationName"]];
        }
        [db close];
        result(results);
    }];
}
- (void)queryConversation
{
    if(![self isTableOK:kConversationName]) return;
    NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:kXMPPmyJID];
    user = [[user componentsSeparatedByString:@"@"] objectAtIndex:0];
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH(user)];
    if(![db open])
    {
        NSLog(@"数据库打开失败");
        return;
    }
    NSString *querySql = [NSString stringWithFormat:@"select * from %@",kConversationName];
    FMResultSet *rs = [db executeQuery:querySql];
    while (rs.next)
    {
        [[ConversationMgr sharedInstance].conversations addObject:[rs stringForColumn:@"conversationName"]];
    }
    [db close];
}
- (int)queryNotReadCount:(NSString *)conversationName
{
    NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:kXMPPmyJID];
    user = [[user componentsSeparatedByString:@"@"] objectAtIndex:0];
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH(user)];
    if(![db open])
    {
        NSLog(@"数据库打开失败");
        return 0;
    }
    NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE conversationName=?",kConversationName];
    FMResultSet *rs = [db executeQuery:querySql,conversationName];
    int notReadCount = 0;
    while (rs.next)
    {
        notReadCount = [rs intForColumn:@"notReadCount"];
        break;
    }
    return notReadCount;
}
- (void)updateConversation:(NSString *)conversationName :(BOOL)isAdd
{
    if(![self isTableOK:kConversationName]) return;
    NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:kXMPPmyJID];
    user = [[user componentsSeparatedByString:@"@"] objectAtIndex:0];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:DATABASE_PATH(user)];
    [queue inDatabase:^(FMDatabase *db) {
        int notReadCount = 0;
        if(isAdd)
        {
            NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE conversationName=?",kConversationName];
            FMResultSet *rs = [db executeQuery:querySql,conversationName];
            
            while (rs.next)
            {
                notReadCount = [rs intForColumn:@"notReadCount"];
                break;
            }
            notReadCount++;
            
            
        }
        NSString *updateSql = [NSString stringWithFormat:@"update %@ set notReadCount=? where conversationName=?",kConversationName];
        [db executeUpdate:updateSql,[NSString stringWithFormat:@"%d",notReadCount],conversationName];
        [db close];
    }];
}
- (void)saveConversation:(NSString *)con :(FMDatabaseQueue*)queue
{
    [self createDataBase:kConversationName :queue :^(BOOL isSuccess) {
        NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:kXMPPmyJID];
        user = [[user componentsSeparatedByString:@"@"] objectAtIndex:0];
        [queue inDatabase:^(FMDatabase *db) {
            
            NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO '%@' ('conversationName', 'type','notReadCount') VALUES (?,?,?)",kConversationName];
            [db executeUpdate:insertSql,con,@"chat",0];
            [db close];
        }];
    }];
}
@end
