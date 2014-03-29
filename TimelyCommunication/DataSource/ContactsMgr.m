//
//  ContactsMgr.m
//  TimelyCommunication
//
//  Created by zhao on 14-3-2.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "ContactsMgr.h"
#import "Config.h"

static ContactsMgr *sharedInstance = nil;
@implementation ContactsMgr
+ (ContactsMgr*)sharedInstance
{
    if(!sharedInstance)
        sharedInstance = [[ContactsMgr alloc]init];
    return sharedInstance;
}
+ (void)destory
{
    sharedInstance = nil;
}
- (BOOL)isConversationExist:(NSString *)conName
{
    for (NSString *name in self.friends)
    {
        if([name isEqualToString:conName])
            return YES;
    }
    return NO;
}
- (void)parseFriends:(NSDictionary *)userInfo
{
    
    NSMutableArray *friendsTmp = [[NSMutableArray alloc]init];
    NSArray *friendsInfo = [userInfo objectForKey:@"friends"];
    for (NSString *username in friendsInfo)
    {
        [friendsTmp addObject:username];
    }
    self.friends = [NSMutableArray arrayWithArray:friendsTmp];
    [[NSNotificationCenter defaultCenter] postNotificationName:kContactLoadFinish object:nil userInfo:nil];
}
@end
