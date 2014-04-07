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

- (void)queryConversationWithFinished :(FMDatabaseQueue*)queue :(queryFinished)result
{
    [queue inDatabase:^(FMDatabase *db) {
        NSString *querySql = [NSString stringWithFormat:@"select * from %@",kConversationName];
        FMResultSet *rs = [db executeQuery:querySql];
        NSMutableArray *results = [[NSMutableArray alloc]init];
        while (rs.next)
        {
            [results addObject:[rs stringForColumn:@"conversationName"]];
        }
        [db closeOpenResultSets];
        if(result)
        {
            MAIN(^{
                result(results);
            });
        }
        
    }];
}
- (void)queryConversation :(FMDatabaseQueue*)queue
{
    [queue inDatabase:^(FMDatabase *db) {
        
        NSString *querySql = [NSString stringWithFormat:@"select * from %@",kConversationName];
        FMResultSet *rs = [db executeQuery:querySql];
        while (rs.next)
        {
            [[ConversationMgr sharedInstance].conversations addObject:[rs stringForColumn:@"conversationName"]];
        }
        [db closeOpenResultSets];
    }];
    
}
- (void)queryNotReadCount :(NSString *)conversationName :(FMDatabaseQueue*)queue :(void(^)(int count))result
{
    [queue inDatabase:^(FMDatabase *db) {
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE conversationName=?",kConversationName];
        FMResultSet *rs = [db executeQuery:querySql,conversationName];
        int notReadCount = 0;
        while (rs.next)
        {
            notReadCount = [rs intForColumn:@"notReadCount"];
            break;
        }
        if(result)
        {
            MAIN(^{
                result(notReadCount);
            });
        }
        [db closeOpenResultSets];
    }];
    
}
- (void)updateConversation:(NSString *)conversationName :(BOOL)isAdd :(FMDatabaseQueue*)queue :(void(^)(int count))complete
{
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
        [db closeOpenResultSets];
        if(complete)
        {
            MAIN(^{
                complete(notReadCount);
            });
        }
    }];
}
- (void)deleteConversation:(NSString *)name :(FMDatabaseQueue *)queue :(void (^)(BOOL))finished
{
    [queue inDatabase:^(FMDatabase *db) {
        NSString *deleteStr = [NSString stringWithFormat:@"delete from %@ where conversationName=?",kConversationName];
        BOOL isSucess = [db executeUpdate:deleteStr,name];
        if(finished)
        {
            MAIN(^{
                finished(isSucess);
            });
        }
        
    }];
}
- (void)saveConversation:(NSString *)con :(FMDatabaseQueue*)queue :(void(^)(void))complete
{
    [queue inDatabase:^(FMDatabase *db) {
        
        NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO '%@' ('conversationName', 'type','notReadCount') VALUES (?,?,?)",kConversationName];
        [db executeUpdate:insertSql,con,@"chat",0];
        if(complete)
        {
            MAIN(^{
                complete();
            });
        }
    }];
}
@end
