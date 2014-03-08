//
//  AddFriendMgr.m
//  TimelyCommunication
//
//  Created by zhao on 14-3-7.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "AddFriendMgr.h"
#import "SMClient.h"
#import "SMQuery.h"
#import "CommonData.h"
static AddFriendMgr *shared = nil;
@implementation AddFriendMgr
+ (AddFriendMgr*)sharedInstance
{
    if(!shared)
        shared = [[AddFriendMgr alloc]init];
    return shared;
}
- (BOOL)isMeHasSendRqquest :(NSArray*)members
{
    NSString *myName = [CommonData sharedCommonData].curentUser.username;
    for (NSString *uname in members)
    {
        if([uname isEqualToString:myName])
            return YES;
    }
    return NO;
}
- (void)addFriend:(NSString *)userName :(AddSuccess)success :(AddFailed)failed
{
    AddFriendMgr __weak *tmp = shared;
    SMQuery *query = [[SMQuery alloc]initWithSchema:@"user"];
    [query where:@"username" isEqualTo:userName];
    [[[SMClient defaultClient] dataStore] performQuery:query onSuccess:^(NSArray *results) {
        NSDictionary *user = [results objectAtIndex:0];
        NSArray *applies = [user objectForKey:@"addme"];
        if(applies == nil)
        {
            NSDictionary *updatedTodo = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:[CommonData sharedCommonData].curentUser.username, nil], @"addme", nil];
            
            [[[SMClient defaultClient] dataStore] updateObjectWithId:userName inSchema:@"user" update:updatedTodo onSuccess:^(NSDictionary *object, NSString *schema) {
                NSLog(@"%@",object);
            } onFailure:^(NSError *error, NSDictionary *object, NSString *schema) {
                NSLog(@"error");
            }];
            
        }else
        {
            if([tmp isMeHasSendRqquest:applies])
            {
                success();
                return ;
            }
            NSMutableArray *addMes = [NSMutableArray arrayWithArray:applies];
            [addMes addObject:[CommonData sharedCommonData].curentUser.username];
             NSDictionary *updatedTodo = [NSDictionary dictionaryWithObjectsAndKeys:addMes, @"addme", nil];
            [[[SMClient defaultClient] dataStore] updateObjectWithId:userName inSchema:@"user" update:updatedTodo onSuccess:^(NSDictionary *object, NSString *schema) {
                NSLog(@"%@",object);
            } onFailure:^(NSError *error, NSDictionary *object, NSString *schema) {
                NSLog(@"error");
            }];
        }
        
        success();
    } onFailure:^(NSError *error) {
        failed();
    }];
}
@end
