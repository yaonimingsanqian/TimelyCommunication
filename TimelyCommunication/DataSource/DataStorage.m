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
#import "TextMessage.h"
#define kTableCount 4
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
        contactsHelper = [[ContactsHelper alloc]init];
        NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:kXMPPmyJID];
        user = [[user componentsSeparatedByString:@"@"] objectAtIndex:0];
       // queue = [FMDatabaseQueue databaseQueueWithPath:DATABASE_PATH(user)];
    }
    return self;
}
-(void)addColumn:(NSString*)columnName :(NSString*)type intoTable:(NSString*)tableName :(void(^)(BOOL isSuccess))complete
{
    [queue inDatabase:^(FMDatabase *db) {
        NSString *updateStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD '%@' %@",tableName,columnName,type];
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
        [db closeOpenResultSets];
        
    }];
    
}
- (void)tableOk :(NSString*)tableName
{
    NSLog(@"%@",tableName);
    static int finsihCount = 0;
    finsihCount++;
    if(finsihCount == kTableCount && !isNeedUpdateDatabase)
    {
        self.isDatabaseReady = YES;
        finsihCount = 0;
        [[NSNotificationCenter defaultCenter] postNotificationName:kDatabaseCreateFinished object:nil];
        if(createDatabaseAndTableComplete)
        {
            createDatabaseAndTableComplete();
        }
        
    }
}
- (void)addField :(NSArray*)field :(NSArray*)type :(NSString*)table
{
    DataStorage __weak *tmp = self;
    [self createTableWithTableName:table :^(BOOL isTableOk) {
        if(isTableOk)
        {
            [tmp tableOk:table];
            return ;
        }else
        {
            int  i = 0;
            NSString *last = field.lastObject;
            for (NSString *column in field)
            {
                if([column isEqualToString:last])
                {
                    [self addColumn :column :[type objectAtIndex:i] intoTable:table :^(BOOL isSuccess) {
                        [tmp tableOk:table];
                    }];
                }else
                {
                    [tmp addColumn:column :[type objectAtIndex:i] intoTable:table :nil];
                }
                i++;
                
            }
        }
    }];
}
- (void)createConversationTable
{
    [self addField:kConversationColumns :kConversationColumnsType :kConversationName];
}
- (void)createMsgTable
{
    [self addField:kMsgColumns :kMsgFieldType :kMsgTableName];
}
- (void)createContactsTable
{
    [self addField:kContactColumns :kContactColumnsType :kContactName];
}
- (void)createRedPoingTable
{
    [self addField:kRedPointColumns :kRedPointColumnsType :kRedPointName];
}
- (void)createDatabaseAndTables:(NSString *)databaseName :(void (^)(void))complete
{
    if(complete)
    {
        createDatabaseAndTableComplete = complete;
    }
    NSString *dbVersion = [[NSUserDefaults standardUserDefaults] objectForKey:databaseName];
    if(!dbVersion)
    {
        [[NSUserDefaults standardUserDefaults] setObject:kDBVersion forKey:databaseName];
    }
    if(!queue)
    {
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:databaseName];
        BOOL isDir = YES;
        if(![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir] && isDir)
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
            
        }
        path = [path stringByAppendingPathComponent:[databaseName stringByAppendingString:@".sqlite"]];
        queue = [[FMDatabaseQueue alloc]initWithPath:path];
    }
    if(!dbVersion || [dbVersion isEqualToString:kDBVersion])
    {
        
        [self createConversationTable];
        [self createMsgTable];
        [self createRedPoingTable];
        [self createContactsTable];
    }else if([dbVersion intValue] < [kDBVersion intValue])
    {
        isNeedUpdateDatabase = YES;
        
        for(int i = [dbVersion intValue];i < [kDBVersion intValue];i++)
        {
            NSString *selStr=[NSString stringWithFormat:@"updateDbFrom%dTo%d",i,i+1];
            
            SEL sel=NSSelectorFromString(selStr);
            
            if (YES==[self respondsToSelector:sel])
            {
                IMP imp = [self methodForSelector:sel];
                void (*performSelector)(id, SEL) = (void *)imp;
                performSelector(self,sel);
            }
        }
        [[NSUserDefaults standardUserDefaults] setObject:kDBVersion forKey:databaseName];
    }
    
    
}
- (void)complete
{
    self.isDatabaseReady = YES;
    if(createDatabaseAndTableComplete)
    {
        createDatabaseAndTableComplete();
    }
}
- (void)updateDbFrom1To2
{
     DataStorage __weak *tmp = self;
    
    [queue inDatabase:^(FMDatabase *db) {
        TCLog(@"数据库正在更新 updateDbFrom1To2。。");
        NSString *updateStr1 = [NSString stringWithFormat:@"ALTER TABLE %@ ADD '%@' %@",kMsgTableName,@"msgId",@"VARCHAR"];
        if(NO == [db executeUpdate:updateStr1])
        {
            TCLog(@"插入行失败了");
            //NSAssert(NO==YES, @"插入行失败了");
            //return ;
        }
         NSString *updateStr2 = [NSString stringWithFormat:@"ALTER TABLE %@ ADD '%@' %@",kMsgTableName,@"isSendSuccess",@"VARCHAR"];
        if(NO == [db executeUpdate:updateStr2])
        {
            TCLog(@"插入行失败了");
           // NSAssert(NO==YES, @"插入行失败了");
            //return ;
        }
        NSString *updateSql = [NSString stringWithFormat:@"update %@ set msgId=?,isSendSuccess=?",kMsgTableName];
        [db executeUpdate:updateSql,@"db1",@"1"];
        MAIN(^{
            TCLog(@"数据库更新完毕 updateDbFrom1To2");
            [tmp complete];
        });
    }];
}
- (void)saveConversation:(NSString *)con :(void(^)(void))complete
{
    [conversationHelper saveConversation:con :queue :complete];
}
//- (void)queryConversation
//{
//    [conversationHelper queryConversation:queue];
//}
- (void)updateConversation :(NSString*)conversationName :(BOOL)isAdd
{
    [conversationHelper updateConversation:conversationName :isAdd :queue :^(int count) {
        NSLog(@"%d",count);
    }];
}
- (void)queryNotReadCount :(NSString*)conversationName :(void(^)(int count))result;
{
    [conversationHelper queryNotReadCount:conversationName :queue :result];
}
- (void)deleteConversation:(NSString *)name :(void (^)(BOOL))finished
{
    [conversationHelper deleteConversation:name :queue :finished];
}
- (void)queryConversationWithFinished:(queryFinished)result
{
    [conversationHelper queryConversationWithFinished :queue :result];
}

