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
#import "Conversation.h"
#import <Parse/Parse.h>
static AddFriendMgr *shared = nil;
@implementation AddFriendMgr
+ (AddFriendMgr*)sharedInstance
{
    if(!shared)
        shared = [[AddFriendMgr alloc]init];
    return shared;
}
+ (void)destory
{

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
    PFQuery *pfquery = [[PFQuery alloc]initWithClassName:@"social"];
    [pfquery whereKey:@"username" equalTo:userName];
    [pfquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        PFObject *object = [objects objectAtIndex:0];
         NSArray *applies = object[@"addme"];
        if(applies.count == 0)
        {
            object[@"addme"] = [NSArray arrayWithObject:[CommonData sharedCommonData].curentUser.username];
            [object saveInBackground];
            [[Conversation sharedInstance] pushApply:userName];
        }else
        {
            
            if([self isMeHasSendRqquest:applies])
            {
                [[Conversation sharedInstance] pushApply:userName];
                success();
                return ;
            }
             NSMutableArray *addMes = [NSMutableArray arrayWithArray:applies];
            [addMes addObject:[CommonData sharedCommonData].curentUser.username];
            object[@"addme"] = addMes;
            [object saveInBackground];
            [[Conversation sharedInstance] pushApply:userName];
            
        }
        success();
    }];
//    [query where:@"username" isEqualTo:userName];
//    [[[SMClient defaultClient] dataStore] performQuery:query onSuccess:^(NSArray *results) {
//        NSDictionary *user = [results objectAtIndex:0];
//        NSArray *applies = [user objectForKey:@"addme"];
//        if(applies == nil)
//        {
//            NSDictionary *updatedTodo = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:[CommonData sharedCommonData].curentUser.username, nil], @"addme", nil];
//            
//            [[[SMClient defaultClient] dataStore] updateObjectWithId:userName inSchema:@"user" update:updatedTodo onSuccess:^(NSDictionary *object, NSString *schema) {
//                //推送
//                [[Conversation sharedInstance] pushApply:userName];
//            } onFailure:^(NSError *error, NSDictionary *object, NSString *schema) {
//                NSLog(@"error");
//            }];
//            
//        }else
//        {
//            if([tmp isMeHasSendRqquest:applies])
//            {
//                success();
//                return ;
//            }
//            NSMutableArray *addMes = [NSMutableArray arrayWithArray:applies];
//            [addMes addObject:[CommonData sharedCommonData].curentUser.username];
//            NSDictionary *updatedTodo = [NSDictionary dictionaryWithObjectsAndKeys:addMes, @"addme", nil];
//            [[[SMClient defaultClient] dataStore] updateObjectWithId:userName inSchema:@"user" update:updatedTodo onSuccess:^(NSDictionary *object, NSString *schema) {
//                
//                //推送
//                [[Conversation sharedInstance] pushApply:userName];
//            } onFailure:^(NSError *error, NSDictionary *object, NSString *schema) {
//                NSLog(@"error");
//            }];
//        }
//        
//        success();
//    } onFailure:^(NSError *error) {
//        failed();
//    }];
}
- (void)addFriend_:(NSString *)userName :(AddSuccess)success :(AddFailed)failed
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
                //推送
                [[Conversation sharedInstance] pushApply:userName];
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
                
                //推送
                [[Conversation sharedInstance] pushApply:userName];
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
