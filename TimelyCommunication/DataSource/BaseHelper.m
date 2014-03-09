//
//  BaseHelper.m
//  TimelyCommunication
//
//  Created by zhao on 14-3-9.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "BaseHelper.h"
#import "FMDatabase.h"
#import "Config.h"

@implementation BaseHelper

- (BOOL) isTableOK:(NSString *)tableName
{
    NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:kXMPPmyJID];
    user = [[user componentsSeparatedByString:@"@"] objectAtIndex:0];
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH(user)];
    [db open];
    FMResultSet *rs = [db executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
    while ([rs next])
    {
        NSInteger count = [rs intForColumn:@"count"];
        
        if (0 == count)
        {
            [db close];
            return NO;
        }
        else
        {
            [db close];
            return YES;
        }
    }
    [db close];
    return NO;
}
@end
