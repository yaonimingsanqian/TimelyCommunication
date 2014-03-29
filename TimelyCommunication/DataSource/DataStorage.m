//
//  DataStorage.m
//  TimelyCommunication
//
//  Created by zhao on 14-3-9.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "DataStorage.h"
#import "Config.h"
#import "DDLog.h"
static DataStorage *sharedInyance = nil;
@implementation DataStorage

+ (DataStorage*)sharedInstance
{
    if(!sharedInyance)
        sharedInyance = [[DataStorage alloc]init];
    return sharedInyance;
}
+ (void)destory
{
    sharedInyance = nil;
}
- (id)init
{
    self = [super init];
    if(self)
    {
        msgHelper = [[MsgSaveHelper alloc]init];
        conversationHelper = [[ConversationHelper alloc]init];
        NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:kXMPPmyJID];
        user = [[user componentsSeparatedByString:@"@"] objectAtIndex:0];
       // queue = [FMDatabaseQueue databaseQueueWithPath:DATABASE_PATH(user)];
    }
    return self;
}
-(void)addColumn:(NSString*)columnName :(NSString*)type intoTable:(NSString*)tableName :(void(^)(BOOL isSuccess))complete
{
    [queue inDatabase:^(FMDatabase *db) {
        NSString *updateStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@  %@",tableName,columnName,type];
        if(NO == [db executeUpdate:updateStr])
        {
            NSAssert(NO==YES, @"插入行失败了");
        }
        if(complete)
        {
            MAIN(^{
                complete(YES);
            });
        }
        
    }];
    
    
}
-(void)createTableWithTableName:(NSString*)name :(void(^)(BOOL isTableOk))complete
{
    [queue inDatabase:^(FMDatabase *db) {
        
        NSString *querySql = [NSString stringWithFormat:@"SELECT count(*) as 'count' FROM sqlite_master WHERE type='table' AND name=?"];
        FMResultSet *rs = [db executeQuery:querySql,name];
        int count = 0;
        if(rs.next)
        {
            count = [rs intForColumn:@"count"];
        }
        [db closeOpenResultSets];
        if(count > 0)
        {
            if(complete)
            {
                MAIN(^{
                    complete(YES);
                });
            }
            
            return ;
        }else
        {
            NSString *createStr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE)",name];
            if (NO==[db executeUpdate:createStr])
            {
            }else
            {
                if(complete)
                {
                    MAIN(^{
                        complete(NO);
                    });
                }
                
            }
        }
        
    }];
    
}
- (void)tableOk :(NSString*)tableName
{
    NSLog(@"%@",tableName);
    static int finsihCount = 0;
    finsihCount++;
    if(finsihCount == 1)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDatabaseCreateFinished object:nil];
        if(createDatabaseAndTableComplete)
        {
            createDatabaseAndTableComplete();
        }
        
    }
}
- (void)createConversationTable
{
    //NSString *sql =  [NSString stringWithFormat:@"CREATE  TABLE  IF NOT EXISTS '%@' ('messageId' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL  UNIQUE , 'conversationName' VARCHAR,'type' VARCHAR,'notReadCount' int)",tableName];
    DataStorage __weak *tmp = self;
    [self createTableWithTableName:kConversationName :^(BOOL isTableOk) {
        if(isTableOk)
        {
            [tmp tableOk:kConversationName];
            return ;
        }else
        {
            int  i = 0;
            NSString *last = kConversationColumns.lastObject;
            for (NSString *column in kConversationColumns)
            {
                if([column isEqualToString:last])
                {
                    [self addColumn :column :[kConversationColumnsType objectAtIndex:i] intoTable:kConversationName :^(BOOL isSuccess) {
                        [tmp tableOk:kConversationName];
                    }];
                }else
                {
                    [tmp addColumn:column :[kConversationColumnsType objectAtIndex:i] intoTable:kConversationName :nil];
                }
                i++;
                
            }
        }
    }];
}
- (void)createDatabaseAndTables:(NSString *)databaseName :(void (^)(void))complete
{
    if(complete)
    {
        createDatabaseAndTableComplete = complete;
    }
    if(!queue)
    {
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:databaseName];
        NSLog(@"%@",path);
        BOOL isDir = YES;
        if(![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir] && isDir)
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
            path = [path stringByAppendingPathComponent:[databaseName stringByAppendingString:@".sqlite"]];
            queue = [[FMDatabaseQueue alloc]initWithPath:path];
        }
    }
    [self createConversationTable];
}
- (void)saveConversation:(NSString *)con
{
    [conversationHelper saveConversation:con :queue];
}
- (void)queryConversation
{
    [conversationHelper queryConversation];
}
- (void)updateConversation :(NSString*)conversationName :(BOOL)isAdd
{
    [conversationHelper updateConversation:conversationName :isAdd];
}
- (int)queryNotReadCount :(NSString*)conversationName
{
    return [conversationHelper queryNotReadCount:conversationName];
}
- (void)queryConversationWithFinished:(queryFinished)result
{
    [conversationHelper queryConversationWithFinished:result];
}


- (BOOL)saveMsg :(BaseMesage*)msg
{
    return [msgHelper saveMsg:msg];
}
- (NSArray*)loadHistoryMsg :(NSString*)conversationId
{
    return [msgHelper loadHistoryMsg:conversationId];
}
- (void)loadHistoryMsg :(NSString*)conversationId :(LoadMsgComplete)complete
{
    [msgHelper loadHistoryMsg:conversationId :complete];
}
- (TextMessage*)queryLastMsg :(NSString*)username :(NSString*)conId
{
    return [msgHelper queryLastMsg:username :conId];
}


@end
