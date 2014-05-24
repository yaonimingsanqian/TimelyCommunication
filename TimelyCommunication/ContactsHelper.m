//
//  ContactsHelper.m
//  TimelyCommunication
//
//  Created by zhao on 14-4-19.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "ContactsHelper.h"
#import "Config.h"
#import "FMDatabase.h"
#import "Contact.h"
@implementation ContactsHelper

- (void)saveContacts:(NSArray *)contactIds :(NSArray *)types :(FMDatabaseQueue*)queue :(void (^)(BOOL))result
{
    //#define kContactColumns @[@"uid",@"type"]
    [queue inDatabase:^(FMDatabase *db) {
        NSString *querySql = [NSString stringWithFormat:@"select * from %@ where uid=? and type=?",kContactName];
        NSString *insertSql = [NSString stringWithFormat:@"insert into '%@' ('uid','type') values(?,?)",kContactName];
        BOOL isSuccess = NO;
        for (int i = 0; i != contactIds.count; i++)
        {
            NSString *uid = contactIds[i];
            NSString *type = types!=nil?types[i]:@"0";
            FMResultSet *rsExist = [db executeQuery:querySql,uid,type];
            if(![rsExist next])
            {
              isSuccess = [db executeUpdate:insertSql,uid,type];
            }
        }
        
        if(result)
        {
            MAIN(^{
                result(isSuccess);
            });
        }
        MAIN(^{
             [[NSNotificationCenter defaultCenter] postNotificationName:kSaveContact object:nil userInfo:nil];
        });
        
        [db closeOpenResultSets];
    }];
}
- (void)deleteContacts:(NSArray *)contactIds :(NSArray *)types :(FMDatabaseQueue*)queue :(void (^)(BOOL))result
{
    [queue inDatabase:^(FMDatabase *db) {
        
        BOOL isSuccess;
        NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where uid=? and type=?",kContactName];
        for (int i = 0; i != contactIds.count; i++)
        {
            NSString *uid = contactIds[i];
            NSString *type = types!=nil?types[i]:@"0";
            isSuccess = [db executeUpdate:deleteSql,uid,type];
            
        }
        if(contactIds.count == 0)
        {
             NSString *deleteSql = [NSString stringWithFormat:@"delete from %@",kContactName];
            isSuccess = [db executeUpdate:deleteSql];
        }
        if(result)
        {
            MAIN(^{
                
                result(isSuccess);
            });
        }
        MAIN(^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kDeleteContact object:nil userInfo:nil];
        });
        
    }];
}
- (void)queryContacts:(NSArray *)contactIds :(NSArray *)types :(FMDatabaseQueue*)queue :(void (^)(NSArray *result))result
{
    [queue inDatabase:^(FMDatabase *db) {
        
        NSString *querySql = [NSString stringWithFormat:@"select * from %@ where uid=? and type=?",kContactName];
        NSMutableArray *contacts = [[NSMutableArray alloc]init];
        for (int i = 0; i != contactIds.count; i++)
        {
            NSString *uid = contactIds[i];
            NSString *type = types!=nil?types[i]:@"0";
            FMResultSet *rs = [db executeQuery:querySql,uid,type];
            if(rs.next)
            {
                NSString *uid = [rs stringForColumn:@"uid"];
                NSString *type = [rs stringForColumn:@"type"];
                NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",type,@"type", nil];
                [contacts addObject:info];
            }
        }
        if(result)
        {
            MAIN(^{
                result(contacts);
            });
        }
        [db closeOpenResultSets];
    }];
}
- (void)queryAllContacts:(FMDatabaseQueue *)queue :(NSString*)type :(void (^)(NSArray *))result
{
    [queue inDatabase:^(FMDatabase *db) {
        NSMutableArray *contacts = [[NSMutableArray alloc]init];
        NSString *querySql = [NSString stringWithFormat:@"select * from %@ where type=?",kContactName];
        FMResultSet *rs = [db executeQuery:querySql,type];
        while (rs.next)
        {
            NSString *uid = [rs stringForColumn:@"uid"];
            NSString *type = [rs stringForColumn:@"type"];
            NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",type,@"type", nil];
            [contacts addObject:info];
        }
        if(result)
        {
            MAIN(^{
                result(contacts);
            });
        }
    }];
}
@end
