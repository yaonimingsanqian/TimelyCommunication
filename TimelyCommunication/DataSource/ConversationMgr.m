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
- (void)destoryData
{
    [self.conversations removeAllObjects];
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
- (BOOL)removeConversations:(NSString *)con
{
    for (NSString *converstion in self.conversations)
    {
        if([con isEqualToString:converstion])
        {
            [self.conversations removeObject:converstion];
            return YES;
        }
    }
    return NO;
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
@end