- (void)markedAsSend:(NSString *)msgID :(void (^)(BOOL))finished
{
    [msgHelper markedAsSend:msgID :queue :finished];
}
- (void)markedAsSendFailed:(NSString *)msgID :(void (^)(BOOL))finished
{
    [msgHelper markedAsFailed:msgID :queue :finished];
}
- (void)markedAsSendSuccess:(NSString *)msgID :(void (^)(BOOL))finished
{
    [msgHelper markedAsReceived:msgID :queue :finished];
}
- (BOOL)saveMsg :(BaseMesage*)msg :(void(^)(void))complete
{
    return [msgHelper saveMsg :msg :queue :complete];
}
- (void)deleteMsg:(NSString *)conId :(void (^)(BOOL))finished
{
    [msgHelper deleteMSg:conId :queue :finished];
}
- (void)loadMoreMsg:(NSString *)conversationId :(int)origin :(int)lenght :(void (^)(NSArray *))result
{
    [msgHelper loadMore:conversationId :origin :lenght :queue :result];
}
- (void)loadHistoryMsg :(NSString*)conversationId :(void(^)(NSArray*))result
{
    [msgHelper loadHistoryMsg:conversationId :queue :result];
}
//- (void)loadHistoryMsg :(NSString*)conversationId :(LoadMsgComplete)complete
//{
//    [msgHelper loadHistoryMsg:conversationId :complete];
//}
- (void)queryLastMsg :(NSString*)username :(NSString*)conId :(void(^)(TextMessage *msg))result;
{
    [msgHelper queryLastMsg:username :conId :queue :result];
}

- (void)saveContacts:(NSArray *)contactIds :(NSArray *)types :(void (^)(BOOL))result
{
    [contactsHelper saveContacts:contactIds :types :queue :result];
}
- (void)deleteContacts:(NSArray *)contactIds :(NSArray *)types :(void (^)(BOOL))result
{
    [contactsHelper deleteContacts:contactIds :types :queue :result];
}
- (void)queryContacts:(NSArray *)contactIds :(NSArray *)types :(void (^)(NSArray *))result
{
    [contactsHelper queryContacts:contactIds :types :queue :result];
}
- (void)queryAllContacts :(NSString *)type :(void (^)(NSArray *))result
{
    [contactsHelper queryAllContacts:queue :type :result];
}
@end
