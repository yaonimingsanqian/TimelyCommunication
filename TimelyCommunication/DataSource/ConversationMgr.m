//
//  ConversationMgr.m
//  TimelyCommunication
//
//  Created by zhao on 14-3-2.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "ConversationMgr.h"
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"
#import "CommonData.h"
#import "Config.h"

static ConversationMgr *sharedInstance = nil;
@implementation ConversationMgr

+ (ConversationMgr*)sharedInstance
{
    if(!sharedInstance)
        sharedInstance = [[ConversationMgr alloc]init];
    return sharedInstance;
}
- (id)init
{
    self = [super init];
    if(self)
    {
        self.conversations = [[NSMutableArray alloc]init];
    }
    return self;
}
- (BOOL)isConversationExist:(NSString *)con
{
    for (NSString *acon in self.conversations)
    {
        if([acon isEqualToString:con])
            return YES;
    }
    return NO;
}
- (BOOL)createDataBase:(NSString *)tableName
{
    NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:kXMPPmyJID];
    user = [[user componentsSeparatedByString:@"@"] objectAtIndex:0];
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH(user)];
    if(![db open])
    {
        NSLog(@"数据库打开失败");
        return NO;
    }
    NSString *sql =  [NSString stringWithFormat:@"CREATE  TABLE  IF NOT EXISTS '%@' ('messageId' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL  UNIQUE , 'conversationName' VARCHAR,'type' VARCHAR,'notReadCount' int)",tableName];
    BOOL isWorked = [db executeUpdate:sql];
    [db close];
    return  isWorked;
}
- (void)queryConversation
{
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
        [self.conversations addObject:[rs stringForColumn:@"conversationName"]];
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
        NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where conversationName=?",kConversationName];
        [db executeUpdate:deleteSql,conversationName];
        NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO '%@' ('conversationName', 'type','notReadCount') VALUES (?,?,?)",kConversationName];
        [db executeUpdate:insertSql,conversationName,@"chat",[NSString stringWithFormat:@"%d",notReadCount]];
        [db close];
    }];
}
- (void)saveConversation:(NSString *)con
{
    [self createDataBase:kConversationName];
    NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:kXMPPmyJID];
    user = [[user componentsSeparatedByString:@"@"] objectAtIndex:0];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:DATABASE_PATH(user)];
    [queue inDatabase:^(FMDatabase *db) {
        
        NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO '%@' ('conversationName', 'type','notReadCount') VALUES (?,?,?)",kConversationName];
        [db executeUpdate:insertSql,con,@"chat",0];
        [db close];
    }];
}
@end
