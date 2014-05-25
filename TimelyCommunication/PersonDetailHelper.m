//
//  PersonDetailHelper.m
//  TimelyCommunication
//
//  Created by zhao on 14-5-25.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "PersonDetailHelper.h"
#import "Config.h"
#import "FMDatabase.h"
@implementation PersonDetailHelper

- (void)updatePersonDetail:(NSDictionary *)info :(FMDatabaseQueue *)queue :(void (^)(BOOL , NSError *))complete
{
    if(!info||![info objectForKey:@"username"] || ![info objectForKey:@"avatar"])
    {
        if(complete)
        {
            MAIN(^{
                 complete(NO,[NSError errorWithDomain:@"database" code:-1 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"参数错误",@"error-desc", nil]]);
            });
        }
       
    }
    [queue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"select * from %@ where username=?",kPersonDetailName];
        FMResultSet *rs = [db executeQuery:sql,[info objectForKey:@"username"]];
        BOOL isSuccess = NO;
        if(rs.next)
        {
            NSString *update = [NSString stringWithFormat:@"update %@ set avatar=? where username=?",kPersonDetailName];
           isSuccess = [db executeUpdate:update,[info objectForKey:@"avatar"],[info objectForKey:@"username"]];
        }else
        {
            NSString *insert = [NSString stringWithFormat:@"insert into %@ ('avatar','username') values(?,?)",kPersonDetailName];
            isSuccess = [db executeUpdate:insert,[info objectForKey:@"avatar"],[info objectForKey:@"username"]];
        }
        if(complete)
        {
            MAIN(^{
                complete(isSuccess,nil);
            });
        }
         [db closeOpenResultSets];
    }];
}
- (void)queryPersonDetail:(NSArray *)usernames :(FMDatabaseQueue *)queue :(void (^)(NSArray *, NSError *))complete
{
    if(usernames.count <= 0)
    {
        complete(nil,[NSError errorWithDomain:@"database" code:-1 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"参数错误",@"error-desc", nil]]);
        return;
    }
    [queue inDatabase:^(FMDatabase *db) {
        
        NSMutableArray *results = [[NSMutableArray alloc]init];
        
        NSString *query = [NSString stringWithFormat:@"select * from %@ where username=?",kPersonDetailName];
        for (NSString *username in usernames)
        {
            FMResultSet *rs = [db executeQuery:query,username];
            if(rs.next)
            {
                [results addObject:rs.resultDictionary];
            }
        }
       
        if(complete)
        {
            MAIN(^{
                complete(results,nil);
            });
        }
         [db closeOpenResultSets];
        
    }];
}
- (void)deletePersonDetail:(NSArray *)usernames :(FMDatabaseQueue *)queue :(void (^)(BOOL, NSError *))complete
{
    [queue inDatabase:^(FMDatabase *db) {
        NSString *deleteStr = [NSString stringWithFormat:@"delete from %@ where username=?",kPersonDetailName];
        BOOL isScuccess = NO;
        for (NSString *username in usernames)
        {
            isScuccess = [db executeUpdate:deleteStr,username];
            
        }
        if(complete)
        {
            MAIN(^{
                complete(isScuccess,nil);
            });
        }
    }];
}
@end
