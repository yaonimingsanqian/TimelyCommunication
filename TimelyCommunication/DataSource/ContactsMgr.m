//
//  ContactsMgr.m
//  TimelyCommunication
//
//  Created by zhao on 14-3-2.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "ContactsMgr.h"
#import "Config.h"
#import "DataStorage.h"

static ContactsMgr *sharedInstance = nil;
@implementation ContactsMgr
+ (ContactsMgr*)sharedInstance
{
    if(!sharedInstance)
    {
        sharedInstance = [[ContactsMgr alloc]init];
        [[NSNotificationCenter defaultCenter] addObserver:sharedInstance selector:@selector(contactChange:) name:kSaveContact object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:sharedInstance selector:@selector(contactChange:) name:kDeleteContact object:nil];
    }
    
    return sharedInstance;
}
- (void)contactChange :(NSNotification*)noti
{
    [[DataStorage sharedInstance] queryAllContacts:@"0" :^(NSArray *result) {
        NSMutableArray *tmp = [[NSMutableArray alloc]init];
        for (NSDictionary *info in result)
        {
            [tmp addObject:[info objectForKey:@"uid"]];
        }
        
        self.friends = [NSMutableArray arrayWithArray:tmp];
        [[NSNotificationCenter defaultCenter] postNotificationName:kContactLoadFinish object:nil];
        
    }];
}
+ (void)destory
{
    [[NSNotificationCenter defaultCenter] removeObserver:sharedInstance];
    sharedInstance = nil;
}
- (BOOL)isContactExist:(NSString *)conName
{
    for (NSString *name in self.friends)
    {
        if([name isEqualToString:conName])
            return YES;
    }
    return NO;
}
//- (void)parseFriends:(NSDictionary *)userInfo
//{
//    
//    NSMutableArray *friendsTmp = [[NSMutableArray alloc]init];
//    NSArray *friendsInfo = [userInfo objectForKey:@"friends"];
//    for (NSString *username in friendsInfo)
//    {
//        [friendsTmp addObject:username];
//    }
//    self.friends = [NSMutableArray arrayWithArray:friendsTmp];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kContactLoadFinish object:nil userInfo:nil];
//}
@end
