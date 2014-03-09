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
+ (void)destory
{
    sharedInstance = nil;
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
@end
